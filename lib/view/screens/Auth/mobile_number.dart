// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_bank/view/src/components/loadingWrapper.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';
import 'package:money_bank/view/src/constants/imgConst.dart';
import 'package:money_bank/view/src/constants/string_const.dart';
import 'package:money_bank/view/src/provider/homeProvider.dart';
import 'package:money_bank/routes/routes.dart';
import 'package:provider/provider.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController countryCode = TextEditingController();
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  Future _sendOtp(p) async {
    try {
      p.setLoader();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode.text + _phoneController.text.toString(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            if (mounted) {
              setState(() {});
            }

            await auth.signInWithCredential(credential);

            // Access the user's phone number
            p.hideLoader();
          } on FirebaseAuthException catch (e) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Given Phone Number is Not Valid $e}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 70,
                          decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(7)),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });

            p.hideLoader();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          SnackBar snackBar = SnackBar(
              content: Text("Something went wrong, pleaes try again later $e"));
          if (e.code == 'invalid-phone-number') {
            snackBar = const SnackBar(
              content: Text('The provided phone number is not valid.'),
            );
          } else if (e.code == 'too-many-requests') {
            snackBar = const SnackBar(
              content: Text('Too Many Attempts'),
            );
          }
          p.hideLoader();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushNamed(context, otpRoute, arguments: {
            "verficationId": verificationId,
            "phoneNumber": _phoneController.text
          });
          SnackBar snackbar = SnackBar(
            content: Text('OTP Sent to ${_phoneController.text}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          p.hideLoader();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          p.hideLoader();
        },
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Given Phone Number is Not Valid'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(7)),
                    child: const Center(
                      child: Text(
                        "OK",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });

      //////
      // SnackBar snackbar = const SnackBar(
      //   content: Text('Given Phone Number is Not Valid'),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
      p.hideLoader();
    }
  }

  @override
  void initState() {
    countryCode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingWrapper(
      child: Scaffold(
        body: Consumer<HomeProvider>(builder: (_, provider, __) {
          return Padding(
            padding: const EdgeInsets.all(8),
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
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Text(
                        textAlign: TextAlign.center,
                        otpText,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF565656)),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        child: Container(
                          height: 50,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: greyColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                child: TextField(
                                  controller: countryCode,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                              const Text(
                                '|',
                                style:
                                    TextStyle(fontSize: 20, color: baseColor),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.length != 10) {
                                      return "Invalid phone number";
                                    }
                                    return null;
                                  },
                                  controller: _phoneController,
                                  onChanged: (value) {},
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter mobile number',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 27, vertical: 18),
                      child: InkWell(
                        onTap: () async {
                          if (_phoneController.text.isNotEmpty &&
                              _phoneController.text.length == 10) {
                            provider.showLoader();
                            await _sendOtp(provider);
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Pleaase Enter valid 10 digit Phone Number'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: baseColor,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: const Center(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text(
                            //             'Pleaase Enter valid 10 digit Phone Number')));
                          }
                        },
                        child: Container(
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              requestOtpText,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: whiteColor),
                            ))),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 27,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, bottomBarRoute);
                              },
                              child: const Text(
                                'Skip...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
