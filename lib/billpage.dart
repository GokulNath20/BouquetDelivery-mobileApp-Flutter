// ignore_for_file: avoid_print, deprecated_member_use, unnecessary_string_escapes

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_bouquet_delivery/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'model/user.dart';
import 'package:flutter/services.dart';

class BillPage extends StatefulWidget {
  final String sessionId;
  final User user;

  const BillPage({Key? key, required this.user, required this.sessionId})
      : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  late WebViewController _webViewController;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _webViewController = webViewController,
        onPageFinished: (String url) {
          if (url == initialUrl) {
            print('Page finished loading: $url');

            _redirectToStripe(widget.sessionId);
          }
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('http://localhost:8080/#/success')) {
            Navigator.of(context).pushReplacementNamed('/success');
          } else if (request.url.startsWith('http://localhost:8080/#/cancel')) {
            Navigator.of(context).pushReplacementNamed('/cancel');
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String get initialUrl => 'https://marcinusx.github.io/test1/index.html';

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
// ignore: unnecessary_string_escapes
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({sessionId: '$sessionId'}).then(function (result) {
  
  result.error.message = 'Error'});''';

    try {
      await _webViewController.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}
