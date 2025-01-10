import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '/services/api_service.dart';
import '/widgets/product_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<dynamic>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  void updateQuantity(dynamic product, int change) {
    setState(() {
      int currentQuantity = product['quantity'] ?? 0;
      int newQuantity = currentQuantity + change;
      if (newQuantity >= 0) {
        product['quantity'] = newQuantity;
      }
    });
  }

  Future<void> checkoutAllProducts() async {
  try {
    var productsData = await products;
    var selectedProducts = productsData
        .where((product) => product['quantity'] != null && product['quantity'] > 0)
        .map((product) => {
              'productId': product['id'],
              'quantity': product['quantity'],
              'name': product['name'] // Include product name
            })
        .toList();

    String description = 'Sale of multiple products: ';
    for (var product in selectedProducts) {
      description += '${product['name']} (x${product['quantity']}), ';
    }
    // Remove trailing comma and space
    description = description.substring(0, description.length - 2);

    await recordSale(selectedProducts, description);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All products checked out successfully')),
    );
    setState(() {
      products = fetchProducts(); // Refresh the product list
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade800.withOpacity(0.1),
              Colors.blue.shade200.withOpacity(0.1),
              Colors.pink.shade100.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Product Management',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    var productsData = snapshot.data ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: productsData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ProductCard(
                            product: productsData[index],
                            onUpdateQuantity: updateQuantity,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GlassmorphicContainer(
                    width: 280,
                    height: 70,
                    borderRadius: 20,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green.withOpacity(0.1),
                        Colors.green.withOpacity(0.05),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        var productsData = await products;
                        var hasSelectedProducts = productsData.any((product) =>
                            product['quantity'] != null &&
                            product['quantity'] > 0);
                        if (hasSelectedProducts) {
                          checkoutAllProducts();
                        }
                      },
                      icon: const Icon(Icons.shopping_cart_checkout,
                          color: Colors.white, size: 28),
                      label: const Text(
                        'Checkout All',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200, // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
