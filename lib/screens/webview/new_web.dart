// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebScreen extends StatefulWidget {
//   const WebScreen({Key? key}) : super(key: key);

//   @override
//   _WebScreenState createState() => _WebScreenState();
// }

// class _WebScreenState extends State<WebScreen> {
  
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WebView(
//         initialUrl: "https://skoolearn.in",
//         javascriptMode: JavascriptMode.unrestricted,
//         navigationDelegate: (navigation) {
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }
