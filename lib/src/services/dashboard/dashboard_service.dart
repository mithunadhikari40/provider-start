import 'package:location/location.dart';
import 'package:places/src/services/auth_rx_provider.dart';

class DashboardService {
  final AuthRxProvider authRxProvider;

  DashboardService({required this.authRxProvider});

  void setLocation(LocationData locationData) {
    authRxProvider.addLocation(locationData);
  }
}
