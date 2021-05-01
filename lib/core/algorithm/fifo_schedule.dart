import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class FifoSchedule extends Schedule {
  FifoSchedule(List<Task> tasks) : super(tasks);

  @override
  Future<bool> execute(Task task, int time) async {
    super.execute(task, time);
    if (task.isComplete()) {
      await removeTaskToFinishedTaskQueue(task, time);
      return true;
    }
    return false;
  }
}
