import 'package:freezed_annotation/freezed_annotation.dart';

part 'dio_error_model.freezed.dart';
part 'dio_error_model.g.dart';

@freezed
class Errors with _$Errors {
  const factory Errors({
    bool? status,
    int? code,
    String? errorCode,
    Message? message,
  }) = _Errors;

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    List<String>? video,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
