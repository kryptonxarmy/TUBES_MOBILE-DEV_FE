import 'package:flutter/material.dart';
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
          .toList();

      for (var product in selectedProducts) {
        await recordSale([{'productId': product['id'], 'quantity': product['quantity']}]);
      }

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
      appBar: AppBar(
        title: const Text('Admin Page'),
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
          ElevatedButton(
            onPressed: () async {
              var productsData = await products;
              var hasSelectedProducts = productsData.any((product) => product['quantity'] != null && product['quantity'] > 0);
              if (hasSelectedProducts) {
                checkoutAllProducts();
              }
            },
            child: const Text('Checkout All'),
          ),
        ],
      ),
    );
  }
}