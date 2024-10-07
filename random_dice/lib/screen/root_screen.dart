import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/setting_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? tabcontroller; // 타입에 ?를 붙이면 null값을 가질수 있다.
  double threshold = 2.7; //기본값
  int number = 2;
  ShakeDetector? shakeDetector;
  @override
  void initState() {
    //단한번만 실행된다.
    // TODO: implement initState
    super.initState();
    tabcontroller = TabController(length: 2, vsync: this); //컨트롤러 초기화
    tabcontroller?.addListener(tabListner);
    // 컨트롤러 속성이 변경될때마다 실행할 함수를 등록 할수 있다. 여기에 setState를 넣어 build를 실행하도록한다.

    shakeDetector = ShakeDetector.autoStart(
      // 감지 즉시 시작
      shakeSlopTimeMS: 500, //감지주기
      shakeThresholdGravity: threshold, //민감도
      onPhoneShake: MyPhoneShake, //감지 후 실행
    );

    shakeDetector!.startListening();
  }

  void MyPhoneShake() {
    final rand = new Random();
    print('shake!');
    setState(() {
      number = rand.nextInt(5) + 1;
    });
  }

  tabListner() {
    setState(() {});
  }

  @override
  void dispose() {
    tabcontroller!.removeListener(tabListner); // 리스너에 등록한 함수 등록 취소
    shakeDetector!.stopListening(); // 흔들기 감지 중지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          tabcontroller!.index = (tabcontroller!.index + 1) % 2;
          setState(() {});
        },
        // onDoubleTap: () {
        //   MyPhoneShake();
        //   setState(() {});
        // },
        child: TabBarView(
          controller: tabcontroller,
          children: renderChildren(), //PageView 처럼 화면을 제공할수 있다. 위젯을 받는다.
        ),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number),
      SettingScreen(threshold: threshold, onThresholdChange: onThresholdChange),
    ];
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
        currentIndex: tabcontroller!.index, //지금인덱스는 controller가 가지고 있다.
        //controller는 TabBarView의 컨트롤러이고 이 인덱스를 가지고 있다.
        //이는 TabBarView가 보는 위치를 같이 currerntIndex에 저장한다.
        onTap: (int index) {
          //index가 위치 값을 가지고 있다.
          // 탭이 선택될때마다 실행되는 함수
          setState(() {
            tabcontroller!.animateTo(index); //자연스럽게 화면이 index로 넘어가도록한다.
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.edgesensor_high_outlined), label: '주사위'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: '설정'),
        ]);
  }

  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }
}
