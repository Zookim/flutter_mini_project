import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/repository/schdule_repository.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() async {
  //debugRepaintRainbowEnabled = true; //디버깅에 편리
  WidgetsFlutterBinding.ensureInitialized(); //준비 될때까지 대기
  await initializeDateFormatting();

  //프로바이더 초기화
  final repository = SchduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

//하위위젯들에 프로바이더 제공
  runApp(ChangeNotifierProvider(
    create: (_) => scheduleProvider,
    child: MaterialApp(home: HomeScreen()),
  ));
}
