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
          .where((product) =>
              product['quantity'] != null && product['quantity'] > 0)
          .map((product) =>
              {'productId': product['id'], 'quantity': product['quantity']})
          .toList();

      String description = 'Sale of multiple products: ';
      for (var product in checkoutList) {
        if (product['quantity'] != null && product['quantity'] > 0) {
          description += '${product['name']} (x${product['quantity']}), ';
        }
      }
      // Remove trailing comma and space
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
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var productsData = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: productsData.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: productsData[index],
                      onUpdateQuantity: updateQuantity,
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
              label: const Text('Checkout All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
