import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class TaskResult {
  final String name;
  final int size;
  final int startTime;
  final int endTime;
  final List<TaskHistory> history;
  TaskResult(this.name, this.size, this.startTime, this.endTime, this.history);

  factory TaskResult.fromTask(Task task) => TaskResult(
      task.name, task.size, task.startTime, task.endTime, task.taskHistoryList);
}
