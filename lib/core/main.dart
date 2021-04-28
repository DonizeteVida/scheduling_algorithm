import 'package:scheduling_algorithm/core/algorithm/fifo_schedule.dart';
import 'package:scheduling_algorithm/core/algorithm/model/schedule_time.dart';
import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/result/task_result.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';
import '../main.dart' as pMain;

///To run dart code without screen
void main() {
  fifoSchedule();
  pMain.main();
}

void fifoSchedule() {
  final tasks = [Task("A", 8), Task("B", 6), Task("C", 4)];

  final Schedule schedule = FifoSchedule(tasks: tasks);
  final List<TaskResult> taskResult = schedule.start(ScheduleTime.infinite());
  print(taskResult);
}
