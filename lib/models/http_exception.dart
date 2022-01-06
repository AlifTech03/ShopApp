class HttpException implements Exception {
  String message;
  HttpException(this.message);

//   String toString() {
//     return message;
//   }
  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
