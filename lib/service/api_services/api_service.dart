import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/service/api_services/error_handling.dart';
import 'package:weather_app/utils/app_dialog.dart';
import 'package:weather_app/utils/url_constants.dart';

import 'models/dio_model.dart';

enum RequestType { get, post, postvideo, put, patch, delete }

class ApiService {
  final dio = createDio();

  ApiService._internal();

  static final _singleton = ApiService._internal();

  factory ApiService() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: UrlConstants.baseUrl,
      receiveTimeout: const Duration(minutes: 15),
      connectTimeout: const Duration(minutes: 15),
      sendTimeout: const Duration(minutes: 15),
      followRedirects: false,
      validateStatus: (status) => true,
      contentType: 'application/json',
    ));

    dio.interceptors.addAll({
      Logging(dio),
    });

    return dio;
  }

  Future<DioResponse?> apiCall(String url,
      {Map<String, dynamic>? queryParameters,
      var body,
      RequestType requestType = RequestType.get,
      Function(int count, int total)? onSendProgress}) async {
    try {
      final Map<String, String> header = {};

      late Response? result;
      switch (requestType) {
        case RequestType.get:
          {
            Options options = Options(headers: header);
            queryParameters?.addAll({
              "APPID":UrlConstants.apiKey
            });
            result = await dio.get(url,
                queryParameters: queryParameters, options: options);
            break;
          }
        case RequestType.post:
          {
            Options options = Options(
              headers: header,
            );
            result = await dio.post(url,
                data: body, options: options, queryParameters: queryParameters);
            break;
          }
        case RequestType.delete:
          {
            Options options = Options(headers: header);
            result =
                await dio.delete(url, data: queryParameters, options: options);
            break;
          }
        case RequestType.put:
          Options options = Options(headers: header);
          result = await dio.put(url, data: body, options: options);
          break;
        case RequestType.patch:
          break;
        case RequestType.postvideo:
          Options options = Options(headers: header);
          result = await dio.post(url,
              data: body, options: options, onSendProgress: onSendProgress);
          break;
      }
      if (result?.statusCode == 500 || result?.data == null) {
        return DioResponse.error({
          "error_code": result!.statusCode,
          "message": result.statusMessage
        });
      }
      if (result?.statusCode == 504 || result?.data == null) {
        return DioResponse.error({
          "error_code": result!.statusCode,
          "message": "サーバの負荷が高すぎて接続できなくなっている可能性があります。しばらくしてから再度試してください。"
        });
      }
      if (result != null && result.statusCode == 200) {
        return DioResponse.success(result.data);
      } else {
        return DioResponse.error(result?.data);
      }
    } on DioException catch (e) {
      if (e.response == null) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return DioResponse.error({
          "content": errorMessage,
        });
      }
      return DioResponse.error({
        "content": e.message,
        "error_code": e.response?.statusCode,
        "message": e.response?.statusMessage
      });
    } on Exception {
      return const DioResponse.error({"message": "Exception"});
    }
  }

  static Future showDialogError(data, {Function()? onTap}) async {
    String msg = " ";
    if (data != null) {
      String temp = errCodeToMessage(data["error_code"].toString());
      if (temp.isNotEmpty) {
        msg = temp;
      } else {
        if (data["message"] != null) {
          if (data["message"] is String) {
            msg += data["message"].toString();
          } else {
            String message = data["message"]
                .keys
                .map((key) => data["message"][key][0] ?? data["message"][key])
                .join('\n');
            msg += message;
          }
        }
        // if (data["loginId"] != null) {
        //   msg += "\n ${data["loginId"]}";
        // }
        // if (data["id"] != null) {
        //   msg += "\n ${data["id"].toString()}";
        // }
        // if (data["error_code"] != null) {
        //   msg += "\n ${data["error_code"].toString()}";
        // }
        if (data["content"] != null) {
          msg += "\n ${data["content"].toString()}";
        }
      }
    }
    await AppDialog.show(msg: msg, onTap: onTap);
  }

  static errCodeToMessage(var code) {
    if (code == null) return "";
    switch (code.toString()) {
      case "0":
        return "";
      case "AccessTokenExpired":
        return "ログインタイムアウトが起りました。再度ログインしなおしてください。";
      case "NotAuthorized":
        return "Not Authorized";
      default:
        return '';
    }
  }
}

class ErrorInterceptors extends InterceptorsWrapper {
  final Dio dio;

  ErrorInterceptors(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}

class Logging extends Interceptor {
  final Dio dio;
  Logging(this.dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    debugPrint('*** API Request - Start ***');
    debugPrint('URI: ${options.uri}');
    debugPrint('METHOD ${options.method}');
    debugPrint('HEADERS:');
    options.headers.forEach((key, v) => debugPrint(
          ' - $key : $v',
        ));
    debugPrint('BODY:');
    debugPrint(options.data.toString());

    debugPrint('*** API Request - End ***');

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    debugPrint(
        '''RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}''');

    debugPrint('*** Api Response - Start ***');
    debugPrint('URI ${response.requestOptions.uri}');
    debugPrint('STATUS CODE ${response.statusCode!}');
    debugPrint('REDIRECT ${response.isRedirect}');
    debugPrint('BODY:');
    debugPrint(response.data.toString());
    debugPrint('*** Api Response - End ***');

    if (response.statusCode == 401 &&
        response.data["error_code"] != "RefreshTokenExpired") {
      // If a 401 response is received, refresh the access token
      // String? newToken;
      // final newAccessToken = await refreshToken();
      // await newAccessToken!.when(
      //     success: (data) async {
      //       if (data["status"] == true && data["data"] != null) {
      //         await SecureStorage()
      //             .writeStorage(SecureStorage.token, data["data"]["token"]);
      //         await SecureStorage().writeStorage(
      //             SecureStorage.refreshToken, data["data"]["refreshToken"]);
      //         newToken = data["data"]["token"];
      //       }
      //     },
      //     error: (e) {
      //       ApiService.showDialogError(e, onTap: () async {
      //         rootNavigatorKey.currentContext
      //             ?.pushReplacementNamed(RouteConstants.login);
      //       });
      //       throw Exception();
      //     },
      //     loading: (_) {});
      // response.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      // return handler.resolve(await dio.fetch(response.requestOptions));
    }
    return handler.next(response);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    debugPrint('*** Api Error - Start ***:');

    debugPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      debugPrint('STATUS CODE: ${err.response!.statusCode?.toString()}');
    }
    debugPrint('$err');
    if (err.response != null) {
      debugPrint('REDIRECT: ${err.response!.realUri}');
      debugPrint('BODY: ${err.requestOptions.data}');
      debugPrint(err.response?.toString());
    }

    debugPrint('*** Api Error - End ***');
    if (err.response?.statusCode == 401 &&
        err.response?.data["error_code"] != "RefreshTokenExpired") {
      // If a 401 response is received, refresh the access token
      // String? newToken;
      // final newAccessToken = await refreshToken();
      // await newAccessToken!.when(
      //     success: (data) async {
      //       if (data["status"] == true && data["data"] != null) {
      //         await SecureStorage()
      //             .writeStorage(SecureStorage.token, data["data"]["token"]);
      //         await SecureStorage().writeStorage(
      //             SecureStorage.refreshToken, data["data"]["refreshToken"]);
      //         newToken = data["data"]["token"];
      //       }
      //     },
      //     error: (e) {
      //       ApiService.showDialogError(e, onTap: () async {
      //         rootNavigatorKey.currentContext
      //             ?.pushReplacementNamed(RouteConstants.login);
      //       });
      //       throw Exception();
      //     },
      //     loading: (_) {});
      // err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      return handler.resolve(await dio.fetch(err.requestOptions));
    }
    return handler.next(err);
  }
}
