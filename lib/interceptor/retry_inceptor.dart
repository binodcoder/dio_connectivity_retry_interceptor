import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_connectivity_retry_inerceptor/interceptor/dio_connectivity_request_retrier.dart';
import 'package:flutter/material.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({@required this.requestRetrier});
  @override
  Future onError(DioError err) async {
    if (_shouldRetry(err)) {
      try {
        return requestRetrier.scheduleRequestRetry(err.request);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.DEFAULT && err.error != null && err.error is SocketException;
  }
}
