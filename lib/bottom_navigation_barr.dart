// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/loading_screen.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/controller/report_controller.dart';
import 'package:aether_wallet/models/categories_response.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:aether_wallet/view/about/settings.dart';
import 'package:aether_wallet/view/add_exppanse/add_expanse.dart';
import 'package:aether_wallet/view/contact/contact_screen.dart';
import 'package:aether_wallet/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationBarr extends StatefulWidget {
  const BottomNavigationBarr({super.key});

  @override
  State<BottomNavigationBarr> createState() => _BottomNavigationBarrState();
}

class _BottomNavigationBarrState extends State<BottomNavigationBarr> {
  // bool isLoading = true;
  // int _selectedIndex = 0;
  // Map<String, dynamic>? userData;
  // double? userBalance;
  // List<Category>? categories;
  // late ReportController reportController;
  // List<Report> reports = [];

  // double currentMonthExpanse = 0;
  // double currentMonthIncome = 0;

  // Future<void> fetchUserData() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString("token");
  //     if (token != null) {
  //       String finalToken = "Bearer $token";
  //       var response = await restClient.getUser(finalToken);
  //       setState(() {
  //         userData = response.toJson();
  //         isLoading = false;
  //       });
  //     } else {
  //       debugPrint("Token not found");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching user data: $e");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> fetchBalance() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString("token");
  //     if (token != null) {
  //       String finalToken = "Bearer $token";
  //       var response = await restClient.getBalance(finalToken);
  //       setState(() {
  //         userBalance = response.balance;
  //         isLoading = false;
  //       });
  //     } else {
  //       debugPrint("Token not found");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching balance: $e");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> fetchCategories() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString("token");
  //     if (token != null) {
  //       String finalToken = "Bearer $token";
  //       restClient.getCategories(finalToken).then((response) {
  //         setState(() {
  //           categories = response.categories;
  //           isLoading = false;
  //         });
  //       });
  //     } else {
  //       debugPrint("Token not found");
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching categories: $e");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> fetchReports() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString("token");

  //   if (token != null) {
  //     await reportController.getReports("Bearer $token");
  //     setState(() {
  //       reports = reportController.reports;
  //       reportController.calculateMonthlyTotals(
  //           DateTime.now().month.toString(), reports);
  //       currentMonthExpanse = reportController.currenMonthExpanse;
  //       currentMonthIncome = reportController.currenMonthIncome;
  //     });
  //   } else {
  //     debugPrint("Token not found");
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   reportController = Get.put(ReportController(restClient));
  //   fetchUserData();
  //   fetchBalance();
  //   fetchCategories();
  //   fetchReports();
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isLoading = true;
  int _selectedIndex = 0;
  Map<String, dynamic>? userData;
  double? userBalance;
  List<Category> categories = [];
  List<Report> reports = [];

  double currentMonthExpanse = 0;
  double currentMonthIncome = 0;
  late ReportController reportController;

  Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        debugPrint("Token not found");
        return;
      }

      String finalToken = "Bearer $token";

      // ✅ Await each API call
      var userResponse = await restClient.getUser(finalToken);
      var balanceResponse = await restClient.getBalance(finalToken);
      var categoryResponse = await restClient.getCategories(finalToken);
      await reportController.getReports(finalToken);

      setState(() {
        userData = userResponse.toJson(); // ✅ Now safe to call toJson()
        userBalance = balanceResponse.balance;
        categories = categoryResponse.categories;
        reports = reportController.reports.reversed.toList();

        reportController.calculateMonthlyTotals(
          DateTime.now().month.toString(),
          reports,
        );
        currentMonthExpanse = reportController.currenMonthExpanse;
        currentMonthIncome = reportController.currenMonthIncome;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    reportController = Get.put(ReportController(restClient));
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: LoadingScreen());
    }

    if (userData == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Failed to load user data",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    final List<Widget> widgetOptions = [
      HomeScreen(
        userData: userData!,
        userBalance: userBalance,
        reports: reports.reversed.toList(),
        expanse: currentMonthExpanse,
        income: currentMonthIncome,
        categories: categories,
      ),
      const Text('Analytics Page'),
      const Text('Search Page'),
      ContactScreen(),
      About(userData: userData!),
    ];

    return Scaffold(
        body: Center(child: widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: bottomNavBar, // Dark teal background
          ),
          child: BottomNavigationBar(
            backgroundColor: bottomNavBar, // Dark teal background
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: inactiveNavItem, // Muted teal for inactive
            selectedItemColor: primaryButton, // Bright teal for active
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(LineIcons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(LineIcons.barChartAlt),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    Get.to(() => AddExpanse(
                          categoryList: categories,
                          currentBalance: userBalance,
                        ));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Color(0xFF14B8B8), // Bright teal for the plus button
                    ),
                    padding: const EdgeInsets.all(15),
                    child: const Icon(LineIcons.plus,
                        color: Colors.white, size: 30),
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(LineIcons.userCog),
                label: 'Contact',
              ),
              const BottomNavigationBarItem(
                icon: Icon(LineIcons.cog),
                label: 'Settings',
              ),
            ],
            iconSize: 25,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
