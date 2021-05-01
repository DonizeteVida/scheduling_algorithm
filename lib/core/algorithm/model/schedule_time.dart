//Have to be passed as param to schedule algorithm, this will be more used
//on play pause chart representation
abstract class ScheduleTime {
  final int until;
  ScheduleTime(this.until);

  factory ScheduleTime.finite(int until) => Finite(until);
  factory ScheduleTime.infinite() => Infinite();
}

class Finite extends ScheduleTime {
  Finite(int until) : super(until);
}

class Infinite extends ScheduleTime {
  //Obviusly this is not infinite, but is a good representation
  //If I divide infinite by 2, keeps infinite?
  //So if consecutives divisions by 2 result in 999999, and consecutives
  //divisions is infinite, 999999 is infinite
  Infinite() : super(999999);
}
