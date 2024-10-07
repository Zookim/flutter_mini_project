import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  XFile? image; // 선택한 이미지를 저장할 변수
  Set<StickerModel> stickers = {}; //화면에 추가된 스티커를 저장할 변수
  String? selectedId; //현재 선택된 스티커의 아이디
  GlobalKey imgKey = GlobalKey(); //이미지로 전환할 위젯에 입력할 키값

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final permission = Permission.storage.request();
    // if (permission != PermissionStatus.granted &&
    //     permission != PermissionStatus.limited) {
    //   openAppSettings();
    // }
    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // 자식들을 최대크기로 펼친다.사진 때문에
        children: [
          renderbody(),
          Positioned(
              //탭하면 사라지도록
              top: 0, //맨위에
              right: 0, //양끝에 펼친다.
              left: 0,
              child: MainAppBar(
                onPickImage: onPickImage,
                onDeleteItem: onDeleteItem,
                onSaveImage: onSaveImage,
              )),
          if (image != null)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Footer(
                  onEmoticonTap: onEmoticonTap,
                ))
        ],
      ),
    );
  }

  Widget renderbody() {
    if (this.image != null) {
      return RepaintBoundary(
          key: imgKey, //이 키값으로 어디에서든지 접근가능
          child: Positioned.fill(
              child: InteractiveViewer(
            child: Stack(
                fit: StackFit.expand, //최대크기로
                children: [
                  Image.file(
                    File(this.image!.path),
                    fit: BoxFit.cover,
                  ),
                  ...stickers.map((sticker) => Center(
                        child: EmoticonSticker(
                            key: ObjectKey(sticker.id),
                            onTransform: () {
                              onTransform(sticker.id);
                            },
                            imgPath: sticker.imgPath,
                            isSelected: selectedId == sticker.id),
                      )),
                ]),
          )));
    } else {
      return Center(
          child: Icon(
        Icons.image_not_supported,
        color: Colors.grey.withOpacity(0.5),
      ));
    }
  }

  void onTransform(String id) {
    //스티커가 변형될때마다 변형중인 스티커를 현재 선택한 스티커로 지정
    setState(() {
      selectedId = id;
    });
  }

  void onEmoticonTap(int index) async {
    //footer에 있는 스티커를 탭하면
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(),
          imgPath: 'asset/img/emoticon_$index.png',
        ),
      };
    });
  }

  void onPickImage() async {
    // 선택되면 바로 렌더링한다.
    print('!!------select image from gallery-----!!');
    final pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = pickedImg;
    });
  }

  void onDeleteItem() {
    setState(() {
      stickers = stickers
          .where((sticker) => sticker.id != selectedId)
          .toSet(); //현재 선택된것을 뺀다.
    });
  }

  void onSaveImage() async {
    RenderRepaintBoundary boundary = imgKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary; //findRenderObject 위젯을 찾는다.

    ui.Image image = await boundary.toImage(); //바운더리를 이미지로 지정
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    //이미지에 저장하기
    final result = await ImageGallerySaver.saveImage(pngBytes, quality: 80);
    //저장후 snackbar보여주기
    print(result.toString());
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('저장되었습니다.')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('저장에 실패했습니다.')));
    }
  }
}
