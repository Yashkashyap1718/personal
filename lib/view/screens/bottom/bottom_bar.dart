import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_bank/view/screens/home/home.dart';
import 'package:money_bank/view/screens/profile/profile_screen.dart';
import 'package:money_bank/view/src/constants/colorConst.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return HomeScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        getScreen(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: whiteColor,
              ),
              child: TabBar(
                dividerHeight: 0,
                onTap: (value) {
                  _onItemTapped(value);
                },
                indicatorColor: Colors.transparent,
                controller: _tabController,
                unselectedLabelColor: Colors.black54,
                labelColor: baseColor,
                labelStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const <Widget>[
                  Tab(
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.home), Text('Home')],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.star), Text('gallery')],
                    ),
                  ),
                  Tab(
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.profile_circled),
                        Text('Profile')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
