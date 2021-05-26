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

/// The types of payment statuses supported.
///
/// * [final_price] determines that the price has been calculated and
/// won't change.
/// * [pending] expects changes to the final price in response to user selection
/// or other circumstances that are not known when requesting the payment.
/// * [unknown] for any other scenario other than the above.
enum PaymentItemStatus { unknown, pending, final_price }

/// A set of utility methods associated to the [PaymentItemStatus] enumeration.
extension on PaymentItemStatus {
  /// Creates a string representation from the [PaymentItemStatus] enumeration.
  String toSimpleString() => {
        PaymentItemStatus.unknown: 'unknown',
        PaymentItemStatus.pending: 'pending',
        PaymentItemStatus.final_price: 'final_price',
      }[this]!;
}

/// The types of payment types supported.
///
/// * [item] defines an element as a regular entry in the payment summary.
/// * [total] describes the item as the total amount to be paid.
enum PaymentItemType { item, total }

/// A set of utility methods associated to the [PaymentItemType] enumeration.
extension on PaymentItemType {
  /// Creates a string representation from the [PaymentItemType] enumeration.
  String toSimpleString() => {
        PaymentItemType.item: 'item',
        PaymentItemType.total: 'total',
      }[this]!;
}

/// A simple object that holds information about individual entries in the
/// payment summary shown before completing a payment.
///
/// Payment items are typically shown as a collection of entries with basic
/// information about the items being purchased.
///
/// Here is an example of an individual payment item:
/// ```dart
/// PaymentItem(
///   label: 'Your new shoes',
///   amount: '99.99',
///   status: PaymentItemStatus.final_price,
///   type: PaymentItemType.item,
/// )
/// ```
///
/// And a summary entry with the total price.
/// ```dart
/// PaymentItem(
///   label: 'Total',
///   amount: '102.99',
///   status: PaymentItemStatus.final_price,
///   type: PaymentItemType.total,
/// )
/// ```
class PaymentItem {
  /// A text with basic information about the item.
  final String? label;

  ///  The price of the item in string format.
  final String amount;

  /// The type of the item, either [item] or [total].
  final PaymentItemType type;

  /// The status of the price, either [unknown], [pending] or [final_price].
  final PaymentItemStatus status;

  /// Creates a new payment item with the specified parameters, defaulting to
  /// a [total] [type], and an [unknown] [status].
  const PaymentItem({
    required this.amount,
    this.label,
    this.type = PaymentItemType.total,
    this.status = PaymentItemStatus.unknown,
  });

  /// Creates a map representation of the object.
  Map<String, Object?> toMap() => {
        'label': label,
        'amount': amount,
        'type': type.toSimpleString(),
        'status': status.toSimpleString(),
      };
}
