import 'package:assignment/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewDemo extends StatefulWidget {
  WebviewDemo({Key? key}) : super(key: key);

  @override
  _WebviewDemoState createState() => _WebviewDemoState();
}

class _WebviewDemoState extends State<WebviewDemo> {
  late InAppWebViewController _webViewController;
  Uri? url;
  double progress = 0;
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            trailing: Text(_notificationInfo!.body.toString()),
            background: Colors.black,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse("https://skoolearn.in/signin")),
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      javaScriptEnabled: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      mediaPlaybackRequiresUserGesture: true,
                      useShouldOverrideUrlLoading: true),
                  android: AndroidInAppWebViewOptions(),
                  ios: IOSInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                      allowsBackForwardNavigationGestures: true)),
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (InAppWebViewController controller, Uri? url) {
                Loader.show(context, progressIndicator: CustomLoader());
              },
              onLoadStop: (InAppWebViewController controller, Uri? url) async {
                Loader.hide();
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunch(uri.toString())) {
                    // Launch the App
                    await launch(uri.toString());
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                } else {
                  return NavigationActionPolicy.ALLOW;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
