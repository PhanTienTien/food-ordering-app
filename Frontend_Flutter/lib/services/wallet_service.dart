import 'package:dio/dio.dart';
import '../utils/error_utils.dart';
import '../models/wallet.dart';
import 'dio_client.dart';

class WalletService {
  final Dio _dio = DioClient().dio;

  Future<Wallet> getWalletByUser(int userId) async {
    try {
      final response = await _dio.get('/wallets/user/$userId');
      return Wallet.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Wallet> createWallet(int userId) async {
    try {
      final response = await _dio.post('/wallets/user/$userId');
      return Wallet.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Wallet> addBalance(
    int userId,
    double amount,
    String description,
  ) async {
    try {
      final response = await _dio.post(
        '/wallets/user/$userId/deposit',
        queryParameters: {'amount': amount, 'description': description},
      );
      return Wallet.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Wallet> addPoints(int userId, int points) async {
    try {
      final response = await _dio.post(
        '/wallets/user/$userId/points/add',
        queryParameters: {'points': points},
      );
      return Wallet.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<Wallet> redeemPoints(int userId, int points) async {
    try {
      final response = await _dio.post(
        '/wallets/user/$userId/points/redeem',
        queryParameters: {'points': points},
      );
      return Wallet.fromJson(response.data);
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }

  Future<List<WalletTransaction>> getTransactionHistory(int userId) async {
    try {
      final response = await _dio.get('/wallets/user/$userId/transactions');
      return (response.data as List)
          .map((json) => WalletTransaction.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ErrorUtils.message(e);
    }
  }
}
