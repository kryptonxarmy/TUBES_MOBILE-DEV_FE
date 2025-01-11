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
        products = fetchProducts();
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF4CAF50)],
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
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4.0,
                            color: Colors.black38,
                          ),
                        ],
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: GestureDetector(
                  onTap: () async {
                    var productsData = await products;
                    var hasSelectedProducts = productsData.any((product) =>
                        product['quantity'] != null &&
                        product['quantity'] > 0);
                    if (hasSelectedProducts) {
                      checkoutAllProducts();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No products selected for checkout!'),
                        ),
                      );
                    }
                  },
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 70,
                    borderRadius: 12,
                    blur: 20,
                    border: 1,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.withOpacity(0.2),
                        Colors.blueAccent.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.shopping_cart_checkout,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Checkout All',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
