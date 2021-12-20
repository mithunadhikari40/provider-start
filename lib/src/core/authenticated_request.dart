import 'dart:convert';

import 'package:http/http.dart';
import 'package:places/src/core/locator/service_locator.dart';
import 'package:places/src/services/navigation_service.dart';

class _AuthenticatedRequest extends BaseClient {
  Map<String, String> _headers = {};
  static final Client _httpClient = Client();

  static final NavigationService _navigationService =
      locator<NavigationService>();

  _AuthenticatedRequest(Map<String, String> headers) {
    _headers = headers;
  }

  void setDefaultHeaders(Map<String, String>? headers) {
    _headers = {..._headers, ...?headers};
  }

  void clearHeaders() {
    _headers = {"Content-Type": "application/json"};
  }
  Map<String, String> _mergedHeaders(Map<String, String>? headers) =>
      {..._headers, ...?headers};

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request..headers.addAll(_headers);
    final response = await _httpClient.send(request);
    if(response.statusCode == 401){ /// Unauthorized...
      _navigationService.logout();
    }
    return response;
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _httpClient.patch(url, headers: _mergedHeaders(headers));
    if(response.statusCode == 401){ /// Unauthorized...
      _navigationService.logout();
    }
    return response;

  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _httpClient.get(url, headers: _mergedHeaders(headers));
    if(response.statusCode == 401){ /// Unauthorized...
      _navigationService.logout();
    }
    return response;

  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _httpClient.put(url, headers: _mergedHeaders(headers));
    if(response.statusCode == 401){ /// Unauthorized...
      _navigationService.logout();
    }
    return response;

  }

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _httpClient.post(url, headers: _mergedHeaders(headers),body: body);
    if(response.statusCode == 401){ /// Unauthorized...
      _navigationService.logout();
    }
    return response;
  }

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final response = await _httpClient.delete(url, headers: _mergedHeaders(headers),body: body);
    if(response.statusCode == 401){ /// Unauthorized...
      _navigationService.logout();
    }
    return response;

  }
}

final authenticatedRequest =
    _AuthenticatedRequest({"Content-Type": "application/json"});
