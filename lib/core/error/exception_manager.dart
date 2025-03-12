import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasks_admin/core/error/handlers/auth_exception_handler.dart';
import 'package:tasks_admin/core/error/handlers/firebase_exception_handler.dart';
import 'package:tasks_admin/core/error/handlers/unexpected_exception_handler.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

abstract class ExceptionHandler {
  String handle(Exception exception);
}

class ExceptionManager {
  static final Map<Type, ExceptionHandler> _handlers = <Type, ExceptionHandler>{
    FirebaseAuthException: FirebaseAuthExceptionHandler(),
    FirebaseException: FirebaseExceptionHandler(),
    UnexpectedExceptionHandler: UnexpectedExceptionHandler(),
  };

  static String getMessage(Exception exception) {
                return _handlers[exception.runtimeType]?.handle(exception) ??
        _handlers[UnexpectedExceptionHandler]!.handle(exception);
  }

  static void showMessage(Exception exception) {
    Fluttertoast.showToast(
      msg: getMessage(exception),
      backgroundColor: ColorManager.red,
    );
  }
}
