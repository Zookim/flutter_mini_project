import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/const/radius.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  const MainCalendar(
      {required this.onDaySelected, required this.selectedDate, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => MainCalendarState();
}

class MainCalendarState extends State<MainCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TableCalendar(
      locale: 'ko',
      focusedDay: widget.selectedDate,
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      daysOfWeekHeight: 20, //요일칸 높이 dow
      daysOfWeekStyle:
          DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.red)),
      calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          //cellPadding: EdgeInsets.all(100),
          tablePadding: EdgeInsets.all(15),
          cellMargin: EdgeInsets.fromLTRB(3, 5, 3, 5),
          //tableBorder: TableBorder.all(color: Colors.black),
          //rowDecoration: BoxDecoration(color: Colors.red),
          todayTextStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          todayDecoration: BoxDecoration(
              color: DARK_DRAY_COLOR,
              borderRadius: BorderRadius.all(DAY_CELL_RADIUS)),
          /*기본날짜 스타일*/
          defaultTextStyle: TextStyle(color: Colors.black),
          defaultDecoration: BoxDecoration(
              color: LIGHT_GREY_COLOR,
              borderRadius: BorderRadius.all(DAY_CELL_RADIUS)),
          /*주말 스타일*/
          weekendTextStyle: TextStyle(color: Colors.red),
          weekendDecoration: BoxDecoration(
            color: LIGHT_GREY_COLOR,
            borderRadius: BorderRadius.all(DAY_CELL_RADIUS),
          ),
          /*선택된 날짜 스타일 */
          selectedTextStyle:
              TextStyle(fontWeight: FontWeight.w700, color: PRIMARY_COLOR),
          selectedDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(DAY_CELL_RADIUS),
            border: Border.all(color: PRIMARY_COLOR, width: 1.0),
          )),
      headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              border: Border.all(color: Colors.black)),
          formatButtonTextStyle: TextStyle(),
          titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      onDaySelected: widget.onDaySelected,
      // 어떤 날짜를 선택된 날짜로 볼지 정하는 함수
      selectedDayPredicate: (day) =>
          day.year == widget.selectedDate.year &&
          day.month == widget.selectedDate.month &&
          day.day == widget.selectedDate.day,
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
    );
  }
}
