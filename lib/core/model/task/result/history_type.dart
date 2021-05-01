enum HistoryType {
  //Queue list (ready for process)
  QUEUE,
  //Processor is taking care of that
  EXECUTING,
  //Waiting for some reson, like IO, is another list
  WAITING,
  //Ready to get out of waiting list
  READY,

  //Just for better UI generation
  //We use to fix task result size
  //If task end with 8 size, but another has like 20, we will fill 12 with undefined
  UNDEFINED,
  DESTROYED,
}
