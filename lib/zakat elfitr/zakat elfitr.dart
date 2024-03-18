import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../home/home_screen.dart'; // Make sure this path is correct for your project structure.

class ZakatElfitrPage extends StatefulWidget {
  @override
  _ZakatElfitrPageState createState() => _ZakatElfitrPageState();
}

class _ZakatElfitrPageState extends State<ZakatElfitrPage> {
  final TextEditingController _familyMembersController = TextEditingController();
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    _initInterstitialAd();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Use test ad unit ID for development
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerAdReady = true),
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Use test ad unit ID for development
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _setInterstitialAdListener();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _setInterstitialAdListener() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Ad showed.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('Ad dismissed.');
        ad.dispose();
        _initInterstitialAd(); // Load a new ad for the next time
        // Calculate and show the zakat amount after the ad is dismissed
        int numberOfFamilyMembers = int.tryParse(_familyMembersController.text) ?? 0;
        double zakatAmount = numberOfFamilyMembers * 2.75;
        _showZakatDialog(context, numberOfFamilyMembers, zakatAmount);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('Ad failed to show.');
        ad.dispose();
        // Directly show the zakat dialog if the ad fails to show
        int numberOfFamilyMembers = int.tryParse(_familyMembersController.text) ?? 0;
        double zakatAmount = numberOfFamilyMembers * 2.75;
        _showZakatDialog(context, numberOfFamilyMembers, zakatAmount);
      },
    );
  }

  void _calculateZakat(BuildContext context) {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      // If the ad isn't ready, calculate and show the dialog immediately.
      int numberOfFamilyMembers = int.tryParse(_familyMembersController.text) ?? 0;
      double zakatAmount = numberOfFamilyMembers * 2.75;
      _showZakatDialog(context, numberOfFamilyMembers, zakatAmount);
    }
  }

  void _showZakatDialog(BuildContext context, int numberOfFamilyMembers, double zakatAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Locales.string(context, 'elfitr_amount')),
          content: Text('''
${Locales.string(context, 'the_zakat_amount')} $numberOfFamilyMembers 
${Locales.string(context, 'family_members_is')} $zakatAmount ${Locales.string(context, 'kg')}.'''),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Locales.string(context, 'ok')),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

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
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.34),
                LocaleText('zakat_elftr', style: TextStyle(fontSize: 20, color: Colors.black)),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LocaleText('zakat_elfitr_explaination', style: TextStyle(fontSize: 13, color: Colors.black)),
                ),
                SizedBox(height: 26.0),
                LocaleText('number_of_family', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _familyMembersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: Locales.string(context, 'number_of_family'),
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () => _calculateZakat(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: LocaleText('calculate', style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
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
