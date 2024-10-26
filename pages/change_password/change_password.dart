import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/cubit/user/user_cubit.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/services/request/change_password.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/input.dart';
import 'package:ess_iris/widgets/loading.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = '/change-password';

  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String newPassword = '';
  bool _isObscure = true;
  bool _isObscure2 = true;
  ChangePasswordRequest data = ChangePasswordRequest();

  _onChangePass() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String userId = context.read<AuthCubit>().state.data?.id ?? '';
      context.read<UserCubit>().changePassword(userId, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Kata Sandi'),
        centerTitle: true,
      ),
      body: BlocListener<UserCubit, DetailState<User>>(
        listenWhen: (previous, current) {
          if (previous.status == DetailStateStatus.loading) {
            Navigator.pop(context);
          }
          return true;
        },
        listener: (context, state) {
          if (state.status == DetailStateStatus.loading) {
            AppLoading.of(context).show();
          }
          if (state.status == DetailStateStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Berhasil mengubah password'),
              ),
            );
            Navigator.pop(context);
          }
          if (state.status == DetailStateStatus.failure) {
            AppError.of(context).show(message: state.error?.message ?? '');
          }
        },
        child: CustomScrollView(slivers: [
          SliverPadding(
            padding: kPageViewPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildForm(),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: kPageViewPadding,
              height: 180,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _onChangePass,
                      child: Text(
                        'Ubah Kata Sandi',
                        style: kLargeHeavy.copyWith(color: kWhiteColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            title: 'Kata sandi saat ini',
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Mohon masukkan kata sandi saat ini';
              }
              return null;
            },
            obscureText: _isObscure,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: Icon(!_isObscure ? Icons.visibility : Icons.visibility_off),
            ),
            onSaved: (val) {
              data.currentPassword = val;
            },
          ),
          kMediumSpacing,
          AppInput(
            title: 'Kata sandi baru',
            onChanged: (val) {
              newPassword = val;
            },
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Mohon masukkan kata sandi baru';
              }
              return null;
            },
            onSaved: (val) {
              data.newPassword = val;
            },
            obscureText: _isObscure2,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure2 = !_isObscure2;
                });
              },
              icon:
                  Icon(!_isObscure2 ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          kMediumSpacing,
          AppInput(
            title: 'Konfirmasi kata sandi baru',
            obscureText: true,
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Mohon masukkan konfirmasi kata sandi baru';
              } else {
                if (val != newPassword) {
                  return 'Kata sandi baru tidak sama';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
