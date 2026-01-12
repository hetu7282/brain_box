import 'package:brain_box/src/core/database/storage.dart';
import 'package:brain_box/src/core/utils/log.dart';
import 'package:dio/dio.dart';

class ApiInterceptors {
  InterceptorsWrapper get interceptorsWrapper {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        String token = Storage.instance.getToken() ?? '';
        Log.d(
          '-----------------------------------------------------------------------------------',
        );
        Log.d('URI:- ${options.uri.toString()}');
        Log.d('DATA:- ${options.data.toString()}');
        Log.d('TOKEN:- $token');
        Log.d(
          '-----------------------------------------------------------------------------------',
        );
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) async {
        if (response.statusCode == 403) {
          // BuildContext? context =
          //     AppRouterNavigationKey.navigatorKey.currentContext;
          // await context?.read<AuthProvider>().logout(context);
        }
        Log.d(
          '-----------------------------------------------------------------------------------',
        );
        Log.d('STATUS CODE:- ${response.statusCode}');
        Log.d('RESPONSE:- ${response.data}');
        Log.d(
          '-----------------------------------------------------------------------------------',
        );
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        Log.d(
          '-----------------------------------------------------------------------------------',
        );
        if (e.response?.statusCode == 403) {
          // BuildContext? context =
          // AppRouterNavigationKey.navigatorKey.currentContext;
          // await context?.read<AuthProvider>().logout(context);
        }
        Log.e('ERROR CODE:- ${e.response?.statusCode}');
        Log.e('RESPONSE:- ${e.response?.data}');
        Log.d(
          '-----------------------------------------------------------------------------------',
        );
        return handler.next(e);
      },
    );
  }
}
