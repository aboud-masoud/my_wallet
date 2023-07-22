import 'package:flutter/material.dart';
import 'package:my_wallet/models/amount_model.dart';
import 'package:my_wallet/small_widgets/header_view.dart';
import 'package:my_wallet/small_widgets/list_cell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AmountModel> myList = [
    AmountModel(type: TransType.income, desc: "shogool 1", amount: 300),
    AmountModel(type: TransType.outcome, desc: "ajaar al beet", amount: 200),
    AmountModel(type: TransType.outcome, desc: "banzeeen", amount: 25),
    AmountModel(type: TransType.outcome, desc: "telphone", amount: 12.5),
    AmountModel(type: TransType.income, desc: "freelance", amount: 600)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
        ),
        body: Column(
          children: [
            HeaderView(
              youHave: calculateTotalAmount(),
              income: claculateIncome(),
              outcome: claculateOutcome(),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: myList.length,
                  itemBuilder: (ctx, index) {
                    return ListCell(
                      type: myList[index].type,
                      desc: myList[index].desc,
                      amount: myList[index].amount,
                      onDelete: () {
                        myList.removeAt(index);
                        setState(() {});
                      },
                    );
                  }),
            ),
          ],
        ),
        floatingActionButton:
            ElevatedButton(onPressed: () {}, child: const Icon(Icons.add)));
  }

  double calculateTotalAmount() {
    return claculateIncome() - claculateOutcome();
  }

  double claculateIncome() {
    var list = myList.where((element) => element.type == TransType.income);
    double total = 0;

    for (var item in list) {
      total = total + item.amount;
    }

    return total;
  }

  double claculateOutcome() {
    var list = myList.where((element) => element.type == TransType.outcome);
    double total = 0;

    for (var item in list) {
      total = total + item.amount;
    }

    return total;
  }
}
