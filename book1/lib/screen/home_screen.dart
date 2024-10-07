import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HomeScreen extends StatelessWidget {
  //const를 사용하면 HW리소스를 적게 사용할수 있다.
  const HomeScreen({Key? Key}) : super();

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.thingiverse.com'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('ThingGivers!'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (controller != null) {
                  controller
                      .loadRequest(Uri.parse('https://www.thingiverse.com'));
                }
              },
              icon: Icon(Icons.home))
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
