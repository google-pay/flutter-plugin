/// Copyright 2021 Google LLC
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

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

  const PaymentItem({
    required this.amount,
    this.label,
    this.type = PaymentItemType.total,
    this.status = PaymentItemStatus.unknown,
  });

  Map<String, dynamic> toMap() => {
        'label': label,
        'amount': amount,
        'type': type.toSimpleString(),
        'status': status.toSimpleString(),
      };
}
