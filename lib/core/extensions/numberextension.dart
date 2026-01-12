import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/widgets.dart';

extension NumberExtension on num {
  SizedBox get heightBox => SizedBox(height: h);
  SizedBox get widthBox => SizedBox(width: w);
}

extension PaddingExtension on Widget {
  /// Apply padding to any widget
  Widget padding([EdgeInsetsGeometry value = const EdgeInsets.all(24)]) {
    return Padding(padding: value, child: this);
  }

  /// Apply only horizontal padding
  Widget paddingHorizontal(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  /// Apply only vertical padding
  Widget paddingVertical(double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }
}

extension MarginExtension on Widget {
  /// Apply margin to any widget
  Widget margin([EdgeInsetsGeometry value = const EdgeInsets.all(24)]) {
    return Container(margin: value, child: this);
  }

  /// Apply only horizontal margin
  Widget marginHorizontal(double value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  /// Apply only vertical margin
  Widget marginVertical(double value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }
}
