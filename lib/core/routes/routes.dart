import 'package:casetracking/features/add_boxes/bloc/add_box_bloc.dart';
import 'package:casetracking/features/add_boxes/screens/add_box_screen.dart';
import 'package:casetracking/features/assign_cases/bloc/assign_case_bloc.dart';
import 'package:casetracking/features/assign_cases/repository/assign_case_repository.dart';

import 'package:casetracking/features/assign_cases/screens/assign_stage1_screen.dart';
import 'package:casetracking/features/assign_cases/screens/assign_stage2_screen.dart';
import 'package:casetracking/features/assign_cases/screens/assign_stage3_screen.dart';
import 'package:casetracking/features/authentication/Screens/login_screen.dart';
import 'package:casetracking/features/authentication/Screens/update_password.dart';
import 'package:casetracking/features/authentication/Screens/update_user.dart';
import 'package:casetracking/features/authentication/bloc/auth_bloc.dart';
import 'package:casetracking/features/home/screens/homescreen.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_event.dart';
import 'package:casetracking/features/master_api/department/bloc/department_bloc.dart';
import 'package:casetracking/features/master_api/department/bloc/department_event.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_bloc.dart';
import 'package:casetracking/features/master_api/parties/bloc/parties_event.dart';
import 'package:casetracking/features/master_api/repositories/masterrepo.dart';
import 'package:casetracking/features/partyWiseReport/bloc/party_wise_report_bloc.dart';
import 'package:casetracking/features/partyWiseReport/bloc/party_wise_report_event.dart';
import 'package:casetracking/features/partyWiseReport/repository/party_wise_repository.dart';
import 'package:casetracking/features/partyWiseReport/screens/partywisereport_screen.dart';
import 'package:casetracking/features/recieve_cases/bloc/recieve_case_bloc.dart';
import 'package:casetracking/features/recieve_cases/screens/receive_case_stage1_screen.dart';
import 'package:casetracking/features/recieve_cases/screens/receive_case_screen_admin.dart';
import 'package:casetracking/features/recieve_cases/screens/receive_case_stage2_screen.dart';
import 'package:casetracking/features/recieve_cases/screens/receive_case_stage3_screen.dart';
import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_bloc.dart';
import 'package:casetracking/features/recieve_pending_barcode/bloc/receieve_pending_event.dart';
import 'package:casetracking/features/reports/bloc/report_bloc.dart';
import 'package:casetracking/features/reports/bloc/report_event.dart';
import 'package:casetracking/features/reports/models/pendin_report_model.dart';
import 'package:casetracking/features/reports/screens/pending_detail_report_screen.dart';

import 'package:casetracking/features/reports/screens/pending_report.dart';
import 'package:casetracking/features/reports/screens/assigned_report.dart';
import 'package:casetracking/features/reports/screens/received_report.dart';
import 'package:casetracking/features/reports/screens/recieve_all_cases_screen.dart';
import 'package:casetracking/features/reports/screens/reports_homescreen.dart';
import 'package:casetracking/features/splash/splashscreen.dart';
import 'package:casetracking/features/userList/bloc/user_list_bloc.dart';
import 'package:casetracking/features/userList/bloc/user_list_event.dart';
import 'package:casetracking/features/userList/repository/user_list_repo.dart';
import 'package:casetracking/features/userList/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  login,
  home,
  assign1,
  assign2,
  receiveall,
  assignAdmin,
  addBox,
  receive1,
  receive2,
  receive3,
  receiveAdmin,
  adminReports,
  pendingReports,
  assignedReports,
  receivedReports,
  splash,
  updateuser,
  updatePassword,
  userlist,
  pendingreportDetail,
  partywiseReport,
}

GoRouter router = GoRouter(
  // initialLocation: "/receiveAdmin",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => Splashscreen(),
      name: Routes.splash.name,
    ),

    GoRoute(
      path: "/login",
      builder: (context, state) =>
          BlocProvider(create: (context) => AuthBloc(), child: LoginScreen()),
      name: Routes.login.name,
    ),
    GoRoute(
      path: "/updateuser",
      name: Routes.updateuser.name,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthBloc()),
            BlocProvider(
              create: (_) =>
                  DepartmentBloc(MasterRepo())..add(const FetchDepartments()),
            ),
          ],
          child: UpdateUserScreen(
            userId: data['id'] as int,
            fullname: data['fullname'] as String,
            email: data['email'] as String,
            departmentId: data['departmentId'] as int,
          ),
        );
      },
    ),

    GoRoute(
      path: "/updatepassword",
      name: Routes.updatePassword.name,
      builder: (context, state) {
        final userId = state.extra as int;

        return BlocProvider(
          create: (_) => AuthBloc(),
          child: UpdatePasswordScreen(userid: userId),
        );
      },
    ),

    GoRoute(
      path: "/home",
      builder: (context, state) => HomeScreen(),
      name: Routes.home.name,
    ),
    GoRoute(
      path: "/userlist",
      builder: (context, state) => BlocProvider(
        create: (context) =>
            UserListBloc(repo: UserListRepo())..add(FetchUserList()),
        child: UserListScreen(),
      ),
      name: Routes.userlist.name,
    ),

    GoRoute(
      path: "/assign1",
      name: Routes.assign1.name,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AssignCaseBloc(AssignCaseRepository())),
            BlocProvider(
              create: (_) =>
                  DepartmentBloc(MasterRepo())..add(const FetchDepartments()),
            ),
            BlocProvider(
              create: (_) => BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
            ),
          ],
          child: AssignStage1Screen(),
        );
      },
    ),

    GoRoute(
      path: "/assign2",
      name: Routes.assign2.name,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AssignCaseBloc(AssignCaseRepository())),

            BlocProvider(
              create: (_) =>
                  DepartmentBloc(MasterRepo())..add(const FetchDepartments()),
            ),

            BlocProvider(
              create: (_) =>
                  BoxSizeBloc(MasterRepo())..add(const FetchBoxSizes()),
            ),

            BlocProvider(
              create: (_) => PartyBloc(MasterRepo())..add(const FetchParties()),
            ),
          ],
          child: const AssignStage2Screen(),
        );
      },
    ),

    // GoRoute(
    //   path: "/assign3",
    //   name: Routes.assign3.name,
    //   builder: (context, state) {
    //     return MultiBlocProvider(
    //       providers: [
    //         BlocProvider(create: (_) => AssignCaseBloc(AssignCaseRepository())),
    //         BlocProvider(
    //           create: (_) =>
    //               DepartmentBloc(MasterRepo())..add(const FetchDepartments()),
    //         ),
    //         BlocProvider(
    //           create: (_) =>
    //               BoxSizeBloc(MasterRepo())..add(const FetchBoxSizes()),
    //         ),
    //       ],
    //       child: const AssignStage3Screen(),
    //     );
    //   },
    // ),
    GoRoute(
      path: "/addBox",

      name: Routes.addBox.name,

      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
            ),
            BlocProvider(create: (_) => AddBoxBloc()),
          ],
          child: AddBoxScreen(),
        );
      },
    ),

    GoRoute(
      path: "/receive2",
      name: Routes.receive2.name,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  PendingBarcodeBloc()..add(const FetchPendingBarcodes()),
            ),

            BlocProvider(create: (_) => ReceiveBloc()),
            BlocProvider(create: (_) => BoxSizeBloc(MasterRepo())),
          ],
          child: const ReceiveStage2Screen(),
        );
      },
    ),
    GoRoute(
      path: "/receive1",
      name: Routes.receive1.name,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  PendingBarcodeBloc()..add(const FetchPendingBarcodes()),
            ),

            BlocProvider(create: (_) => ReceiveBloc()),
          ],
          child: const ReceiveStage1Screen(),
        );
      },
    ),
    GoRoute(
      path: "/pending-to-received-detail",
      name: Routes.pendingreportDetail.name,
      builder: (context, state) {
        final extra = state.extra;

        if (extra is! PendingToReceivedBatch) {
          return const Scaffold(
            body: Center(child: Text("Invalid batch data")),
          );
        }

        return MultiBlocProvider(
          providers: [BlocProvider(create: (_) => ReceiveBloc())],
          child: PendingToReceivedDetailScreen(batch: extra),
        );
      },
    ),

    // GoRoute(
    //   path: "/receive3",
    //   name: Routes.receive3.name,
    //   builder: (context, state) {
    //     return MultiBlocProvider(
    //       providers: [
    //         BlocProvider(
    //           create: (_) =>
    //               PendingBarcodeBloc()..add(const FetchPendingBarcodes()),
    //         ),

    //         BlocProvider(create: (_) => ReceiveBloc()),
    //       ],
    //       child: const ReceiveStage3Screen(),
    //     );
    //   },
    // ),
    GoRoute(
      path: "/receiveAdmin",
      builder: (context, state) => ReceiveCaseScreenAdmin(),
      name: Routes.receiveAdmin.name,
    ),

    GoRoute(
      path: "/receiveall",
      name: Routes.receiveall.name,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ReportBloc()..add(PendingToReceivedFetch()),
            ),
            BlocProvider(
              create: (_) => BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
            ),
          ],
          child: RecieveAllCases(),
        );
      },
    ),
    GoRoute(
      path: "/partywiseReport",
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PartyBloc(MasterRepo())..add(FetchParties()),
          ),
          BlocProvider(
            create: (context) =>
                BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
          ),
          BlocProvider(
            create: (context) =>
                PartyWiseReportBloc(PartyWiseRepository())
                  ..add(FetchPartyReport(offset: 1)),
          ),
        ],
        child: const PartyWiseReport(),
      ),
      name: Routes.partywiseReport.name,
    ),

    ShellRoute(
      builder: (context, state, child) {
        return ReportsHomescreen(child: child);
      },
      routes: [
        GoRoute(
          path: "/pendingReports",
          name: Routes.pendingReports.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ReportBloc()..add(PendingToReceivedFetch()),
                ),
                BlocProvider(
                  create: (_) =>
                      BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
                ),
              ],
              child: PendingReport(),
            );
          },
        ),
        GoRoute(
          path: "/assignedReports",
          name: Routes.assignedReports.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => ReportBloc()..add(AssignedReportFetch()),
                ),
                BlocProvider(
                  create: (_) =>
                      BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
                ),
              ],
              child: AssignedReport(),
            );
          },
        ),

        GoRoute(
          path: "/receivedReports",
          name: Routes.receivedReports.name,
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => ReportBloc()),
                BlocProvider(
                  create: (_) =>
                      BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
                ),
              ],
              child: ReceivedReport(),
            );
          },
        ),
      ],
    ),
  ],
);
