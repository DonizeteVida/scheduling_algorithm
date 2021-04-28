import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_type.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class FifoSchedule extends Schedule {
  FifoSchedule({List<Task> tasks = const []}) : super(tasks);

  @override
  void execute(Task task, int time) {
    task.addHistory(generateTaskHistory(HistoryType.EXECUTING, time));
    task.consume();
    if (task.isReady()) {
      removeTaskAndAddHistory(task);
    } else {
      pushStart(task);
    }
  }

  @override
  void onScheduleFinish() {
    //Save history for first task
    if (taskQueue.isNotEmpty) {
      removeTaskAndAddHistory(taskQueue.first);
    }
  }
}
