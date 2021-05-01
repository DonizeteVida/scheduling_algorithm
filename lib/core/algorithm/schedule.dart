import 'package:flutter/widgets.dart';
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
  final List<Task> finishedTasksQueue = [];

  Schedule(this.taskQueue);

  ///Start some schedule algorithm
  Future<List<TaskResult>> start(ScheduleTime scheduleTime) async {
    int time = 0;
    Task? processorTask;

    while (taskQueue.isNotEmpty && time < scheduleTime.until ||
        processorTask != null) {
      if (processorTask == null) {
        processorTask = popStart();
      }

      //This will never happen, because I ask on while, I hope
      if (processorTask == null)
        throw "Processor task must no be null. Revise your code !!!";
      await updateQueues(time);
      await onUpdateTaskQueue();
      bool removeFromProcessor = await execute(processorTask, time++);
      if (removeFromProcessor) {
        processorTask = null;
      }
    }
    await onScheduleFinish();
    return taskResultQueue;
  }

  ///This method remove the first task on queue and give it to algorithm handle it.
  ///I think this is universal.
  ///Algorithm have to put this task on queue or taskResult queue when task finish your work.
  ///Must return true to remove task from processor
  @mustCallSuper
  Future<bool> execute(Task task, int time) async {
    task.addHistory(generateTaskHistory(HistoryType.EXECUTING, time));
    if (task.startTime <= 0) task.startTime = time;
    task.work();
    return false;
  }

  ///Called when schedule finish for some reason.
  ///Or when task queue is empty, or schedule time is over
  ///If we have tasks, we extract their historic
  Future<void> onScheduleFinish() async {
    final Iterable<Future> future1 = taskQueue.map((e) async {
      await removeTaskAndAddHistory(e);
    });
    final Iterable<Future> future2 = finishedTasksQueue.map((e) async {
      await removeTaskAndAddHistory(e);
    });
    await Future.wait([Future.wait(future1), Future.wait(future2)]);
  }

  Future<void> onUpdateTaskQueue() async {}

  ///May be overrided to update virtual or IO queue
  Future<void> updateQueues(
    int time,
  ) async {
    final future1 =
        addHistoryToEachTaskInList(taskQueue, HistoryType.QUEUE, time);
    final future2 = addHistoryToEachTaskInList(
        finishedTasksQueue, HistoryType.DESTROYED, time);
    await Future.wait([future1, future2]);
  }

  Future<void> addHistoryToEachTaskInList(
    List<Task> task,
    HistoryType historyType,
    int time,
  ) async {
    final Iterable<Future<Null>> futures = task.map((t) async {
      t.addHistory(
        generateTaskHistory(historyType, time),
      );
    });
    await Future.wait(futures);
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

  Future<void> removeTaskAndAddHistory(Task task) async {
    taskResultQueue.add(TaskResult.fromTask(task));
  }

  Future<void> removeTaskToFinishedTaskQueue(Task task, int endTime) async {
    task.endTime = endTime;
    finishedTasksQueue.add(task);
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
