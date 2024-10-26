import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ess_iris/utils/constant.dart';

class AppImage extends StatelessWidget {
  final String? url;

  const AppImage({Key? key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$kBaseUrl/$url',
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          height: 80,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/svg/bg-red.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Text(
                  'Tidak dapat memuat foto',
                  style: kLargeHeavy.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
