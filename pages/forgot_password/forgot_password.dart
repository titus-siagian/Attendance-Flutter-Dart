import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/forgot_password/forgot_password.dart';
import 'package:ess_iris/services/request/forgot_password.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/input.dart';
import 'package:ess_iris/widgets/loading.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String routeName = '/forgot-password';

  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  RegExp validatorEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final _formKey = GlobalKey<FormState>();
  final _request = ForgotPasswordRequest();

  _onReset() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<ForgotPasswordCubit>().forgotPassword(_request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: BlocListener<ForgotPasswordCubit, DetailState<bool>>(
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
                content: Text('Request berhasil! silahkan cek email anda.'),
              ),
            );
            Navigator.pop(context);
          }
          if (state.status == DetailStateStatus.failure) {
            AppError.of(context).show(
                message: state.error?.message ?? 'Terjadi kesalahan server');
          }
        },
        child: _buildContent(),
      ),
    );
  }

  CustomScrollView _buildContent() {
    return CustomScrollView(slivers: [
      SliverPadding(
        padding: kPageViewPadding,
        sliver: SliverList(
          delegate: SliverChildListDelegate(
            [
              Text(
                'Masukkan informasi email anda dibawah ini, dan pastikan anda menerima email di kotak masuk maupun spam.',
                style: kLargeMedium.copyWith(color: kDarkBlueColor),
              ),
              kMediumSpacing,
              Form(
                key: _formKey,
                child: AppInput(
                  placeholder: 'example@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return 'Mohon masukkan email anda';
                    } else {
                      if (!validatorEmail.hasMatch(val!)) {
                        return 'Mohon masukkan format email dengan benar';
                      }
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _request.email = val!;
                  },
                ),
              )
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
                  onPressed: _onReset,
                  child: Text(
                    'Lupa Kata Sandi',
                    style: kLargeHeavy.copyWith(color: kWhiteColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
