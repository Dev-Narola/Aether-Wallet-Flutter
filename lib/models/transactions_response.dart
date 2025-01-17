import 'package:json_annotation/json_annotation.dart';
part 'transactions_response.g.dart';

@JsonSerializable()
class TransactionsResponse {
  @JsonKey(name: "transactions")
  List<Transaction> transactions;

  TransactionsResponse({
    required this.transactions,
  });

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsResponseToJson(this);
}

@JsonSerializable()
class Transaction {
  @JsonKey(name: "amount")
  double amount;
  @JsonKey(name: "created_at")
  String createdAt;
  @JsonKey(name: "date")
  String date;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "type")
  String type;

  Transaction({
    required this.amount,
    required this.createdAt,
    required this.date,
    required this.description,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
