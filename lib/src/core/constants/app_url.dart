class AppUrl {
  static const BASE_URL = "https://places-2021-broadway.herokuapp.com/api";
  static const LOGIN_URL = "$BASE_URL/auth/login";
  static const PROFILE_URL = "$BASE_URL/users/me";
  static const REGISTER_URL = "$BASE_URL/auth/register";
  static const PLACES_LIST_URL = "$BASE_URL/places/all";
  static const FAVORITE_LIST_URL = "$BASE_URL/favorite";
  static const PLACES_URL = "$BASE_URL/places";
  static const IS_FAVORITE_URL = "$BASE_URL/favorite/isFavorite";

  static const UPDATE_NAME_URL = "$BASE_URL/auth/updateName";
  static const UPDATE_TOKEN_URL = "$BASE_URL/auth/updateToken";
  static const UPDATE_PASSWORD_URL = "$BASE_URL/auth/updatePassword";
  static const UPDATE_PROFILE_PIC_URL = "$BASE_URL/auth/updateProfilePic";
  static const UPDATE_COVER_PIC_URL = "$BASE_URL/auth/updateCoverPic";
}
