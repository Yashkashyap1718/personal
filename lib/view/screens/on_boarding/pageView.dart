// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';
import 'package:money_bank/view/src/constants/imgConst.dart';
import 'package:money_bank/view/src/provider/homeProvider.dart';

import 'package:provider/provider.dart';

import '../Auth/mobile_number.dart';
// Replace with your image constants

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({Key? key}) : super(key: key);

  @override
  PageViewScreenState createState() => PageViewScreenState();
}

class PageViewScreenState extends State<PageViewScreen> {
  late PageController _pageController;
  List pages = [olPosterImg]; // Replace with your image paths

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<HomeProvider>(builder: (_, provider, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SafeArea(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 15, top: 25),
                //   child: SizedBox(
                //     height: 80,
                //     width: size.width,
                //     child: Center(
                //         child: Image.asset(
                //             appLogoImg)), // Replace with your app logo image
                //   ),
                // ),
                Expanded(
                  child: SizedBox(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) => provider.updatepage(value),
                      itemCount: pages.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(size.height * .02),
                              child: SizedBox(
                                height: size.height * .75,
                                // color: Colors.amber,
                                width: size.width,
                                child: Image.asset(
                                  pages[index],
                                  fit: BoxFit.fill,
                                ), // Display image based on index
                              ),
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 40),
                            //   child: Text(
                            //     textAlign: TextAlign.center,
                            //     'Spiritual Conferences, Exhibitions & Clubs with spiritual gurus worldwide,',
                            //     style: TextStyle(
                            //         fontSize: 15,
                            //         fontWeight: FontWeight.w400,
                            //         color: Color(0xFF565656)),
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const MobileScreen()));
                      //   },
                      //   child: Container(
                      //       height: 50,
                      //       width: 110,
                      //       decoration: BoxDecoration(
                      //           color: greyColor,
                      //           borderRadius: BorderRadius.circular(5)),
                      //       child: const Center(
                      //           child: Text(
                      //         textAlign: TextAlign.center,
                      //         'Skip',
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w700,
                      //             color: textColor),
                      //       ))),
                      // ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled)) {
                                return baseColor; // Set the button color when disabled
                              }
                              return baseColor; // Set the button color when enabled
                            },
                          ),
                        ),
                        onPressed: () {
                          _pageController.hasClients &&
                                  provider.pageIndex < pages.length - 1
                              ? _pageController.animateToPage(
                                  provider.pageIndex + 1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.bounceIn)
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MobileScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              provider.pageIndex >= pages.length - 1
                                  ? 'Next'
                                  : 'Next',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
