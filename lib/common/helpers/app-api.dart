import 'dart:io';
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/services/local-storage.service.dart';
import 'package:dio/dio.dart';

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
      }, onError: (DioError e, ErrorInterceptorHandler handler) {
        print('app-api dioerror: $e');
        print(e.response?.data);
        // if (e.response?.data != null) {
        //   return e.response?.data['error'];
        // }
        // return e.response;
        return handler.next(e);
      }, onResponse:
          (Response<dynamic> res, ResponseInterceptorHandler handler) {
        res.data = res.data['data'];
        return handler.next(res);
      }),
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
