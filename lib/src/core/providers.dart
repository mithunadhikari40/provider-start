import 'package:flutter/cupertino.dart';
import 'package:places/src/api/auth_api.dart';
import 'package:places/src/services/auth/login_service.dart';
import 'package:provider/provider.dart';

final providers = [
  ...independentProviders,
  ...dependantProviders,
];

final independentProviders = [
  Provider.value(
    value: AuthApi(),
  ),
];
final dependantProviders = [
  ProxyProvider<AuthApi,LoginService>(
    update: (BuildContext context,AuthApi api,LoginService? service){
      return LoginService();
    },
  ),
];