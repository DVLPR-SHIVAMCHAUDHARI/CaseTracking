import 'package:casetracking/core/consts/globals.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/core/services/token_service.dart';
import 'package:casetracking/features/authentication/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  runApp(CaseTracking());
  WidgetsFlutterBinding.ensureInitialized();

  token.loadToken();
}

class CaseTracking extends StatelessWidget {
  const CaseTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 915),
      child: MultiBlocProvider(
        providers: [BlocProvider<AuthBloc>(create: (context) => AuthBloc())],

        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          routerConfig: router,
        ),
      ),
    );
  }
}
