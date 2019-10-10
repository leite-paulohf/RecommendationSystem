import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader {
  Widget show() {
    return Center(
        child: SpinKitWave(color: Colors.teal, type: SpinKitWaveType.center));
  }

  Widget body(bool loading, Widget widget) {
    if (loading) {
      return Center(
          child: SpinKitWave(color: Colors.teal, type: SpinKitWaveType.center));
    } else {
      return widget;
    }
  }
}
