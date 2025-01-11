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
    bool isOutOfStock = product['stock'] == 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFEDE7F6)], // Soft gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product['stock']}',
                  style: TextStyle(
                    color: isOutOfStock ? Colors.redAccent : Colors.black54,
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
                  color: Colors.teal,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                      fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed == null
              ? Colors.grey.withOpacity(0.5)
              : Colors.blue.shade300,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
