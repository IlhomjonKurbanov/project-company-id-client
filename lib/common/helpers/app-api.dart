// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/services/local-storage.service.dart';

AppApi api = AppApi(localStorageService);

class AppApi {
  AppApi(this.localStorageService) {
    dio.interceptors.addAll(<Interceptor>[
      InterceptorsWrapper(onRequest: (RequestOptions requestOptions,
          RequestInterceptorHandler handler) async {
        dio.interceptors.requestLock.lock();
        final String? token = await localStorageService.getTokenKey();
        if (token != null && token.isNotEmpty) {
          requestOptions.headers[HttpHeaders.authorizationHeader] =
              'Bearer $token';
        }
        dio.interceptors.requestLock.unlock();
        return handler.next(requestOptions);
      })
    ]);
  }

  final LocalStorageService localStorageService;
  final Dio dio = Dio(BaseOptions(
    connectTimeout: 10000,
    baseUrl: AppConstants.baseUrl,
    responseType: ResponseType.json,
    contentType: ContentType.json.toString(),
  ));
}
