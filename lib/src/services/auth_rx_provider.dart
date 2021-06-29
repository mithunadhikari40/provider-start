import 'package:location/location.dart';
import 'package:places/src/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class AuthRxProvider{
  final BehaviorSubject<UserModel> _userSubject= BehaviorSubject();
  final BehaviorSubject<String> _tokenSubject= BehaviorSubject();
  final BehaviorSubject<LocationData> _locationSubject = BehaviorSubject();

  Function(UserModel user) get addUser => _userSubject.sink.add;
  Function(String token) get addToken => _tokenSubject.sink.add;
  Function(LocationData location) get addLocation => _locationSubject.sink.add;

  UserModel? get getUser => _userSubject.hasValue ? _userSubject.value : null;
  String? get getToken => _tokenSubject.hasValue ? _tokenSubject.value : null;
  LocationData? get getLocation => _locationSubject.hasValue ? _locationSubject.value : null;

  void dispose(){
    _userSubject.close();
    _tokenSubject.close();
    _locationSubject.close();
  }

}