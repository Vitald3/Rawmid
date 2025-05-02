import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/widget/primary_button.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../model/location.dart';
import '../../utils/utils.dart';
import '../../widget/switch.dart';
import '../../widget/w.dart';

class AddressView extends GetView<UserController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Адреса доставки', style: TextStyle(
              color: Color(0xFF8A95A8),
              fontSize: 14
          )),
          h(12),
          ...?controller.user.value?.address.map((e) => GestureDetector(
              onTap: () => controller.setAddress(e.id),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 20,
                            height: 24,
                            child: Radio(
                                value: e.def || controller.addressId.value == e.id,
                                groupValue: true,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  controller.setAddress(e.id);
                                }
                            )
                        ),
                        w(8),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      e.address,
                                      style: TextStyle(
                                          color: Color(0xFF1E1E1E),
                                          fontSize: 14,
                                          height: 1.40,
                                          letterSpacing: 0.14
                                      )
                                  ),
                                  if (e.def) h(4),
                                  if (e.def) Text('Основной', style: TextStyle(color: Colors.grey))
                                ]
                            )
                        )
                      ]
                  )
              )
          )),
          h(20),
          if (controller.addAddress.value && controller.country.isNotEmpty) newAddress(controller),
          if (controller.edit.value) controller.addAddress.value ? PrimaryButton(
              text: 'Сохранить',
              height: 40,
              loader: true,
              onPressed: controller.newAddress
          ) : GestureDetector(
              onTap: controller.newAddress,
              child:  Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      image: DecorationImage(image: AssetImage('assets/image/border.png'), fit: BoxFit.cover),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      )
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset('assets/icon/plus.png'),
                        w(8),
                        Text(
                            'Добавить адрес',
                            style: TextStyle(
                                color: Color(0xFF8A95A8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                            )
                        )
                      ]
                  )
              )
          )
        ]
    ));
  }

  Widget newAddress(UserController controller) {
    return Obx(() => Form(
        key: controller.formKeyAddress,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                  value: controller.country.value,
                  isExpanded: true,
                  decoration: decorationInput(hint: 'Страна', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: controller.countries.map((item) {
                    return DropdownMenuItem<String>(
                        value: item.countryId!,
                        child: Text(item.name!, style: TextStyle(fontSize: 14))
                    );
                  }).toList(),
                  onChanged: (val) => controller.setCountry(val),
                  validator: (value) => value == null ? 'Выберите страну' : null
              ),
              if (controller.regions.isNotEmpty) h(16),
              if (controller.regions.isNotEmpty) DropdownButtonFormField<String?>(
                  value: controller.region.value,
                  isExpanded: true,
                  decoration: decorationInput(hint: 'Регион', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                  items: controller.regions.map((item) {
                    return DropdownMenuItem<String?>(
                        value: item.zoneId,
                        child: Text(item.name!, style: TextStyle(fontSize: 14))
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.region.value = newValue ?? '';
                  },
                  validator: (value) => value == null ? 'Выберите регион' : null
              ),
              if (controller.regions.isNotEmpty) h(16),
              if (controller.regions.isNotEmpty) TypeAheadField<Location>(
                  suggestionsCallback: controller.suggestionsCallback,
                  controller: controller.controllersAddress['city'],
                  focusNode: controller.focusNodeAddress['city'],
                  itemBuilder: (context, e) => ListTile(title: Text(e.label)),
                  onSelected: (e) {
                    controller.controllersAddress['city']!.text = e.label;
                  },
                  builder: (context, textController, focusNode) {
                    return TextFormField(
                        controller: textController,
                        focusNode: focusNode,
                        cursorHeight: 15,
                        validator: (value) => controller.activeField.value == 'city' ? controller.validators['city']!(value) : null,
                        decoration: decorationInput(hint: 'Город *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next
                    );
                  }
              ),
              if (controller.regions.isNotEmpty) h(16),
              if (controller.regions.isNotEmpty) TextFormField(
                  controller: controller.controllersAddress['postcode'],
                  focusNode: controller.focusNodeAddress['postcode'],
                  cursorHeight: 15,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)
                  ],
                  decoration: decorationInput(hint: 'Индекс ', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next
              ),
              if (controller.regions.isNotEmpty) h(16),
              if (controller.regions.isNotEmpty) TypeAheadField<String>(
                  suggestionsCallback: controller.suggestionsCallback2,
                  controller: controller.controllersAddress['address_1'],
                  focusNode: controller.focusNodeAddress['address_1'],
                  itemBuilder: (context, e) => ListTile(title: Text(e)),
                  onSelected: (e) {
                    controller.controllersAddress['address_1']!.text = e;
                  },
                  builder: (context, textController, focusNode) {
                    return TextFormField(
                        controller: textController,
                        focusNode: focusNode,
                        cursorHeight: 15,
                        validator: (value) => controller.activeField.value == 'address_1' ? controller.validators['address_1']!(value) : null,
                        decoration: decorationInput(hint: 'Адрес *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done
                    );
                  }
              ),
              SwitchTile(title: 'Адрес по умолчанию', value: controller.addressDef.value, onChanged: (val) {
                controller.addressDef.value = val;
              }),
              h(20)
            ]
        )
    ));
  }
}