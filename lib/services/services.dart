import 'package:alfred_tutorial_1/services/users_service.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:get_it/get_it.dart';

const _JWTSECRET = 'QDSFQ%\$WBTVQWEVTQ\$ TvqweRQWRQWEFQWCFQW RQ';

class Services {
  UsersService users = UsersService();
  final jwtSigner = JWTHmacSha256Signer(_JWTSECRET);
}

Services get services => GetIt.instance.get<Services>();
