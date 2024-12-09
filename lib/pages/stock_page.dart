import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final Function(dynamic) onAddToCheckout;
  final Function(dynamic) onRemoveFromCheckout;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCheckout,
    required this.onRemoveFromCheckout,
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
            ElevatedButton(
              onPressed: () {
                onAddToCheckout(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['name']} added to checkout list')),
                );
              },
              child: const Text('Add to Checkout'),
            ),
            ElevatedButton(
              onPressed: () {
                onRemoveFromCheckout(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['name']} removed from checkout list')),
                );
              },
              child: const Text('Remove from Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}