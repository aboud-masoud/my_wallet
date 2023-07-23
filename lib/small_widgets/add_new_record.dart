import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/models/amount_model.dart';
import 'package:my_wallet/small_widgets/list_cell.dart';

class AddNewRecord extends StatefulWidget {
  final Function(AmountModel) onAdd;
  const AddNewRecord({super.key, required this.onAdd});

  @override
  State<AddNewRecord> createState() => _AddNewRecordState();
}

class _AddNewRecordState extends State<AddNewRecord> {
  bool incomingSelected = true;
  TextEditingController amountController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              Expanded(child: Container()),
              const Text("Add New Record"),
              Expanded(child: Container()),
              TextButton(
                  onPressed: () {
                    widget.onAdd(AmountModel(
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        desc: descController.text,
                        type: incomingSelected ? TransType.income : TransType.outcome));
                    Navigator.pop(context);
                  },
                  child: const Text("Add")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                  value: incomingSelected,
                  onChanged: (x) {
                    incomingSelected = !incomingSelected;
                    setState(() {});
                  }),
              const Text("Incoming"),
              Checkbox(
                  value: !incomingSelected,
                  onChanged: (x) {
                    incomingSelected = !incomingSelected;
                    setState(() {});
                  }),
              const Text("Outcoming"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: "Descreption"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: "Amount",
              ),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
