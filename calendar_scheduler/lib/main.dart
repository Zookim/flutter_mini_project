import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get_it/get_it.dart';

void main() async {
  //debugRepaintRainbowEnabled = true; //디버깅에 편리
  WidgetsFlutterBinding.ensureInitialized(); //준비 될때까지 대기

  MobileAds.instance.initialize();
  await initializeDateFormatting();

  final database = LocalDatabase(); // DB 생성
  // GetIt(프로젝트 전역 의존성 주입)에 DB변수 추가
  //어디서든 GetIt.I를 통해 database변수에 접근가능
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}
