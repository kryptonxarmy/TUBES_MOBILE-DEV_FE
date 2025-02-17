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
          .toList();

      for (var product in selectedProducts) {
        await recordSale([{'productId': product['id'], 'quantity': product['quantity']}]);
      }

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
            onPressed: checkoutList.isEmpty ? null : checkoutAllProducts,
            child: const Text('Checkout All'),
          ),
        ],
      ),
    );
  }
}