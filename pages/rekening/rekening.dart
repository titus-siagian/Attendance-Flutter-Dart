import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_mobile/controllers/detail_state.dart';
import 'package:hr_mobile/cubit/auth/auth_cubit.dart';
import 'package:hr_mobile/models/user.dart';
import 'package:hr_mobile/pages/edit_profile/edit_profile.dart';
import 'package:hr_mobile/utils/constant.dart';
import 'package:hr_mobile/widgets/input.dart';

class RekeningPage extends StatefulWidget{
  static const String routeName = '/rekening-profile';

  const RekeningPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RekeningPageState();

}

class _RekeningPageState extends State<RekeningPage> {

  final _formkey = GlobalKey<FormState>();
  late final User user;

  @override
  void initState() {
    user = User.fromJson(
        (context.read<AuthCubit>().state.data ?? User()).toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekening Information'),
      ),
      body: BlocListener<AuthCubit, DetailState<User>>(
        listener: (context, state){

        },
        child: SingleChildScrollView(
          padding: kPageViewPadding,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppInput(
                    enabled: false,
                    initialValue: user.name,
                    title: 'Nama',
                    placeholder: 'John Doe',
                  ),
                  kLargeSpacing,
                  AppInput(
                    enabled: false,
                    initialValue: 'Rp. 541.135.000',
                    title: 'Saldo',
                    placeholder: 'Rp. 541.135.000',
                  )
                ],
              ),
            ),
        ),
      )
    );
  }
}