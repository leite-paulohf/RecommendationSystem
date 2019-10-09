class Error {
  final int code;
  final String message;

  Error({this.code, this.message});

  factory Error.from(int code) {
    switch (code) {
      case 400:
        return Error(
            code: code, message: '[400]: Solicitação está incorreta.');
      case 401:
        return Error(
            code: code, message: '[401]: Solicitação não autorizada.');
      case 403:
        return Error(
            code: code, message: '[403]: Solicitação não permitida.');
      case 404:
        return Error(
            code: code, message: '[404]: Solicitação não encontrada.');
      case 410:
        return Error(
            code: code, message: '[410]: Solicitação de acesso perdida.');
      case 501:
        return Error(
            code: code, message: '[501]: Solicitação não implementada.');
      case 503:
        return Error(
            code: code, message: '[503]: Serviço indisponível no momento.');
      case 550:
        return Error(
            code: code, message: '[550]: Permissão de acesso negada.');
      default:
        return Error(
            code: code, message: '[$code]: Um erro não mapeado ocorreu.');
    }
  }
}
