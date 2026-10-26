import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_log_plus/dio_log_plus.dart';
import 'package:path/path.dart' show basename;

class HttpUtil {
  HttpUtil._();

  /// 网络状态
  static bool isNoneNetwork = false;
  static bool isMobile = false;
  static bool isWifi = false;
  static Connectivity connectivity = Connectivity()
    ..checkConnectivity().then((value) {
      isNoneNetwork = value.contains(ConnectivityResult.none);
      isMobile = value.contains(ConnectivityResult.mobile);
      isWifi = value.contains(ConnectivityResult.wifi);
      connectivity.onConnectivityChanged.listen((event) {
        isNoneNetwork = event.contains(ConnectivityResult.none);
        isMobile = event.contains(ConnectivityResult.mobile);
        isWifi = event.contains(ConnectivityResult.wifi);
      });
    });

  /// 创建dio
  static Dio create([
    String baseUrl = '',

    /// 请求超时3s
    int timeout = 3,

    /// 忽略https证书
    bool sslIgnore = true,

    /// 调试日志开关
    bool logDebug = true,
  ]) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: timeout),
      receiveTimeout: Duration(seconds: timeout),
      headers: {'operatingSystem': Platform.operatingSystem},
    );
    Dio dio = Dio(options);
    if (sslIgnore) {
      final ad = dio.httpClientAdapter;
      if (ad is IOHttpClientAdapter) {
        ad.validateCertificate = (certificate, host, port) {
          // 忽略https证书
          // 也可以在此处验证证书/地址/端口
          return true;
        };
      }
    }
    if (logDebug) {
      dio.interceptors.add(DioLogInterceptor());
    }
    return dio;
  }

  /// 下载文件
  static Future<Response> downloadFile(
    String fullUrl,
    String savePath, {
    String method = 'GET',
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    ProgressCallback? onReceiveProgress,

    /// 请求超时3*60s
    int timeout = 3 * 60,

    /// 忽略https证书
    bool sslIgnore = true,
  }) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: timeout),
        receiveTimeout: Duration(seconds: timeout),
        sendTimeout: Duration(seconds: timeout),
      ),
    );

    if (sslIgnore) {
      final ad = dio.httpClientAdapter;
      if (ad is IOHttpClientAdapter) {
        ad.validateCertificate = (certificate, host, port) {
          // 忽略https证书
          // 也可以在此处验证证书/地址/端口
          return true;
        };
      }
    }

    final options = Options(method: method, headers: headers);
    Response response = await dio.download(
      fullUrl,
      savePath,
      data: data,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
    return response;
  }

  /// 上传文件
  static Future<Response> uploadFile(
    String fullUrl,
    List<String> localFilePaths, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,

    /// 请求超时3*60s
    int timeout = 3 * 60,

    /// 忽略https证书
    bool sslIgnore = true,
  }) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: timeout),
        receiveTimeout: Duration(seconds: timeout),
        sendTimeout: Duration(seconds: timeout),
      ),
    );

    if (sslIgnore) {
      final ad = dio.httpClientAdapter;
      if (ad is IOHttpClientAdapter) {
        ad.validateCertificate = (certificate, host, port) {
          // 忽略https证书
          // 也可以在此处验证证书/地址/端口
          return true;
        };
      }
    }

    final options = Options(headers: headers);

    final formData = FormData();
    for (var value in localFilePaths) {
      final multipartFile = MultipartFile.fromFileSync(
        value,
        filename: basename(value),
      );
      formData.files.add(MapEntry('files[]', multipartFile));
    }
    data = data ?? {};
    data.forEach((key, value) => formData.fields.add(MapEntry(key, '$value')));

    Response response = await dio.post(
      fullUrl,
      queryParameters: queryParameters,
      data: formData,
      onSendProgress: onSendProgress,
      options: options,
    );
    return response;
  }

  /// 整合请求
  static Future<Response<T>> request<T>(
    String fullUrl, {
    String method = 'GET',
    Map<String, dynamic>? headers,
    dynamic data,

    /// 请求超时3s
    int timeout = 3,

    /// 忽略https证书
    bool sslIgnore = true,

    /// 调试日志开关
    bool logDebug = true,
  }) async {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: timeout),
        receiveTimeout: Duration(seconds: timeout),
        sendTimeout: Duration(seconds: timeout),
      ),
    );
    if (sslIgnore) {
      final ad = dio.httpClientAdapter;
      if (ad is IOHttpClientAdapter) {
        ad.validateCertificate = (certificate, host, port) {
          // 忽略https证书
          // 也可以在此处验证证书/地址/端口
          return true;
        };
      }
    }
    if (logDebug) {
      dio.interceptors.add(DioLogInterceptor());
    }
    final options = Options(method: method, headers: headers);
    return await dio.request<T>(fullUrl, data: data, options: options);
  }
}
