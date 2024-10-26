import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/cubit/question/question.dart';
import 'package:ess_iris/models/question.dart';
import 'package:ess_iris/repositories/question_repository.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/helper.dart';
import 'package:ess_iris/widgets/loading.dart';

class QuestionModal extends StatefulWidget {
  final Question question;

  const QuestionModal({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionModalState createState() => _QuestionModalState();
}

class _QuestionModalState extends State<QuestionModal> {
  final _bloc = QuestionCubit();
  String answer = '';
  int _counterError = 0;
  late Question _question;
  String? error;

  onAnswer() {
    if (answer.isNotEmpty) {
      _bloc.validate(_question.id ?? '', answer);
    } else {
      setState(() {
        error = 'Mohon pilih jawaban';
      });
    }
  }

  @override
  void initState() {
    _question = widget.question;
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuestionCubit, DetailState<Question>>(
      bloc: _bloc,
      listenWhen: (prev, curr) {
        if (prev.status == DetailStateStatus.loading) {
          Navigator.pop(context);
        }
        return true;
      },
      listener: (context, state) {
        if (state.status == DetailStateStatus.loading) {
          AppLoading.of(context).show();
        }

        if (state.status == DetailStateStatus.success) {
          Navigator.pop(context, true);
        }

        if (state.status == DetailStateStatus.failure) {
          if (state.error?.statusCode == 400) {
            _counterError += 1;
          }

          if (_counterError > 2) {
            final getUser = context.read<AuthCubit>().state.data;
            Helper.blockUser(getUser!.email!).then((value) {
              context.read<AuthCubit>().fetchUser();
            });
          } else {
            context.read<AuthCubit>().fetchUser();
          }

          QuestionRepository().getQuestion().then((val) {
            setState(() {
              _question = val;
            });
          });

          setState(() {
            answer = '';
            error = state.error?.message ?? 'Terjadi kesalahan pada server';
          });
        }
      },
      child: AlertDialog(
        scrollable: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        title: const Text('Validasi Pengguna'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_question.question ?? ''),
            kLargeSpacing,
            for (MultipleChoice item in _question.choices ?? [])
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: choiceBox(code: item.code, text: item.text),
              ),
            Visibility(
              visible: error != null,
              child: Text(
                error ?? '',
                style: kMediumMedium.copyWith(color: kPrimaryColor),
              ),
            )
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: kPrimaryColor,
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Kembali',
              style: kMediumMedium.copyWith(color: kDarkBlueColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(140, 0)),
            onPressed: onAnswer,
            child: const Text('Jawab'),
          ),
        ],
        buttonPadding: kDefaultPadding,
      ),
    );
  }

  InkWell choiceBox({String? text, String? code}) {
    return InkWell(
      onTap: () {
        setState(() {
          answer = code ?? '';
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(
            color: code == answer ? kDarkBlueColor : kWhiteColor2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(width: 48, child: Text(code ?? '')),
            Expanded(child: Text(text ?? ''))
          ],
        ),
      ),
    );
  }
}
