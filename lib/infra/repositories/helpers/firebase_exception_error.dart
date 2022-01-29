enum FirebaseExceptionError {
  notFound,
  wrongPassword,
}

extension FirebaseExceptionErrorExtension on FirebaseExceptionError {
  String get toCode {
    switch (this) {
      case FirebaseExceptionError.notFound:
        return 'user-not-found';
      case FirebaseExceptionError.wrongPassword:
        return 'wrong-password';
      default:
        return '';
    }
  }
}
