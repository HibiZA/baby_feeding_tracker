import 'package:baby_feeding_tracker/shared/state/actions/app.action.dart';
import 'package:redux/redux.dart';
import '../states/appstate.state.dart';

AppState appReducer(AppState state, action) {
  if (action is AppAddFeedTime) {
    return state.copyWith(feedTime: action.feedTime);
  }
  if (action is AppAddFeed) {
    return state.copyWith(feed: action.feed);
  }
  return AppState(state.loading, state.error, state.feedTime, state.feed);
}
