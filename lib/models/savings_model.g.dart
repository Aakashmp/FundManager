// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsModelAdapter extends TypeAdapter<SavingsModel> {
  @override
  final int typeId = 0;

  @override
  SavingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavingsModel(
      compABalance: fields[0] as double,
      compBBalance: fields[1] as double,
      withdrawals: (fields[2] as List).cast<WithdrawalModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SavingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.compABalance)
      ..writeByte(1)
      ..write(obj.compBBalance)
      ..writeByte(2)
      ..write(obj.withdrawals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WithdrawalModelAdapter extends TypeAdapter<WithdrawalModel> {
  @override
  final int typeId = 1;

  @override
  WithdrawalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WithdrawalModel(
      year: fields[0] as int,
      amount: fields[1] as double,
      withdrawn: fields[2] as double,
      title: fields[3] as String,
      fromCompA: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WithdrawalModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.withdrawn)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.fromCompA);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WithdrawalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
