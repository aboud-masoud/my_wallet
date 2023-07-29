import 'package:cloud_firestore/cloud_firestore.dart';
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
  // List<AmountModel> myList = [];

  // final myBox = Hive.box("wallet");
  final walletDB = FirebaseFirestore.instance.collection('wallet');

  @override
  void initState() {
    // getDataFromHive();
    super.initState();
  }

  // getDataFromHive() async {
  //   final data = await walletDB.doc().get().then(
  //     (DocumentSnapshot doc) {
  //       final value = doc.data() as Map<String, dynamic>;
  //       return AmountModel(
  //           desc: value["desc"],
  //           amount: value["amount"],
  //           type: value["type"] == "income"
  //               ? TransType.income
  //               : TransType.outcome);
  //     },
  //     onError: (e) => print("Error getting document: $e"),
  //   );

  //   print(data);
  //   // final data = myBox.keys.map((key) {
  //   //   final value = myBox.get(key);
  //   //   return AmountModel(
  //   //       desc: value["desc"],
  //   //       amount: value["amount"],
  //   //       type:
  //   //           value["type"] == "income" ? TransType.income : TransType.outcome);
  //   // }).toList();

  //   // myList = data;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
        ),
        body: StreamBuilder(
            stream: walletDB.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Column(
                children: [
                  HeaderView(
                    youHave: calculateTotalAmount(snapshot.data!.docs),
                    income: claculateIncome(snapshot.data!.docs),
                    outcome: claculateOutcome(snapshot.data!.docs),
                  ),
                  Flexible(
                    child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) {
                          return ListCell(
                            type: snapshot.data!.docs[index]["type"] == "income"
                                ? TransType.income
                                : TransType.outcome,
                            desc: snapshot.data!.docs[index]["desc"],
                            amount: double.tryParse(snapshot
                                    .data!.docs[index]["amount"]
                                    .toString()) ??
                                0,
                            onEdit: () {
                              // showModalBottomSheet(
                              //     context: context,
                              //     isScrollControlled: true,
                              //     builder: (context) {
                              //       return AddEditRecord(
                              //         onAdd: (value) async {
                              //           if (value.amount > 0 &&
                              //               value.desc.isNotEmpty) {
                              //             // myList[index] = value;
                              //             // setState(() {});

                              //             // await myBox.putAt(index, {
                              //             //   "type": value.type == TransType.income
                              //             //       ? "income"
                              //             //       : "outcome",
                              //             //   "desc": value.desc,
                              //             //   "amount": value.amount
                              //             // });
                              //             // getDataFromHive();
                              //           } else {
                              //             ScaffoldMessenger.of(context)
                              //                 .showSnackBar(
                              //               const SnackBar(
                              //                 content: Text(
                              //                     "Amount should be more than Zereooo and Desc should be filled"),
                              //               ),
                              //             );
                              //           }
                              //         },
                              //         amount: myList[index].amount,
                              //         desc: myList[index].desc,
                              //         type: myList[index].type,
                              //       );
                              //     });
                            },
                            onDelete: () {
                              // myList.removeAt(index);
                              // setState(() {});

                              // myBox.deleteAt(index);
                              // getDataFromHive();
                            },
                          );
                        }),
                  ),
                  const SizedBox(height: 40)
                ],
              );
            }),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return AddEditRecord(
                      onAdd: (value) async {
                        if (value.amount > 0 && value.desc.isNotEmpty) {
                          await walletDB.add({
                            "type": value.type == TransType.income
                                ? "income"
                                : "outcome",
                            "desc": value.desc,
                            "amount": value.amount
                          });

                          // myList.add(value);
                          // setState(() {});

                          // await myBox.add({
                          //   "type": value.type == TransType.income
                          //       ? "income"
                          //       : "outcome",
                          //   "desc": value.desc,
                          //   "amount": value.amount
                          // });

                          // getDataFromHive();
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

  double calculateTotalAmount(List<QueryDocumentSnapshot<Object?>> data) {
    return claculateIncome(data) - claculateOutcome(data);
  }

  double claculateIncome(List<QueryDocumentSnapshot<Object?>> data) {
    var list = data.where((element) => element["type"] == "income");
    double total = 0;

    for (var item in list) {
      total = total + item["amount"];
    }

    return total;
  }

  double claculateOutcome(List<QueryDocumentSnapshot<Object?>> data) {
    var list = data.where((element) => element["type"] == "outcome");
    double total = 0;

    for (var item in list) {
      total = total + item["amount"];
    }

    return total;
  }
}
