import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_bank/model/user_model.dart';
import 'package:money_bank/view/screens/Auth/mobile_number.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';
import 'package:money_bank/view/src/constants/imgConst.dart';

import 'package:money_bank/view/src/provider/homeProvider.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatelessWidget {
  FirstScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    Future _handleSignIn() async {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      homeProvider.showLoader();
      try {
        print("done------------------------------------- ");
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        print("googleUser -------------------- $googleUser");

        if (googleUser == null) return;
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        print("userCredential -------------------- $authResult");
        //  final  user = UserModel(
        //     name: authResult.user?.displayName,
        //     email: authResult.user?.email,
        //   );
      } catch (e) {
        print("error - $e");
        homeProvider.hideLoader();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              Widget continueButton = TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              );

              return AlertDialog(
                // title: const Text("Password"),
                content: SizedBox(
                  height: 100,
                  child: Text(
                    "$e",
                  ),
                ),
                actions: [continueButton],
              );
            });
      }
    }

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                await _handleSignIn();
              },
              icon: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: baseColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    googleImage,
                    // scale: size.height * .021,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MobileScreen()));
              },
              icon: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    border: Border.all(color: baseColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    callImage,
                    // scale: size.height * .021,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
