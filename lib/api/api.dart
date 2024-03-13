import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../business_logic/first_screen.dart';

class PricesDisplayPage extends StatefulWidget {
  @override
  _PricesDisplayPageState createState() => _PricesDisplayPageState();
}

class _PricesDisplayPageState extends State<PricesDisplayPage> {

  String? selectedCountry;
  final _formKey = GlobalKey<FormState>();
  late String _currencyController = '';
  late String _gold24Controller = '';
  late String _gold22Controller = '';
  late String _gold21Controller = '';
  late String _gold18Controller = '';
  late String _silverController = '';

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gold and Silver Prices'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('metalPrices').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<DropdownMenuItem<String>> countryItems = snapshot.data!.docs
                    .map( (doc) => DropdownMenuItem(
                  value: doc.id,
                  child: Text(doc.id),
                )
                ).toList();
                String? val = countryItems[0].value;
                selectedCountry = val;
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select a country'),
                  items: countryItems,
                  onChanged: (value) async {
                    final docSnapshot = await FirebaseFirestore.instance.collection('metalPrices').doc(value).get();
                    final data = docSnapshot.data()!;
                    setState(() {
                      selectedCountry = value;
                      _currencyController = data['currency'];
                      _gold24Controller = data['gold_24'];
                      _gold22Controller = data['gold_22'];
                      _gold21Controller = data['gold_21'];
                      _gold18Controller = data['gold_18'];
                      _silverController = data['silver'];
                    });
                  },
                  value: selectedCountry,
                );
              },
            ),
            PriceCard(
              title: 'Gold 24 carat Price Per Gram',
              price: _gold24Controller,
              currency: _currencyController,
              imagePath: 'assets/images/gold_logo.png',
            ),
            PriceCard(
              title: 'Gold 22 carat Price Per Gram',
              price: _gold22Controller,
              currency: _currencyController,
              imagePath: 'assets/images/gold_logo.png',
            ),
            PriceCard(
              title: 'Gold 21 carat Price Per Gram',
              price: _gold21Controller,
              currency: _currencyController,
              imagePath: 'assets/images/gold_logo.png',
            ),
            PriceCard(
              title: 'Gold 18 carat Price Per Gram',
              price: _gold18Controller,
              currency: _currencyController,
              imagePath: 'assets/images/gold_logo.png',
            ),
            PriceCard(
              title: 'Silver Price Per Gram',
              price: _silverController,
              currency: _currencyController,
              imagePath: 'assets/images/sliver_logo.png',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GoldCashScreen(
                      gold24Price: double.parse(_gold24Controller),
                      gold22Price: double.parse(_gold22Controller),
                      gold21Price: double.parse(_gold21Controller),
                      gold18Price: double.parse(_gold18Controller),
                      silverPrice: double.parse(_silverController),
                      currency: _currencyController,
                    ),
                  ),
                );
              },
              child: Text('Go to Calculator'),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final String title;
  final String price;
  final String currency;
  final String imagePath;

  const PriceCard({
    Key? key,
    required this.title,
    required this.price,
    required this.currency,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.asset(imagePath, width: 40),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("$price $currency", style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
      ),
    );
  }
}