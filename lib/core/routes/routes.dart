import 'package:casetracking/features/assign_cases/screens/assign_screen.dart';
import 'package:casetracking/features/assign_cases/screens/assign_screen_admin.dart';
import 'package:casetracking/features/authentication/Screens/login_screen.dart';
import 'package:casetracking/features/home/screens/homescreen.dart';
import 'package:casetracking/features/recieve_cases/screens/receive_case_screen.dart';
import 'package:casetracking/features/recieve_cases/screens/receive_case_screen_admin.dart';
import 'package:casetracking/features/reports/screens/reports_screen.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  login,
  home,
  assign,
  assignAdmin,
  receive,
  receiveAdmin,
  reportsScreen,
}

GoRouter router = GoRouter(
  // initialLocation: "/receiveAdmin",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => LoginScreen(),
      name: Routes.login.name,
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => HomeScreen(),
      name: Routes.home.name,
    ),
    GoRoute(
      path: "/assign",
      builder: (context, state) => AssignCaseScreen(),
      name: Routes.assign.name,
    ),
    GoRoute(
      path: "/assignadmin",
      builder: (context, state) => AssignCaseScreenAdmin(),
      name: Routes.assignAdmin.name,
    ),
    GoRoute(
      path: "/receive",
      builder: (context, state) => ReceiveCaseScreen(),
      name: Routes.receive.name,
    ),
    GoRoute(
      path: "/receiveAdmin",
      builder: (context, state) => ReceiveCaseScreenAdmin(),
      name: Routes.receiveAdmin.name,
    ),
    GoRoute(
      path: "/reportsScreen",
      builder: (context, state) => ReportsScreen(),
      name: Routes.reportsScreen.name,
    ),
  ],
);
