import 'package:scheduling_algorithm/core/algorithm/schedule.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

class RoundRobinSchedule extends Schedule {
  final int quantum;
  RoundRobinSchedule(this.quantum, List<Task> task) : super(task);

  @override
  Future<void> execute(Task task, int time) async {
    super.execute(task, time);
    //means that we have done our quantum job
    if (task.getWork() >= quantum || task.isComplete()) {
      task.resetWork();
      task.removeSize(quantum);
      if (task.isComplete()) {
        await removeTaskToFinishedTaskQueue(task, time);
      } else {
        //If we have done on work, but is not complete yet, we will to end of task queue
        pushEnd(task);
      }
    } else {
      //If out amount of work is not completed, we keeps on start of task queue
      pushStart(task);
    }
  }
}
