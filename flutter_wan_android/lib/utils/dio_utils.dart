
import 'package:dio/dio.dart';
import 'package:flutter_wan_android/constant/net_url_constant.dart';

class DioUtils{

  static Dio _dio;

  static getDioInstance(){
    if(_dio == null){
      Options options = Options();
      options.baseUrl = NetUrlConstant.baseUrl;
      options.connectTimeout = 3000;
      options.receiveTimeout = 3000;
      options.headers = {

      };
      _dio = Dio(options);
    }
    return _dio;
  }


}