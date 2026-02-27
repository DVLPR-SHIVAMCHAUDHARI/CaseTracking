import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/asset_url.dart';
import 'package:casetracking/core/consts/unimesh_logo.dart';
import 'package:casetracking/core/consts/user_context.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/core/services/local_db.dart';
import 'package:casetracking/features/authentication/Screens/login_screen.dart';
import 'package:casetracking/features/authentication/bloc/auth_bloc.dart';
import 'package:casetracking/features/authentication/bloc/auth_event.dart';
import 'package:casetracking/features/authentication/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _departmentName;

  @override
  void initState() {
    super.initState();

    _loadLocation();
  }

  Future<UserContext> _loadContext() async {
    final roleId = await LocalDb.getRoleId();
    final stageId = await LocalDb.getStageId();

    return UserContext(roleId: roleId ?? "", stageId: stageId ?? "");
  }

  Future<void> _loadLocation() async {
    final name = await LocalDb.getDepartmentName();

    _departmentName = name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadContext(),
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = asyncSnapshot.data!;
        final isAdmin = user.isAdmin;
        final isStage1 = user.stageId == "1";
        final isStage2 = user.stageId == "2";

        return Scaffold(
          backgroundColor: AppColors.background,

          // appBar: AppBar(
          //   centerTitle: true,
          //   title: const Text('Case Operations'),
          //   leading: Image.asset(AssetUrl.icUnimeshTechnology),
          //   leadingWidth: 100.w,
          //   actions: [
          //     BlocListener<AuthBloc, AuthState>(
          //       listener: (context, state) {
          //         if (state is LogoutSuccessState) {
          //           router.goNamed(Routes.login.name);
          //         }
          //       },
          //       child: IconButton(
          //         icon: const Icon(Icons.logout),
          //         onPressed: () {
          //           showConfirmLogoutDialog(context);
          //         },
          //       ),
          //     ),
          //   ],
          //   backgroundColor: Colors.white,
          //   foregroundColor: Colors.black,
          //   elevation: 0,
          // ),
          body: SafeArea(
            top: false,
            child: Container(
              // color: const Color.fromARGB(255, 227, 227, 226),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 167, 185, 221),
                    Color.fromARGB(255, 52, 67, 95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Image.asset(
                          //   AssetUrl.icUnimeshTechnology,
                          //   width: 90.w,
                          // ),
                          SizedBox(
                            height: 40.h,
                            width: 40.w,
                            child: Image.asset(
                              AssetUrl.icUnimesh,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "Case Operations",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          const Spacer(),

                          BlocListener<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is LogoutSuccessState) {
                                router.goNamed(Routes.login.name);
                              }
                            },
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                showConfirmLogoutDialog(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        // color: AppColors.primary.withOpacity(0.1),
                        color: AppColors.card.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isAdmin
                            ? "Administrator ($_departmentName)"
                            : "Stage ${user.stageId} $_departmentName",
                        style: const TextStyle(
                          color: AppColors.background,
                          // color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// GRID DASHBOARD
                    Expanded(
                      child: GridView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 19,

                              childAspectRatio: 1,
                            ),
                        children: [
                          //// ASSIGN
                          _DashboardCard(
                            icon: Icons.assignment_ind,
                            title: "Assign",
                            color: DashboardColors.assign,
                            onTap: () {
                              if (isStage1) {
                                router.pushNamed(Routes.assign1.name);
                              } else if (isStage2) {
                                router.pushNamed(Routes.assign2.name);
                              }
                            },
                          ),

                          /// RECEIVE
                          _DashboardCard(
                            icon: Icons.assignment_turned_in,
                            title: "Receive",
                            color: DashboardColors.receive,
                            onTap: () {
                              if (isStage1) {
                                router.pushNamed(Routes.receive1.name);
                              } else if (isStage2) {
                                router.pushNamed(Routes.receive2.name);
                              }
                            },
                          ),

                          /// REPORTS
                          _DashboardCard(
                            icon: Icons.analytics_outlined,
                            title: "Reports",
                            color: DashboardColors.reports,
                            onTap: () {
                              router.pushNamed(Routes.pendingReports.name);
                            },
                          ),

                          if (isAdmin)
                            _DashboardCard(
                              icon: Icons.people_outline,
                              title: "Users",
                              color: DashboardColors.users,
                              onTap: () {
                                router.pushNamed(Routes.userlist.name);
                              },
                            ),

                          if (isAdmin)
                            _DashboardCard(
                              icon: Icons.bar_chart,
                              title: "Party Reports",
                              color: DashboardColors.partyReports,
                              onTap: () {
                                router.pushNamed(Routes.partywiseReport.name);
                              },
                            ),

                          if (isAdmin)
                            _DashboardCard(
                              icon: Icons.add_box_outlined,
                              title: "Add Box",
                              color: DashboardColors.addBox,
                              onTap: () {
                                router.pushNamed(Routes.addBox.name);
                              },
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Scan → Assign → Receive → Track',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12.sp,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showConfirmLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text("Confirm Logout"),
          ],
        ),
        content: const Text(
          "Are you sure you want to logout?\nYou will need to login again.",
          style: TextStyle(fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          /// CANCEL
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),

          /// LOGOUT
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);

              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

class DashboardColors {
  static const assign = Color(0xFF4F46E5); // Indigo
  static const receive = Color(0xFF0EA5E9); // Sky Blue
  static const reports = Color(0xFF7C3AED); // Violet
  static const users = Color(0xFF10B981); // Emerald
  static const partyReports = Color(0xFFF59E0B); // Amber
  static const addBox = Color(0xFFEF4444); // Soft Red
}
