import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:random_dice/const/colors.dart';

class HomeScreen extends StatelessWidget {
  final int number;
  const HomeScreen({
    required this.number,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('asset/img/${number}.png'),
              SizedBox(
                height: 30,
              ),
              Text(
                '오늘의 숫자',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                number.toString(),
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 60,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
