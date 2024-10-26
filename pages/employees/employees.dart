import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/list_state.dart';
import 'package:ess_iris/cubit/user/user_list.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/pages/employees_detail/employees_detail.dart';
import 'package:ess_iris/widgets/avatar.dart';
import 'package:ess_iris/widgets/empty.dart';

class EmployeesPage extends StatefulWidget {
  static const String routeName = '/employees';

  const EmployeesPage({Key? key}) : super(key: key);

  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  void _onEmployeeDetail(User user) {
    Navigator.pushNamed(
      context,
      EmployeesDetailPage.routeName,
      arguments: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserListCubit, ListState<User>>(
        builder: (context, state) {
          if (state.status == ListStateStatus.success) {
            if (state.data?.isNotEmpty ?? false) {
              return ListView.builder(
                itemCount: state.data!.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      onTap: () => _onEmployeeDetail(state.data![i]),
                      leading: Hero(
                        tag: state.data?[i].id ?? 0,
                        child: AppAvatar(
                          url: state.data?[i].avatarUrl,
                        ),
                      ),
                      title: Text(state.data?[i].name ?? ''),
                    ),
                  );
                },
              );
            }
            return const AppEmpty();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
