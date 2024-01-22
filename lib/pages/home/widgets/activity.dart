import 'dart:math';

import 'package:flutter/material.dart';

class RecentActivities extends StatefulWidget {
  const RecentActivities({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RecentActivitiesState createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  List<ActivityData> activitiesData = List.generate(10, (index) => ActivityData.random());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Activities',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue,),
                  onPressed: () async {
                    await _showAddActivityDialog();
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: activitiesData.length,
                itemBuilder: (context, index) => ActivityItem(data: activitiesData[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddActivityDialog() async {
    TextEditingController activityController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController caloriesController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Activity', style: TextStyle(
            fontSize: 30,
          ),),
          content: Column(
            children: [
              TextField(
                controller: activityController,
                decoration: const InputDecoration(labelText: 'Activity'),
              ),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration (min)'),
              ),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String activity = activityController.text;
                int duration = int.tryParse(durationController.text) ?? 0;
                int calories = int.tryParse(caloriesController.text) ?? 0;

                if (activity.isNotEmpty && duration > 0 && calories > 0) {
                  ActivityData newActivity = ActivityData(activity: activity, duration: duration, calories: calories);
                  setState(() {
                    activitiesData.insert(0, newActivity); 
                  });
                  Navigator.of(context).pop(); 
                } else {
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class ActivityItem extends StatelessWidget {
  final ActivityData data;

  const ActivityItem({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/details');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffe1e1e1),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffcff2ff),
              ),
              height: 35,
              width: 35,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/running.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              data.activity,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Expanded(child: SizedBox()),
            const Icon(Icons.timer, size: 12),
            const SizedBox(width: 5),
            Text(
              '${data.duration} min',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.wb_sunny_outlined, size: 12),
            const SizedBox(width: 5),
            Text(
              '${data.calories} kcal',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}

class ActivityData {
  final String activity;
  final int duration;
  final int calories;

  ActivityData({required this.activity, required this.duration, required this.calories});

  factory ActivityData.random() {
    List<String> activities = ['Running', 'Swimming', 'Hiking', 'Cycling', 'Walking'];
    String activity = activities[Random().nextInt(activities.length)];
    int duration = Random().nextInt(31) + 30;
    int calories = Random().nextInt(301) + 200;

    return ActivityData(activity: activity, duration: duration, calories: calories);
  }
}
