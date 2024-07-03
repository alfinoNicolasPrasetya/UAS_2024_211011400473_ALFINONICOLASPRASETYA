import 'package:flutter/material.dart';
import '../models/crypto.dart';
import '../services/crypto_service.dart';

class CryptoProvider with ChangeNotifier {
  List<Crypto> _cryptos = [];
  bool _isLoading = false;

  List<Crypto> get cryptos => _cryptos;
  bool get isLoading => _isLoading;

  Future<void> fetchCryptos([String query = '']) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cryptos = await CryptoService().fetchCryptos(query);
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }
}
