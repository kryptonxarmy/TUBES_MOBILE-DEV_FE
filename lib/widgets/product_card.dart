import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final Function(dynamic, int) onUpdateQuantity;

  const ProductCard({
    super.key,
    required this.product,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(product['name']),
        subtitle: Text('Stock: ${product['stock']}'),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\$${product['price']}'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    onUpdateQuantity(product, -1);
                  },
                ),
                Text('${product['quantity'] ?? 0}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    onUpdateQuantity(product, 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}