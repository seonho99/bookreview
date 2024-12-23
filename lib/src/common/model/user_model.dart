import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? name;
  final String? uid;
  final String? email;

  UserModel({this.name, this.uid, this.email});

  factory UserModel.fromJson(Map<String,dynamic> json) => _$UserModelFromJson(json);

  @override
  List<Object?> get props => [
    uid,name,email,
  ];
}