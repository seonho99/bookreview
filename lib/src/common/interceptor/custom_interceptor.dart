import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Naver-Client-id'] = 'GNH0rtgImmWCw2x2jkjM';
    options.headers['X-Naver-Client-Secret'] = 'x0D7zbBnTb';
    super.onRequest(options, handler);
  }
}