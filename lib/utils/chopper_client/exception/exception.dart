class PathNotFoundException implements Exception {
  final String message;
  PathNotFoundException([this.message = '']);
}

class JsonFactoryNotFoundException implements Exception {
  final String message;
  JsonFactoryNotFoundException([this.message = '']);
}
