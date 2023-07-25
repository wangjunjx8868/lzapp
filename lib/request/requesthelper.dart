import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lanzhong/request/token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'config.dart';
import 'exception.dart';

class RequestHelper{
  late Dio _dio;
  RequestHelper() {
    _dio = Dio(
        BaseOptions(baseUrl: RequestConfig.baseUrl, connectTimeout: Duration(seconds: RequestConfig.connectTimeout)));
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
  }

  Future<String?> request(
      String url, {
        String method = "Get",
        Map<String, dynamic>? queryParameters,
        data,
        Map<String, dynamic>? headers,
        bool Function(ApiException)? onError
      }) async {
    try {
      Options options = Options()
        ..method = method
        ..headers = headers;
      data = _convertRequestData(data);
      Response response = await _dio.request(url, queryParameters: queryParameters, data: data, options: options);
      return response.data.toString();
    } catch (e) {
      var exception = ApiException.from(e);
      if(onError?.call(exception) != true){
        throw exception;
      }
    }
    return null;
  }

  _convertRequestData(data) {
    if (data != null) {
      data = jsonDecode(jsonEncode(data));
    }
    return data;
  }

  Future<String?> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
        bool showLoading = true,
        bool Function(ApiException)? onError
      }) {
    return request(url,
        queryParameters: queryParameters,
        headers: headers,
        onError: onError);
  }

  Future<String?> post(
      String url, {
        Map<String, dynamic>? queryParameters,
        data,
        Map<String, dynamic>? headers,
        bool showLoading = true,
        bool Function(ApiException)? onError,
      }) {
    return request(url,
        method: "POST",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        onError: onError);
  }
}