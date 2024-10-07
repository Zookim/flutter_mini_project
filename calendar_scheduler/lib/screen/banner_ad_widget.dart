import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late final BannerAd banner;

  void initState() {
    super.initState();

    final adUnitId = '';

    banner = BannerAd(
      size: AdSize.banner, adUnitId: adUnitId,
      //광고의 생명주기가 변경될때마다 실행할 함수 설정
      //광고 로딩에 실패시 그냥 닫는다.
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        print('loading failed');
        ad.dispose();
      }),
      //광고 요청정보를 담고 있는 클래스
      request: AdRequest(),
    );
    banner.load();
  }

  void dispose() {
    banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 75,
      child: AdWidget(ad: banner),
    );
  }
}
