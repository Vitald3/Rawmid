import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:rawmid/controller/navigation.dart';
import 'package:rawmid/widget/module_title.dart';
import 'package:rawmid/widget/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/support.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/search.dart';
import '../../widget/search_bar.dart';
import 'package:flutter_map/flutter_map.dart' as map;

class SupportView extends GetView<NavigationController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(
        init: SupportController(),
        builder: (support) => Scaffold(
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
            backgroundColor: Colors.white,
            body: SafeArea(
                bottom: false,
                child: Obx(() => Stack(
                    children: [
                      SingleChildScrollView(
                          child: Stack(
                              children: [
                                if (support.isLoading.value) Container(
                                    color: Colors.white,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ColoredBox(
                                              color: Color(0xFFF0F0F0),
                                              child: Column(
                                                  children: [
                                                    h(20),
                                                    SearchBarView(),
                                                    h(20)
                                                  ]
                                              )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  h(20),
                                                  Text(
                                                      'Поддержка',
                                                      style: TextStyle(
                                                          color: Color(0xFF1E1E1E),
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.w700
                                                      )
                                                  ),
                                                  h(support.questions.isNotEmpty ? 32 : 6),
                                                  if (support.questions.isNotEmpty) Text(
                                                    'Часто задаваемые вопросы',
                                                    style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w700
                                                    )
                                                  ),
                                                  if (support.questions.isNotEmpty) h(20),
                                                  if (support.questions.isNotEmpty) Wrap(
                                                    children: List.generate(support.questions.length, (index) {
                                                      return Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              support.isExpandedList[index] = !support.isExpandedList[index];
                                                            },
                                                            child: Container(
                                                              color: Colors.transparent,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ListTile(
                                                                    title: Text(
                                                                      support.questions[index].question,
                                                                      style: TextStyle(
                                                                        color: Color(0xFF1E1E1E),
                                                                        fontSize: 16,
                                                                        height: 1.40
                                                                      )
                                                                    ),
                                                                    trailing: AnimatedRotation(
                                                                      turns: support.isExpandedList[index] ? 0.5 : 0,
                                                                      duration: Duration(milliseconds: 300),
                                                                      child: Icon(
                                                                        Icons.expand_more,
                                                                        color: Colors.grey
                                                                      )
                                                                    ),
                                                                    contentPadding: EdgeInsets.zero
                                                                  ),
                                                                  AnimatedSize(
                                                                    duration: Duration(milliseconds: 300),
                                                                    curve: Curves.easeInOut,
                                                                    child: support.isExpandedList[index] ? Transform.translate(
                                                                      offset: Offset(-8, 0),
                                                                      child: Padding(
                                                                          padding: EdgeInsets.symmetric(vertical: 8),
                                                                          child: Html(
                                                                              data: support.questions[index].answer,
                                                                              onLinkTap: (val, map, element) {
                                                                                if ((val ?? '').isNotEmpty) {
                                                                                  Helper.openLink(val!);
                                                                                }
                                                                              }
                                                                          )
                                                                      )
                                                                    ) : SizedBox.shrink()
                                                                  )
                                                                ]
                                                              )
                                                            )
                                                          ),
                                                          Divider(height: 1, color: Colors.grey[300]),
                                                        ]
                                                      );
                                                    }).toList()
                                                  ),
                                                  if (support.questions.isNotEmpty) h(20),
                                                  if (support.questions.isNotEmpty) Text(
                                                    'Остались вопросы?',
                                                    style: TextStyle(
                                                      color: Color(0xFF1E1E1E),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600
                                                    )
                                                  ),
                                                  h(20),
                                                  DropdownButtonFormField<int>(
                                                      value: support.type.value,
                                                      isExpanded: true,
                                                      decoration: decorationInput(hint: 'Отдел', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                                      items: List.generate(support.types.length, (index) {
                                                        return DropdownMenuItem<int>(
                                                            value: index,
                                                            child: Text(support.types[index], style: TextStyle(fontSize: 14))
                                                        );
                                                      }).toList(),
                                                      onChanged: (val) {
                                                        support.type.value = val;
                                                        support.subjectField.text = support.types[val!];
                                                      }
                                                  ),
                                                  h(16),
                                                  if (support.type.value == 1) Text.rich(
                                                      TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: 'Для сервисного обращения необходимо ',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                    letterSpacing: 0.30
                                                                )
                                                            ),
                                                            TextSpan(
                                                                text: 'авторизироваться',
                                                                recognizer: TapGestureRecognizer()..onTap = () {
                                                                  Get.toNamed('/login', parameters: {'route': '/support'});
                                                                },
                                                                style: TextStyle(
                                                                    color: primaryColor,
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.w700,
                                                                    letterSpacing: 0.30
                                                                )
                                                            )
                                                          ]
                                                      )
                                                  ),
                                                  if (support.type.value == 1) h(16),
                                                  Form(
                                                    key: support.formKey,
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                            key: support.target,
                                                            cursorHeight: 15,
                                                            autofocus: support.orderId.value != null,
                                                            controller: support.emailField,
                                                            decoration: decorationInput(hint: 'E-mail *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            onChanged: support.validateEmailX,
                                                            validator: (value) {
                                                              String? item;

                                                              if (value == null || value.isEmpty) item = 'Введите email';
                                                              if (value != null && !EmailValidator.validate(value)) item = 'Некорректный email';

                                                              return item;
                                                            },
                                                            textInputAction: TextInputAction.next
                                                        ),
                                                        if (support.emailValidate.value) Padding(
                                                            padding: const EdgeInsets.only(top: 4, left: 16),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                      'E-mail не существует',
                                                                      style: TextStyle(color: dangerColor, fontSize: 12)
                                                                  )
                                                                ]
                                                            )
                                                        ),
                                                        h(16),
                                                        TextFormField(
                                                            cursorHeight: 15,
                                                            controller: support.nameField,
                                                            decoration: decorationInput(hint: 'Имя *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            validator: (value) {
                                                              String? item;

                                                              if (value == null || value.isEmpty) item = 'Введите имя';

                                                              return item;
                                                            },
                                                            textInputAction: TextInputAction.next
                                                        ),
                                                        h(16),
                                                        if (support.type.value == 0 || support.type.value == 6) TextFormField(
                                                            cursorHeight: 15,
                                                            controller: support.orderField,
                                                            decoration: decorationInput(hint: 'Номер заказа', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            textInputAction: TextInputAction.next
                                                        ),
                                                        if (support.type.value == 0 || support.type.value == 6) h(16),
                                                        TextFormField(
                                                            cursorHeight: 15,
                                                            controller: support.subjectField,
                                                            decoration: decorationInput(hint: 'Тема', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            textInputAction: TextInputAction.next
                                                        ),
                                                        h(16),
                                                        TextFormField(
                                                            cursorHeight: 15,
                                                            controller: support.textField,
                                                            maxLines: 3,
                                                            validator: (value) {
                                                              String? item;

                                                              if (value == null || value.isEmpty) item = 'Введите текст';

                                                              return item;
                                                            },
                                                            decoration: decorationInput(hint: 'Текст *', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                            textInputAction: TextInputAction.done
                                                        )
                                                      ]
                                                    )
                                                  ),
                                                  h(16),
                                                  GestureDetector(
                                                    onTap: support.pickFile,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(image: AssetImage('assets/image/dotted.png'), fit: BoxFit.fill)
                                                        ),
                                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        child: Column(
                                                            children: [
                                                              Image.asset('assets/icon/download.png', width: 20),
                                                              h(4),
                                                              Text(
                                                                  'Загрузить файл',
                                                                  style: TextStyle(
                                                                      color: Color(0xFF8A95A8),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500
                                                                  )
                                                              )
                                                            ]
                                                        )
                                                    )
                                                  ),
                                                  h(16),
                                                  PrimaryButton(text: 'Задать вопрос', onPressed: support.send, height: 40),
                                                  h(32),
                                                  if (support.locations.isNotEmpty) ModuleTitle(title: 'Карта магазинов', type: true),
                                                  if (support.locations.isNotEmpty) Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12)
                                                      ),
                                                      clipBehavior: Clip.antiAlias,
                                                      height: 200,
                                                      width: double.infinity,
                                                      child: map.FlutterMap(
                                                          options: map.MapOptions(
                                                              initialCenter: support.lng.value ?? support.locations.first.lng,
                                                              initialZoom: 12
                                                          ),
                                                          mapController: support.mapController,
                                                          children: [
                                                            map.TileLayer(
                                                                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                                subdomains: ['a', 'b', 'c']
                                                            ),
                                                            map.MarkerLayer(
                                                                markers: support.locations.map((item) => map.Marker(
                                                                    point: item.lng,
                                                                    width: 40,
                                                                    height: 40,
                                                                    child: Icon(
                                                                        Icons.location_on,
                                                                        color: Colors.blue,
                                                                        size: 30
                                                                    )
                                                                )).toList()
                                                            )
                                                          ]
                                                      )
                                                  ),
                                                  if (support.locations.isNotEmpty) h(20),
                                                  if (support.locations.isNotEmpty) Wrap(
                                                    runSpacing: 16,
                                                    children: support.locations.map((item) => GestureDetector(
                                                      onTap: () {
                                                        support.mapController.move(item.lng, 12);
                                                      },
                                                      child: Container(
                                                          width: double.infinity,
                                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                                          decoration: ShapeDecoration(
                                                              color: Color(0x4CF0F0F0),
                                                              shape: RoundedRectangleBorder(
                                                                  side: BorderSide(width: 1, color: Color(0xFFDDE8EA)),
                                                                  borderRadius: BorderRadius.circular(6)
                                                              )
                                                          ),
                                                          child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    item.title,
                                                                    style: TextStyle(
                                                                        color: Color(0xFF1E1E1E),
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.w700,
                                                                        height: 1.40
                                                                    )
                                                                ),
                                                                h(24),
                                                                Flexible(
                                                                    child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        spacing: 12,
                                                                        children: [
                                                                          Padding(
                                                                              padding: EdgeInsets.only(top: 3),
                                                                              child: Image.asset('assets/icon/mark.png', width: 16, height: 16)
                                                                          ),
                                                                          Flexible(
                                                                              child: Text(
                                                                                  item.map,
                                                                                  style: TextStyle(
                                                                                      color: Color(0xFF1E1E1E),
                                                                                      fontSize: 16,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      height: 1.40
                                                                                  )
                                                                              )
                                                                          )
                                                                        ]
                                                                    )
                                                                ),
                                                                h(24),
                                                                Flexible(
                                                                    child: GestureDetector(
                                                                        onTap: () async {
                                                                          final url = Uri.parse('https://wa.me/${item.wa.replaceAll(RegExp(r'[^0-9]'), '')}');

                                                                          if (await canLaunchUrl(url)) {
                                                                            await launchUrl(url);
                                                                          } else {
                                                                            Helper.snackBar(error: true, text: 'Не удалось открыть WhatsApp');
                                                                          }
                                                                        },
                                                                        child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            spacing: 12,
                                                                            children: [
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(top: 3),
                                                                                  child: Image.asset('assets/icon/whatsapp.png', width: 16, height: 16)
                                                                              ),
                                                                              Flexible(
                                                                                  child: Text(
                                                                                      item.wa,
                                                                                      style: TextStyle(
                                                                                          color: Color(0xFF1E1E1E),
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w500
                                                                                      )
                                                                                  )
                                                                              )
                                                                            ]
                                                                        )
                                                                    )
                                                                ),
                                                                h(11),
                                                                Flexible(
                                                                    child: GestureDetector(
                                                                        onTap: () async {
                                                                          final url = Uri.parse('https://t.me/${item.tg}');

                                                                          if (await canLaunchUrl(url)) {
                                                                            await launchUrl(url);
                                                                          } else {
                                                                            Helper.snackBar(error: true, text: 'Не удалось открыть WhatsApp');
                                                                          }
                                                                        },
                                                                        child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            spacing: 12,
                                                                            children: [
                                                                              Padding(
                                                                                  padding: EdgeInsets.only(top: 3),
                                                                                  child: Image.asset('assets/icon/telegram.png', width: 16, height: 16)
                                                                              ),
                                                                              Flexible(
                                                                                  child: Text(
                                                                                      '@${item.tg}',
                                                                                      style: TextStyle(
                                                                                          color: Color(0xFF1E1E1E),
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.w500
                                                                                      )
                                                                                  )
                                                                              )
                                                                            ]
                                                                        )
                                                                    )
                                                                ),
                                                              ]
                                                          )
                                                      )
                                                    )).toList()
                                                  ),
                                                  h(20),
                                                  PrimaryButton(text: 'Вернуться на главную', height: 40, background: Colors.white, borderColor: primaryColor, borderWidth: 2, textStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w700), onPressed: () {
                                                    controller.onItemTapped(0);
                                                    Get.back();
                                                    Get.back();
                                                  }),
                                                  h(20 + MediaQuery.of(context).padding.bottom)
                                                ]
                                            )
                                          )
                                        ]
                                    )
                                ),
                                if (support.isLoading.value) SearchWidget()
                              ]
                          )
                      ),
                      if (!support.isLoading.value) Center(child: CircularProgressIndicator(color: primaryColor))
                    ]
                ))
            )
        )
    );
  }
}