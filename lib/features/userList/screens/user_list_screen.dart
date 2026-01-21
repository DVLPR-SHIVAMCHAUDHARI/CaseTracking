import 'package:casetracking/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/features/userList/bloc/user_list_bloc.dart';
import 'package:casetracking/features/userList/bloc/user_list_event.dart';
import 'package:casetracking/features/userList/bloc/user_list_state.dart';
import 'package:casetracking/features/userList/shared_widgets/user_list_card.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();

    /// ✅ Call API ONCE
    context.read<UserListBloc>().add(const FetchUserList(offset: 1, limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("User List"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserListError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is UserListEmpty) {
            return const Center(child: Text("No users found"));
          }

          if (state is UserListLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index == state.users.length - 1 ? 80 : 0,
                  ),
                  child: UserCard(
                    user: state.users[index],
                    onUpdatePassword: () => router.pushNamed(
                      Routes.updatePassword.name,
                      extra: state.users[index].id,
                    ),
                    onUpdateUser: () => router.pushNamed(
                      Routes.updateuser.name,
                      extra: {
                        'id': state.users[index].id,
                        'fullname': state.users[index].fullname,
                        'email': state.users[index].email,
                        'departmentId': state.users[index].departmentId,
                      },
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
