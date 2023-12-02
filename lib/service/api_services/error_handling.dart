import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Error ! Connection has been canceled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Error ! Connection timed out";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Error ! Connection timed out";
        break;
      case DioExceptionType.sendTimeout:
        message = "Error ! Connection timed out";
        break;
      case DioExceptionType.unknown:
        if (dioError.error.toString().contains("SocketException")) {
          message = "Error ! Cannot establish connection";
          break;
        }
        message = "Error ! Unknow error has appeared";
        break;
      default:
        message = "Error ! No connection";
        break;
    }
  }

  @override
  String toString() => message;
}
