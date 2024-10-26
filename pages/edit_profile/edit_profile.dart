import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ess_iris/controllers/detail_state.dart';
import 'package:ess_iris/cubit/auth/auth_cubit.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/response/employee_detail.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/utils/logger.dart';
import 'package:ess_iris/widgets/avatar.dart';
import 'package:ess_iris/widgets/error.dart';
import 'package:ess_iris/widgets/input.dart';
import 'package:ess_iris/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = '/edit-profile';

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  final _repository = UserRepository();
  late final User user;
  XFile? file;
  late final Future<EmployeeDetailResponse> company;
  late final Future<EmployeeDetailResponse> division;
  late final Future<EmployeeDetailResponse> subdivision;
  late final Future<EmployeeDetailResponse> department;

  @override
  void initState() {
    user = User.fromJson(
      (context.read<AuthCubit>().state.data ?? User()).toJson(),
    );
    company = _repository.findCompany(user.companyId ?? '');
    division = _repository.findDivision(user.divisionId ?? '');
    subdivision = _repository.findSubdivision(user.subdivisionId ?? '');
    department = _repository.findDepartment(user.departmentId ?? '');
    super.initState();
  }

  _onSave() {
    _formKey.currentState!.save();
    if (file != null) {
      context.read<AuthCubit>().updateUser(user, file: File(file!.path));
    } else {
      context.read<AuthCubit>().updateUser(user);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? getFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 720,
      );
      if (getFile != null) {
        setState(() {
          file = getFile;
        });
      }
    } catch (e) {
      logger.e(e);
    }
  }

  _choosePick() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.photo),
                        kTinySpacing,
                        Text('Galeri'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera),
                        kTinySpacing,
                        Text('Kamera'),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<AuthCubit, DetailState<User>>(
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
                content: Text('Update profile berhasil!'),
              ),
            );
          }
          if (state.status == DetailStateStatus.failure) {
            AppError.of(context).show(message: state.error?.message ?? '');
          }
        },
        child: SingleChildScrollView(
          padding: kPageViewPadding,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _choosePick,
                    child: Center(
                      child: Stack(
                        children: [
                          Visibility(
                            visible: file == null,
                            replacement: CircleAvatar(
                              radius: 60,
                              backgroundColor: kWhiteColor2,
                              backgroundImage:
                                  FileImage(File(file?.path ?? '')),
                            ),
                            child: AppAvatar(
                              radius: 60,
                              url: user.avatarUrl,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.photo_camera,
                                  color: kWhiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kLargeSpacing,
                  AppInput(
                    initialValue: user.email,
                    title: 'Email',
                    placeholder: 'johndoe@example.com',
                    onSaved: (String? val) {
                      user.email = val;
                    },
                  ),
                  kLargeSpacing,
                  AppInput(
                    enabled: false,
                    initialValue: user.id,
                    title: 'ID Karyawan',
                    placeholder: '12345',
                    onSaved: (String? val) {
                      user.id = val;
                    },
                  ),
                  kLargeSpacing,
                  AppInput(
                    enabled: false,
                    initialValue: user.name,
                    title: 'Nama',
                    placeholder: 'John Doe',
                    onSaved: (String? val) {
                      user.name = val;
                    },
                  ),
                  kLargeSpacing,
                  AppInput(
                    enabled: false,
                    initialValue: user.placeOfBirth,
                    title: 'Tempat Lahir',
                    placeholder: 'Jakarta',
                    onSaved: (String? val) {
                      user.placeOfBirth = val;
                    },
                  ),
                  kLargeSpacing,
                  Text(
                    'Tanggal Lahir',
                    style: kMediumMedium.copyWith(color: kDarkBlueColor),
                  ),
                  kTinySpacing,
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kWhiteColor2,
                      primary: kGreyColor2,
                      minimumSize: const Size(double.infinity, 0),
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: null,
                    // onPressed: () async {
                    //   final result = await showDatePicker(
                    //     context: context,
                    //     initialDate: user.dateOfBirth != null
                    //         ? user.dateOfBirth!
                    //         : DateTime(1990),
                    //     firstDate: DateTime(1980),
                    //     lastDate: DateTime.now(),
                    //     builder: (context, child) {
                    //       return Theme(
                    //         data: ThemeData(
                    //           colorScheme: const ColorScheme.light(
                    //             primary: kPrimaryColor,
                    //           ),
                    //         ),
                    //         child: child!,
                    //       );
                    //     },
                    //   );
                    //   if (result != null) {
                    //     setState(() {
                    //       user.dateOfBirth =
                    //           result.add(const Duration(hours: 7)).toUtc();
                    //     });
                    //   }
                    // },
                    child: Text(
                      user.dateOfBirth != null
                          ? DateFormat('dd MMMM yyyy').format(user.dateOfBirth!)
                          : '-',
                      style: kMediumMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  kLargeSpacing,
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          enabled: false,
                          title: 'Jenis Kelamin',
                          initialValue:
                              user.sex == 0 ? 'Laki-laki' : 'Perempuan',
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'Jenis Kelamin',
                        //       style:
                        //           kMediumMedium.copyWith(color: kDarkBlueColor),
                        //     ),
                        //     kTinySpacing,
                        //     DropdownButtonFormField<int>(
                        //       onSaved: (val) {
                        //         user.sex = val;
                        //       },
                        //       onChanged: (val) {},
                        //       value: user.sex ?? 0,
                        //       items: [0, 1].map((e) {
                        //         return DropdownMenuItem<int>(
                        //           child: Text(
                        //             e == 0 ? 'Laki-laki' : 'Perempuan',
                        //             style: kMediumMedium,
                        //           ),
                        //           value: e,
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ],
                        // ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: AppInput(
                          enabled: false,
                          title: 'Golongan Darah',
                          initialValue: user.blood,
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'Golongan Darah',
                        //       style:
                        //           kMediumMedium.copyWith(color: kDarkBlueColor),
                        //     ),
                        //     kTinySpacing,
                        //     DropdownButtonFormField<String>(
                        //       onSaved: (val) {
                        //         user.blood = val;
                        //       },
                        //       onChanged: (val) {},
                        //       value: user.blood ?? 'A',
                        //       items: ['A', 'B', 'O', 'AB'].map((e) {
                        //         return DropdownMenuItem<String>(
                        //           child: Text(e, style: kMediumMedium),
                        //           value: e,
                        //         );
                        //       }).toList(),
                        //     ),
                        //   ],
                        // ),
                      )
                    ],
                  ),
                  kLargeSpacing,
                  AppInput(
                    initialValue: user.phone,
                    title: 'No Telp',
                    placeholder: '0812345678',
                    keyboardType: TextInputType.phone,
                    onSaved: (String? val) {
                      user.phone = val;
                    },
                  ),
                  kLargeSpacing,
                  AppInput(
                    enabled: false,
                    initialValue: user.address,
                    title: 'Alamat',
                    placeholder: 'Jl. Asia Afrika',
                    minLines: 4,
                    maxLines: 4,
                    onSaved: (String? val) {
                      user.address = val;
                    },
                  ),
                  kLargeSpacing,
                  FutureBuilder<EmployeeDetailResponse>(
                    future: company,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AppInput(
                          enabled: false,
                          title: 'Perusahaan',
                          initialValue: snapshot.data?.name,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  kLargeSpacing,
                  FutureBuilder<EmployeeDetailResponse>(
                    future: division,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AppInput(
                          enabled: false,
                          title: 'Divisi',
                          initialValue: snapshot.data?.name,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  kLargeSpacing,
                  FutureBuilder<EmployeeDetailResponse>(
                    future: subdivision,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AppInput(
                          enabled: false,
                          title: 'Sub Divisi',
                          initialValue: snapshot.data?.name,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  kLargeSpacing,
                  FutureBuilder<EmployeeDetailResponse>(
                    future: department,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AppInput(
                          enabled: false,
                          title: 'Departemen',
                          initialValue: snapshot.data?.name,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  kGiantSpacing,
                  const Divider(),
                  kSmallSpacing,
                  Center(
                    child: Text(
                      'Disclaimer',
                      style: kLargeHeavy.copyWith(color: kDarkBlueColor),
                    ),
                  ),
                  kMediumSpacing,
                  const Text(
                    'Semua informasi mengenal data karyawan yang terdaftar dalam perusahaan tertentu, tidak membatasi area tugas ataupun penempatan secara aktual.',
                    style: kMediumMedium,
                  ),
                  kMediumSpacing,
                  const Text(
                    'Dengan menggunakan dan membaca informasi dalam aplikasi ini, Anda dengan secara langsung maupun tidak langsung setuju dengan disclaimer telah dicantumkan.',
                    style: kMediumMedium,
                  ),
                  kSmallSpacing,
                  const Divider(),
                  kGiantSpacing,
                  kGiantSpacing,
                  ElevatedButton(
                    onPressed: _onSave,
                    child: const Text('Save', style: kLargeHeavy),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
