import 'package:scheduling_algorithm/core/model/task/result/history_time.dart';
import 'package:scheduling_algorithm/core/model/task/result/history_type.dart';

class TaskHistory {
  final HistoryType historyType;
  final HistoryTime historyTime;

  TaskHistory(this.historyType, this.historyTime);
}
