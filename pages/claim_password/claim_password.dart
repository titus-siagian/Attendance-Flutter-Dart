import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/forgot_password/forgot_password.dart';
import 'package:ess_iris/services/request/claim_password.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/input.dart';
import 'package:ess_iris/widgets/loading.dart';

class ClaimPasswordPage extends StatefulWidget {
  static const String routeName = '/claim-password';

  final String? claimId;

  const ClaimPasswordPage({Key? key, this.claimId}) : super(key: key);

  @override
  _ClaimPasswordPageState createState() => _ClaimPasswordPageState();
}

class _ClaimPasswordPageState extends State<ClaimPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _request = ClaimPasswordRequest();
  String password = '';

  bool _isObscure = true;
  bool _isObscure2 = true;

  _onSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _request.id = widget.claimId;
      context.read<ForgotPasswordCubit>().claimPassword(_request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kata Sandi Baru'),
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
                content: Text('Berhasil! silahkan login kembali.'),
              ),
            );
            Navigator.pop(context);
          }
          if (state.status == DetailStateStatus.failure) {
            AppError.of(context).show(
                message: state.error?.message ?? 'Terjadi kesalahan server');
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: kPageViewPadding,
              sliver: SliverToBoxAdapter(
                child: _buildForm(),
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
                        onPressed: _onSubmit,
                        child: Text(
                          'Submit',
                          style: kLargeHeavy.copyWith(color: kWhiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInput(
            title: 'Kata sandi baru',
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Mohon masukkan Kata sandi baru';
              }
              return null;
            },
            onChanged: (val) {
              password = val;
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
              _request.newPassword = val;
            },
          ),
          kMediumSpacing,
          AppInput(
            title: 'Konfirmasi kata sandi baru',
            validator: (val) {
              if (val?.isEmpty ?? true) {
                return 'Mohon masukkan konfirmasi Kata sandi baru';
              }
              if (val != password) {
                return 'Kata sandi anda tidak sama, mohon periksa kembali';
              }
              return null;
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
        ],
      ),
    );
  }
}
