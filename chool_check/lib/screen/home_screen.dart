import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  static final companyLatLng = LatLng(35.1835022, 129.0501946);
  //마커를 사용할때 markerId가 중복되는 값을 가지면 지도상에 표시되지 않는다.
  static final Marker marker =
      Marker(markerId: MarkerId('company'), position: companyLatLng);

  static final Circle circle = Circle(
    circleId: CircleId('checkCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: 100, //원믜 반지름, 미터단위
    strokeColor: Colors.blue, // 원의 테두리 색
    strokeWidth: 1, //원의 테두리 두께
  );

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩중
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == '위치권한이 허용되었습니다.') {
            return mapWidget(context: context);
          }
          //권한이 없는 경우
          return Center(child: Text(snapshot.data.toString()));
        },
      ),
    );
  }

  Widget mapWidget({required context}) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: companyLatLng, zoom: 16),
            myLocationEnabled: true, // 내위치를 지도에 보여준다.
            markers: Set.from([marker]), //set으로 입력한다.
            circles: Set.from([circle]),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timelapse_outlined,
                color: Colors.blue,
                size: 50,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final curPosition =
                      await Geolocator.getCurrentPosition(); //현위치
                  final dis = Geolocator.distanceBetween(
                      curPosition.latitude,
                      curPosition.longitude,
                      companyLatLng.latitude,
                      companyLatLng.longitude);

                  bool cancheck = dis < 100;

                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('체크하기'),
                          content:
                              Text(cancheck ? '체크하시겠습니까?' : '체크할수 없는 위치 입니다.'),
                          actions: [
                            TextButton(
                                // 취소시 false반환
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('취소')),
                            if (cancheck)
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('체크하기'))
                          ],
                        );
                      });
                },
                child: Text('체크하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        '오늘도 출첵',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnablued = await Geolocator.isLocationServiceEnabled();

    if (!isLocationEnablued) {
      return '위치 서비스를 활성화 해주세요';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();
    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
    }
    if (checkedPermission == LocationPermission.denied) {
      return '위치 권한을 허용해 주세요';
    }
    if (checkedPermission == LocationPermission.deniedForever) {
      return '설정에서 앱의 위치권한을 허용해 주세요';
    }
    return '위치권한이 허용되었습니다.';
  }
}
