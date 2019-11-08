class Error {
  final int code;
  final String message;

  Error({this.code, this.message});

  factory Error.from(int code) {
    switch (code) {
      case 400:
        return Error(
            code: code, message: '[400]: Request is incorrect.');
      case 401:
        return Error(
            code: code, message: '[401]: Unauthorized request. Unlogged!');
      case 403:
        return Error(
            code: code, message: '[403]: Request not allowed.');
      case 404:
        return Error(
            code: code, message: '[404]: Not found request.');
      case 410:
        return Error(
            code: code, message: '[410]: Lost access request.');
      case 501:
        return Error(
            code: code, message: '[501]: Unimplemented request.');
      case 503:
        return Error(
            code: code, message: '[503]: Unavailable service at the moment.');
      case 550:
        return Error(
            code: code, message: '[550]: Access denied.');
      default:
        return Error(
            code: code, message: '[$code]: Undefined error.');
    }
  }
}
