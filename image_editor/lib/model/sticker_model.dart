class StickerModel {
  final String id;
  final String imgPath;

  StickerModel(
      {required this.id,
      required this.imgPath,
});

  @override
  bool operator ==(Object other) {
    //==연산에대해 id값이 같으면 true로 반환
    return (other as StickerModel).id == id;
  }

  @override
  // set내에서 ID값이 같으면 같은 인스턴스로 인식
  int get hashCode => id.hashCode;
}
