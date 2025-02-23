import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';

class FirebaseExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    if (exception is FirebaseException) {
      switch (exception.code) {
        case 'cancelled':
          return 'İşlem iptal edildi';
        case 'unknown':
          return 'Bilinmeyen bir hata oluştu';
        case 'invalid-argument':
          return 'Geçersiz argüman sağlandı';
        case 'deadline-exceeded':
          return 'İstek zaman aşımına uğradı';
        case 'not-found':
          return 'İstenen belge bulunamadı';
        case 'already-exists':
          return 'Belge zaten mevcut';
        case 'permission-denied':
          return 'İzin reddedildi';
        case 'resource-exhausted':
          return 'Kaynak sınırı aşıldı';
        case 'failed-precondition':
          return 'Ön koşul başarısız oldu';
        case 'aborted':
          return 'İşlem iptal edildi';
        case 'out-of-range':
          return 'Değer aralık dışında';
        case 'unimplemented':
          return 'İşlem uygulanmamış';
        case 'internal':
          return 'İç hata oluştu';
        case 'unavailable':
          return 'Hizmet kullanılamıyor';
        case 'data-loss':
          return 'Veri kaybı oluştu';
        case 'unauthenticated':
          return 'Kimlik doğrulama gerekli';
        default:
          return 'Bilinmeyen bir Firebase hatası: ${exception.message}';
      }
    }
    return 'Firebase hatası oluştu';
  }
}

