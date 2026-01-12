import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: RoleFab(
        onAdminTap: () {
          isAdmin = true;
          print(isAdmin);
        },
        onStaffTap: () {
          isAdmin = false;
          print(isAdmin);
        },
      ),
      appBar: AppBar(
        title: const Text('Case Operations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              router.goNamed(Routes.login.name);
            },
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
                subtitle: 'Scan & assign cases to a company',
                color: AppColors.primaryLight,
                onTap: () {
                  isAdmin
                      ? router.pushNamed(Routes.assignAdmin.name)
                      : router.pushNamed(Routes.assign.name);
                },
              ),
              const SizedBox(height: 20),

              _ActionCard(
                icon: Icons.assignment_turned_in,
                title: 'Receive Cases',
                subtitle: 'Scan returned cases from company',
                color: AppColors.card,
                onTap: () {
                  isAdmin
                      ? router.pushNamed(Routes.receiveAdmin.name)
                      : router.pushNamed(Routes.receive.name);
                },
              ),
              const SizedBox(height: 20),

              _ActionCard(
                icon: Icons.list_alt_sharp,
                title: 'Reports',
                subtitle: "View case assignment and reception reports",
                color: AppColors.card,
                onTap: () {
                  isAdmin ? router.pushNamed(Routes.reportsScreen.name) : null;
                },
              ),

              const Spacer(),

              Text(
                'Scan → Assign → Receive → Track',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
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

class RoleFab extends StatefulWidget {
  final VoidCallback onAdminTap;
  final VoidCallback onStaffTap;

  const RoleFab({
    super.key,
    required this.onAdminTap,
    required this.onStaffTap,
  });

  @override
  State<RoleFab> createState() => _RoleFabState();
}

class _RoleFabState extends State<RoleFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void toggle() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (isOpen)
          GestureDetector(
            onTap: toggle,
            child: Container(color: Colors.black38),
          ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _FabOption(
                icon: Icons.admin_panel_settings,
                label: "Admin",
                animation: _animation,
                onTap: () {
                  toggle();
                  widget.onAdminTap();
                },
              ),
              const SizedBox(height: 12),
              _FabOption(
                icon: Icons.badge,
                label: "Staff",
                animation: _animation,
                onTap: () {
                  toggle();
                  widget.onStaffTap();
                },
              ),
              const SizedBox(height: 16),

              FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: toggle,
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: _animation,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FabOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _FabOption({
    required this.icon,
    required this.label,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: AppColors.primary,
            onPressed: onTap,
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
