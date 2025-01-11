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
      height: 130,
      borderRadius: 20,
      blur: 15,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.blueAccent.withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.blue.withOpacity(0.2),
        ],
      ),
      child: Opacity(
        opacity: isOutOfStock ? 0.4 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Detail Produk
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
                    const SizedBox(height: 8),
                    Text(
                      'Stock: ${product['stock']} pcs',
                      style: TextStyle(
                        color: isOutOfStock ? Colors.redAccent : Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Harga dan Tombol Tambah/Kurang
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rp ${product['price']}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        color: Colors.redAccent,
                        onPressed: isOutOfStock
                            ? null
                            : () => onUpdateQuantity(product, -1),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${product['quantity'] ?? 0}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildQuantityButton(
                        icon: Icons.add,
                        color: Colors.greenAccent,
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

  Widget _buildQuantityButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: color.withOpacity(onPressed == null ? 0.5 : 1.0),
        elevation: 5,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
