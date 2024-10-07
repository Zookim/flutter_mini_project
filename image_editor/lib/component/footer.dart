import 'package:flutter/material.dart';

//시그니쳐
typedef OnEmoticonTap = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmoticonTap onEmoticonTap;
  const Footer({required this.onEmoticonTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 150,
      color: Colors.white.withOpacity(0.7),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              10,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        onEmoticonTap(index + 1);
                      },
                      child: Image.asset(
                        'asset/img/emoticon_${index + 1}.png',
                        height: 100,
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
