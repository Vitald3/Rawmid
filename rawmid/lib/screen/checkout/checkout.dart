import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rawmid/controller/checkout.dart';
import 'package:rawmid/utils/constant.dart';
import 'package:rawmid/utils/extension.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/cart.dart';
import '../../model/checkout/shipping.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../../widget/h.dart';
import '../../widget/primary_button.dart';
import '../../widget/w.dart';
import '../home/city.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
        init: CheckoutController(),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 0,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 20),
                    child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: Get.back,
                              icon: Image.asset('assets/icon/left.png')
                          ),
                          if (controller.navController.city.value.isNotEmpty) w(10),
                          if (controller.navController.city.value.isNotEmpty) Expanded(
                              child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: Get.context!,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        useRootNavigator: true,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                        ),
                                        builder: (context) {
                                          return CitySearch();
                                        }
                                    ).then((_) {
                                      controller.navController.filteredCities.value = controller.navController.cities;
                                      controller.navController.filteredLocation.clear();
                                      controller.initialize(update: true);
                                    });
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.location_on_rounded, color: Color(0xFF14BFFF)),
                                            w(6),
                                            Flexible(
                                                child: Text(
                                                    controller.navController.city.value,
                                                    textAlign: TextAlign.right,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xFF14BFFF),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                )
                                            )
                                          ]
                                      )
                                  )
                              )
                          )
                        ]
                    ))
                )
            ),
            backgroundColor: Colors.white,
            body: Obx(() => SafeArea(
                bottom: false,
                child: controller.isLoading.value ? SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: controller.success.value ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        h(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Номер вашего заказа:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500
                                )
                            )
                          ]
                        ),
                        Text(
                          '${controller.order.value!.orderId}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        h(30),
                        Image.asset('assets/image/success.png', width: 130),
                        h(12),
                        Text(
                          'Заказ успешно оформлен!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8A95A8),
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          )
                        )
                      ]
                    ) : Form(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Оформление заказа',
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            h(24),
                            ValueListenableBuilder<int>(
                                valueListenable: Helper.trigger,
                                builder: (context, items, child) => Column(
                                    children: controller.navController.cartProducts.map((item) => _cartItemTile(item, controller.updateCart, controller.updateCart, controller.addWishlist)).toList()
                                )
                            ),
                            if (controller.acc.isNotEmpty) Container(
                                height: 120,
                                padding: const EdgeInsets.all(16),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                    color: Color(0xFFEBF3F6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Добавить аксессуары',
                                          style: TextStyle(
                                              color: Color(0xFF1E1E1E),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                          )
                                      ),
                                      h(15),
                                      Expanded(
                                          child: PageView.builder(
                                              clipBehavior: Clip.none,
                                              controller: controller.pageController,
                                              itemCount: controller.acc.length,
                                              padEnds: false,
                                              itemBuilder: (context, index) {
                                                return Obx(() => GestureDetector(
                                                    onTap: () => controller.addCartAcc(controller.acc[index].id, index),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                                        clipBehavior: Clip.antiAlias,
                                                        alignment: Alignment.center,
                                                        child: controller.accAdd[controller.acc[index].id] != null ? Container(
                                                          alignment: Alignment.center,
                                                          width: 20,
                                                          height: 20,
                                                          child: CircularProgressIndicator(color: primaryColor)
                                                        ) : CachedNetworkImage(
                                                            imageUrl: controller.acc[index].image,
                                                            errorWidget: (c, e, i) {
                                                              return Image.asset('assets/image/no_image.png');
                                                            },
                                                            height: 120,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover
                                                        )
                                                    )
                                                ));
                                              }
                                          )
                                      )
                                    ]
                                )
                            ),
                            h(20),
                            Text(
                                'Личная информация',
                                style: TextStyle(
                                    color: Color(0xFF1E1E1E),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            h(20),
                            Container(
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                decoration: ShapeDecoration(
                                    color: Color(0xFFEBF3F6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                ),
                                child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () => controller.setTab(0),
                                              child: Container(
                                                  height: 32,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  decoration: ShapeDecoration(
                                                      color: Color(controller.tab.value == 0 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Физическое лицо',
                                                      style: TextStyle(
                                                          color: controller.tab.value != 0 ? Color(0xFF80AEBF) : Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.24
                                                      )
                                                  )
                                              )
                                          )
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                              onTap: () => controller.setTab(1),
                                              child: Container(
                                                  height: 32,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  decoration: ShapeDecoration(
                                                      color: Color(controller.tab.value == 1 ? 0xFF80AEBF : 0xFFEBF3F6),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Юридическое лицо',
                                                      style: TextStyle(
                                                          color: controller.tab.value != 1 ? Color(0xFF80AEBF) : Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          letterSpacing: 0.24
                                                      )
                                                  )
                                              )
                                          )
                                      )
                                    ]
                                )
                            ),
                            h(16),
                            controller.tab.value == 0 ? Wrap(
                                runSpacing: 16,
                                children: controller.fizControllers.entries.map((item) => Column(
                                    children: [
                                        item.key == 'telephone' ? PhoneFormField(
                                        controller: controller.phoneField,
                                        validator: PhoneValidator.compose([PhoneValidator.required(Get.context!, errorText: 'Номер телефона обязателен'), PhoneValidator.validMobile(Get.context!, errorText: 'Номер телефона некорректен')]),
                                        countrySelectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(),
                                        isCountrySelectionEnabled: true,
                                        isCountryButtonPersistent: true,
                                        autofillHints: const [AutofillHints.telephoneNumber],
                                        countryButtonStyle: const CountryButtonStyle(
                                            showDialCode: true,
                                            showIsoCode: false,
                                            showFlag: true,
                                            showDropdownIcon: false,
                                            flagSize: 20
                                        ),
                                        onChanged: (val) => controller.saveField(item.key, '+${val.countryCode}${val.nsn}'),
                                        decoration: decorationInput(contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                                      ) :
                                      TextFormField(
                                          cursorHeight: 15,
                                          key: controller.errors[item.key],
                                          controller: item.value,
                                          validator: (value) => controller.validators[item.key]!(value),
                                          decoration: decorationInput(error: item.key == 'email' && controller.emailValidate.value ? dangerColor : null, prefixIcon: item.key == 'phone_buh' ? Image.asset('assets/icon/rph.png', width: 20) : null, hint: controller.controllerHints[item.key], contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          onChanged: (val) async {
                                            controller.saveField(item.key, val);

                                            if (item.key == 'email') {
                                              controller.validateEmailX(val);
                                            }
                                          }
                                      ),
                                      if (item.key == 'email' && controller.emailValidate.value) Padding(
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
                                      )
                                    ]
                                )).toList()
                            ) : Column(
                              children: [
                                Wrap(
                                    runSpacing: 16,
                                    children: controller.urControllers.entries.map((item) => Column(
                                        children: [
                                          item.key == 'phone_buh' ? PhoneFormField(
                                            controller: controller.phoneBuhField,
                                            validator: PhoneValidator.compose([PhoneValidator.required(Get.context!, errorText: 'Номер телефона обязателен'), PhoneValidator.validMobile(Get.context!, errorText: 'Номер телефона некорректен')]),
                                            countrySelectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(),
                                            isCountrySelectionEnabled: true,
                                            isCountryButtonPersistent: true,
                                            autofillHints: const [AutofillHints.telephoneNumber],
                                            countryButtonStyle: const CountryButtonStyle(
                                                showDialCode: true,
                                                showIsoCode: false,
                                                showFlag: true,
                                                showDropdownIcon: false,
                                                flagSize: 20
                                            ),
                                            decoration: decorationInput(contentPadding: const EdgeInsets.symmetric(horizontal: 8)),
                                          ) :
                                          TextFormField(
                                              cursorHeight: 15,
                                              key: controller.errors[item.key],
                                              controller: item.value,
                                              validator: (value) => controller.validators[item.key] != null ? controller.validators[item.key]!(value) : null,
                                              decoration: decorationInput(error: item.key == 'email_buh' && controller.emailValidate.value ? dangerColor : null, prefixIcon: item.key == 'phone_buh' ? Image.asset('assets/icon/rph.png', width: 20) : null, hint: controller.controllerHints[item.key], contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              keyboardType: TextInputType.text,
                                              textInputAction: TextInputAction.next,
                                              onChanged: (val) async {
                                                controller.saveField(item.key, val);

                                                if (item.key == 'email_buh') {
                                                  controller.validateEmailX(val);
                                                }
                                              }
                                          ),
                                          if (item.key == 'email_buh' && controller.emailValidate.value) Padding(
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
                                          )
                                        ]
                                    )).toList()
                                ),
                                h(16),
                                DropdownButtonFormField<String?>(
                                    value: controller.edo.value,
                                    isExpanded: true,
                                    decoration: decorationInput(hint: 'ЭДО', contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                    items: ['ДИАДОК', 'СБИС', 'НЕТ'].map((item) {
                                      return DropdownMenuItem<String?>(
                                          value: item,
                                          child: Text(item, style: TextStyle(fontSize: 14))
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller.edo.value = newValue ?? '';
                                      controller.saveField('edo', newValue ?? '');
                                    }
                                )
                              ]
                            ),
                            h(20),
                            Stack(
                                children: [
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Способ доставки',
                                            style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                        h(24),
                                        controller.shipping.length > 1 ? Column(
                                            children: controller.shipping.map((item) => _buildRadioTile(
                                                item: item,
                                                controller: controller
                                            )).toList()
                                        ) : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if ((controller.navController.user.value?.address ?? []).isEmpty) Text('Заполните адрес, чтобы увидеть способы доставки', style: TextStyle(fontSize: 12)),
                                              if ((controller.navController.user.value?.address ?? []).isNotEmpty) h(15),
                                              ...?controller.navController.user.value?.address.map((e) => GestureDetector(
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
                                                                      if (value ?? false) {
                                                                        controller.addressId.value = e.id;
                                                                      }
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
                                              if ((controller.navController.user.value?.address ?? []).isEmpty) Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          controller.saveField('zone_id', newValue ?? '');
                                                        },
                                                        validator: (value) => value == null ? 'Выберите регион' : null
                                                    ),
                                                    if (controller.regions.isNotEmpty) h(16),
                                                    if (controller.regions.isNotEmpty) TextFormField(
                                                        key: controller.errors['city'],
                                                        cursorHeight: 15,
                                                        controller: controller.controllersAddress['city'],
                                                        validator: (value) => controller.validators['city']!(value),
                                                        decoration: decorationInput(hint: 'Город *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        textInputAction: TextInputAction.next,
                                                        onChanged: (val) => controller.saveField('city', val),
                                                    ),
                                                    if (controller.regions.isNotEmpty) h(16),
                                                    if (controller.regions.isNotEmpty) TextFormField(
                                                        key: controller.errors['postcode'],
                                                        cursorHeight: 15,
                                                        onChanged: (val) => controller.saveField('postcode', val),
                                                        controller: controller.controllersAddress['postcode'],
                                                        decoration: decorationInput(hint: 'Индекс ', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        textInputAction: TextInputAction.next
                                                    ),
                                                    if (controller.regions.isNotEmpty) h(16),
                                                    if (controller.regions.isNotEmpty) TextFormField(
                                                        key: controller.errors['address_1'],
                                                        cursorHeight: 15,
                                                        onChanged: (val) => controller.saveField('address_1', val),
                                                        controller: controller.controllersAddress['address_1'],
                                                        validator: (value) => controller.validators['address_1']!(value),
                                                        decoration: decorationInput(hint: 'Адрес *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                                        textInputAction: TextInputAction.done
                                                    ),
                                                    h(20)
                                                  ]
                                              ),
                                              controller.navController.user.value != null ? controller.addAddress.value ? PrimaryButton(
                                                  text: 'Добавить адрес',
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
                                                          image: DecorationImage(image: AssetImage('assets/image/border.png')),
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
                                              ) : PrimaryButton(text: 'Применить', height: 40, loader: true, onPressed: () => controller.setShipping(address: true)),
                                              h(20)
                                            ]
                                        ),
                                        h(20),
                                        Text(
                                            'Способ оплаты',
                                            style: TextStyle(
                                                color: Color(0xFF1E1E1E),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                        h(24),
                                        Column(
                                            children: controller.payment.map((item) => GestureDetector(
                                                onTap: () => controller.setPayment(item),
                                                child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: Row(
                                                        children: [
                                                          Icon(
                                                              controller.selectedPayment.value == item.code ? Icons.radio_button_checked : Icons.circle_outlined,
                                                              color: primaryColor,
                                                              size: 24
                                                          ),
                                                          w(10),
                                                          Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                        item.title,
                                                                        style: TextStyle(
                                                                            color: Color(0xFF141414),
                                                                            fontSize: 14,
                                                                            height: 1.40,
                                                                            letterSpacing: 0.14
                                                                        )
                                                                    ),
                                                                    h(4),
                                                                    if (item.paymentDiscount.isNotEmpty) Text(
                                                                        item.paymentDiscount.trim(),
                                                                        style: TextStyle(
                                                                            color: Color(0xFF8A95A8),
                                                                            fontSize: 12,
                                                                            height: 1.40,
                                                                            letterSpacing: 0.12
                                                                        )
                                                                    )
                                                                  ]
                                                              )
                                                          )
                                                        ]
                                                    )
                                                )
                                            )).toList()
                                        ),
                                        h(20),
                                        TextFormField(
                                            cursorHeight: 15,
                                            controller: controller.commentField,
                                            decoration: decorationInput(hint: 'Комментарий к заказу', contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                                            keyboardType: TextInputType.text,
                                            maxLines: 3,
                                            onChanged: (val) => controller.saveField('comment', val),
                                            textInputAction: TextInputAction.done
                                        ),
                                        h(20),
                                        Column(
                                            children: controller.totals.map((total) => _buildRow(total.title, total.text, isTotal: total.code == 'total')).toList()
                                        ),
                                        h(20),
                                        Divider(color: Color(0xFFDDE8EA), thickness: 1, height: 0.1),
                                        h(32),
                                        Text.rich(
                                            TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: 'Я прочитал ',
                                                      style: TextStyle(
                                                          color: Color(0xFF8A95A8),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500
                                                      )
                                                  ),
                                                  TextSpan(
                                                      recognizer: TapGestureRecognizer()..onTap = () {
                                                        showAdaptiveDialog(
                                                            context: Get.context!,
                                                            useRootNavigator: true,
                                                            useSafeArea: true,
                                                            builder: (c) {
                                                              controller.webPersonalController = WebViewController()
                                                                ..setJavaScriptMode(
                                                                    JavaScriptMode.unrestricted)
                                                                ..loadRequest(Uri.parse(uslUrl));

                                                              return Scaffold(
                                                                  backgroundColor: Colors.black45,
                                                                  body: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                          padding: EdgeInsets.all(20),
                                                                          height: Get.height * 0.7,
                                                                          child: Container(
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: Stack(
                                                                                  children: [
                                                                                    Padding(
                                                                                        padding: EdgeInsets.all(20),
                                                                                        child: Column(
                                                                                            children: [
                                                                                              Expanded(child: WebViewWidget(controller: controller.webPersonalController!))
                                                                                            ]
                                                                                        )
                                                                                    ),
                                                                                    Positioned(
                                                                                        right: 0,
                                                                                        top: 0,
                                                                                        child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 20, color: Colors.black))
                                                                                    )
                                                                                  ]
                                                                              )
                                                                          )
                                                                      )
                                                                  )
                                                              );
                                                            }
                                                        );
                                                      },
                                                      text: 'Условия соглашения сторон',
                                                      style: TextStyle(
                                                          color: Color(0xFF14BFFF),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500
                                                      )
                                                  ),
                                                  TextSpan(
                                                      text: ' и ',
                                                      style: TextStyle(
                                                          color: Color(0xFF8A95A8),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500
                                                      )
                                                  ),
                                                  TextSpan(
                                                      recognizer: TapGestureRecognizer()..onTap = () {
                                                        showAdaptiveDialog(
                                                            context: Get.context!,
                                                            useRootNavigator: true,
                                                            useSafeArea: true,
                                                            builder: (c) {
                                                              controller.webPersonalController = WebViewController()
                                                                ..setJavaScriptMode(
                                                                    JavaScriptMode.unrestricted)
                                                                ..loadRequest(Uri.parse(personalDataUrl));

                                                              return Scaffold(
                                                                  backgroundColor: Colors.black45,
                                                                  body: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Container(
                                                                          padding: EdgeInsets.all(20),
                                                                          height: Get.height * 0.7,
                                                                          child: Container(
                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                                                                              clipBehavior: Clip.antiAlias,
                                                                              child: Stack(
                                                                                  children: [
                                                                                    Padding(
                                                                                        padding: EdgeInsets.all(20),
                                                                                        child: Column(
                                                                                            children: [
                                                                                              Expanded(child: WebViewWidget(controller: controller.webPersonalController!))
                                                                                            ]
                                                                                        )
                                                                                    ),
                                                                                    Positioned(
                                                                                        right: 0,
                                                                                        top: 0,
                                                                                        child: IconButton(onPressed: Get.back, icon: Icon(Icons.close, size: 20, color: Colors.black))
                                                                                    )
                                                                                  ]
                                                                              )
                                                                          )
                                                                      )
                                                                  )
                                                              );
                                                            }
                                                        );
                                                      },
                                                      text: 'Обработки персональных данных',
                                                      style: TextStyle(
                                                          color: Color(0xFF14BFFF),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500
                                                      )
                                                  ),
                                                  TextSpan(
                                                      text: ' и согласен с условиями',
                                                      style: TextStyle(
                                                          color: Color(0xFF8A95A8),
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w500
                                                      )
                                                  )
                                                ]
                                            )
                                        ),
                                        h(20),
                                        PrimaryButton(text: 'Оформить', height: 50, loader: true, onPressed: controller.checkout)
                                      ]
                                  ),
                                  if (controller.preload.value) Positioned.fill(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: Get.height,
                                          width: Get.width,
                                          color: Colors.white.withOpacityX(0.8),
                                          child: CircularProgressIndicator(color: primaryColor)
                                      )
                                  )
                                ]
                            ),
                            h(20 + MediaQuery.of(context).padding.bottom)
                          ]
                      )
                    )
                ) : Center(
                    child: CircularProgressIndicator(color: primaryColor)
                )
            ))
        )
    );
  }

  Widget _buildRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(top: isTotal ? 16 : 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
                  )
              )
            ),
            w(16),
            Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
                )
            )
          ]
      )
    );
  }

  Widget _buildRadioTile({required ShippingModel item, required CheckoutController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            item.title,
            style: TextStyle(
                color: Color(0xFF141414),
                fontSize: 16,
                height: 1.40,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.14
            )
        ),
        h(12),
        Column(
          children: item.quote.map((e) => Column(
            children: [
              GestureDetector(
                  onTap: () {
                    if (controller.selectedShipping.value == e.code) {
                      return;
                    }

                    controller.selectedShipping.value = e.code;

                    if (e.title.contains('пункта выдачи')) {
                      controller.selectedPvz.value = null;
                      controller.selectedBBPvz.value = null;
                    } else {
                      controller.setShipping();
                    }
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                                controller.selectedShipping.value == e.code ? Icons.radio_button_checked : Icons.circle_outlined,
                                color: primaryColor,
                                size: 24
                            ),
                            w(10),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          e.title,
                                          style: TextStyle(
                                              color: Color(0xFF141414),
                                              fontSize: 14,
                                              height: 1.40,
                                              letterSpacing: 0.14
                                          )
                                      ),
                                      h(4),
                                      if (e.title.contains('пункта выдачи')) InkWell(
                                          onTap: () {
                                            controller.selectedShipping.value = e.code;

                                            showModalBottomSheet(
                                                context: Get.context!,
                                                isScrollControlled: true,
                                                useSafeArea: true,
                                                useRootNavigator: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                ),
                                                builder: (context) {
                                                  return e.code.contains('bb') ? _buildMapBB(controller) : _buildMap(controller);
                                                }
                                            );
                                          },
                                          child: Text(
                                              (controller.selectedPvz.value != null && e.code.contains('cdek')) || (controller.selectedBBPvz.value != null && e.code.contains('bb.')) ? 'Изменить ПВЗ' : 'Выбрать ПВЗ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14,
                                                  height: 1.40,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.12
                                              )
                                          )
                                      ),
                                      if (e.title.contains('пункта выдачи') && ((controller.selectedPvz.value != null && e.code.contains('cdek')) || (controller.selectedBBPvz.value != null && e.code.contains('bb.')))) Text(
                                          '${controller.selectedPvz.value?.code ?? controller.selectedBBPvz.value?.id ?? ''}: ${controller.selectedPvz.value?.address ?? controller.selectedBBPvz.value?.pvzAddr ?? ''}',
                                          style: TextStyle(
                                              color: Color(0xFF8A95A8),
                                              fontSize: 12,
                                              height: 1.40,
                                              letterSpacing: 0.12
                                          )
                                      ),
                                      if (!e.title.contains('пункта выдачи') && e.description.isNotEmpty) Text(
                                          e.description.trim(),
                                          style: TextStyle(
                                              color: Color(0xFF8A95A8),
                                              fontSize: 12,
                                              height: 1.40,
                                              letterSpacing: 0.12
                                          )
                                      )
                                    ]
                                )
                            ),
                            w(10),
                            Text(
                                Helper.formatPrice(e.cost.toDouble()),
                                style: TextStyle(
                                    color: Color(0xFF141414),
                                    fontSize: 14,
                                    height: 1.40,
                                    letterSpacing: 0.14
                                )
                            )
                          ]
                      )
                  )
              ),
              if (controller.selectedShipping.value == e.code && e.title.contains('До дверей')) Column(
                children: [
                  ...?controller.navController.user.value?.address.map((e) => GestureDetector(
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
                                          if (value ?? false) {
                                            controller.addressId.value = e.id;
                                          }
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
                  if (controller.addAddress.value || (controller.navController.user.value?.address ?? []).isEmpty) Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            controller.saveField('zone_id', newValue ?? '');
                          },
                          validator: (value) => value == null ? 'Выберите регион' : null
                      ),
                      if (controller.regions.isNotEmpty) h(16),
                      if (controller.regions.isNotEmpty) TextFormField(
                          key: controller.errors['city'],
                          cursorHeight: 15,
                          onChanged: (val) => controller.saveField('city', val),
                          controller: controller.controllersAddress['city'],
                          validator: (value) => controller.validators['city']!(value),
                          decoration: decorationInput(hint: 'Город *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next
                      ),
                      if (controller.regions.isNotEmpty) h(16),
                      if (controller.regions.isNotEmpty) TextFormField(
                          key: controller.errors['postcode'],
                          cursorHeight: 15,
                          onChanged: (val) => controller.saveField('postcode', val),
                          controller: controller.controllersAddress['postcode'],
                          decoration: decorationInput(hint: 'Индекс ', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next
                      ),
                      if (controller.regions.isNotEmpty) h(16),
                      if (controller.regions.isNotEmpty) TextFormField(
                          key: controller.errors['address_1'],
                          cursorHeight: 15,
                          onChanged: (val) => controller.saveField('address_1', val),
                          controller: controller.controllersAddress['address_1'],
                          validator: (value) => controller.validators['address_1']!(value),
                          decoration: decorationInput(hint: 'Адрес *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.done
                      ),
                      h(20)
                    ]
                  ),
                  if (controller.navController.user.value != null) controller.addAddress.value ? PrimaryButton(
                      text: 'Добавить адрес',
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
                              image: DecorationImage(image: AssetImage('assets/image/border.png')),
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
                  ),
                  h(20)
                ]
              )
            ]
          )).toList()
        ),
        h(6)
      ]
    );
  }

  Widget _buildMap(CheckoutController controller) {
    if (controller.userLocation.value == null) {
      controller.getUserLocation();
    }

    return Obx(() => Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.only(top: 20),
        child: FlutterMap(
            options: MapOptions(
                initialCenter: controller.userLocation.value ?? LatLng(55.853593, 37.501265),
                initialZoom: 3.0
            ),
            children: [
              TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),
              MarkerLayer(
                  markers: controller.pvz.map((pvz) {
                    return Marker(
                        point: LatLng(pvz.coordY, pvz.coordX),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                            onTap: () {
                              showAdaptiveDialog(
                                  context: Get.context!,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text(pvz.name, textAlign: TextAlign.center),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                                                        w(8),
                                                        Expanded(
                                                            child: Text(
                                                                'Адрес: ${pvz.address}',
                                                                style: TextStyle(fontSize: 14)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                                                        w(8),
                                                        Expanded(
                                                            child: Text(
                                                                'Часы работы: ${pvz.workTime}',
                                                                style: TextStyle(fontSize: 14)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                                                        w(8),
                                                        Expanded(
                                                            child: Text(
                                                                'Телефон: ${pvz.phone}',
                                                                style: TextStyle(fontSize: 14)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              if (pvz.note.isNotEmpty)
                                                Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: Text(
                                                        "📌 ${pvz.note}",
                                                        style: TextStyle(fontSize: 14, color: Colors.grey[700])
                                                    )
                                                )
                                            ]
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: Get.back,
                                              child: Text('Закрыть')
                                          ),
                                          TextButton(
                                              onPressed: () => controller.setPvz(pvz),
                                              child: Text('Выбрать')
                                          )
                                        ]
                                    );
                                  }
                              );
                            },
                            child: Icon(
                                Icons.location_on,
                                color: controller.selectedPvz.value == pvz ? Colors.red : Colors.blue,
                                size: 30
                            )
                        )
                    );
                  }).toList()
              )
            ]
        )
    ));
  }

  Widget _buildMapBB(CheckoutController controller) {
    if (controller.userLocation.value == null) {
      controller.getUserLocation();
    }

    return Obx(() => Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.only(top: 20),
        child: FlutterMap(
            options: MapOptions(
                initialCenter: controller.userLocation.value ?? LatLng(55.853593, 37.501265),
                initialZoom: 3.0
            ),
            children: [
              TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),
              MarkerLayer(
                  markers: controller.bbItems.map((pvz) {
                    return Marker(
                        point: LatLng(pvz.latitude, pvz.longitude),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                            onTap: () {
                              showAdaptiveDialog(
                                  context: Get.context!,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text(pvz.pvzName, textAlign: TextAlign.center),
                                        content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                                                        w(8),
                                                        Expanded(
                                                            child: Text(
                                                                'Адрес: ${pvz.pvzAddr}',
                                                                style: TextStyle(fontSize: 14)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                                                        w(8),
                                                        Expanded(
                                                            child: Text(
                                                                'Часы работы: ${pvz.work}',
                                                                style: TextStyle(fontSize: 14)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                                  child: Row(
                                                      children: [
                                                        Icon(Icons.location_on, color: Colors.blue, size: 20),
                                                        w(8),
                                                        Expanded(
                                                            child: Text(
                                                                'Телефон: ${pvz.phone}',
                                                                style: TextStyle(fontSize: 14)
                                                            )
                                                        )
                                                      ]
                                                  )
                                              )
                                            ]
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: Get.back,
                                              child: Text('Закрыть')
                                          ),
                                          TextButton(
                                              onPressed: () => controller.bbCallback(pvz),
                                              child: Text('Выбрать')
                                          )
                                        ]
                                    );
                                  }
                              );
                            },
                            child: Icon(
                                Icons.location_on,
                                color: controller.selectedBBPvz.value == pvz ? Colors.red : Colors.blue,
                                size: 30
                            )
                        )
                    );
                  }).toList()
              )
            ]
        )
    ));
  }

  Widget _cartItemTile(CartModel product, Function(CartModel) plus, Function(CartModel) minus, Function(String) addWishlist) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: product.image.isNotEmpty ? CachedNetworkImageProvider(product.image) : AssetImage('assets/image/empty.png'),
                          fit: BoxFit.cover
                      )
                  )
              ),
              w(12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            product.name,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 11,
                                fontWeight: FontWeight.w700
                            )
                        ),
                        if (product.color.isNotEmpty) h(4),
                        if (product.color.isNotEmpty) Text(
                            'Цвет: ${product.color}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600])
                        ),
                        h(8),
                        Text(
                            product.price,
                            style: TextStyle(
                                color: Color(0xFF1E1E1E),
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ]
                  )
              ),
              w(6),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => addWishlist(product.id),
                        child: Icon(Helper.wishlist.value.contains(product.id) ? Icons.favorite : Icons.favorite_border, color: Helper.wishlist.value.contains(product.id) ? primaryColor : Colors.black, size: 18)
                    ),
                    h(28),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                            children: [
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      product.quantity = product.quantity! - 1;
                                      minus(product);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Icon(Icons.remove, color: Colors.blue, size: 18),
                                  )
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  width: 35,
                                  child: Text(
                                      '${product.quantity}',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          height: 1.30
                                      )
                                  )
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        product.quantity = product.quantity! + 1;
                                        plus(product);
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Icon(Icons.add, color: Colors.blue, size: 18)
                                  )
                              )
                            ]
                        )
                    )
                  ]
              )
            ]
        )
    );
  }
}