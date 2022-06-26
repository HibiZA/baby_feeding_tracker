import 'package:flutter/material.dart';

class AppAction {
  @override
  String toString() {
    return 'AppAction { }';
  }
}

class AppSuccessAction {
  final int isSuccess;

  AppSuccessAction({required this.isSuccess});
  @override
  String toString() {
    return 'AppSuccessAction { isSuccess: $isSuccess }';
  }
}

class AppFailedAction {
  final String error;

  AppFailedAction({required this.error});

  @override
  String toString() {
    return 'AppFailedAction { error: $error }';
  }
}

class AppAddFeedTime {
  DateTime addFeedTime;

  set time(DateTime time) {
    addFeedTime = time;
  }

  get feedTime {
    return addFeedTime;
  }

  AppAddFeedTime({required this.addFeedTime});
}
