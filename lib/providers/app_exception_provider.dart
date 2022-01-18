import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imagedeletor/model/app_exception_model.dart';
import 'package:imagedeletor/notifiers/app_state_notifier.dart';

final appExceptionProvider = StateProvider<AppExceptionModel>((ref) {
  return AppExceptionModel("");
});

final appMsgProvider = StateProvider<String>((ref) {
  return "";
});
