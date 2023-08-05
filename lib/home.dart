import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_wallet/change_profile_image.dart';

import 'package:my_wallet/small_widgets/add_edit_record.dart';
import 'package:my_wallet/small_widgets/header_view.dart';
import 'package:my_wallet/small_widgets/list_cell.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CollectionReference<Map<String, dynamic>> walletDB;

  int counter = 0;

  @override
  void initState() {
    walletDB = FirebaseFirestore.instance.collection(widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: walletDB.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Home Screen"),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ChangeProfileImageScreen(
                            email: widget.email,
                          );
                        }));
                      }),
                ],
              ),
              body: snapshot.hasData
                  ? Column(
                      children: [
                        HeaderView(
                          youHave: calculateTotalAmount(snapshot.data!.docs),
                          income: claculateIncome(snapshot.data!.docs),
                          outcome: claculateOutcome(snapshot.data!.docs),
                        ),
                        snapshot.data!.docs.isNotEmpty
                            ? Flexible(
                                child: ListView.builder(
                                    reverse: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (ctx, index) {
                                      return ListCell(
                                        type: snapshot.data!.docs[index]
                                                    ["type"] ==
                                                "income"
                                            ? TransType.income
                                            : TransType.outcome,
                                        desc: snapshot.data!.docs[index]
                                            ["desc"],
                                        amount: double.tryParse(snapshot
                                                .data!.docs[index]["amount"]
                                                .toString()) ??
                                            0,
                                        onEdit: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return AddEditRecord(
                                                  onAdd: (value) async {
                                                    if (value.amount > 0 &&
                                                        value.desc.isNotEmpty) {
                                                      walletDB
                                                          .doc(snapshot.data!
                                                              .docs[index].id)
                                                          .update({
                                                        "type": value.type ==
                                                                TransType.income
                                                            ? "income"
                                                            : "outcome",
                                                        "desc": value.desc,
                                                        "amount": value.amount
                                                      });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Amount should be more than Zereooo and Desc should be filled"),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  amount: snapshot.data!
                                                      .docs[index]["amount"],
                                                  desc: snapshot.data!
                                                      .docs[index]["desc"],
                                                  type:
                                                      snapshot.data!.docs[index]
                                                                  ["type"] ==
                                                              "income"
                                                          ? TransType.income
                                                          : TransType.outcome,
                                                );
                                              });
                                        },
                                        onDelete: () {
                                          walletDB
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete();
                                        },
                                      );
                                    }),
                              )
                            : Column(
                                children: const [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Center(
                                    child: Text("No Data to show"),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 40)
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
              floatingActionButton: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return AddEditRecord(
                            onAdd: (value) async {
                              if (value.amount > 0 && value.desc.isNotEmpty) {
                                await walletDB.doc("$counter").set({
                                  "type": value.type == TransType.income
                                      ? "income"
                                      : "outcome",
                                  "desc": value.desc,
                                  "amount": value.amount
                                });

                                counter = counter + 1;
                                // await walletDB.add();
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
        });
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
