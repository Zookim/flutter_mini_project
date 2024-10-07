import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAppBar extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onDeleteItem;
  final VoidCallback onSaveImage;

  MainAppBar(
      {required this.onPickImage,
      required this.onDeleteItem,
      required this.onSaveImage,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // TODO: implement build
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // 일정간격 양끝과 화면 끝은 절반 간격
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
              onPressed: onPickImage,
              icon: Icon(
                Icons.image_search_rounded,
                color: Colors.black.withOpacity(0.5),
              )),
          IconButton(
              onPressed: onDeleteItem,
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.black.withOpacity(0.5),
              )),
          IconButton(
              onPressed: onSaveImage,
              icon: Icon(
                Icons.save_alt_outlined,
                color: Colors.black.withOpacity(0.5),
              )),
        ],
      ),
    );
  }
}
