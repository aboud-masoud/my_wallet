import 'package:my_wallet/small_widgets/list_cell.dart';

class AmountModel {
  double amount;
  TransType type;
  String desc;

  AmountModel({required this.type, required this.desc, required this.amount});
}
