// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceController {
  double currentBalance;
  double reportAmount;
  String type;
  BalanceController(this.currentBalance, this.reportAmount, this.type);

  Future<void> updatebalance() async {
    if (type == "Expense") {
      currentBalance = currentBalance - reportAmount;
    } else if (type == "Income") {
      currentBalance = currentBalance + reportAmount;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String finalToken = "Bearer $token";

    restClient.updatebalance(finalToken, {
      "balance": currentBalance,
    }).then((response) {
      debugPrint(
          "update balance response ----------------------> ${response.message}");
    });
  }
}
