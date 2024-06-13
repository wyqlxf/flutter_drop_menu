import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Extension on [State] to safely call [setState] even if the widget is not mounted.
extension SafeUpdateState on State {
  void safeSetState(VoidCallback fn) {
    void callSetState() {
      // Can only call setState if mounted
      if (mounted) {
        // ignore: invalid_use_of_protected_member
        setState(fn);
      }
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Currently building, can't call setState -- add post-frame callback
      SchedulerBinding.instance.addPostFrameCallback((_) => callSetState());
    } else {
      callSetState();
    }
  }
}
