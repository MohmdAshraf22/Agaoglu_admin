import 'package:tasks_admin/core/error/exception_manager.dart';

class UnexpectedExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    return "Beklenmeyen bir hata oluştu";
  }
}
