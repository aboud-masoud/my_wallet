import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  final double youHave;
  final double income;
  final double outcome;
  const HeaderView(
      {super.key,
      required this.youHave,
      required this.income,
      required this.outcome});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "You Have",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "$youHave JD",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        insideView(
                            title: "In Come",
                            desc: "$income JD",
                            icon: Icons.arrow_downward),
                        insideView(
                            desc: "$outcome JD",
                            title: "Out Come",
                            icon: Icons.arrow_upward)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget insideView(
      {required String title, required String desc, required IconData icon}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        Icon(
          icon,
          color: Colors.white,
        ),
        Text(
          desc,
          style: const TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
