import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/auth/widgets/condition_check_box_widget.dart';
import 'package:sixam_mart/features/auth/widgets/sign_up_widget.dart';
import 'package:sixam_mart/features/auth/widgets/social_login_widget.dart';
import 'package:sixam_mart/features/verification/screens/forget_pass_screen.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/helper/validate_check.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';

class ManualLoginWidget extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final FocusNode phoneFocus;
  final FocusNode passwordFocus;
  final Function() onClickLoginButton;
  final Function()? onWebSubmit;
  final bool socialEnable;
  final Function()? onOtpViewClick;
  const ManualLoginWidget({
    super.key, required this.phoneController, required this.phoneFocus, required this.onClickLoginButton, required this.passwordController,
    required this.passwordFocus, this.onWebSubmit, this.socialEnable = false, this.onOtpViewClick,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveHelper.isDesktop(context);
    return GetBuilder<AuthController>(builder: (authController) {
      
      if(isDesktop) {
        return webView(isDesktop, context, authController);
      }
      
      return Column(mainAxisSize: MainAxisSize.min, children: [
        
        // // Full width logo container at top
        // Container(
        //   width: double.infinity,
        //   height: 120,
        //   margin: const EdgeInsets.only(top: 40, bottom: 20),
        //   decoration: BoxDecoration(
        //     gradient: const LinearGradient(
        //       colors: [Color(0xFF8A2BE2), Color(0xFF9932CC), Color(0xFF6A0DAD)],
        //     ),
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       // Your app logo here - replace with actual logo
        //       Image.asset(
        //         Images.logo, // Use your actual logo image
        //         width: 80,
        //         height: 60,
        //         color: Colors.white,
        //         errorBuilder: (context, error, stackTrace) {
        //           // Fallback icon if logo not found
        //           return const Icon(Icons.local_shipping, color: Colors.white, size: 40);
        //         },
        //       ),
        //       const SizedBox(height: 8),
        //       const Text(
        //         'Online FMCG and Courier Service',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        
        const SizedBox(height: 30),
        
        Align(
          alignment: Alignment.topLeft,
          child: Text('Log In', style: robotoBold.copyWith(fontSize: 28, color: Colors.black87)),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Phone Field with white background
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
            onCountryChanged: (countryCode) => authController.countryDialCode = countryCode.dialCode!,
            countryDialCode: authController.isNumberLogin ? authController.countryDialCode : null,
            labelText: 'Phone Number',
            titleText: 'enter_email_or_phone'.tr,
            controller: phoneController,
            focusNode: phoneFocus,
            nextFocus: passwordFocus,
            inputType: TextInputType.emailAddress,
            prefixImage: authController.isNumberLogin ? null : Images.emailWithPhoneIcon,
            onChanged: (String text){
              final numberRegExp = RegExp(r'^[+]?[0-9]+$');
              final notNumberRegExp = RegExp(r'[^0-9+]');

              if(text.isEmpty && authController.isNumberLogin){
                authController.toggleIsNumberLogin();
              }
              if(text.startsWith(numberRegExp) && !text.contains(notNumberRegExp) && !authController.isNumberLogin ){
                authController.toggleIsNumberLogin();
                phoneController.text = text.replaceAll("+", "");
              }
              final emailRegExp = RegExp(r'@');
              if((text.contains(emailRegExp) || text.contains(notNumberRegExp)) && authController.isNumberLogin){
                authController.toggleIsNumberLogin();
              }
            },
            validator: (String? value){
              if(authController.isNumberLogin && ValidateCheck.getValidPhone(authController.countryDialCode+value!) == ""){
                return "enter_valid_phone_number".tr;
              }
              return (GetUtils.isPhoneNumber(authController.countryDialCode+value!.tr) || GetUtils.isEmail(value.tr)) ? null : 'enter_email_address_or_phone_number'.tr;
            },
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        // Password Field with white background
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
            titleText: '8_character'.tr,
            controller: passwordController,
            focusNode: passwordFocus,
            inputAction: TextInputAction.done,
            inputType: TextInputType.visiblePassword,
            prefixIcon: Icons.lock,
            isPassword: true,
            onSubmit: (text) => (GetPlatform.isWeb) ? onWebSubmit : null,
            labelText: 'Password',
            required: true,
            validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_password".tr),
          ),
        ),
        
        SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () => authController.toggleRememberMe(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24, width: 24,
                  child: Checkbox(
                    side: BorderSide(color: Theme.of(context).hintColor),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: const Color(0xFF8A2BE2),
                    value: authController.isActiveRememberMe,
                    onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text('remember_me'.tr, style: robotoRegular),
              ],
            ),
          ),

          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {
              Get.toNamed(RouteHelper.getForgotPassRoute());
            },
            child: Text('Forgot Password?', style: robotoRegular.copyWith(color: const Color(0xFF8A2BE2))),
          ),
        ]),

        const SizedBox(height: Dimensions.paddingSizeLarge),

        const ConditionCheckBoxWidget(forSignUp: true),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

        // Purple Login Button
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
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: isDesktop ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        // Sign Up Row with purple theme
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("I don't have an account ", style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
          InkWell(
            onTap: authController.isLoading ? null : () {
              Get.toNamed(RouteHelper.getSignUpRoute());
            },
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Text('Sign Up', style: robotoMedium.copyWith(color: const Color(0xFF8A2BE2))),
            ),
          ),
        ]),

        SizedBox(height: isDesktop ? Dimensions.paddingSizeLarge : 20),

        // OTP Section (keeping original)
        onOtpViewClick != null ? Column(children: [
          Text('or'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text('sign_in_with'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            InkWell(
              onTap: onOtpViewClick,
              child: Text('otp'.tr, style: robotoRegular.copyWith(color: const Color(0xFF8A2BE2), decoration: TextDecoration.underline)),
            ),
          ]),
        ]) : const SizedBox(),

        // Social Login with styled icons
        socialEnable ? Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.g_mobiledata, color: Color(0xFF4285F4), size: 25),
              ),
              const SizedBox(width: 20),
              // Facebook Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 25),
              ),
            ],
          ),
        ) : const SocialLoginWidget(onlySocialLogin: false),

      ]);
    });
  }

  Widget webView(bool isDesktop, BuildContext context, AuthController authController) {
    bool onlyManualLoginEnable = onOtpViewClick == null && !socialEnable;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

        Expanded(
          flex: 6,
          child: Column(children: [
            
            // Full width logo container for web too
            Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8A2BE2), Color(0xFF9932CC), Color(0xFF6A0DAD)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Images.logo,
                    width: 60,
                    height: 40,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_shipping, color: Colors.white, size: 30);
                    },
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Online FMCG and Courier Service',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            
            Align(
              alignment: Alignment.topLeft,
              child: Text('login'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            CustomTextField(
              onCountryChanged: (countryCode) => authController.countryDialCode = countryCode.dialCode!,
              countryDialCode: authController.isNumberLogin ? authController.countryDialCode : null,
              labelText: 'email_or_phone'.tr,
              titleText: 'enter_email_or_phone'.tr,
              controller: phoneController,
              focusNode: phoneFocus,
              nextFocus: passwordFocus,
              prefixImage: authController.isNumberLogin ? null : Images.emailWithPhoneIcon,
              inputType: TextInputType.emailAddress,
              onChanged: (String text){
                final numberRegExp = RegExp(r'^[+]?[0-9]+$');

                if (text.isEmpty && authController.isNumberLogin) {
                  authController.toggleIsNumberLogin();
                } else if (text.startsWith(numberRegExp) && !authController.isNumberLogin) {
                  authController.toggleIsNumberLogin();
                  final cleanedText = text.replaceAll("+", "");
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    phoneController.text = cleanedText;
                    phoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: phoneController.text.length),
                    );
                  });
                } else if (text.contains('@') && authController.isNumberLogin) {
                  authController.toggleIsNumberLogin();
                }
              },
              validator: (String? value){
                if(authController.isNumberLogin && ValidateCheck.getValidPhone(authController.countryDialCode+value!) == ""){
                  return "enter_valid_phone_number".tr;
                }
                return (GetUtils.isPhoneNumber(value!.tr) || GetUtils.isEmail(value.tr)) ? null : 'enter_email_address_or_phone_number'.tr;
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            CustomTextField(
              titleText: '8_character'.tr,
              controller: passwordController,
              focusNode: passwordFocus,
              inputAction: TextInputAction.done,
              inputType: TextInputType.visiblePassword,
              prefixIcon: Icons.lock,
              isPassword: true,
              onSubmit: (text) => (GetPlatform.isWeb) ? onWebSubmit : null,
              labelText: 'password'.tr,
              required: true,
              validator: (value) => ValidateCheck.validateEmptyText(value, "please_enter_password".tr),
            ),
            SizedBox(height: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                onTap: () => authController.toggleRememberMe(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 24, width: 24,
                      child: Checkbox(
                        side: BorderSide(color: Theme.of(context).hintColor),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: const Color(0xFF8A2BE2),
                        value: authController.isActiveRememberMe,
                        onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Text('remember_me'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  ],
                ),
              ),

              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  if(isDesktop) {
                    Get.back();
                    Get.dialog(const Center(child: ForgetPassScreen(fromDialog: true)));
                  } else {
                    Get.toNamed(RouteHelper.getForgotPassRoute());
                  }
                },
                child: Text('${'forgot_password'.tr}?', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF8A2BE2))),
              ),
            ]),

            const SizedBox(height: Dimensions.paddingSizeLarge),
            const ConditionCheckBoxWidget(forSignUp: true),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            CustomButton(
              buttonText: 'login'.tr,
              radius: Dimensions.radiusDefault,
              isBold: isDesktop ? false : true,
              isLoading: authController.isLoading,
              onPressed: onClickLoginButton,
              fontSize: Dimensions.fontSizeSmall,
            ),

            onlyManualLoginEnable ? Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('do_not_have_account'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.dialog(
                      SizedBox(
                        width: 700,
                        child: Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          backgroundColor: Theme.of(context).cardColor,
                          insetPadding: EdgeInsets.zero,
                          child: const SignUpWidget(),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Text('sign_up'.tr, style: robotoMedium.copyWith(color: const Color(0xFF8A2BE2))),
                  ),
                ),
              ]),
            ) : const SizedBox(),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        ),

        !onlyManualLoginEnable ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraOverLarge, vertical: Dimensions.paddingSizeLarge),
            child: RotatedBox(
              quarterTurns: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 1,
                    child: Container(
                      color: Theme.of(context).disabledColor,
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or_login_with'.tr,
                      style: robotoMedium.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                    child: Container(
                      color: Theme.of(context).disabledColor,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) : const SizedBox(),

        !onlyManualLoginEnable ? Expanded(flex: 5, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [

          socialEnable ? const SocialLoginWidget(onlySocialLogin: true, showWelcomeText: false) : const SizedBox(),

          onOtpViewClick != null ? Container(
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5, offset: const Offset(2, 2))],
            ),
            child: CustomInkWell(
              onTap: onOtpViewClick!,
              radius: Dimensions.radiusDefault,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(Images.otp, height: 20, width: 20),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('otp_sign_in'.tr, style: robotoMedium.copyWith()),
                ]),
              ),
            ),
          ) : const SizedBox(),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('do_not_have_account'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
            InkWell(
              onTap: () {
                Get.back();
                Get.dialog(
                  SizedBox(
                    width: 700,
                    child: Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
                      backgroundColor: Theme.of(context).cardColor,
                      insetPadding: EdgeInsets.zero,
                      child: const SignUpWidget(),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Text('sign_up'.tr, style: robotoMedium.copyWith(color: const Color(0xFF8A2BE2))),
              ),
            ),
          ]),
        ])) : const SizedBox(),

      ]),
    );
  } 
}
