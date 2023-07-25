import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lanzhong/request/token_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../model/api_response/api_response_entity.dart';
import '../model/api_response/raw_data.dart';
import 'config.dart';
import 'exception.dart';



class RequestClient {
  late Dio _dio;

  RequestClient() {
    _dio = Dio(
        BaseOptions(baseUrl: RequestConfig.baseUrl, connectTimeout: Duration(seconds: RequestConfig.connectTimeout)));
    _dio.interceptors.add(TokenInterceptor());
    _dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseHeader: true));
  }

  Future<T?> request<T>(
    String url, {
    String method = "Get",
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers, Function(ApiResponse<T>)? onSuccess,
    bool Function(ApiException)? onError
  }) async {
    try {
      Options options = Options()
        ..method = method
        ..headers = headers;

      data = _convertRequestData(data);

      Response response = await _dio.request(url, queryParameters: queryParameters, data: data, options: options);
      return _handleResponse<T>(response, onSuccess);
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

  Future<T?> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool Function(ApiException)? onError,
        Function(ApiResponse<T>)? onSuccess,
  }) {
    return request(url,
        queryParameters: queryParameters,
        headers: headers,
        onError: onError, onSuccess: onSuccess);
  }

  Future<T?> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers,
    bool showLoading = true,
    bool Function(ApiException)? onError,
        Function(ApiResponse<T>)? onSuccess,
  }) {
    return request(url,
        method: "POST",
        queryParameters: queryParameters,
        data: data,
        headers: headers,
        onError: onError,
        onSuccess: onSuccess);
  }


  ///请求响应内容处理
  T? _handleResponse<T>(Response response, Function(ApiResponse<T>)? onSuccess) {
    if (response.statusCode == 200) {
      if(T.toString() == (RawData).toString()){
        RawData raw = RawData();
        raw.value = response.data;
        return raw as T;
      }else {
        ApiResponse<T> apiResponse = ApiResponse<T>.fromJson(response.data);
        onSuccess?.call(apiResponse);
        return _handleBusinessResponse<T>(apiResponse);
      }
    } else {
      var exception = ApiException(response.statusCode, ApiException.unknownException);
      throw exception;
    }
  }

  ///业务内容处理
  T? _handleBusinessResponse<T>(ApiResponse<T> response) {
    // if (response.code == RequestConfig.successCode) {
    //   return response.data;
    // } else {
    //   var exception = ApiException(response.code, response.message);
    //   throw exception;
    // }
   return  response.data;
  }
}
