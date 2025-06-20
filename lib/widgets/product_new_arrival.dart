// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// // Sample data model for new arrival products
// class NewArrivalProduct {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final double price;
//   final String badge;
//   final Color badgeColor;
//
//   NewArrivalProduct({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.price,
//     required this.badge,
//     required this.badgeColor,
//   });
// }
//
// // Provider for new arrivals data - you can replace this with your actual data provider
// final newArrivalsProvider = Provider<List<NewArrivalProduct>>((ref) {
//   return [
//     NewArrivalProduct(
//       id: '1',
//       name: 'Nike Air Jordan',
//       imageUrl: 'assets/images/nike_air_jordan.png', // Replace with your actual image path
//       price: 849.69,
//       badge: 'BEST CHOICE',
//       badgeColor: Colors.blue,
//     ),
//     NewArrivalProduct(
//       id: '2',
//       name: 'Nike Air Max Pro',
//       imageUrl: 'assets/images/nike_air_max_pro.png',
//       price: 699.99,
//       badge: 'NEW',
//       badgeColor: Colors.green,
//     ),
//     NewArrivalProduct(
//       id: '3',
//       name: 'Adidas Ultraboost',
//       imageUrl: 'assets/images/adidas_ultraboost.png',
//       price: 759.99,
//       badge: 'TRENDING',
//       badgeColor: Colors.orange,
//     ),
//   ];
// });
//
// class NewArrivals extends ConsumerWidget {
//   final Function(String)? onProductTap;
//
//   const NewArrivals({
//     super.key,
//     this.onProductTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final newArrivals = ref.watch(newArrivalsProvider);
//
//     return Container(
//       height: 160,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: newArrivals.length,
//         itemBuilder: (context, index) {
//           final product = newArrivals[index];
//           return Container(
//             width: 320,
//             margin: EdgeInsets.only(
//               right: index < newArrivals.length - 1 ? 16 : 0,
//             ),
//             child: NewArrivalCard(
//               product: product,
//               onTap: () => onProductTap?.call(product.id),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class NewArrivalCard extends StatelessWidget {
//   final NewArrivalProduct product;
//   final VoidCallback? onTap;
//
//   const NewArrivalCard({
//     super.key,
//     required this.product,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               spreadRadius: 0,
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // Product Info Section
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Badge
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: product.badgeColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         product.badge,
//                         style: TextStyle(
//                           color: product.badgeColor,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//
//                     // Product Name
//                     Text(
//                       product.name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//
//                     // Price
//                     Text(
//                       '\$${product.price.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Product Image Section
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   height: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.asset(
//                       product.imageUrl,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         // Fallback widget when image fails to load
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.image_not_supported_outlined,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Alternative version if you want to show just one featured product like in your screenshot
// class FeaturedNewArrival extends ConsumerWidget {
//   final Function(String)? onProductTap;
//
//   const FeaturedNewArrival({
//     super.key,
//     this.onProductTap,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final newArrivals = ref.watch(newArrivalsProvider);
//
//     if (newArrivals.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     // Show only the first/featured product
//     final featuredProduct = newArrivals.first;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: NewArrivalCard(
//         product: featuredProduct,
//         onTap: () => onProductTap?.call(featuredProduct.id),
//       ),
//     );
//   }
// }