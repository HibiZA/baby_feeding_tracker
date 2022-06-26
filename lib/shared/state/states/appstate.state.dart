class AppState {
  final bool loading;
  final String error;
  final DateTime feedTime;

  AppState(this.loading, this.error, this.feedTime);

  factory AppState.initial() => AppState(false, '', DateTime.now());

  AppState copyWith({bool? loading, String? error, DateTime? feedTime}) =>
      AppState(loading ?? this.loading, error ?? this.error,
          feedTime ?? this.feedTime);

  DateTime get time => feedTime;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          loading == other.loading &&
          error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^ runtimeType.hashCode ^ loading.hashCode ^ error.hashCode;

  @override
  String toString() =>
      "AppstateState { loading: $loading,  error: $error, feedTime: $feedTime}";
}
