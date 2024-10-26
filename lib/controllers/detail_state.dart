import 'package:flutter/material.dart';
import 'package:ess_iris/services/response/error.dart';

enum DetailStateStatus {
  initial,
  loading,
  success,
  failure,
}

@immutable
class DetailState<T> {
  final DetailStateStatus status;
  final T? data;
  final ErrorResponse? error;

  const DetailState(
      {this.status = DetailStateStatus.initial, this.data, this.error});

  DetailState<T> copyWith({
    DetailStateStatus? status,
    T? data,
    ErrorResponse? error,
  }) {
    return DetailState<T>(
        status: status ?? this.status,
        data: data ?? this.data,
        error: error ?? this.error);
  }
}
