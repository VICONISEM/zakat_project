import 'package:flutter/material.dart';
import 'package:my_zakat/database_utils.dart';
import 'package:my_zakat/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../provider/my_user.dart';
import '../provider/user_provider.dart';

Future<List<double>> calculateZakat({
  required double gold24Weight,
  required double gold22Weight,
  required double gold21Weight,
  required double gold18Weight,
  required double silverWeight,
  required double cash,
  required double gold24Price,
  required double silverPrice,
  required double apartments,
  required double investments,
  required double inventory,
  required double debts,
  required String currency,
  required BuildContext context,
  // Add other necessary parameters
}) async {
  // Add your Zakat calculation logic here
  // For example:
  double goldZakat = 0.0;
  double silverZakat = 0.0;
  double cashZakat = 0.0;
  double zakatAmount = 0.0;
  double totalGolds24Weight = ((gold24Weight * 24.0) +
      (gold21Weight * 21.0) +
      (gold22Weight * 22.0) +
      (gold18Weight * 18.0)) / 24.0;
  double silverToGold24 = (silverWeight * silverPrice) / gold24Price;
  double cashToGold24 = (cash + apartments + inventory + investments)/gold24Price;
  double totalGold24Weight = totalGolds24Weight + silverToGold24 + cashToGold24;
  double totalAfterDebts = totalGold24Weight - (debts/gold24Price);

  if(totalAfterDebts >= 85.0){
    zakatAmount = totalAfterDebts * gold24Price * 0.025;
  }

  if(totalGolds24Weight != 0){
    totalGolds24Weight -= (debts/gold24Price);
  }
  else if(silverWeight != 0){
    silverWeight -= (debts/silverPrice);
  }
  else{
    cashToGold24 -= (debts/gold24Price);
  }

  if(totalGolds24Weight >= 85){
    goldZakat = totalGolds24Weight * gold24Price * 0.025;
  }
  if(silverWeight >= 595){
    silverZakat = silverWeight * silverPrice * 0.025;
  }
  if(cashToGold24 >= 85){
    cashZakat = cashToGold24 * gold24Price * 0.025;
  }

  // Update total_zakat
  MyUser? currentUser = Provider.of<UserProvider>(context, listen: false).user;
  if (currentUser != null) {
    double updatedTotalZakat = zakatAmount;
    currentUser.total_zakat = updatedTotalZakat;
    currentUser.last_time = DateTime.now();
    await DataBaseUtils.updateUser(currentUser);
    Provider.of<UserProvider>(context, listen: false).user = currentUser;

  }

  return [zakatAmount,goldZakat,silverZakat,cashZakat];
}