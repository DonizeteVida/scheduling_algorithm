import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_type.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class FifoSchedule extends Schedule {
  FifoSchedule(List<Task> tasks) : super(tasks);

  @override
  void execute(Task task, int time) {
    task.addHistory(generateTaskHistory(HistoryType.EXECUTING, time));
    task.work();
    if (task.isComplete()) {
      removeTaskAndAddHistory(task);
    } else {
      pushStart(task);
    }
  }
}
