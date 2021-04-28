import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_type.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class RoundRobinSchedule extends Schedule {
  final int quantum;
  RoundRobinSchedule(this.quantum, List<Task> task) : super(task);

  @override
  void execute(Task task, int time) {
    task.addHistory(generateTaskHistory(HistoryType.EXECUTING, time));
    task.consume();
    if (task.getConsumed() >= quantum) {
      task.resetConsumed();
      task.eatSize(quantum);
      if (task.isReady()) {
        removeTaskAndAddHistory(task);
      } else {
        pushEnd(task);
      }
    } else {
      pushStart(task);
    }
  }
}
