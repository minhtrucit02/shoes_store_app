import 'package:flutter/material.dart';
import 'package:shoes_store_app/screeen/shopping_cart_screen.dart';

class AppBarCard extends StatelessWidget{
  const AppBarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.grid_view_rounded),
          onPressed: () {},
          // _onMenuPressed,
        ),
        Column(
          children: [
            Text(
              'Store location',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 16),
                Text(
                  'Mondolibug, Sylhet',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_bag_outlined),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShoppingCartScreen()));
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}