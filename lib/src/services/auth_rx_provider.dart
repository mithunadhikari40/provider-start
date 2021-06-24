import 'package:places/src/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class AuthRxProvider{
  final BehaviorSubject<UserModel> _userSubject= BehaviorSubject();
  final BehaviorSubject<String> _tokenSubject= BehaviorSubject();

  Function(UserModel user) get addUser => _userSubject.sink.add;
  Function(String token) get addToken => _tokenSubject.sink.add;

  UserModel? get getUser => _userSubject.hasValue ? _userSubject.value : null;
  String? get getToken => _tokenSubject.hasValue ? _tokenSubject.value : null;

  void dispose(){
    _userSubject.close();
    _tokenSubject.close();
  }

}