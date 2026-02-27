import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/userList/models/user_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  /// Callbacks (optional for now)
  final VoidCallback? onUpdateUser;
  final VoidCallback? onUpdatePassword;

  const UserCard({
    super.key,
    required this.user,
    this.onUpdateUser,
    this.onUpdatePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UID: ${user.id}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Chip(
                label: Text(user.roleName!),
                backgroundColor: AppColors.primaryLight,
                labelStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            user.fullname!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          Text(
            user.email!,
            style: const TextStyle(color: AppColors.textSecondary),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.apartment, size: 16),
              const SizedBox(width: 6),
              Text(
                user.departmentName!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                user.isVerified == 01 ? Icons.verified : Icons.error_outline,
                size: 16,
                color: user.isVerified == 1
                    ? AppColors.success
                    : AppColors.error,
              ),
              const SizedBox(width: 6),
              Text(user.isVerified == 1 ? "Verified" : "Not Verified"),
            ],
          ),

          const Divider(height: 24),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onUpdateUser,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Update User"),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onUpdatePassword,
                icon: const Icon(Icons.lock_reset, size: 18),
                label: const Text("Update Password"),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
