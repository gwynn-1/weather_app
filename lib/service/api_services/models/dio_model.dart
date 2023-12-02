import 'package:freezed_annotation/freezed_annotation.dart';
part 'dio_model.freezed.dart';

@freezed
class DioResponse with _$DioResponse {
  const factory DioResponse.success(Map<String, dynamic> data) = SUCCESS;
  const factory DioResponse.error(Map<String, dynamic> data) = ERROR;
  const factory DioResponse.loading(String message) = LOADING;
}
