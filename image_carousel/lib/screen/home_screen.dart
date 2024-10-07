import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(Duration(seconds: 3), (timer) {
      int? nextPage = pageController.page?.toInt(); //현재 페이지 가져오기
      if (nextPage == null) {
        return;
      }
      if (nextPage == 4) {
        nextPage = 0;
      } else {
        nextPage++;
      }
      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //상태바 색상 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: pageController,
        //map 원본을 차례로 수정한다.
        children: [1, 2, 3, 4, 5]
            .map(
              (e) => Image.asset('assets/image_$e.jpeg', fit: BoxFit.cover),
            )
            .toList(),
      ),
    );
  }
}
