sealed class AsyncData<T> {
  const AsyncData();
}

class NoData<T> extends AsyncData<T> {
  const NoData();
}

class SomeData<T> extends AsyncData<T> {
  final T data;
  const SomeData(this.data);
}

class LoadingData<T> extends AsyncData<T> {
  const LoadingData();
}

class ErrorData<T> extends AsyncData<T> {
  final String message;
  const ErrorData(this.message);
}
