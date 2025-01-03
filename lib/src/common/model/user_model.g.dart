// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'] as String?,
      uid: json['uid'] as String?,
      email: json['email'] as String?,
      profile: json['profile'] as String?,
      discription: json['discription'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'email': instance.email,
      'profile': instance.profile,
      'discription': instance.discription,
    };
