import 'package:dio/dio.dart';

class CacheObject {
  late num timestamp;
  Response response;

  CacheObject(this.response) {
    timestamp = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  bool operator == (other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}