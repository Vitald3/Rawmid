import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/checkout.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/checkout/order.dart';
import '../../widget/h.dart';

class PaymentView extends GetView<CheckoutController> {
  const PaymentView({super.key, required this.order});

  final OrderModel order;

  Future<void> _initializeWebView() async {
    controller.webController = WebViewController()
      ..addJavaScriptChannel(
          'ErrorChannel',
          onMessageReceived: (message) {
            debugPrint('JavaScript Error: ${message.message}');
          }
      )
      ..setNavigationDelegate(
          NavigationDelegate(
              onPageFinished: (String url) {
                _injectErrorCatcher();
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('checkout/success')) {
                  controller.setSuccess();
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              }
          )
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('$paymentUrl&order_id=${order.orderId}'));
  }

  void _injectErrorCatcher() async {
    await controller.webController?.runJavaScript('''
    (function() {
      var oldConsoleError = console.error;
      console.error = function(message) {
        ErrorChannel.postMessage("Ошибка в консоли: " + message);
        oldConsoleError.apply(console, arguments);
      };

      window.addEventListener('error', function(event) {
        ErrorChannel.postMessage("Ошибка: " + event.message + 
          "\\nИсточник: " + event.filename + 
          "\\nСтрока: " + event.lineno + 
          " Колонка: " + event.colno + 
          "\\n" + (event.error ? event.error.stack : ""));
      });

      window.addEventListener('unhandledrejection', function(event) {
        ErrorChannel.postMessage("Unhandled Promise Rejection: " + event.reason);
      });
    })();
  ''');

    Future.delayed(Duration(seconds: 3), () {
      controller.isPayLoad.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.isPayLoad.value) {
      _initializeWebView();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      height: Get.height * 0.8,
      clipBehavior: Clip.antiAlias,
      child: Obx(() => Stack(
        children: [
          Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              "Оплата заказа",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                          IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: Get.back
                          )
                        ]
                    )
                ),
                const Divider(height: 1),
                h(16),
                if (controller.webController != null) Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: WebViewWidget(
                      controller: controller.webController!
                    )
                  )
                )
              ]
          ),
          if (!controller.isPayLoad.value) Container(alignment: Alignment.center, color: Colors.white, width: Get.width, height: Get.height, child: CircularProgressIndicator(color: primaryColor))
        ]
      ))
    );
  }
}