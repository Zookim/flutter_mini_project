import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class selectedDayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;
  const selectedDayBanner(
      {required this.selectedDate, required this.count, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(fontWeight: FontWeight.w600, color: Colors.white);
    // TODO: implement build
    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                style: textStyle,
                '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일'),
            Text(
              '$count 개',
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
