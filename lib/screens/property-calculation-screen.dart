import 'package:finance/finance.dart';
import 'package:flutter/material.dart';
import 'package:real_state_finder/utils/constants.dart';
import 'package:real_state_finder/widgets/number-text-field.dart';

class PropertyCalcScreen extends StatefulWidget {
  final double price;
  final double taxAssesment;
  PropertyCalcScreen({@required this.price, @required  this.taxAssesment});
  @override
  _PropertyCalcScreenState createState() => _PropertyCalcScreenState();
}

class _PropertyCalcScreenState extends State<PropertyCalcScreen> {
  final downController = TextEditingController();
  final interestController = TextEditingController();
  final taxController = TextEditingController();
  final mPeriodController = TextEditingController();
  final rentController = TextEditingController();
  final otherIncomeController = TextEditingController();
  final insuranceController = TextEditingController();
  final pmiController = TextEditingController();
  final utilityController = TextEditingController();
  final repairController = TextEditingController();
  final vacancyController = TextEditingController();
  final capitalController = TextEditingController();
  final rnlcController = TextEditingController();
  final rehabController = TextEditingController();

  double annualTax, downPayment, tIncome, mortgage, allPiti, repair, vacancy, capital, rnlc, tExpense, cashFlow, prepay,
    escrow, closing, inBuyDown, c2c, tInvestment, roi;

  @override
  void initState() {
    downController.text = '25';
    interestController.text = '3.3';
    taxController.text = '2.5';
    mPeriodController.text = '30';
    rentController.text = '${widget.taxAssesment * 0.9 / 100}';
    otherIncomeController.text = '0';
    insuranceController.text = '100';
    pmiController.text = '0';
    utilityController.text = '0';
    repairController.text = '0';
    vacancyController.text = '5';
    capitalController.text = '5';
    rnlcController.text = '10';
    rehabController.text = '0';

    calculate();
    super.initState();
  }

  calculate() {
    try {
      annualTax = widget.price * double.parse(taxController.text) / 100;
      downPayment = widget.price * double.parse(downController.text) / 100;
      tIncome = double.parse(rentController.text) + double.parse(otherIncomeController.text);
      mortgage = Finance.pmt(rate: double.parse(interestController.text)/1200, 
      nper: 30*double.parse(mPeriodController.text), 
      pv: widget.price - downPayment) *-1;
      allPiti = mortgage + (annualTax /12) + double.parse(insuranceController.text) + double.parse(pmiController.text);
      repair = allPiti * double.parse(repairController.text) / 100;
      vacancy = allPiti * double.parse(vacancyController.text) / 100;
      capital = allPiti * double.parse(capitalController.text) / 100;
      tExpense = allPiti + double.parse(utilityController.text) + repair + vacancy + capital + double.parse(rnlcController.text); 
      cashFlow = tIncome - tExpense;
      prepay = (annualTax/12 + double.parse(insuranceController.text)) * 12;
      escrow = (annualTax/12 + double.parse(insuranceController.text)) * 6;
      closing = 1500;
      inBuyDown = 1200;
      c2c = closing + inBuyDown + prepay + escrow + downPayment;
      tInvestment = c2c + double.parse(rehabController.text);
      roi = (cashFlow*12) / tInvestment;
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error!'),
            contentPadding: EdgeInsets.only(top: 20.0, bottom: 30.0, left: 20.0, right: 20.0),
            content: Text('Please Input number ONLY to get the correct value.'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        leadingWidth: 40.0,
        titleSpacing: 0,
        title: Text(
          'Detail Calculation', 
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => calculate());
            }, 
            child: Text('Calculate', style: propertyCalcLabel,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Property Cost (\$)', style: propertyCalcLabel,),
                  Text(widget.price.toInt().toString(), style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Down Payment(%)', style: propertyCalcLabel,),
                  NumberTextField(controller: downController, width: 50.0,),
                  Text('${downPayment?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Interest(%)', style: propertyCalcLabel,),
                  NumberTextField(controller: interestController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax Rate(%)', style: propertyCalcLabel,),
                  NumberTextField(controller: taxController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimated Annual Tax (\$)', style: propertyCalcLabel,),
                  Text('${annualTax?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mortgage Period (Years)', style: propertyCalcLabel,),
                  NumberTextField(controller: mPeriodController, width: 50.0,),
                ],
              ),
              
              SizedBox(height: 25.0),
              Text('Income (monthly)', style: propertyCalcValue,),
              Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rent (\$ Guess Value)', style: propertyCalcLabel,),
                  NumberTextField(controller: rentController, width: 65.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Others (\$)', style: propertyCalcLabel,),
                  NumberTextField(controller: otherIncomeController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Income (\$)', style: propertyCalcLabel,),
                  Text('${tIncome?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 25.0),
              Text('Expanses (monthly)', style: propertyCalcValue,),
              Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mortage (\$)', style: propertyCalcLabel,),
                  Text('${mortgage?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tax (\$)', style: propertyCalcLabel,),
                  Text('${annualTax ~/ 12}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Insurance (\$)', style: propertyCalcLabel,),
                  NumberTextField(controller: insuranceController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PMI (\$)', style: propertyCalcLabel,),
                  NumberTextField(controller: pmiController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All-In-PITI (\$)', style: propertyCalcLabel,),
                  Text('${allPiti?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Utilities (\$)', style: propertyCalcLabel,),
                  NumberTextField(controller: utilityController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Repair (%)', style: propertyCalcLabel,),
                  NumberTextField(controller: repairController, width: 50.0,),
                  Text('${repair?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vacancy (%)', style: propertyCalcLabel,),
                  NumberTextField(controller: vacancyController, width: 50.0,),
                  Text('${vacancy?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Capital Ex. (%)', style: propertyCalcLabel,),
                  NumberTextField(controller: capitalController, width: 50.0,),
                  Text('${capital?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rental License (\$)', style: propertyCalcLabel,),
                  NumberTextField(controller: rnlcController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Expenses (\$)', style: propertyCalcLabel,),
                  Text('${tExpense?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 25.0),
              Text('Cash Flow', style: propertyCalcValue,),
              Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Monthly*', style: propertyCalcLabel,),
                  Text('${cashFlow?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Annually*', style: propertyCalcLabel,),
                  Text('${(cashFlow*12)?.toInt() }', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 25.0),
              Text('Total Invested', style: propertyCalcValue,),
              Container(
                height: 2.0,
                width: double.infinity,
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 10.0, top: 3.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Down Payment (\$)', style: propertyCalcLabel,),
                  Text('${downPayment?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Closing (\$)', style: propertyCalcLabel,),
                  Text('${closing?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pre Pay(12 moT & I)', style: propertyCalcLabel,),
                  Text('${prepay?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Escrow(6mo T & I)', style: propertyCalcLabel,),
                  Text('${escrow?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Interest Buy Down (\$)', style: propertyCalcLabel,),
                  Text('${inBuyDown?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cash To Close (\$)', style: propertyCalcLabel,),
                  Text('${c2c?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rehab (\$)', style: propertyCalcLabel,),
                  NumberTextField(controller: rehabController, width: 50.0,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Investment (\$)', style: propertyCalcLabel,),
                  Text('${tInvestment?.toInt()}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('### Annual ROI', style: propertyCalcLabel,),
                  Text('${roi.toStringAsFixed(2)}', style: propertyCalcValue,),
                ],
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}