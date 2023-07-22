import 'package:flutter/material.dart';

enum TransType { income, outcome }

class ListCell extends StatelessWidget {
  final TransType type;
  final String desc;
  final double amount;
  final VoidCallback onDelete;

  const ListCell(
      {super.key,
      required this.type,
      required this.desc,
      required this.amount,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        type == TransType.income
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        size: 12,
                        color: type == TransType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                      Text(
                        type == TransType.income ? "Income" : "Outcome",
                        style: TextStyle(
                            color: type == TransType.income
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                        color: Color(0xff444444), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Text(
                type == TransType.income ? "+$amount JD" : "-$amount JD",
                style: TextStyle(
                    color: type == TransType.income ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () => onDelete(), icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
