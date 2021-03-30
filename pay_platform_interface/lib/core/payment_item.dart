enum PaymentItemStatus { unknown, pending, final_price }

extension on PaymentItemStatus {
  String? toSimpleString() => {
        PaymentItemStatus.unknown: 'unknown',
        PaymentItemStatus.pending: 'pending',
        PaymentItemStatus.final_price: 'final_price',
      }[this];
}

enum PaymentItemType { item, total }

extension on PaymentItemType {
  String? toSimpleString() => {
        PaymentItemType.item: 'item',
        PaymentItemType.total: 'total',
      }[this];
}

class PaymentItem {
  final String? label;
  final String amount;
  final PaymentItemType type;
  final PaymentItemStatus status;

  const PaymentItem(
      {required this.amount,
      this.label,
      this.type = PaymentItemType.total,
      this.status = PaymentItemStatus.unknown});

  Map<String, dynamic> toMap() => {
        'label': label,
        'amount': amount,
        'type': type.toSimpleString(),
        'status': status.toSimpleString(),
      };
}
