import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';

class Task {
  final String name;
  final List<TaskHistory> taskHistoryList = [];

  final int size;

  int _sizeControl;
  int _consumedControl;

  Task(this.name, this.size)
      : this._sizeControl = size,
        this._consumedControl = 0;

  void addHistory(TaskHistory taskHistory) => taskHistoryList.add(taskHistory);

  ///
  void consume() {
    _consumedControl++;
  }

  int getConsumed() {
    return _consumedControl;
  }

  void resetConsumed() {
    _consumedControl = 0;
  }

  void eatSize(int size) {
    _sizeControl -= size;
  }

  bool isReady() => _consumedControl >= _sizeControl;
}
