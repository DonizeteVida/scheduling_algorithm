import 'package:scheduling_algorithm/core/algorithm/model/schedule_time.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_time.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_type.dart';
import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';
import 'package:scheduling_algorithm/core/model/task/result/task_result.dart';
import 'package:scheduling_algorithm/core/model/task/task.dart';

/*
  Base class for scheduling algorithm.
  Every schedule algorithm must return a task result list, which represent a state of tasks
    when algorithm finish itself.
*/
abstract class Schedule with TaskHistoryMixinGenerator {
  List<Task> taskQueue;
  final List<TaskResult> taskResultQueue = [];

  Schedule(this.taskQueue);

  ///Start some schedule algorithm
  List<TaskResult> start(ScheduleTime scheduleTime) {
    int time = 0;
    while (taskQueue.isNotEmpty && time < scheduleTime.until) {
      Task? task = popStart();

      //This will never happen, because I ask on while, I hope
      if (task == null) continue;
      updateTaskQueue(time);
      onUpdateTaskQueue();
      execute(task, time++);
    }
    onScheduleFinish();
    return taskResultQueue;
  }

  ///This method remove the first task on queue and give it to algorithm handle it.
  ///I think this is universal.
  ///Algorithm have to put this task on queue or taskResult queue when task finish your work
  void execute(Task task, int time);

  ///Called when schedule finish for some reason.
  ///Or when task queue is empty, or schedule time is over
  ///If we have tasks, we extract their historic
  void onScheduleFinish() {
    taskQueue.forEach((e) {
      removeTaskAndAddHistory(e);
    });
  }

  void onUpdateTaskQueue() {}

  ///May be overrided to update virtual or IO queue
  void updateTaskQueue(int time) {
    addHistoryToEachTaskInList(taskQueue, HistoryType.QUEUE, time);
  }

  void addHistoryToEachTaskInList(
      List<Task> task, HistoryType historyType, int time) {
    task.forEach((t) {
      t.addHistory(generateTaskHistory(historyType, time));
    });
  }

  Task? popStart() => _removeTaskAt(0);

  Task? popEnd() => _removeTaskAt(taskQueue.length + -1);

  Task? _removeTaskAt(int index) {
    if (containsTask) {
      return taskQueue.removeAt(index);
    }
  }

  bool pushStart(Task? task) {
    if (task == null) return false;
    int oldSize = taskQueue.length;
    taskQueue = [task, ...taskQueue];
    int newSize = taskQueue.length;
    return newSize > oldSize;
  }

  bool pushEnd(Task? task) {
    if (task == null) return false;
    int oldSize = taskQueue.length;
    taskQueue = [...taskQueue, task];
    int newSize = taskQueue.length;
    return newSize > oldSize;
  }

  void removeTaskAndAddHistory(Task task) {
    taskResultQueue.add(TaskResult.fromTask(task));
  }

  List<Task> getAllTasks() {
    List<Task> tempTasks = taskQueue;
    taskQueue = [];
    return tempTasks;
  }

  bool putAllTasks(List<Task> newTasks) {
    int oldSize = taskQueue.length;
    taskQueue = [...taskQueue, ...newTasks];
    int newSize = taskQueue.length;
    int diff = newSize - oldSize;
    return diff == newTasks.length;
  }

  bool get containsTask {
    return taskQueue.isNotEmpty;
  }
}

mixin TaskHistoryMixinGenerator {
  ///We will consider start time as time and end time as time + 1
  TaskHistory generateTaskHistory(HistoryType historyType, int time) {
    final historyTime = HistoryTime.from(time, time + 1);
    return TaskHistory(historyType, historyTime);
  }
}
