import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scheduling_algorithm/core/algorithm/fifo_schedule.dart';
import 'package:scheduling_algorithm/core/algorithm/model/schedule_time.dart';
import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_type.dart';
import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';
import 'package:scheduling_algorithm/core/model/task/result/task_result.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int until = 0;

  List<TaskResult> generateTaskResult(int until) {
    final tasks = [Task("A", 8), Task("B", 6), Task("C", 4)];

    final Schedule schedule = FifoSchedule(tasks: tasks);
    final List<TaskResult> taskResult =
        schedule.start(ScheduleTime.finite(until));

    return taskResult;
  }

  Widget generateRow(TaskResult taskResult) {
    return Expanded(
      child: Row(
        children: [
          ...taskResult.history.map((TaskHistory e) {
            Color color;
            if (e.historyType == HistoryType.QUEUE) {
              color = Colors.white;
            } else {
              color = Colors.black;
            }
            return Container(
              color: color,
              width: 50,
              margin: EdgeInsets.all(1),
            );
          })
        ],
      ),
    );
  }

  Widget generateWidget(int until) {
    final taskResultList = generateTaskResult(until);
    return Column(
      children: [...taskResultList.map(generateRow)],
    );
  }

  void inc() {
    setState(() {
      until++;
    });
  }

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 500), (_) => inc());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: generateWidget(until),
    );
  }
}
