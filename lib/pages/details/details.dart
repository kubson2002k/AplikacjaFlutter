import 'package:flutter/material.dart';
import 'package:gymapp/pages/details/widgets/Stats.dart';
import 'package:gymapp/pages/details/widgets/appbar.dart';
import 'package:gymapp/pages/details/widgets/dates.dart';
import 'package:gymapp/pages/details/widgets/graph.dart';
import 'package:gymapp/pages/details/widgets/info.dart' hide Stats;
import 'package:gymapp/pages/details/widgets/steps.dart';
import 'package:gymapp/widgets/bottom_navigation.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(appBar: AppBar()),
      body: const Column(
        children: [
          Dates(),
          Steps(),
          Graph(),
          Info(),
          Divider(height: 30),
          Stats(),
          SizedBox(height: 30),
          BottomNavigation(),
        ],
      ),
    );
  }
}