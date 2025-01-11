import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/widgets/product_card.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Future<List<dynamic>> products;
  List<dynamic> checkoutList = [];

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
      var selectedProducts = checkoutList
          .where((product) => product['quantity'] != null && product['quantity'] > 0)
          .map((product) => {
                'productId': product['id'],
                'quantity': product['quantity'],
                'name': product['name']
              })
          .toList();

      String description = 'Sale of multiple products: ';
      for (var product in selectedProducts) {
        description += '${product['name']} (x${product['quantity']}), ';
      }
      description = description.substring(0, description.length - 2);

      await recordSale(selectedProducts, description);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All products checked out successfully')),
      );
      setState(() {
        checkoutList.clear();
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
      appBar: AppBar(
        title: const Text('Checkout'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4DD0E1), Color(0xFF00796B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  var productsData = snapshot.data ?? [];
                  if (productsData.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products available for checkout.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: productsData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ProductCard(
                            product: productsData[index],
                            onUpdateQuantity: updateQuantity,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: checkoutList.isEmpty ? null : checkoutAllProducts,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text(
                  'Checkout All',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00796B),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
