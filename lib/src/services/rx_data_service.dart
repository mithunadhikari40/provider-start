import 'package:location/location.dart';
import 'package:places/src/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class RxDataService {
  final BehaviorSubject<UserModel> _userSubject = BehaviorSubject();
  final BehaviorSubject<LocationData> _locationSubject = BehaviorSubject();
  final BehaviorSubject<String> _tokenSubject = BehaviorSubject();
  final BehaviorSubject<bool> _themeSubject = BehaviorSubject();

  // getters to add data
  Function(UserModel user) get addUser => _userSubject.sink.add;
  Function(LocationData loc) get addLocation => _locationSubject.sink.add;
  Function(String token) get addToken => _tokenSubject.sink.add;
  Function(bool theme) get addTheme => _themeSubject.sink.add;
  // getters for stream
  Stream<UserModel> get userStream => _userSubject.stream;
  Stream<LocationData> get userLocation => _locationSubject.stream;
  Stream<String> get tokenStream => _tokenSubject.stream;
  Stream<bool> get themeStream => _themeSubject.stream;

  // getters to get the current value( last added value)
  UserModel? get currentUser =>
      !_userSubject.hasValue ? null : _userSubject.value;
  LocationData? get currentLocation =>
      !_locationSubject.hasValue ? null : _locationSubject.value;
  String? get currentToken =>
      !_tokenSubject.hasValue ? null : _tokenSubject.value;
  bool? get currentTheme =>
      !_themeSubject.hasValue ? null : _themeSubject.value;

  void close() {
    _userSubject.close();
    _locationSubject.close();
    _tokenSubject.close();
    _themeSubject.close();
  }

  void clear() {
    _userSubject.drain();
    _locationSubject.drain();
    _tokenSubject.drain();
    _themeSubject.drain();
  }
}
