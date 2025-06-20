import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes_store_app/models/enum_cart_status.dart';

Widget buildCartStatus(CartItemStatus cartStatus){
  Color backgroundColor;
  Color textColor;
  String text;
  switch(cartStatus){
    case CartItemStatus.paid:
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      text = 'Success';
      break;
    case CartItemStatus.unpaid:
      backgroundColor = Colors.white.withOpacity(0.1);
      textColor = Colors.white;
      text = '';
      break;
    case CartItemStatus.checked:
      backgroundColor = Colors.grey.withOpacity(0.1);
      textColor = Colors.grey;
      text = '';
      break;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget buildDetailRow(String label, String value, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        size: 16,
        color: Colors.grey[600],
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      const Spacer(),
      Flexible(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

void showReorderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Reorder Item'),
        content: Text('Do you want to reorder ""?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle reorder logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item added to cart!')),
              );
            },
            child: const Text('Reorder'),
          ),
        ],
      );
    },
  );
}

void showReceiptDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Download Receipt'),
        content: const Text('Receipt will be downloaded to your device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle receipt download logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Receipt downloaded!')),
              );
            },
            child: const Text('Download'),
          ),
        ],
      );
    },
  );
}
