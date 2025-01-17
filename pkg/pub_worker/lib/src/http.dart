import 'dart:async' show FutureOr;
import 'package:http/http.dart' as http;

/// Returns an [http.Client] which sends a `Bearer` token as `Authorization`
/// header for each request.
extension WithAuthorization on http.Client {
  http.Client withAuthorization(
    FutureOr<String?> Function() tokenProvider, {
    bool closeParent = false,
  }) =>
      _AuthenticatedClient(
        tokenProvider,
        this,
        closeParent,
      );
}

/// An [http.Client] which sends a `Bearer` token as `Authorization` header for
/// each request.
class _AuthenticatedClient extends http.BaseClient {
  final FutureOr<String?> Function() _tokenProvider;
  final http.Client _client;
  final bool _closeInnerClient;

  _AuthenticatedClient(
    this._tokenProvider,
    this._client,
    this._closeInnerClient,
  );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await _tokenProvider();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return await _client.send(request);
  }

  @override
  void close() {
    if (_closeInnerClient) {
      _client.close();
    }
    super.close();
  }
}
