enum CartItemStatus {
  unpaid,
  paid,
  checked,
}

extension CartStatusExtension on CartItemStatus{
  String get displayName{
    switch(this){
      case CartItemStatus.unpaid:
        return 'unpaid';
      case CartItemStatus.paid:
        return 'paid';
      case CartItemStatus.checked:
        return 'checked';
    }
  }
}