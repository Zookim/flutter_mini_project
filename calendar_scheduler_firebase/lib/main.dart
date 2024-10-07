import 'package:calendar_scheduler/firebase_options.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  //debugRepaintRainbowEnabled = true; //디버깅에 편리
  WidgetsFlutterBinding.ensureInitialized(); //준비 될때까지 대기

//플러터 앱에 파이어베이스 설정 추가
//initializeApp : firebase초기화
//DefaultFirebaseOptions.currentPlatform : firebase_options.dart 설정을 적용
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting();

  //프로바이더 초기화
  //final repository = SchduleRepository();
  //final scheduleProvider = ScheduleProvider(repository: repository);

//하위위젯들에 프로바이더 제공
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
  );
}
