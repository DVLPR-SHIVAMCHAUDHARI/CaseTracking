import 'package:casetracking/core/consts/globals.dart';
import 'package:casetracking/core/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class Repository {
  final String host =
      "https://logistics.unimeshserver.online/Inventory/api/v1/";
  late final Dio dio;

  Repository() {
    dio = Dio(
      BaseOptions(
        baseUrl: host,
        connectTimeout: kIsWeb ? null : const Duration(seconds: 15),
        receiveTimeout: kIsWeb ? null : const Duration(seconds: 15),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          logger.d("➡️ REQUEST: ${options.uri}");

          final token = TokenServices().accessToken;

          if (token != null && token.isNotEmpty) {
            options.headers["x-auth-token"] = token;
          }

          if (options.data != null) {
            logger.d("📦 PAYLOAD: ${options.data}");
          }

          return handler.next(options);
        },

        onResponse: (response, handler) {
          logger.d(
            "✅ RESPONSE: ${response.statusCode} ${response.realUri.path}",
          );
          logger.d(response.data);

          // Store token from header (if refreshed)
          final headerToken = response.headers.value('x-auth-token');
          if (headerToken != null && headerToken.isNotEmpty) {
            TokenServices().storeTokens(accessToken: headerToken);
            logger.d("🔑 Token updated from header");
          }

          // Store token from body (optional)
          final bodyToken =
              response.data?['Response']?['ResponseData']?['x_auth_token'];
          if (bodyToken != null && bodyToken.isNotEmpty) {
            TokenServices().storeTokens(accessToken: bodyToken);
            logger.d("🔑 Token updated from body");
          }

          return handler.next(response);
        },

        onError: (error, handler) {
          logger.e("❌ ERROR: ${error.requestOptions.uri}");
          logger.e("STATUS: ${error.response?.statusCode}");
          logger.e("MESSAGE: ${error.message}");

          if (error.response?.data != null) {
            logger.e("BODY: ${error.response?.data}");
          }

          return handler.next(error);
        },
      ),
    );
  }
}
