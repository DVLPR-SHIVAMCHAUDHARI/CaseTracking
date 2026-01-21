import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_bloc.dart';
import 'package:casetracking/features/master_api/box_size/bloc/box_size_event.dart';
import 'package:casetracking/features/master_api/repositories/masterrepo.dart';
import 'package:casetracking/features/reports/bloc/report_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReportsHomescreen extends StatelessWidget {
  final Widget child;

  const ReportsHomescreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BoxSizeBloc(MasterRepo())..add(FetchBoxSizes()),
        ),
        BlocProvider(create: (_) => ReportBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: Text(
            location.contains("receivedReports")
                ? "Received Reports"
                : location.contains("assignedReports")
                ? "Assigned Reports"
                : "Pending Reports",
          ),
          automaticallyImplyLeading: true,
          centerTitle: true,

          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        /// LEFT NAVBAR / DRAWER
        endDrawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Reports",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                _drawerItem(
                  context,
                  label: "Pending Reports",
                  icon: Icons.pending_actions,
                  route: Routes.pendingReports.name,
                  selected: location.contains("pendingReports"),
                ),

                _drawerItem(
                  context,
                  label: "Assigned Reports",
                  icon: Icons.upload,
                  route: Routes.assignedReports.name,
                  selected: location.contains("assignedReports"),
                ),

                _drawerItem(
                  context,
                  label: "Received Reports",
                  icon: Icons.download,
                  route: Routes.receivedReports.name,
                  selected: location.contains("receivedReports"),
                ),
              ],
            ),
          ),
        ),

        /// 🔹 ACTIVE SCREEN
        body: child,
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String route,
    required bool selected,
  }) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.blue : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: selected,
      onTap: () {
        Navigator.pop(context); // close drawer
        router.pushNamed(route);
      },
    );
  }
}
