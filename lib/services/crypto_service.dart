import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto.dart';

class CryptoService {
  static const String _url = 'https://api.coinlore.net/api/tickers/';

  Future<List<Crypto>> fetchCryptos([String query = '']) async {
    final url = query.isEmpty ? _url : '$_url?search=$query';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((crypto) => Crypto.fromJson(crypto)).toList();
    } else {
      throw Exception('Failed to load cryptos');
    }
  }
}
