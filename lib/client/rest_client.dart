// ignore_for_file: depend_on_referenced_packages

import 'package:aether_wallet/models/add_contect_request.dart';
import 'package:aether_wallet/models/add_report_request.dart';
import 'package:aether_wallet/models/balance_model.dart';
import 'package:aether_wallet/models/categories_response.dart';
import 'package:aether_wallet/models/category_request.dart';
import 'package:aether_wallet/models/common_response.dart';
import 'package:aether_wallet/models/contact_response.dart';
import 'package:aether_wallet/models/get_all_contacts.dart';
import 'package:aether_wallet/models/get_all_report.dart';
import 'package:aether_wallet/models/signin_request.dart';
import 'package:aether_wallet/models/signin_response.dart';
import 'package:aether_wallet/models/transaction_request.dart';
import 'package:aether_wallet/models/transactions_response.dart';
import 'package:aether_wallet/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/signup_request.dart';
import '../models/api_response.dart';

part 'rest_client.g.dart';

const String baseUrl = "http://192.168.94.199:5000/";

// dart pub run build_runner build

@RestApi(baseUrl: baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("auth/register")
  Future<ApiResponse> signup(@Body() SignupRequest signupRequest);

  @POST("balance/balance")
  Future<CommonResponse> addbalance(
    @Header("Authorization") String token,
    @Body() BalanceModel balanceRequest,
  );

  @PUT("balance/balance")
  Future<CommonResponse> updatebalance(
    @Header("Authorization") String token,
    @Body() Map<String, double> body,
  );

  @POST("auth/login")
  Future<SigninResponse> signin(
    @Header("Authorization") String token,
    @Body() SigninRequest signinRequest,
  );

  @GET("auth/profile")
  Future<UserModel> getUser(@Header("Authorization") String token);

  @POST("auth/logout")
  Future<CommonResponse> logout(@Header("Authorization") String token);

  @DELETE("auth/delete_account")
  Future<CommonResponse> deleteAccount(@Header("Authorization") String token);

  @GET("balance/balance")
  Future<BalanceModel> getBalance(@Header("Authorization") String token);

  @POST("category/category")
  Future<CommonResponse> addcategory(
    @Header("Authorization") String token,
    @Body() CategoryRequest categoryRequest,
  );

  @GET("category/category")
  Future<CategoriesResponse> getCategories(
    @Header("Authorization") String token,
  );

  @DELETE("category/category")
  Future<CommonResponse> deleteCategory(
    @Header("Authorization") String token,
    @Body() Map<String, String> body,
  );

  @POST("report/report")
  Future<CommonResponse> addReport(
    @Header("Authorization") String token,
    @Body() AddReportRequest addReport,
  );

  @GET("report/reports")
  Future<ReportsResponse> getReports(@Header("Authorization") String token);

  @GET("contact/contacts")
  Future<GetAllContacts> getAllContacts(@Header("Authorization") String token);

  @POST("contact/contact")
  Future<CommonResponse> addContect(
    @Header("Authorization") String token,
    @Body() AddContectRequest contectRequest,
  );

  @POST("lending/lending-transactions")
  Future<TransactionsResponse> getTransactions(
    @Header("Authorization") String token,
    @Header("Contact-ID") String contactId,
  );

  @POST("lending/lending")
  Future<CommonResponse> addTransaction(
    @Header("Authorization") String token,
    @Body() TransectionsRequest transactionRequest,
  );

  @GET("contact/contact")
  Future<ContectResponse> getContact(
    @Header("Authorization") String token,
    @Header("Contact-ID") String contactId,
  );

  @DELETE("contact/contact/{contact_id}")
  Future<CommonResponse> deleteContact(
    @Header("Authorization") String token,
    @Path("contact_id") String contactId,
  );
}
