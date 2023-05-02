import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client/common/index.dart';

import '../models/index.dart';

class GitService {
  BuildContext? context;
  late Options _options;

  GitService([this.context]) {
    _options = Options(extra: {
      "context": context,
    });
  }

  static Dio dio = Dio(
    BaseOptions(baseUrl: 'https://api.github.com/', headers: {
      Headers.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json",
    }),
  );

  static void init() {
    dio.interceptors.add(Global.netCache);
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    if (!Global.kReleaseMode) {
      // 如果是 debug 需要禁用抓包证书
    }
  }

  Future<User> login(String username, String pwd) async {
    String basic = 'Basic ${base64.encode(utf8.encode('$username:$pwd'))}';
    var res = await dio.get(
      "/user",
      options: _options.copyWith(headers: {
        HttpHeaders.authorizationHeader: basic,
      }, extra: {
        "noCache": true,
      }),
    );

    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    Global.netCache.cache.clear();
    Global.profile.token = basic;

    return User.fromJson(res.data);
  }

  Future<List<Repo>> getRepos({Map<String, dynamic>? query, refresh = true}) async {
    if (refresh) {
      _options.extra!.addAll({
        "refresh": true,
        "list": true,
      });
    }

    var res = await dio.get(
        "/user/repos",
        queryParameters: query ?? {},
        options: _options
    );

    return res.data!.map((item) => Repo.fromJson(item));
  }
}
