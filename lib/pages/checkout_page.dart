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
                'name': product['name'],
              })
          .toList();

      String description = 'Sale of multiple products: ';
      for (var product in selectedProducts) {
        description += '${product['name']} (x${product['quantity']}), ';
      }
      description = description.substring(0, description.length - 2);

      await recordSale(selectedProducts, description);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All products checked out successfully! 🎉'),
          backgroundColor: Colors.greenAccent,
        ),
      );
      setState(() {
        checkoutList.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(offset: Offset(1, 2), blurRadius: 4.0, color: Colors.black26)],
          ),
        ),
        backgroundColor: Colors.teal.withOpacity(0.9),
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF80CBC4)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 6,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  var productsData = snapshot.data ?? [];

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                label: const Text(
                  'Checkout All',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: checkoutList.isEmpty ? Colors.grey : Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                  shadowColor: Colors.tealAccent,
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
