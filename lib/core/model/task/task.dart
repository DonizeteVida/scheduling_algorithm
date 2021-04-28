import 'package:scheduling_algorithm/core/model/task/result/task_history.dart';

class Task {
  final String name;
  final List<TaskHistory> taskHistoryList = [];

  final int size;

  int _sizeControl;
  int _workControl;

  Task(this.name, this.size)
      : this._sizeControl = size,
        this._workControl = 0;

  void addHistory(TaskHistory taskHistory) => taskHistoryList.add(taskHistory);

  ///Work consumes 1 unit of workControl.
  ///We will use it to know if task is complete
  void work() {
    _workControl++;
  }

  int getWork() {
    return _workControl;
  }

  void resetWork() {
    _workControl = 0;
  }

  ///Instead work, we remove size.
  ///8 - 4 is same 4 - 0, where result is how much I have to work.
  ///This logical afects how isComplete works. This is the intention
  void removeSize(int size) {
    _sizeControl -= size;
  }

  bool isComplete() => _workControl >= _sizeControl;
}
