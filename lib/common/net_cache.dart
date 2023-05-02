import 'package:dio/dio.dart';
import 'package:github_client/common/global.dart';

import 'cache_object.dart';

class NetCache extends Interceptor {
  var cache = <String, CacheObject>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 如果么有开启缓存
    if (!Global.profile.cache!.enable) {
      return handler.next(options);
    }

    // 启动缓存策略
    bool refresh = options.extra["refresh"] == true;

    if (refresh) {
      if (options.extra["list"] == true) {
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
        cache.remove(options.uri.toString());
      }

      return handler.next(options);
    }

    bool noCache = options.extra["noCache"];

    // 只缓存 get 请求
    if (noCache != true && options.method.toLowerCase() == "get") {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      var cacheValue = cache[key];

      if (null != cacheValue && checkCacheAlive(cacheValue)) {
        return handler.resolve(cacheValue.response);
      } else if (null != cacheValue && !checkCacheAlive(cacheValue!)) {
        cache.remove(key);
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Global.profile.cache!.enable) {
      _saveCache(response);
    }

    handler.next(response);
  }

  _saveCache(Response response) {
    RequestOptions options = response.requestOptions;

    if (options.extra["noCache"] != true && isGet(options)) {
      // 超过最大，要剔除第一个缓存数据
      if (cache.length == Global.profile.cache!.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }

      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(response);
    }
  }

  isGet(RequestOptions options) {
    return options.method.toLowerCase() == "get";
  }

  checkCacheAlive(CacheObject cacheValue) {
    num maxAge = (DateTime.now().millisecondsSinceEpoch -
            (cacheValue.timestamp ?? 3600)) /
        1000;
    return maxAge < Global.profile.cache!.maxAge;
  }
}
