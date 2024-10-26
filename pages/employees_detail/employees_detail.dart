import 'package:flutter/material.dart';
import 'package:ess_iris/models/user.dart';
import 'package:ess_iris/repositories/user_repository.dart';
import 'package:ess_iris/services/response/employee_detail.dart';
import 'package:ess_iris/utils/constant.dart';
import 'package:ess_iris/widgets/avatar.dart';
import 'package:intl/intl.dart';

class EmployeesDetailPage extends StatefulWidget {
  static const String routeName = '/employees/detail';

  final User user;

  const EmployeesDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  _EmployeesDetailPageState createState() => _EmployeesDetailPageState();
}

class _EmployeesDetailPageState extends State<EmployeesDetailPage> {
  late final Future<EmployeeDetailResponse> company;
  late final Future<EmployeeDetailResponse> division;
  late final Future<EmployeeDetailResponse> subdivision;
  late final Future<EmployeeDetailResponse> department;
  final _repository = UserRepository();

  @override
  void initState() {
    final user = widget.user;
    company = _repository.findCompany(user.companyId ?? '');
    division = _repository.findDivision(user.divisionId ?? '');
    subdivision = _repository.findSubdivision(user.subdivisionId ?? '');
    department = _repository.findDepartment(user.departmentId ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name ?? ''),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: kPageViewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name ?? '',
                        style: kGiantHeavy.copyWith(color: kDarkBlueColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Hero(
                  tag: widget.user.id ?? 0,
                  child: AppAvatar(
                    radius: 60,
                    url: widget.user.avatarUrl,
                  ),
                ),
              ],
            ),
            kSmallSpacing,
            const Divider(),
            kSmallSpacing,
            _buildDetail('Tempat Lahir', widget.user.placeOfBirth ?? ''),
            _buildDetail(
              'Tanggal Lahir',
              DateFormat('dd MMMM yyyy').format(
                widget.user.dateOfBirth ?? DateTime.now(),
              ),
            ),
            _buildDetail(
              'Jenis Kelamin',
              widget.user.sex == 0 ? 'Laki-laki' : 'Perempuan',
            ),
            _buildDetail('Golongan Darah', widget.user.blood ?? ''),
            FutureBuilder<EmployeeDetailResponse>(
              future: company,
              builder: (context, snapshot) {
                return _buildDetail(
                  'Perusahaan',
                  snapshot.hasData ? snapshot.data?.name ?? '' : '',
                );
              },
            ),
            FutureBuilder<EmployeeDetailResponse>(
              future: division,
              builder: (context, snapshot) {
                return _buildDetail(
                  'Divisi',
                  snapshot.hasData ? snapshot.data?.name ?? '' : '',
                );
              },
            ),
            FutureBuilder<EmployeeDetailResponse>(
              future: subdivision,
              builder: (context, snapshot) {
                return _buildDetail(
                  'Sub Divisi',
                  snapshot.hasData ? snapshot.data?.name ?? '' : '',
                );
              },
            ),
            FutureBuilder<EmployeeDetailResponse>(
              future: department,
              builder: (context, snapshot) {
                return _buildDetail(
                  'Departemen',
                  snapshot.hasData ? snapshot.data?.name ?? '' : '',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Column _buildDetail(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kMediumHeavy.copyWith(color: kDarkBlueColor),
        ),
        kTinySpacing,
        Text(
          detail,
          style: kMediumMedium.copyWith(color: kDarkBlueColor),
        ),
        kMediumSpacing,
      ],
    );
  }
}
