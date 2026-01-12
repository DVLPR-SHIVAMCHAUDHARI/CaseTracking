import 'package:casetracking/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(CaseTracking());
}

class CaseTracking extends StatelessWidget {
  const CaseTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 915),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        routerConfig: router,
      ),
    );
  }
}
