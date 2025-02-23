import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';

class FirebaseAuthExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'invalid-custom-token':
          return 'Geçersiz özel belirteç';
        case 'custom-token-mismatch':
          return 'Özel belirteç uyuşmuyor';
        case 'invalid-credential':
          return 'Geçersiz kimlik bilgisi';
        case 'user-disabled':
          return 'Kullanıcı devre dışı bırakıldı';
        case 'user-not-found':
          return 'Kullanıcı bulunamadı';
        case 'wrong-password':
          return 'Yanlış şifre';
        case 'email-already-in-use':
          return 'E-posta zaten kullanımda';
        case 'invalid-email':
          return 'Geçersiz e-posta adresi';
        case 'operation-not-allowed':
          return 'İşlem izin verilmiyor';
        case 'weak-password':
          return 'Şifre çok zayıf';
        case 'expired-action-code':
          return 'İşlem kodunun süresi doldu';
        case 'invalid-action-code':
          return 'Geçersiz işlem kodu';
        case 'missing-email':
          return 'E-posta eksik';
        case 'missing-password':
          return 'Şifre eksik';
        case 'account-exists-with-different-credential':
          return 'Farklı bir kimlik bilgisi ile hesap mevcut';
        case 'invalid-verification-code':
          return 'Geçersiz doğrulama kodu';
        case 'invalid-verification-id':
          return 'Geçersiz doğrulama kimliği';
        default:
          return 'Bilinmeyen bir kimlik doğrulama hatası: ${exception.message}';
      }
    }
    return 'Kimlik doğrulama hatası oluştu';
  }
}