import 'package:hive_flutter/hive_flutter.dart';
part 'transaction.g.dart';
@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String imagePath;
    @HiveField(4)
  final String type;
   @HiveField(5)
  final String amount;

  Transaction({
    required this.id,
    required this.name,
    required this.date,
    required this.imagePath,
    required this.type,
    required this.amount
  });
}
