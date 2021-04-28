import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';

class Task {
  final String name;
  final List<TaskHistory> taskHistoryList = [];

  ///To control task size on processor
  final int size;
  int _consumedSize = 0;

  Task(this.name, this.size);

  void addHistory(TaskHistory taskHistory) => taskHistoryList.add(taskHistory);

  void consume() {
    _consumedSize++;
  }

  bool isReady() => _consumedSize >= size;
}
