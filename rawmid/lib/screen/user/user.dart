import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawmid/screen/user/address.dart';
import 'package:rawmid/screen/user/profile.dart';
import 'package:rawmid/utils/constant.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../utils/classes.dart';
import '../../utils/utils.dart';
import 'account_setting.dart';
import 'fiz_field.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (controller) => Scaffold(
          appBar: AppBar(
                backgroundColor: Colors.white,
                titleSpacing: 20,
                leadingWidth: 0,
                leading: SizedBox.shrink(),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: Get.back,
                          child: Image.asset('assets/icon/left.png')
                      ),
                      Image.asset('assets/image/logo.png', width: 70)
                    ]
                )
            ),
          backgroundColor: Colors.white,
          body: Obx(() => SafeArea(
              bottom: false,
              child: controller.isLoading.value ? SingleChildScrollView(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 34),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        h(20),
                        Text(
                          'Настройки',
                          style: TextStyle(
                            color: Color(0xFF1B1B1B),
                            fontSize: 24,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        h(20),
                        controller.edit.value ? Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              controller.tab.value == 0 ? FizFieldView() : Wrap(
                                runSpacing: 16,
                                children: controller.controllerUr.entries.map((item) => TextFormField(
                                    controller: item.value,
                                    focusNode: controller.focusNodeUrAddress[item.key],
                                    validator: (value) => controller.activeField.value == item.key ? controller.validators[item.key]!(value) : null,
                                    decoration: decorationInput(prefixIcon: item.key == 'phone_buh' ? Image.asset('assets/icon/rph.png') : null, hint: controller.controllerHints[item.key], contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: item.key == 'phone_buh' ? [PhoneNumberFormatter()] : null,
                                    keyboardType: item.key == 'phone_buh' ? TextInputType.number : TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: controller.saveUz,
                                    onSaved: (val) => controller.saveUz(),
                                    onTap: controller.saveUz
                                )).toList()
                              ),
                              h(16),
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
                              )
                            ]
                          )
                        ) : ProfileSection(),
                        h(22),
                        AddressView(),
                        h(50),
                        AccountSettingView()
                      ]
                  )
              ) : Center(
                  child: CircularProgressIndicator(color: primaryColor)
              )
          ))
        )
    );
  }
}