// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/client/injection_container.dart';
import 'package:aether_wallet/common/loading_screen.dart';
import 'package:aether_wallet/common/reusable_text.dart';
import 'package:aether_wallet/constant/constant.dart';
import 'package:aether_wallet/models/get_all_contacts.dart';
import 'package:aether_wallet/models/transaction_request.dart';
import 'package:aether_wallet/models/transactions_response.dart';
import 'package:aether_wallet/view/add_exppanse/widget/special_textfield.dart';
import 'package:aether_wallet/view/contact/widget/contact_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:background_sms/background_sms.dart';
import 'package:intl/intl.dart';

class UserContectScreen extends StatefulWidget {
  final Contact contact;
  const UserContectScreen({super.key, required this.contact});

  @override
  State<UserContectScreen> createState() => _UserContectScreenState();
}

class _UserContectScreenState extends State<UserContectScreen> {
  bool isLoading = false;

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Transaction> transactionList = [];

  Future<void> fetchLendingTransections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String finalToken = "Bearer $token";

    setState(() {
      isLoading = true;
    });
    restClient.getTransactions(finalToken, widget.contact.id).then((response) {
      setState(() {
        transactionList = response.transactions;
        isLoading = false;
      });
    });
  }

  void sendNotification() async {
    if (widget.contact.amount > 0) {
      SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: widget.contact.mobileNo,
          message:
              "Hi ${widget.contact.name}, just to keep you informed, I owe you ₹${widget.contact.amount}. I’ll make sure to clear it soon. Thanks for your patience!"); // levana

      if (result == SmsStatus.sent) {
        debugPrint("=================> SMS Sent successfully");
      } else {
        debugPrint("=================> Failed");
      }
    } else {
      SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: widget.contact.mobileNo,
          message:
              "Hi ${widget.contact.name}, the balance between us is now cleared. Thank you for your cooperation. Let’s stay connected!"); // devana

      if (result == SmsStatus.sent) {
        debugPrint("=================> SMS Sent successfully");
      } else {
        debugPrint("=================> Failed");
      }
    }
  }

  String getTime(String createdAt) {
    try {
      DateTime dateTime =
          DateFormat("EEE, dd MMM yyyy HH:mm:ss zzz").parse(createdAt);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLendingTransections();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in transactionList) {
      try {
        DateTime createdAt = DateFormat("EEE, dd MMM yyyy HH:mm:ss zzz")
            .parse(transaction.createdAt);
        String formattedDate = DateFormat('dd MMM yyyy').format(createdAt);

        if (!groupedTransactions.containsKey(formattedDate)) {
          groupedTransactions[formattedDate] = [];
        }
        groupedTransactions[formattedDate]?.add(transaction);
      } catch (e) {
        debugPrint("Error parsing date: $e");
      }
    }
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60.h),
        child: AppBar(
          backgroundColor: appBar,
          leadingWidth: 76.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: GestureDetector(
              onTap: () {
                Get.to(ContactDetailScreen(contact: widget.contact));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150.r),
                  border: Border.all(
                    width: 1.3,
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.contact.userImage),
                    radius: 27.r,
                    backgroundColor: headingText,
                  ),
                ),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              Get.to(ContactDetailScreen(contact: widget.contact));
            },
            child: ReusableText(
              text: widget.contact.name,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              letterSpace: 1.3,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 22.0.w),
              child: ReusableText(
                text: widget.contact.amount.toString(),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: widget.contact.amount >= 0 ? success : error,
              ),
            )
          ],
        ),
      ),
      body: isLoading
          ? LoadingScreen()
          : SizedBox.expand(
              child: Stack(
                children: [
                  transactionList.isEmpty
                      ? Center(
                          child: ReusableText(
                            text: "No Transactions are available",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            letterSpace: 1.4,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: SizedBox(
                            height: 550.h,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 14.w),
                              itemCount: groupedTransactions.keys.length,
                              itemBuilder: (context, index) {
                                String date =
                                    groupedTransactions.keys.elementAt(index);
                                List<Transaction> transactionsForDate =
                                    groupedTransactions[date]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Date Separator
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 12.w),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: ReusableText(
                                            text: date,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            letterSpace: 1.2,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // List of Transactions
                                    ListView.builder(
                                      shrinkWrap:
                                          true, // Makes the ListView only as big as its children
                                      physics:
                                          NeverScrollableScrollPhysics(), // Disables inner scrolling
                                      itemCount: transactionsForDate.length,
                                      itemBuilder: (context, transactionIndex) {
                                        final transaction = transactionsForDate[
                                            transactionIndex];
                                        bool isReceived =
                                            transaction.type == 'received';

                                        return Align(
                                          alignment: isReceived
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6.h),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                                horizontal: 12.w),
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isReceived ? success : error,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12.r),
                                                topRight: Radius.circular(12.r),
                                                bottomLeft: isReceived
                                                    ? Radius.circular(0)
                                                    : Radius.circular(12.r),
                                                bottomRight: isReceived
                                                    ? Radius.circular(12.r)
                                                    : Radius.circular(0),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Transaction Amount
                                                ReusableText(
                                                  text:
                                                      '₹${transaction.amount}',
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: headingText,
                                                ),
                                                SizedBox(height: 4.h),
                                                // Transaction Time
                                                ReusableText(
                                                  text: getTime(
                                                      transaction.createdAt),
                                                  fontSize: 12.sp,
                                                  color: Colors.grey.shade800,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: lightBackground,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22.r),
                            topRight: Radius.circular(22.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            color: lightBackground,
                            child: GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: ReusableText(
                                        text: "Add Transaction",
                                        fontSize: 18.sp,
                                        color: headingText,
                                        fontWeight: FontWeight.bold,
                                        letterSpace: 1.3,
                                      ),
                                    ),
                                    backgroundColor: lightBackground,
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReusableText(
                                          text: "Amount",
                                          fontSize: 16.sp,
                                          letterSpace: 1.2,
                                        ),
                                        SpecialTextfield(
                                          text: "Amount",
                                          Icondata: LineIcons.moneyBill,
                                          controller: amountController,
                                        ),
                                        SizedBox(height: 10.h),
                                        ReusableText(
                                          text: "Description",
                                          fontSize: 16.sp,
                                          letterSpace: 1.2,
                                        ),
                                        SpecialTextfield(
                                          text: "Description",
                                          Icondata: LineIcons.moneyBill,
                                          controller: descriptionController,
                                        ),
                                        SizedBox(height: 20.h),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: ReusableText(
                                          text: "Cancle",
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            double amount = double.parse(
                                                amountController.text);

                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? token =
                                                prefs.getString('token');
                                            String finalToken = "Bearer $token";

                                            setState(() {
                                              isLoading = true;
                                            });

                                            TransectionsRequest
                                                transectionsRequest =
                                                TransectionsRequest(
                                              contactId: widget.contact.id,
                                              amount: amount,
                                              type: "received",
                                              description:
                                                  descriptionController.text,
                                            );

                                            try {
                                              await restClient.addTransaction(
                                                  finalToken,
                                                  transectionsRequest);

                                              // Fetch the updated transactions from the backend
                                              await fetchLendingTransections();
                                              setState(() {
                                                // Update the contact's amount
                                                widget.contact.amount -= amount;
                                                sendNotification();
                                                // Clear input fields
                                                amountController.clear();
                                                descriptionController.clear();

                                                // Stop loading
                                                isLoading = false;
                                              });

                                              // Close the dialog
                                              Get.back();
                                            } catch (errorr) {
                                              setState(() {
                                                isLoading = false;
                                              });

                                              String errorMessage =
                                                  "Something went wrong. Please try again.";
                                              if (errorr is DioException &&
                                                  errorr.response?.data !=
                                                      null) {
                                                errorMessage = errorr.response
                                                        ?.data['message'] ??
                                                    errorMessage;
                                              }
                                              debugPrint(
                                                  'Error: $errorMessage');
                                              Get.snackbar(
                                                "Error",
                                                errorMessage,
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                backgroundColor: error,
                                                colorText: headingText,
                                              );
                                            }
                                          },
                                          child: ReusableText(
                                            text: "Save",
                                            fontSize: 17.sp,
                                            color: primaryButton,
                                          ))
                                    ],
                                  );
                                },
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      color: primaryButton,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          LineIcons.arrowUp,
                                          color: headingText,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        ReusableText(
                                          text: "Received",
                                          fontSize: 18.sp,
                                          color: headingText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: lightBackground,
                            child: GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: ReusableText(
                                        text: "Add Transaction",
                                        fontSize: 18.sp,
                                        color: headingText,
                                        fontWeight: FontWeight.bold,
                                        letterSpace: 1.3,
                                      ),
                                    ),
                                    backgroundColor: lightBackground,
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReusableText(
                                          text: "Amount",
                                          fontSize: 16.sp,
                                          letterSpace: 1.2,
                                        ),
                                        SpecialTextfield(
                                          text: "Amount",
                                          Icondata: LineIcons.moneyBill,
                                          controller: amountController,
                                        ),
                                        SizedBox(height: 10.h),
                                        ReusableText(
                                          text: "Description",
                                          fontSize: 16.sp,
                                          letterSpace: 1.2,
                                        ),
                                        SpecialTextfield(
                                          text: "Description",
                                          Icondata: LineIcons.moneyBill,
                                          controller: descriptionController,
                                        ),
                                        SizedBox(height: 20.h),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: ReusableText(
                                          text: "Cancle",
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            double amount = double.parse(
                                                amountController.text);

                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            String? token =
                                                prefs.getString('token');
                                            String finalToken = "Bearer $token";

                                            setState(() {
                                              isLoading = true;
                                            });

                                            TransectionsRequest
                                                transectionsRequest =
                                                TransectionsRequest(
                                              contactId: widget.contact.id,
                                              amount: amount,
                                              type: "given",
                                              description:
                                                  descriptionController.text,
                                            );

                                            try {
                                              await restClient.addTransaction(
                                                  finalToken,
                                                  transectionsRequest);

                                              // Fetch the updated transactions from the backend
                                              await fetchLendingTransections();
                                              setState(() {
                                                // Update the contact's amount
                                                widget.contact.amount += amount;
                                                sendNotification();
                                                // Clear input fields
                                                amountController.clear();
                                                descriptionController.clear();

                                                // Stop loading
                                                isLoading = false;
                                              });

                                              // Close the dialog
                                              Get.back();
                                            } catch (errorr) {
                                              setState(() {
                                                isLoading = false;
                                              });

                                              String errorrMessage =
                                                  "Something went wrong. Please try again.";
                                              if (errorr is DioException &&
                                                  errorr.response?.data !=
                                                      null) {
                                                errorrMessage = errorr.response
                                                        ?.data['message'] ??
                                                    errorrMessage;
                                              }
                                              debugPrint(
                                                  'Errorr: $errorrMessage');
                                              Get.snackbar(
                                                "Errorr",
                                                errorrMessage,
                                                snackPosition:
                                                    SnackPosition.TOP,
                                                backgroundColor: error,
                                                colorText: headingText,
                                              );
                                            }
                                          },
                                          child: ReusableText(
                                            text: "Save",
                                            fontSize: 17.sp,
                                            color: primaryButton,
                                          ))
                                    ],
                                  );
                                },
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      color: error,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          LineIcons.arrowDown,
                                          color: headingText,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        ReusableText(
                                          text: "Given",
                                          fontSize: 18.sp,
                                          color: headingText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
