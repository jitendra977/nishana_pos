import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String paymentMethod;

  const PaymentPage(
      {Key? key, required this.totalAmount, required this.paymentMethod})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _paymentMethodController = TextEditingController();
  TextEditingController _paidAmountController = TextEditingController();
  TextEditingController _discountController = TextEditingController();

  double _paidAmount = 0.0;
  double _discount = 0.0;
  double _returnAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _totalAmountController.text = widget.totalAmount.toString();
    _paymentMethodController.text = widget.paymentMethod.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              TextField(
                enabled: false,
                controller: _paymentMethodController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Esewa',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 8.0),
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                enabled: false,
                controller: _totalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter total amount',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 8.0),
              Text(
                'Discount',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter discount amount',
                ),
                onChanged: (value) {
                  setState(() {
                    _discount = double.tryParse(value) ?? 0.0;
                    _totalAmountController.text =
                        (widget.totalAmount - _discount).toString();
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Paid Amount',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _paidAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter paid amount',
                ),
                onChanged: (value) {
                  setState(() {
                    _paidAmount = double.tryParse(value) ?? 0.0;
                    _returnAmount =
                        _paidAmount - double.parse(_totalAmountController.text);
                  });
                },
              ),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: _returnAmount >= 0
                      ? Color.fromARGB(255, 47, 0, 255)
                      : Colors.red,
                ),
                child: Column(
                  children: [
                    Text(
                      'Return Amount',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '$_returnAmount',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
