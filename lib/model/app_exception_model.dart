class AppExceptionModel implements Exception {
  const AppExceptionModel(this.error);

  final String error;

//   @override
//   String toString() {
//     return '''
// App Error: $error
//     ''';
//   }
}

class AppMessages {
  final String msg;

  AppMessages(this.msg);
}
