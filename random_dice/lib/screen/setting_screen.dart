import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_dice/const/colors.dart';

class SettingScreen extends StatelessWidget {
  final double threshold; //slider의 값
  final ValueChanged<double> onThresholdChange; //?반환값?

  const SettingScreen({
    Key? key,
    required this.threshold,
    required this.onThresholdChange, //콜백함수를 매개변수로 받는다. root에서 setState 함수를 실행한다.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('민감도',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ))
            ],
          ),
        ),
        Slider(
          min: 0.1,
          max: 10.0,
          divisions: 101, //구간의 갯수,작으면 움직일때 걸린다.
          value: threshold, //선택값
          onChanged: onThresholdChange, // 값이 변경되면 실행되는 함수
          label:
              threshold.toStringAsFixed(1), // 슬라이더를 동작할때 표시되는 값, 소수점 1자리까지 표시
        ),
      ],
    );
  }
}
