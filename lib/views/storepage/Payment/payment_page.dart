import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nishanapos/views/storepage/Payment/Cash_Payment.dart';
import 'package:provider/provider.dart';

import '../../../Services/Providers/CartProviders/grandTotalProvider.dart';

class PaymentOptionsPopup extends StatelessWidget {
  final String restaurantTable;
  const PaymentOptionsPopup({Key? key, required this.restaurantTable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double grandTotal = Provider.of<GrandTotalProvider>(context).grandTotal;
    return AlertDialog(
      title: const Text('Select a payment option'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            buildOptionTile('Esewa', Icons.payment, onTap: () {
              Get.to(PaymentPage(
                totalAmount: grandTotal,
                paymentMethod: "Esewa",
              ));
            }),
            buildOptionTile('Khalti', Icons.payment, onTap: () {
              Get.to(PaymentPage(
                totalAmount: grandTotal,
                paymentMethod: "Khalti",
              ));
            }),
            buildOptionTile('Cash', Icons.money, onTap: () {
              Get.to(PaymentPage(
                totalAmount: grandTotal,
                paymentMethod: "Cash",
              ));
            }),
            buildOptionTile('Credit Card', Icons.credit_card, onTap: () {
              Get.to(PaymentPage(
                totalAmount: grandTotal,
                paymentMethod: "Credit Card",
              ));
            }),
            buildOptionTile('Bank Transfer', Icons.account_balance, onTap: () {
              Get.to(PaymentPage(
                totalAmount: grandTotal,
                paymentMethod: "Bank Transfer",
              ));
            }),
          ],
        ),
      ),
    );
  }

  Widget buildOptionTile(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(title[0]),
      ),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
