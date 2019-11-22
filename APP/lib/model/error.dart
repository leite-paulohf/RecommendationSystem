class Error {
  final int code;
  final String message;

  Error({this.code, this.message});

  factory Error.from(int code) {
    var message = "Algo de inesperado aconteceu e isso foi notificado.";
    return Error(code: code, message: '[$code]: $message');
  }
}
