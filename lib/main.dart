import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/crypto_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CryptoProvider(),
      child: MaterialApp(
        title: 'Crypto Prices',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CryptoListScreen(),
      ),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoProvider>(context, listen: false).fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Prices'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search Cryptos...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    cryptoProvider.fetchCryptos(_controller.text);
                  },
                ),
              ),
              onSubmitted: (query) {
                cryptoProvider.fetchCryptos(query);
              },
            ),
          ),
        ),
      ),
      body: cryptoProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => cryptoProvider.fetchCryptos(_controller.text),
              child: ListView.builder(
                itemCount: cryptoProvider.cryptos.length,
                itemBuilder: (context, index) {
                  final crypto = cryptoProvider.cryptos[index];
                  return ListTile(
                    title: Text(crypto.name),
                    subtitle: Text(crypto.symbol),
                    trailing: Text('\$${crypto.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
    );
  }
}
