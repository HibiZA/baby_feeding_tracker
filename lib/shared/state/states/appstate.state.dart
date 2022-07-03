import '../../models.dart';

class AppState {
  final bool loading;
  final String error;
  final DateTime feedTime;
  final List<Feed>? feed;

  AppState(this.loading, this.error, this.feedTime, this.feed);

  factory AppState.initial() => AppState(false, '', DateTime.now(), null);

  AppState copyWith({bool? loading, String? error, DateTime? feedTime, List<Feed>? feed}) =>
      AppState(loading ?? this.loading, error ?? this.error,
          feedTime ?? this.feedTime, feed ?? this.feed);

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
      "AppstateState { loading: $loading,  error: $error, feedTime: $feedTime, feed: $feed}";
}
