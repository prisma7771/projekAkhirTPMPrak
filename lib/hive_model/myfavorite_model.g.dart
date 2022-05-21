// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myfavorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyFavoriteAdapter extends TypeAdapter<MyFavorite> {
  @override
  final int typeId = 1;

  @override
  MyFavorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyFavorite(
      name: fields[0] as String?,
      nameMeal: fields[1] as String?,
      idMeal: fields[3] as String?,
      imageMeal: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MyFavorite obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.nameMeal)
      ..writeByte(2)
      ..write(obj.imageMeal)
      ..writeByte(3)
      ..write(obj.idMeal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyFavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAccountModelAdapter extends TypeAdapter<UserAccountModel> {
  @override
  final int typeId = 2;

  @override
  UserAccountModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAccountModel(
      username: fields[0] as String,
      password: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserAccountModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccountModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
