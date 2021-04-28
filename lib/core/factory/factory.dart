abstract class Factory<I, O> {
  O build(I params);
}

abstract class AutoFactory<O> extends Factory<void, O> {}
