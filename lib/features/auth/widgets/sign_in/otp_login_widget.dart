import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/auth/widgets/condition_check_box_widget.dart';
import 'package:sixam_mart/features/auth/widgets/social_login_widget.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/validate_check.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class OtpLoginWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final FocusNode phoneFocus;
  final String? countryDialCode;
  final Function(CountryCode countryCode)? onCountryChanged;
  final Function() onClickLoginButton;
  final bool socialEnable;
  const OtpLoginWidget({super.key, required this.phoneController, required this.phoneFocus, required this.onCountryChanged, required this.countryDialCode,
    required this.onClickLoginButton, this.socialEnable = false});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<AuthController>(builder: (authController) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? Dimensions.paddingSizeLarge : 0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text('login'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.black87)),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Phone Field with white background and shadow
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomTextField(
              titleText: 'xxx-xxx-xxxxx'.tr,
              controller: phoneController,
              focusNode: phoneFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.phone,
              isPhone: true,
              onCountryChanged: onCountryChanged,
              countryDialCode: countryDialCode ?? Get.find<LocalizationController>().locale.countryCode,
              labelText: 'phone'.tr,
              required: true,
              validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_phone_number".tr),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => authController.toggleRememberMe(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 24, width: 24,
                    child: Checkbox(
                      side: BorderSide(color: Theme.of(context).hintColor),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: const Color(0xFF8A2BE2), // Purple color
                      value: authController.isActiveRememberMe,
                      onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('remember_me'.tr, style: robotoRegular),
                ],
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          const ConditionCheckBoxWidget(forSignUp: true),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          // Purple gradient button replacing CustomButton
          Container(
            width: double.infinity,
            height: isDesktop ? 50 : 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8A2BE2), Color(0xFF9932CC), Color(0xFF6A0DAD)],
              ),
              borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusSmall : 25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(isDesktop ? Dimensions.radiusSmall : 25),
                onTap: authController.isLoading ? null : onClickLoginButton,
                child: Container(
                  alignment: Alignment.center,
                  child: authController.isLoading 
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                    : Text(
                        'login'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                          fontWeight: isDesktop ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          socialEnable ? const SocialLoginWidget(onlySocialLogin: false) : const SizedBox(),

          socialEnable && isDesktop ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

          !socialEnable ? const SizedBox(height: 100) : const SizedBox(),

        ]),
      );
    });
  }
}
