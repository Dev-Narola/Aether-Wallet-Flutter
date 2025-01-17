import 'package:aether_wallet/client/rest_client.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  var reports = <Report>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  var currenMonthIncome;
  var currenMonthExpanse;

  final RestClient restClient;

  ReportController(this.restClient);

  Future<void> getReports(String token) async {
    try {
      isLoading(true);
      final response = await restClient.getReports(token);

      if (response.reports.isNotEmpty) {
        reports.assignAll(response.reports);
      } else {
        errorMessage('No reports found');
      }
    } catch (e) {
      errorMessage('Error fetching reports: $e');
    } finally {
      isLoading(false);
    }
  }

  void calculateMonthlyTotals(String month, List<Report> reports) {
    double totalExpenses = 0.0;
    double totalIncome = 0.0;
    for (var report in reports) {
      String reportDate = report.date;
      String reportMonth = reportDate.split('/')[1];
      if (reportMonth == month) {
        if (report.reportType == "Expense") {
          totalExpenses += report.amount;
        } else if (report.reportType == "Income") {
          totalIncome += report.amount;
        }
      }
    }
    currenMonthExpanse = totalExpenses;
    currenMonthIncome = totalIncome;
  }
}
