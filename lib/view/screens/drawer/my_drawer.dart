// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_bank/model/user_model.dart';
import 'package:money_bank/routes/routes.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';
import 'package:money_bank/view/src/constants/imgConst.dart';
import 'package:money_bank/view/src/provider/homeProvider.dart';
import 'package:money_bank/view/utils/database_provider.dart';
import 'package:money_bank/view/utils/firebaseClient.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  UserModel user = UserModel();
  DatabaseProvider db = DatabaseProvider();

  getUser() async {
    await db.getUsers().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: whiteColor,
        child: ListView(
          padding: const EdgeInsets.only(top: 50, left: 10),
          children: [
            ListTile(
              leading: SizedBox(
                  height: 35, width: 35, child: Image.asset(leadingImg)),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    user.username ?? "Guest",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => const BottomBar()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.home,
                  color: baseColor,
                ),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const AboutUs()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.person,
                  color: baseColor,
                ),
                title: Text(
                  'About CS',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(
                  Icons.addchart,
                  color: baseColor,
                ),
                title: Text(
                  'Ongoing Contest',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context) async {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String verificationId = args?['verificationId'] ?? '';
    final String smsCode = args?['smsCode'] ?? '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // User chose not to delete
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Step 1: Get the current user
                  User? user = FirebaseAuth.instance.currentUser;
                  UserModel userDet =
                      Provider.of<HomeProvider>(context, listen: false).user;

                  if (user != null) {
                    // // Re-authenticate the user
                    // AuthCredential credential = PhoneAuthProvider.credential(
                    //   verificationId:
                    //       verificationId, // Replace with the actual verification ID
                    //   smsCode: smsCode, // Replace with the actual SMS code
                    // );

                    // await user.reauthenticateWithCredential(credential);

                    // Step 2: Delete user data from Firestore (optional)
                    await FirebaseClient()
                        .deleteUser(userDet.uid, "users")
                        .then((value) async => {
                              if (value)
                                {
                                  await FirebaseClient()
                                      .deleteUser(userDet.uid, "userStatus"),
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Something went wrong, Please try later"))),
                                }
                            });

                    // Step 3: Delete the user account from Firebase Authentication
                    await user.delete();
                    await DatabaseProvider().cleanUserTable();

                    Navigator.pushReplacementNamed(context,
                        initialRoute); // Navigate to a different screen

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account deleted successfully!'),
                      ),
                    );
                  } else {
                    // Handle the case where the user is not signed in
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User not signed in'),
                      ),
                    );
                  }
                } catch (e) {
                  // Handle errors, e.g., display an error message
                  print('$e');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

// // Function to show the confirmation dialog
//   Future<bool> showDeleteDialog(BuildContext context) async {
//     return await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Delete Account'),
//               content:
//                   const Text('Are you sure you want to delete your account?'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context)
//                         .pop(false); // User chose not to delete
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     try {
//                       // Step 1: Get the current user
//                       User? user = FirebaseAuth.instance.currentUser;

//                       if (user != null) {
//                         // Step 2: Delete user data from Firestore (optional)
//                         await FirebaseFirestore.instance
//                             .collection('users')
//                             .doc(user.uid)
//                             .delete();

//                         // Step 3: Delete the user account from Firebase Authentication
//                         await user.delete();
//                         await DatabaseProvider().cleanUserTable();
//                         Navigator.restorablePushNamedAndRemoveUntil(
//                             context, initialRoute, (route) => true);

//                         // Show a success message or navigate to a different screen
//                         if (kDebugMode) {
//                           print('Account deleted successfully!');
//                         }
//                       } else {
//                         // Handle the case where the user is not signed in
//                         if (kDebugMode) {
//                           print('User not signed in');
//                         }
//                       }
//                     } catch (e) {
//                       // Handle errors, e.g., display an error message
//                       if (kDebugMode) {
//                         print('Error deleting account: $e');
//                       }
//                     }
//                   },
//                   child: const Text('Delete'),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false; // Return false if the dialog is dismissed
//   }

  Widget loginButton() {
    if (user.uid == null || user.uid!.isEmpty) {
      return ListTile(
        onTap: () {
          Navigator.pushReplacementNamed(context, mobileRoute);
        },
        leading: const Icon(
          Icons.login,
          color: baseColor,
        ),
        title: const Text(
          'Log In',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          InkWell(
            onTap: () {
              showLogoutConfirmationDialog();
            },
            child: const ListTile(
              leading: Icon(
                Icons.power_settings_new_rounded,
                color: baseColor,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDeleteDialog(context);
            },
            child: const ListTile(
              leading: Icon(
                Icons.delete,
                color: baseColor,
              ),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  Widget deletAccountButton() {
    if (user.uid == null || user.uid!.isEmpty) {
      return ListTile(
        onTap: () {
          Navigator.pushReplacementNamed(context, mobileRoute);
        },
        leading: const Icon(
          Icons.login,
          color: baseColor,
        ),
        title: const Text(
          'Log In',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          showDeleteDialog(context);
        },
        child: const ListTile(
          leading: Icon(
            Icons.power_settings_new_rounded,
            color: baseColor,
          ),
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
  }

  // Function to logout
  void logout() async {
    await FirebaseAuth.instance.signOut();
    await DatabaseProvider().cleanUserTable();
    Navigator.restorablePushNamedAndRemoveUntil(
        context, initialRoute, (route) => true);
  }

  // Function to show logout confirmation dialog
  void showLogoutConfirmationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logout();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: baseColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
