
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    ///todo get token from cache
    // Obtain shared preferences.
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String? tokenSTR = prefs.getString('token');
    if(tokenSTR!=null&&tokenSTR.isNotEmpty)
    {
      options.headers["Authorization"] = "Bearer $tokenSTR";
    }

    // options.headers["response-status"] = 401;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(dio.Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }
}