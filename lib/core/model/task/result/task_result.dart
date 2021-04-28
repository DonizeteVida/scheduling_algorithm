import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class TaskResult {
  final String name;
  final int size;
  final List<TaskHistory> history;
  TaskResult(this.name, this.size, this.history);

  factory TaskResult.fromTask(Task task) =>
      TaskResult(task.name, task.size, task.taskHistoryList);
}
