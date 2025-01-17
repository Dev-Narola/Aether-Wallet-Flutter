import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'rest_client.dart';

final RestClient restClient = RestClient(getDio(), baseUrl: baseUrl);

Dio getDio() {
  BaseOptions options = BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    contentType: 'application/json',
  );

  Dio dio = Dio(options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint('REQUEST [${options.method}] => PATH: ${options.path}');
        debugPrint('Request Body: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint(
          'RESPONSE [${response.statusCode}] => DATA: ${response.data}',
        );
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        final response = error.response;
        debugPrint(
          'ERROR [${response?.statusCode}] => MESSAGE: ${response?.statusMessage}, DATA: ${response?.data}, ERROR: ${error.message}',
        );
        return handler.next(error);
      },
    ),
  );

  return dio;
}
