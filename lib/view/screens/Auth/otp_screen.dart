// ignore_for_file: use_build_context_synchronously, no_logic_in_create_state, body_might_complete_normally_catch_error

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_bank/routes/routes.dart';
import 'package:money_bank/view/src/components/loadingWrapper.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';
import 'package:money_bank/view/src/constants/imgConst.dart';
import 'package:money_bank/view/src/constants/string_const.dart';
import 'package:money_bank/view/src/provider/homeProvider.dart';
import 'package:money_bank/view/utils/firebaseClient.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OTPScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => OTPScreenState(phoneNumber: phoneNumber);
}

class OTPScreenState extends State<OTPScreen> {
  final String phoneNumber;
  OTPScreenState({required this.phoneNumber});

  FirebaseClient firebaseClient = FirebaseClient();

  final _formKey = GlobalKey<FormState>();

  final otpController = TextEditingController();
  var code = '';
  late Timer countdownTimer;
  int resendTime = 60;

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTime = resendTime - 1;
      });
      if (resendTime < 1) {
        stopTimer();
      }
    });
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  void resendOtp(r) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified Succesfuly')));
        },
        verificationFailed: (FirebaseAuthException e) {
          SnackBar snackBar = const SnackBar(
              content: Text("Something went wrong, pleaes try again later"));
          if (e.code == 'too-many-requests') {
            snackBar = const SnackBar(
              content: Text('Too Many Attempts'),
            );
          } else {
            snackBar = const SnackBar(
              content: Text('Something Went Wrong, Try Again later.'),
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          r.hideLoader();
        },
        codeSent: (String verificationId, int? resendToken) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      SnackBar snackBar = const SnackBar(
          content: Text("Something went wrong, pleaes try again later"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      r.hideLoader();
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double width = MediaQuery.of(context).size.width;
    return LoadingWrapper(
      child: Scaffold(
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 25),
                        child: SizedBox(
                            height: 80,
                            width: size.width,
                            child: Image.asset(appLogoImg)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35, bottom: 15),
                        child: SizedBox(
                            height: size.height * .3,
                            width: size.width,
                            child: Image.asset(otpImg)),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Text(
                          textAlign: TextAlign.center,
                          recOTPText,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF565656)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                phoneNumber,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                textAlign: TextAlign.center,
                                'Change Number',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: baseColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Pinput(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter OTP';
                                } else if (value.length < 4) {
                                  return 'Please enter valid OTP';
                                } else {
                                  return null;
                                }
                              },
                              controller: otpController,
                              showCursor: false,
                              focusedPinTheme: PinTheme(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: grey2Color,
                                      border: Border.all(
                                          width: 2,
                                          style: BorderStyle.solid,
                                          color: baseColor),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)))),
                              defaultPinTheme: PinTheme(
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  height: (width - 16) / 7,
                                  width: (width - 16) / 8,
                                  decoration: BoxDecoration(
                                      color: grey2Color,
                                      border: Border.all(
                                          width: 2,
                                          style: BorderStyle.solid,
                                          color: grey2Color),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)))),
                              length: 6,
                              onChanged: (value) {
                                code = value;
                              },
                            ),
                          ),
                        ),
                      ),
                      resendTime == 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  provider.showLoader();
                                  resendOtp(provider);
                                },
                                child: const Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                    color: baseColor,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      resendTime != 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'You can resend OTP after $resendTime second(s)',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nuntio',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27, vertical: 18),
                        child: InkWell(
                          onTap: () {
                            try {
                              provider.showLoader();
                              PhoneAuthCredential cred =
                                  PhoneAuthProvider.credential(
                                      verificationId: widget.verificationId,
                                      smsCode: otpController.text.toString());

                              FirebaseAuth.instance
                                  .signInWithCredential(cred)
                                  .then((value) async {
                                stopTimer();

                                await firebaseClient
                                    .getUserBy(value.user!.uid, context)
                                    .then((val) => {
                                          provider.hideLoader(),
                                          if (val)
                                            {
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  bottomBarRoute,
                                                  (route) => false)
                                            }
                                          else
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Please Register with Charan Sparsh'))),
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  registerRoute,
                                                  (route) => false,
                                                  arguments: {
                                                    "phone": phoneNumber,
                                                    "uid": value.user!.uid
                                                  })
                                            }
                                        })
                                    .catchError((e) {
                                  provider.hideLoader();
                                });
                                return;
                              }).catchError((e) {
                                provider.hideLoader();
                                SnackBar snackBar = SnackBar(
                                    content: Text(
                                        'The OTP you provide is Invalid $e'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            } catch (e) {
                              provider.hideLoader();

                              const snackBar = SnackBar(
                                content: Text(
                                    'Something went wrong, try again later'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                              height: 50,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: const Color(0xff00A010),
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                  child: Text(
                                textAlign: TextAlign.center,
                                verifyText,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor),
                              ))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
