import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/announcement/announcement.dart';
import 'package:ess_iris/models/announcement.dart';
import 'package:ess_iris/models/attachment.dart';
import 'package:ess_iris/repositories/announcement_repository.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/logger.dart';
import 'package:ess_iris/widgets/empty.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementPage extends StatefulWidget {
  static const String routeName = '/announcement';

  final int announcementId;

  const AnnouncementPage({
    Key? key,
    required this.announcementId,
  }) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final _repository = AnnouncementRepository();
  late Future<List<Attachment>> _futureAttachments;

  _onFileAttachment(Attachment data) async {
    final url = Uri.encodeFull(kBaseUrl + '/' + (data.url ?? ''));
    if (await canLaunch(url)) {
      launch(url);
    } else {
      AppError.of(context).show(message: 'Tidak dapat membuka URL');
    }
  }

  @override
  void initState() {
    context.read<AnnouncementCubit>().find(widget.announcementId);
    _futureAttachments = _repository.getAttachment(widget.announcementId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement'),
      ),
      body: BlocBuilder<AnnouncementCubit, DetailState<Announcement>>(
        builder: (context, state) {
          if (state.status == DetailStateStatus.success) {
            if (state.data != null) {
              return _buildContent(state.data!);
            }
            return const Center(
              child: AppEmpty(
                message: 'Pengumuman tidak ditemukan',
              ),
            );
          }

          if (state.status == DetailStateStatus.failure) {
            return Center(
              child: AppEmpty(
                message:
                    state.error?.message ?? 'Terjadi kesalahan pada server.',
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }

  SingleChildScrollView _buildContent(Announcement announcement) {
    return SingleChildScrollView(
      padding: kPageViewPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            announcement.title ?? '',
            style: kLargeHeavy.copyWith(color: kDarkBlueColor),
          ),
          kTinySpacing,
          Text(
            DateFormat('dd MMMM yyyy').format(
              announcement.createdAt ?? DateTime.now(),
            ),
            style: kMediumBook.copyWith(color: kGreyColor),
          ),
          kHugeSpacing,
          HtmlWidget(
            announcement.description ?? '',
            onTapUrl: (url) async {
              if (await canLaunch(url)) {
                launch(url);
              } else {
                AppError.of(context).show(message: 'Tidak dapat membuka URL');
              }
              return true;
            },
            textStyle: kMediumMedium.copyWith(
              color: kDarkBlueColor,
            ),
          ),
          kHugeSpacing,
          FutureBuilder<List<Attachment>>(
            future: _futureAttachments,
            builder: (context, snapshot) {
              if (snapshot.hasData && (snapshot.data?.isNotEmpty ?? false)) {
                return GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  children: snapshot.data!
                      .map(
                        (e) => GestureDetector(
                          onTap: () => _onFileAttachment(e),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Icon(
                                  Icons.file_present_rounded,
                                  size: 60,
                                  color: kSecondaryColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  e.name ?? '',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
