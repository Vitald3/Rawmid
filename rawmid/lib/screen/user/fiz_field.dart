import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widget/h.dart';
import '../../controller/user.dart';
import '../../utils/classes.dart';
import '../../utils/utils.dart';

class FizFieldView extends GetView<UserController> {
  const FizFieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              controller: controller.controllers['lastname'],
              focusNode: controller.focusNodes['lastname'],
              validator: (value) => controller.activeField.value == 'lastname' ? controller.validators['lastname']!(value) : null,
              decoration: decorationInput(hint: 'Фамилия *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              onEditingComplete: controller.save,
              onSaved: (val) => controller.save(),
              onTap: controller.save
          ),
          h(16),
          TextFormField(
              controller: controller.controllers['firstname'],
              focusNode: controller.focusNodes['firstname'],
              validator: (value) => controller.activeField.value == 'firstname' ? controller.validators['firstname']!(value) : null,
              decoration: decorationInput(hint: 'Имя *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              onEditingComplete: controller.save,
              onSaved: (val) => controller.save(),
              onTap: controller.save
          ),
          h(16),
          TextFormField(
              controller: controller.controllers['telephone'],
              focusNode: controller.focusNodes['telephone'],
              validator: (value) => controller.activeField.value == 'telephone' ? controller.validators['telephone']!(value) : null,
              decoration: decorationInput(hint: '+7 (___) ___ __ __', contentPadding: const EdgeInsets.symmetric(horizontal: 8), prefixIcon: Image.asset('assets/icon/rph.png')),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              inputFormatters: [PhoneNumberFormatter()],
              textInputAction: TextInputAction.next,
              onEditingComplete: controller.save,
              onSaved: (val) => controller.save(),
              onTap: controller.save
          ),
          h(16),
          TextFormField(
              controller: controller.controllers['email'],
              focusNode: controller.focusNodes['email'],
              validator: (value) => controller.activeField.value == 'email' ? controller.validators['email']!(value) : null,
              decoration: decorationInput(hint: 'E-mail *', contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              onEditingComplete: controller.save,
              onSaved: (val) => controller.save(),
              onTap: controller.save
          )
        ]
    );
  }
}