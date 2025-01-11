import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 160,
        borderRadius: 20,
        blur: 10,
        alignment: Alignment.center,
        border: 2,
        linearGradient: const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFE0F7FA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: const LinearGradient(
          colors: [
            Colors.white70,
            Colors.white10,
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            product['name'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            'Stock: ${product['stock']} pcs',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          trailing: SizedBox(
            width: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rp ${product['price']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context,
                      label: 'Add',
                      color: Colors.greenAccent,
                      icon: Icons.add,
                      onPressed: () {
                        onAddToCheckout(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['name']} added to checkout list'),
                            backgroundColor: Colors.greenAccent.shade200,
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      label: 'Remove',
                      color: Colors.redAccent,
                      icon: Icons.remove,
                      onPressed: () {
                        onRemoveFromCheckout(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product['name']} removed from checkout list'),
                            backgroundColor: Colors.redAccent.shade200,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
