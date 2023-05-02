import 'package:dio/dio.dart';

import 'cache_object.dart';

class NetCache extends Interceptor {
  var cache = <String, CacheObject>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }
}