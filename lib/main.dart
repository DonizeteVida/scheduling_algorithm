import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scheduling_algorithm/core/algorithm/fifo_schedule.dart';
import 'package:scheduling_algorithm/core/algorithm/model/schedule_time.dart';
import 'package:scheduling_algorithm/core/algorithm/round_robin_schedule.dart';
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
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<TaskResult>> generateTaskResult() async {
    final tasks = [
      Task("A", 8),
      Task("B", 6),
      Task("C", 4),
      Task("D", 2),
      Task("E", 10),
      Task("F", 2)
    ];

    final Schedule schedule;
    if (true) {
      schedule = RoundRobinSchedule(2, tasks);
    } else {
      schedule = FifoSchedule(tasks);
    }

    final List<TaskResult> taskResult =
        await schedule.start(ScheduleTime.infinite());

    taskResult.sort((t1, t2) => t1.name.compareTo(t2.name));

    return taskResult;
  }

  Widget generateRow(TaskResult taskResult) {
    return Expanded(
      child: Row(
        children: [
          ...taskResult.history.map((TaskHistory e) {
            Color color;
            if (e.historyType == HistoryType.QUEUE) {
              color = Colors.blue;
            } else if (e.historyType == HistoryType.DESTROYED) {
              color = Colors.red;
            } else {
              color = Colors.black;
            }
            return Expanded(
              child: GestureDetector(
                child: Container(
                  color: color,
                  margin: EdgeInsets.all(1),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Expanded(
                        child: Text(
                            "Type ${e.historyType}\nTime: ${e.historyTime.startTime} - ${e.historyTime.endTime}"),
                      ),
                    ),
                  );
                },
              ),
            );
          })
        ],
      ),
    );
  }

  Future<Widget> generateWidget() async {
    final taskResultList = await generateTaskResult();
    return Column(
      children: [...taskResultList.map(generateRow)],
    );
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    Widget res = await generateWidget();
    result = res;
    setState(() {});
  }

  Widget? result;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: result == null ? Container() : result,
    );
  }
}
