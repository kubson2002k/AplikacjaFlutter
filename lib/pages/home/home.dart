import 'package:flutter/material.dart';
import 'package:gymapp/pages/home/widgets/activity.dart';
import 'package:gymapp/pages/home/widgets/current.dart';
import 'package:gymapp/pages/home/widgets/header.dart';
import 'package:gymapp/widgets/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          AppHeader(),
          CurrentPrograms(),
          RecentActivities(),
          BottomNavigation(),
        ],
      ),
    );
  }
}