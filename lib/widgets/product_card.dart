import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
    bool isOutOfStock = product['stock'] == 0;

    return GlassmorphicContainer(
      width: double.infinity,
      height: 150,
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.bottomCenter,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.blue.shade200.withOpacity(0.1),
          Colors.pink.shade100.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.blue.shade200.withOpacity(0.5),
          Colors.pink.shade100.withOpacity(0.5),
        ],
      ),
      child: Opacity(
        opacity: isOutOfStock ? 0.3 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stock: ${product['stock']}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Price and Quantity Control
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: isOutOfStock
                            ? null
                            : () => onUpdateQuantity(product, -1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product['quantity'] ?? 0}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: isOutOfStock
                            ? null
                            : () => onUpdateQuantity(product, 1),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon, required VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        backgroundColor: Colors.blue.shade200, // Button color
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
