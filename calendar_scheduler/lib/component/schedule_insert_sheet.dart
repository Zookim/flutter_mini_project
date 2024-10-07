import 'package:calendar_scheduler/component/input_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ScheduleInsertSheet extends StatefulWidget {
  final DateTime selectedDate;
  const ScheduleInsertSheet({required this.selectedDate, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ScheduleInsertSheetState();
}

class _ScheduleInsertSheetState extends State<ScheduleInsertSheet> {
  final GlobalKey<FormState> formkey = GlobalKey(); // 폼 키 생성
  int? startTime;
  int? endTime;
  String? content;

  @override
  Widget build(BuildContext context) {
    //키보드 높이 반큼 올려준다. (시스템이 차지하는 아래부분의 높이 인데 보통 키보드가 차지하는 높이)
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    print(bottomInset);
    return Form(
        // Text 필드를 한번에 관리할수 있는 폼
        key: formkey,
        child: SafeArea(
            child: Container(
                height: MediaQuery.sizeOf(context).height / 2 +
                    bottomInset, //화면의 반을 차지하도록한다. 컨테이너크기를 늘린다.
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 8,
                      left: 8,
                      right: 8,
                      bottom: bottomInset), //늘어난 만큼 띄운다.
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                            child: InputTextField(
                          label: '시작',
                          isTime: true,
                          onSaved: (String? val) {
                            startTime = int.parse(val!); //값을 저장한다.
                          },
                          validator: timeValidator,
                        )),
                        SizedBox(width: 8),
                        Expanded(
                            child: InputTextField(
                          label: '종료',
                          isTime: true,
                          onSaved: (String? val) {
                            endTime = int.parse(val!);
                          },
                          validator: timeValidator,
                        )),
                      ]),
                      SizedBox(height: 6),
                      Expanded(
                          child: InputTextField(
                        label: '일정',
                        isTime: false,
                        onSaved: (String? val) {
                          content = val;
                        },
                        validator: contentValidator,
                      )),
                      SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: onSavePressed,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: PRIMARY_COLOR,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)))),
                            child: Text('저장')),
                      )
                    ],
                  ),
                ))));
  }

  void onSavePressed() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save(); // 검증이 완료되면 저장
      await GetIt.I<LocalDatabase>().createSchedule(SchedulesCompanion(
          startTime: d.Value(startTime!),
          endTime: d.Value(endTime!),
          content: d.Value(content!),
          date: d.Value(widget.selectedDate)));
      Navigator.of(context).pop(); //뒤로가기
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장되었습니다.')));
    }
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return '시간을 입력하세요';
    }
    int? number;
    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력하세요';
    }

    if (number < 0 || number > 24) {
      return '0~24의 값을 입력하세요';
    }
    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력하세요';
    }
    return null;
  }
}
