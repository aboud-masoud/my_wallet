import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/models/amount_model.dart';
import 'package:my_wallet/small_widgets/list_cell.dart';

class AddEditRecord extends StatefulWidget {
  final double? amount;
  final String? desc;
  final TransType? type;

  final Function(AmountModel) onAdd;
  const AddEditRecord({
    super.key,
    required this.onAdd,
    this.amount,
    this.desc,
    this.type,
  });

  @override
  State<AddEditRecord> createState() => _AddEditRecordState();
}

class _AddEditRecordState extends State<AddEditRecord> {
  bool incomingSelected = true;
  TextEditingController amountController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    amountController.text = widget.amount != null ? "${widget.amount}" : "";
    descController.text = widget.desc ?? "";
    incomingSelected = widget.type == TransType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: MediaQuery.of(context).viewInsets.bottom),
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
              Text(widget.amount != null ? "Edit Record" : "Add New Record"),
              Expanded(child: Container()),
              TextButton(
                  onPressed: () {
                    widget.onAdd(AmountModel(
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        desc: descController.text,
                        type: incomingSelected ? TransType.income : TransType.outcome));
                    Navigator.pop(context);
                  },
                  child: Text(widget.amount != null ? "Edit" : "Add")),
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
