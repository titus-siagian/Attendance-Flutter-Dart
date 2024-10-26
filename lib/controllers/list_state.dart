import 'package:flutter/foundation.dart';
import 'package:ess_iris/services/response/error.dart';

enum ListStateStatus {
  initial,
  loading,
  success,
  failure,
}

@immutable
class ListState<T> {
  final ListStateStatus status;
  final List<T>? data;
  final ErrorResponse? error;

  const ListState({this.status = ListStateStatus.initial, this.data, this.error});

  ListState<T> copyWith({
    ListStateStatus? status,
    List<T>? data,
    ErrorResponse? error,
  }) {
    return ListState<T>(
        status: status ?? this.status,
        data: data ?? this.data,
        error: error ?? this.error);
  }
}
