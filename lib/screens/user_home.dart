import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:locker_management/screens/tabs/allLocker.dart';
import 'package:locker_management/screens/tabs/myLocker.dart';
import 'package:locker_management/screens/tabs/profileTab.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<TabItem> items = [
    TabItem(
      icon: Icons.privacy_tip_rounded,
      title: 'My Locker',
    ),
    TabItem(
      icon: Icons.auto_awesome_motion,
      title: 'All Lockers',
    ),
    TabItem(
      icon: Icons.account_circle_outlined,
      title: 'Profile',
    ),
  ];

  int visit = 0;
  double height = 30;

  String uid = '';
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        visit == 0
            ? MyLocker()
            : visit == 1
                ? AllLocker()
                    : ProfileTab(),
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: BottomBarInspiredOutside(
            items: items,
            backgroundColor: Theme.of(context).primaryColor,
            color: Colors.white,
            colorSelected: Colors.white,
            indexSelected: visit,
            onTap: (int index) => setState(() {
              visit = index;
            }),
            top: -25,
            animated: true,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            height: 41,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            itemStyle: ItemStyle.circle,
            chipStyle: ChipStyle(
              drawHexagon: false,
              background: Theme.of(context).primaryColor,
              notchSmoothness: NotchSmoothness.smoothEdge,
            ),
          ),
        ),
      ],
    ));
  }
}
