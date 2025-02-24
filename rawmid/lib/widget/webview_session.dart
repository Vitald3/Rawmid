import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/helper.dart';
import 'package:get/get.dart';

class WebViewWithSession extends StatefulWidget {
  const WebViewWithSession({super.key, required this.link});

  final String link;

  @override
  WebViewWithSessionState createState() => WebViewWithSessionState();
}

class WebViewWithSessionState extends State<WebViewWithSession> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          _getHtmlContent();
        }
      ))
      ..loadRequest(Uri.parse(widget.link), headers: {'Cookie': 'PHPSESSID=${Helper.prefs.getString('PHPSESSID')}'});
  }

  Future _getHtmlContent() async {
    String html = await _controller.runJavaScriptReturningResult(
        "document.documentElement.outerHTML;") as String;
    html = html.replaceAll('"', '');
    printPdf(html);
  }

  printPdf(String html) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('HTML Content\n$html')
        )
      )
    );

    Uint8List pdfData = await pdf.save();

    await Printing.layoutPdf(onLayout: (format) => pdfData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leadingWidth: 0,
          leading: SizedBox.shrink(),
          title: Padding(
              padding: const EdgeInsets.only(left: 4, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: Get.back,
                        icon: Image.asset('assets/icon/left.png')
                    ),
                    Image.asset('assets/image/logo.png', width: 70)
                  ]
              )
          )
      ),
      bottomSheet: WebViewWidget(controller: _controller)
    );
  }
}