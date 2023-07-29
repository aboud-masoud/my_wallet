import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_wallet/models/amount_model.dart';
import 'package:my_wallet/small_widgets/add_edit_record.dart';
import 'package:my_wallet/small_widgets/header_view.dart';
import 'package:my_wallet/small_widgets/list_cell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AmountModel> myList = [];

  // final myBox = Hive.box("wallet");

  @override
  void initState() {
    getDataFromHive();
    super.initState();
  }

  getDataFromHive() {
    // final data = myBox.keys.map((key) {
    //   final value = myBox.get(key);
    //   return AmountModel(
    //       desc: value["desc"],
    //       amount: value["amount"],
    //       type:
    //           value["type"] == "income" ? TransType.income : TransType.outcome);
    // }).toList();

    // myList = data;
    setState(() {});
  }

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
                  reverse: true,
                  itemCount: myList.length,
                  itemBuilder: (ctx, index) {
                    return ListCell(
                      type: myList[index].type,
                      desc: myList[index].desc,
                      amount: myList[index].amount,
                      onEdit: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return AddEditRecord(
                                onAdd: (value) async {
                                  if (value.amount > 0 &&
                                      value.desc.isNotEmpty) {
                                    // myList[index] = value;
                                    // setState(() {});

                                    // await myBox.putAt(index, {
                                    //   "type": value.type == TransType.income
                                    //       ? "income"
                                    //       : "outcome",
                                    //   "desc": value.desc,
                                    //   "amount": value.amount
                                    // });
                                    getDataFromHive();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Amount should be more than Zereooo and Desc should be filled"),
                                      ),
                                    );
                                  }
                                },
                                amount: myList[index].amount,
                                desc: myList[index].desc,
                                type: myList[index].type,
                              );
                            });
                      },
                      onDelete: () {
                        // myList.removeAt(index);
                        // setState(() {});

                        // myBox.deleteAt(index);
                        getDataFromHive();
                      },
                    );
                  }),
            ),
            const SizedBox(height: 40)
          ],
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return AddEditRecord(
                      onAdd: (value) async {
                        if (value.amount > 0 && value.desc.isNotEmpty) {
                          // myList.add(value);
                          // setState(() {});

                          // await myBox.add({
                          //   "type": value.type == TransType.income
                          //       ? "income"
                          //       : "outcome",
                          //   "desc": value.desc,
                          //   "amount": value.amount
                          // });

                          getDataFromHive();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Amount should be more than Zereooo and Desc should be filled"),
                            ),
                          );
                        }
                      },
                    );
                  });
            },
            child: const Icon(Icons.add)));
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
