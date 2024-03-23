import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../business_logic/first_screen.dart'; // Import the GoldCashScreen

class GoldSilverEntryScreen extends StatefulWidget {
  @override
  _GoldSilverEntryScreenState createState() => _GoldSilverEntryScreenState();
}

class _GoldSilverEntryScreenState extends State<GoldSilverEntryScreen> {
  TextEditingController gold24Controller = TextEditingController();
  TextEditingController silverController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  String? gold24ErrorText;
  String? silverErrorText;
  String? currencyErrorText;
  String selectedCountry = 'Egypt';
  String selectedCurrency="EGP"; // Declare selectedCurrency variable
  late List<String> uniqueCurrencies; // Declare uniqueCurrencies as a class field

  Map<String, String> countryToCurrency = {
    'United Arab Emirates': 'AED',
    'Afghanistan': 'AFN',
    'Argentina': 'ARS',
    'Australia': 'AUD',
    'Bahrain': 'BHD',
    'Brazil': 'BRL',
    'Canada': 'CAD',
    'Switzerland': 'CHF',
    'Chile': 'CLP',
    'China': 'CNY',
    'Colombia': 'COP',
    'Egypt': 'EGP',
    'Euro': 'EUR',
    'United Kingdom': 'GBP',
    'Indonesia': 'IDR',
    'Israel': 'ILS',
    'India': 'INR',
    'Iran': 'IRR',
    'Jordan': 'JOD',
    'Japan': 'JPY',
    'South Korea': 'KRW',
    'Kuwait': 'KWD',
    'Lebanon': 'LBP',
    'Mexico': 'MXN',
    'Malaysia': 'MYR',
    'Nigeria': 'NGN',
    'New Zealand': 'NZD',
    'Oman': 'OMR',
    'Peru': 'PEN',
    'Philippines': 'PHP',
    'Pakistan': 'PKR',
    'Qatar': 'QAR',
    'Russia': 'RUB',
    'Saudi Arabia': 'SAR',
    'Singapore': 'SGD',
    'Syria': 'SYP',
    'Thailand': 'THB',
    'Turkey': 'TRY',
    'Taiwan': 'TWD',
    'United States': 'USD',
    'Vietnam': 'VND',
    'South Africa': 'ZAR',
    'Zambia': 'ZMW',
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, MediaQuery.of(context).padding.top + 260.0 , 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Locales.string(context, 'enter_gold_price'),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),

                Container(
                  child: TextFormField(
                    controller: gold24Controller,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'gold_24'),
                      labelStyle: TextStyle(color: Colors.black),
                      errorText: gold24ErrorText,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        gold24ErrorText = value.isEmpty
                            ? Locales.string(context, 'please_enter_gold_value')
                            : null;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.0),

                Container(
                  child: TextFormField(
                    controller: silverController,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'silver'),
                      labelStyle: TextStyle(color: Colors.black),
                      errorText: silverErrorText,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        silverErrorText = value.isEmpty
                            ? Locales.string(context, 'please_enter_silver_value')
                            : null;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.0),

                Container(
                  child: DropdownButtonFormField<String>(
                    value: selectedCountry,
                    items: countryToCurrency.keys.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? country) {
                      setState(() {
                        selectedCountry = country ?? '';
                        selectedCurrency = countryToCurrency[selectedCountry] ?? '';
                        currencyController.text=selectedCurrency;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Country',
                      labelStyle: TextStyle(color: Colors.black),
                      errorText: currencyErrorText,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 40.0),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (gold24Controller.text.isEmpty ||
                          silverController.text.isEmpty ||
                          currencyController.text.isEmpty) {
                        setState(() {
                          gold24ErrorText = gold24Controller.text.isEmpty
                              ? Locales.string(context, 'please_enter_gold_value')
                              : null;
                          silverErrorText = silverController.text.isEmpty
                              ? Locales.string(
                              context, 'please_enter_silver_value')
                              : null;
                          currencyErrorText = currencyController.text.isEmpty
                              ? Locales.string(context, 'please_enter_currency')
                              : null;
                        });
                      } else {
                        // Navigate to the GoldCashScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoldCashScreen(
                              gold24Price: double.tryParse(gold24Controller.text) ?? 0.0,
                              silverPrice: double.tryParse(silverController.text) ?? 0.0,
                              currency: currencyController.text,
                            ),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: Text(
                      Locales.string(context, 'next'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}