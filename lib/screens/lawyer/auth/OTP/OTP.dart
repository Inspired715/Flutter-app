import 'dart:async';

import 'package:inkozi/screens/lawyer/auth/login/C/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inkozi/UTILIS/colors.dart';
import 'package:inkozi/UTILIS/text_style.dart';
import 'package:get/get.dart';
import 'package:inkozi/widgets/custom_snackbar.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../../../../widgets/widget.dart';

class OTPVerifyLawyer extends StatefulWidget {
  String? phone;

  OTPVerifyLawyer({
    super.key,
    required this.phone,
  });

  static String verify = ''; // This should be a class variable

  @override
  State<OTPVerifyLawyer> createState() => _OTPVerifyLawyerState();
}

class _OTPVerifyLawyerState extends State<OTPVerifyLawyer> {
  OtpFieldController otpController = OtpFieldController();

  var code = '';

  int timerSeconds = 45;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void resendCode() async {
    try {
      LoginControllerLawyer.to
          .performLogin(
              navigate: false,
              context: context,
              verifiedPhone: widget.phone!,
              completephone: '')
          .then((value) {
        showCustomSnackBar("Resending code...", isError: true);
        setState(() {
          timerSeconds = 45;
        });
        startTimer();
      });
    } catch (e) {
      showCustomSnackBar("Verification failed", isError: true);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          action: SizedBox(),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: GetBuilder<LoginControllerLawyer>(initState: (state) {
            Get.put(LoginControllerLawyer());
          }, builder: (obj) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWithTitle(
                      title: 'Local Lawyers on demand',
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        width: 380.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.sp),
                            color: bgColor,
                            boxShadow: [
                              BoxShadow(
                                  color: headerBorderColor.withOpacity(0.3),
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 10.r)
                              // offset: Offset(0, 0))
                            ]),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),

                                Text(
                                  "OTP Verification",
                                  style: CustomTextStyle.pc20bold,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Enter the code sent to your number",
                                  // style:,
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                //
                                OTPTextField(
                                    controller: otpController,
                                    length: 6,
                                    width: MediaQuery.of(context).size.width,
                                    textFieldAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    fieldWidth: 45.w,
                                    otpFieldStyle: OtpFieldStyle(
                                        enabledBorderColor: headerFillColor,
                                        focusBorderColor: primaryColor,
                                        borderColor: primaryColor,
                                        backgroundColor: headerFillColor),
                                    fieldStyle: FieldStyle.box,
                                    style: TextStyle(fontSize: 17),
                                    onChanged: (pin) {
                                      setState(() {
                                        code = pin;
                                      });
                                    },
                                    onCompleted: (pin) {
                                      print("Completed: " + pin);
                                    }),
                                SizedBox(
                                  height: 10.h,
                                ),

                                timerSeconds.toString().padLeft(2, '0') == '00'
                                    ? InkWell(
                                        onTap: () {
                                          resendCode();
                                        },
                                        child: Text(
                                          'Resend Code',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: primaryColor,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Resend Code in 00:${timerSeconds.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ////////////
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: ButtonWithBg(
                                      btnName: 'Start Now',
                                      width: width,
                                      onPress: () {
                                        obj.verifyOTP(
                                            phone: widget.phone!,
                                            code: code,
                                            context: context);
                                      }),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),

                                //
                                // SizedBox(
                                //   height: 70.h,
                                // ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/loginlawyer');
                                  },
                                  child: Text(
                                    'Edit my mobile number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 15.sp),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                obj.loading == true
                    ? Container(
                        height: height,
                        width: width,
                        color: primaryColor.withOpacity(0.1),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        )),
                      )
                    : const SizedBox()
              ],
            );
          }),
        ),
      ),
    );
  }
}
