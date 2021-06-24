import 'package:flutter/cupertino.dart';
import 'package:places/src/api/auth_api.dart';
import 'package:places/src/services/auth/login_service.dart';
import 'package:places/src/services/auth_rx_provider.dart';
import 'package:places/src/services/dashboard/dashboard_service.dart';
import 'package:places/src/services/local/cache_provider.dart';
import 'package:places/src/services/local/db_provider.dart';
import 'package:provider/provider.dart';

final providers = [
  ...independentProviders,
  ...dependantProviders,
];

final independentProviders = [
  Provider.value(value: AuthApi()),
  Provider.value(value: DbProvider()),
  Provider.value(value: CacheProvider()),
  Provider.value(value: AuthRxProvider()),
];
final dependantProviders = [
  ProxyProvider4<AuthApi, DbProvider, CacheProvider, AuthRxProvider,
      LoginService>(
    update: (BuildContext context,
        AuthApi api,
        DbProvider dbProvider,
        CacheProvider cacheProvider,
        AuthRxProvider authRxProvider,
        LoginService? service) {
      return LoginService(
          api: api,
          authRxProvider: authRxProvider,
          cacheProvider: cacheProvider,
          dbProvider: dbProvider);
    },
  ),
  ProxyProvider<AuthApi, DashboardService>(
    update: (BuildContext context, AuthApi api, DashboardService? service) {
      return DashboardService(api: api);
    },
  ),
];
