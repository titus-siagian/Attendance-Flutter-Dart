import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/cubit/inbox/inbox_list.dart';
import 'package:ess_iris/models/inbox.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/fcm_notification.dart';
import 'package:ess_iris/widgets/empty.dart';
import 'package:intl/intl.dart';

class InboxPage extends StatefulWidget {
  static const String routeName = '/inbox';

  const InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    final User? user = context.read<AuthCubit>().state.data;

    context.read<InboxListCubit>().getInbox(user?.id ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        centerTitle: true,
      ),
      body: BlocBuilder<InboxListCubit, ListState<Inbox>>(
        builder: (context, state) {
          if (state.status == ListStateStatus.success) {
            if (state.data?.isEmpty ?? true) {
              return const AppEmpty();
            }
            return ListView.separated(
              separatorBuilder: (context, i) {
                return const Divider();
              },
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: state.data?.length ?? 0,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(
                    '${state.data?[i].title ?? ''} - ${state.data?[i].body ?? ''}',
                    style: kMediumBook.copyWith(color: kDarkBlueColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('dd MMMM yyyy HH:mm')
                        .format(state.data?[i].createdAt ?? DateTime.now()),
                    style: kSmallBook.copyWith(color: kGreyColor),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                  onTap: () {
                    final fcm = FCMNotification();
                    final payload = '{"value": "${state.data?[i].data}"}';
                    fcm.notificationAction(payload);
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
