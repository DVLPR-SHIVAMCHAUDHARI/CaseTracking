import 'package:casetracking/core/consts/appcolors.dart';
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

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<UserContext> _loadContext() async {
    final roleId = await LocalDb.getRoleId();
    final stageId = await LocalDb.getStageId();

    return UserContext(roleId: roleId ?? "", stageId: stageId ?? "");
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

          appBar: AppBar(
            title: const Text('Case Operations'),
            actions: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LogoutSuccessState) {
                    router.goNamed(Routes.login.name);
                  }
                },
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    showConfirmLogoutDialog(context);
                  },
                ),
              ),
            ],
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                children: [
                  _ActionCard(
                    icon: Icons.assignment_ind,
                    title: 'Assign Cases',
                    subtitle: 'Scan & assign cases',
                    color: Colors.white,
                    onTap: () {
                      if (isStage1) {
                        router.pushNamed(Routes.assign1.name);
                      } else if (isStage2) {
                        router.pushNamed(Routes.assign2.name);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  _ActionCard(
                    icon: Icons.assignment_turned_in,
                    title: 'Receive Cases',
                    subtitle: 'Scan returned cases from company',
                    color: AppColors.card,
                    onTap: () {
                      if (isStage1) {
                        router.pushNamed(Routes.receive1.name);
                      } else if (isStage2) {
                        router.pushNamed(Routes.receive2.name);
                      }
                    },
                  ),
                  20.verticalSpace,

                  _ActionCard(
                    icon: Icons.list_alt_sharp,
                    title: 'Reports',
                    subtitle: "View case assignment and reception reports",
                    color: AppColors.card,
                    onTap: () {
                      router.pushNamed(Routes.pendingReports.name);
                    },
                  ),
                  20.verticalSpace,

                  isAdmin
                      ? _ActionCard(
                          icon: Icons.person_outlined,
                          title: "Users",
                          subtitle: "Users List & Management",
                          color: Colors.white,
                          onTap: () {
                            router.pushNamed(Routes.userlist.name);
                          },
                        )
                      : SizedBox.shrink(),

                  20.verticalSpace,

                  const Spacer(),

                  Text(
                    'Scan → Assign → Receive → Track',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textSecondary,
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
