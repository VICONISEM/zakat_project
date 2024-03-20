import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_zakat/business_logic/knowledge_base.dart';

import '../home/home_screen.dart';
class SecondScreen extends StatelessWidget {
  final double gold24Price;

  final double silverPrice;
  final double silverWeight;
  final double gold24Weight;
  final double gold22Weight;
  final double gold21Weight;
  final double gold18Weight;
  final String currency;

  SecondScreen({
    Key? key,
    required this.gold24Price,
    required this.gold24Weight,
    required this.gold22Weight,
    required this.gold21Weight,
    required this.gold18Weight,
    required this.silverWeight,
    required this.silverPrice,
    required this.currency,
  }) : super(key: key);

  final TextEditingController apartmentsController = TextEditingController();
  final TextEditingController investmentController = TextEditingController();
  final TextEditingController inventoryController = TextEditingController();
  final TextEditingController debtsController = TextEditingController();
  final TextEditingController cashController = TextEditingController();
  void _loadAndShowAd(BuildContext context) async {
    InterstitialAd? _interstitialAd;
    final AdRequest request = AdRequest();
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Replace with your actual ad unit ID
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              // Navigate or perform actions after the ad is dismissed
              _navigateAfterAd(context);
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('Ad failed to show: $error');
              ad.dispose();
              // Optionally, navigate or perform actions even if the ad fails to show
              _navigateAfterAd(context);
            },
          );
          _interstitialAd?.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad failed to load: $error');
          // Optionally, navigate or perform actions even if the ad fails to load
          _navigateAfterAd(context);
        },
      ),
    );
  }

  void _navigateAfterAd(BuildContext context) async {
    double apart = double.tryParse(apartmentsController.text) ?? 0.0;
    double invent = double.tryParse(inventoryController.text) ?? 0.0;
    double invest = double.tryParse(investmentController.text) ?? 0.0;
    double deb = double.tryParse(debtsController.text) ?? 0.0;
    double cash = double.tryParse(cashController.text) ?? 0.0;

    double zakatAmount = await calculateZakat(
        gold24Weight: gold24Weight,
        gold22Weight: gold22Weight,
        gold21Weight: gold21Weight,
        gold18Weight: gold18Weight,
        silverWeight: silverWeight,
        cash: cash,
        gold24Price: gold24Price,
        silverPrice: silverPrice,
        currency: currency,
        apartments: apart,
        inventory: invent,
        investments: invest,
        debts: deb,
        context: context
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Locales.string(context, 'zakat_amount')),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${Locales.string(context, 'your_zakat_amount_is')} ${zakatAmount.toStringAsFixed(2)} $currency'),
            SizedBox(height: 8.0),
            Text(Locales.string(context, 'this_amount')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text(Locales.string(context, 'ok')),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child : Container(
          height: MediaQuery.of(context).size.height, // Set height to screen height

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery
                .of(context)
                .size
                .height * 0.36),
            Text(
              Locales.string(context, 'enter_money_details'),
              style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: cashController,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'cash'),
                      labelStyle: TextStyle(color: Colors.black),
                      // Set label text color to white
                      // errorText: gold24ErrorText,
                      errorBorder: OutlineInputBorder( // Remove error border to eliminate the horizontal line
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      //prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    // Add logic to handle cash input
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: apartmentsController,
                    decoration: InputDecoration(
                        labelText: Locales.string(context, 'apartments'),
                      labelStyle: TextStyle(color: Colors.black),
                      // Set label text color to white
                      // errorText: gold24ErrorText,
                      errorBorder: OutlineInputBorder( // Remove error border to eliminate the horizontal line
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      //prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),),
                    keyboardType: TextInputType.number,
                    // Add logic to handle silver input
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: investmentController,
                    decoration: InputDecoration(
                        labelText: Locales.string(context, 'investment'),
                      labelStyle: TextStyle(color: Colors.black),
                      // Set label text color to white
                      // errorText: gold24ErrorText,
                      errorBorder: OutlineInputBorder( // Remove error border to eliminate the horizontal line
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      //prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),),
                    keyboardType: TextInputType.number,
                    // Add logic to handle investment input
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: inventoryController,
                    decoration: InputDecoration(
                        labelText: Locales.string(context, 'inventory'),
                      labelStyle: TextStyle(color: Colors.black),
                      // Set label text color to white
                      // errorText: gold24ErrorText,
                      errorBorder: OutlineInputBorder( // Remove error border to eliminate the horizontal line
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      //prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),),
                    keyboardType: TextInputType.number,
                    // Add logic to handle inventory input
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: debtsController,
                    decoration: InputDecoration(
                        labelText: Locales.string(context, 'Debts'),
                      labelStyle: TextStyle(color: Colors.black),
                      // Set label text color to white
                      // errorText: gold24ErrorText,
                      errorBorder: OutlineInputBorder( // Remove error border to eliminate the horizontal line
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      //prefixIcon: Icon(Icons.email, color: Colors.lightBlueAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),),
                    keyboardType: TextInputType.number,
                    // Add logic to handle debts input
                  ),
                ),

              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () => _loadAndShowAd(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Text(Locales.string(context, 'calculate'), style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
        ),
      ),
    );
  }
}
