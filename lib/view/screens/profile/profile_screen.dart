// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_bank/model/user_model.dart';
import 'package:money_bank/view/screens/drawer/my_drawer.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';
import 'package:money_bank/view/src/constants/imgConst.dart';
import 'package:money_bank/view/src/provider/homeProvider.dart';
import 'package:money_bank/view/utils/database_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel user = UserModel();
  bool isImageUploaded = false;
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

  File? profilePic;

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);

    // Get the download URL of the uploaded image
    String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  void updateProfileImageUrlInFirestore(String imageUrl) {
    // Assuming you have a Firestore collection named 'users' with a document for each user
    // Update the profile image URL in Firestore here
    // Replace 'userId' with the actual ID of the user document
    String userId = user.uid.toString(); // Replace this with the actual user ID
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profileImageUrl': imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    HomeProvider provider = Provider.of<HomeProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure you want to close the App?"),
              actions: [
                TextButton(
                  child: const Text(
                    "No",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // User tapped "No"
                  },
                ),
                TextButton(
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true); // User tapped "Yes"
                  },
                ),
              ],
            );
          },
        );

        // Return true if the user tapped "Yes" and false otherwise
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AboutUs()));
                  },
                  child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Image.asset(
                        leadingImg,
                        fit: BoxFit.contain,
                      )),
                ),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: SizedBox(
                  height: 35,
                  width: 35,
                  child: Image.asset(
                    nitinImg,
                  )),
            ),
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu));
            })
          ],
        ),
        drawer: const MyDrawer(),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height * .23,
                      width: size.width,
                      decoration: const BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(110)),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 25, 7, 127),
                            Color.fromARGB(255, 189, 18, 72)
                          ])),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    user.username ?? "Guest",
                                    style: const TextStyle(
                                        color: whiteColor,
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  user.phoneNumber ?? "login your account",
                                  style: const TextStyle(
                                      color: whiteColor, fontSize: 18),
                                ),
                              ],
                            ),
                            Builder(builder: (context) {
                              return Stack(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 40, top: 10),
                                  child: CircleAvatar(
                                    maxRadius: 50,
                                    backgroundImage: (provider.profilePic !=
                                            null)
                                        ? FileImage(provider.profilePic!)
                                        : const NetworkImage(
                                                'https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png')
                                            as ImageProvider<Object>,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    XFile? selectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (selectedImage != null) {
                                      File convertedFile =
                                          File(selectedImage.path);
                                      // Update profile image URL in Firestore
                                      updateProfileImageUrlInFirestore(
                                          selectedImage.path);
                                      provider.setpic(convertedFile);

                                      var user = UserModel(
                                          profilePic: selectedImage.path);

                                      db.insertUser(user);
                                      setState(() {
                                        isImageUploaded = true;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Please Select profile pic again"),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.add_a_photo,
                                      color: Colors.white),
                                ),
                              ]);
                            }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 27, vertical: size.height * .03),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              'Join our Community',
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
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                            height: 50,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: const Color(0xff00A010),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(
                                child: Text(
                              textAlign: TextAlign.center,
                              'Register for Yuva CSF Summit 2024',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: whiteColor),
                            ))),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        )),
      ),
    );
  }
}
