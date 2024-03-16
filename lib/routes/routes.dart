// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:money_bank/view/screens/Auth/mobile_number.dart';
import 'package:money_bank/view/screens/Auth/otp_screen.dart';
import 'package:money_bank/view/screens/Auth/register_screen.dart';
import 'package:money_bank/view/screens/bottom/bottom_bar.dart';
import 'package:money_bank/view/screens/home/home.dart';
import 'package:money_bank/view/screens/on_boarding/pageView.dart';
import 'package:money_bank/view/screens/profile/profile_screen.dart';
import 'package:money_bank/view/screens/splash.dart';

const initialRoute = "/";

const mobileRoute = "/Auth/mobile_number";
const otpRoute = "/Auth/otp_screen";
const registerRoute = "/Auth/register_screen";
const homeRoute = "/home_screen";
const mocktest = "/mocktest";
const bottomBarRoute = "/bottom_bar";
const aboutUsRoute = "/about_us";
const profileRoute = "/profile_screen";
const resultRoute = "/results_screen";
const certificateRoute = "/certificate";
const pageViewRoute = "/pageView";

final routes = {
  initialRoute: (context) => const SplashScreen(),
  mobileRoute: (context) => const MobileScreen(),
  otpRoute: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final verificationId = args['verficationId'];
    final phoneNumber = args['phoneNumber'];

    return OTPScreen(
      verificationId: verificationId,
      phoneNumber: phoneNumber,
    );
  },
  registerRoute: (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final phone = args['phone'];
    final uid = args['uid'];

    return RegisterScreen(phone: phone, uid: uid);
  },
  bottomBarRoute: (context) => const BottomBar(),
  homeRoute: (context) => const HomeScreen(),
  profileRoute: (context) => const ProfileScreen(),
  pageViewRoute: (context) => const PageViewScreen(),
};
