import 'package:dbcrypt/dbcrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  String firstName;
  String lastName;
  String email;
  String? password;

  User({this.firstName = '', this.lastName = '', required this.email});

  setPassword(String newpassword) {
    password = DBCrypt().hashpw(newpassword, new DBCrypt().gensalt());
    print(password);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User fromJson(Map<String, dynamic> json) => User.fromJson(json);
}
