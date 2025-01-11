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
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Produk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '\$${product['price']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Stock: ${product['stock']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Add & Remove
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onAddToCheckout(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product['name']} added to checkout list')),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart_outlined, color: Colors.white),
                    label: const Text(
                      'Add to Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6), // Warna biru pastel
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onRemoveFromCheckout(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product['name']} removed from checkout list')),
                      );
                    },
                    icon: const Icon(Icons.remove_shopping_cart_outlined, color: Colors.white),
                    label: const Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF48FB1), // Warna pink pastel
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
