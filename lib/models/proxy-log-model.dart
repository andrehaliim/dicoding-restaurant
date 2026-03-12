class ProxyLogModel {
  final String url;
  final Map<String, dynamic>? params;
  final int? statusCode;
  final String? response;
  final DateTime time;

  ProxyLogModel({required this.url, this.params, this.statusCode, this.response, required this.time});

  @override
  String toString() {
    return '''
========== API LOG ==========
Time        : $time
URL         : $url
Params      : $params
Status Code : $statusCode
Response    : $response
=============================
''';
  }
}
