import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/pages/claim_password/claim_password.dart';
import 'package:ess_iris/pages/forgot_password/forgot_password.dart';
import 'package:ess_iris/pages/home/home.dart';
import 'package:ess_iris/services/request/login.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/helper.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/input.dart';
import 'package:ess_iris/widgets/loading.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  int _countLoginError = 0;
  String tempEmail = '';
  LoginRequest data = LoginRequest();

  PackageInfo? packageInfo;


  _onLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<AuthCubit>().login(data);
    }
  }

  _deepLinkParse(Map<String, String> data) {
    if (data['forgot']?.isNotEmpty ?? false) {
      Navigator.pushNamed(
        context,
        ClaimPasswordPage.routeName,
        arguments: data['forgot'],
      );
    }
  }

  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      if (mounted) {
        setState(() {
          packageInfo = value;
        });
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<AuthCubit>().appStarted();
    });

    FirebaseDynamicLinks.instance.getInitialLink().then((value) {
      if (value != null) {
        _deepLinkParse(value.link.queryParameters);
      }
    });

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (dynamicLinkData.link.hasQuery) {
        _deepLinkParse(dynamicLinkData.link.queryParameters);
      }
    }).onError((error) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, DetailState<User>>(
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
          if (state.status == DetailStateStatus.success && state.data != null) {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
          if (state.status == DetailStateStatus.failure) {
            if (state.error?.statusCode == 404) {
              _countLoginError += 1;

              if (_countLoginError > 4) {
                Helper.blockUser(data.email!);
              }
            }
            AppError.of(context).show(message: state.error?.message ?? '');
          }
        },
        builder: (context, state) {
          if (state.status != DetailStateStatus.initial && state.data == null) {
            return SafeArea(child: _buildContent(context));
          }
          return const SizedBox();
        },
      ),
    );
  }

  CustomScrollView _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: kPageViewPadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                kLargeSpacing,
                _buildForm(context),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: kDefaultPadding,
            height: 80,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _onLogin,
                    child: Text(
                      'Login',
                      style: kLargeHeavy.copyWith(color: kWhiteColor),
                    ),
                  ),
                  kLargeSpacing,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 280,
              child: Lottie.asset('assets/lottie/hello.json'),
            ),
          ),
          kSmallSpacing,
          Text(
            'Hey,\nLogin Now.',
            style: kBigHeaderHeavy.copyWith(color: kDarkBlueColor),
          ),
          kMediumSpacing,
          AppInput(
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (String? val) {
              if (val?.isEmpty ?? false) {
                return 'Mohon masukkan email anda';
              }
              return null;
            },
            onSaved: (String? val) {
              data.email = val?.replaceAll(" ", "");

              if (val != tempEmail) {
                _countLoginError = 0;
              }

              if (_countLoginError == 0) {
                tempEmail = data.email!;
              }
            },
          ),
          kSmallSpacing,
          AppInput(
            placeholder: 'Kata sandi',
            validator: (String? val) {
              if (val?.isEmpty ?? false) {
                return 'Mohon masukkan kata sandi anda';
              }
              return null;
            },
            onSaved: (String? val) {
              data.password = val;
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
          ),
          kMediumSpacing,
          RichText(
            text: TextSpan(
              text: 'Lupa kata sandi? ',
              style: kMediumMedium.copyWith(color: kGreyColor),
              children: [
                TextSpan(
                  text: 'Reset',
                  style: kMediumHeavy.copyWith(color: kDarkBlueColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                          context, ForgotPasswordPage.routeName);
                    },
                ),
              ],
            ),
          ),
          kGiantSpacing,
          Center(
            child: Text(
              'Versi ${packageInfo?.version ?? 0}',
              style: kMediumBook.copyWith(
                color: kDarkBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
