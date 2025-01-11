import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Product Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Animasi Loading Lottie dari URL
                    return Center(
                      child: Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_j1adxtyb.json',
                        width: 150,
                        height: 150,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network(
                            'https://assets7.lottiefiles.com/private_files/lf30_t26law.json',
                            width: 200,
                          ),
                          Text(
                            'Oops! ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  var productsData = snapshot.data ?? [];

                  if (productsData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.network(
                            'https://assets4.lottiefiles.com/packages/lf20_d0bYW3.json',
                            width: 200,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No products available.',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productsData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
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
          ],
        ),
      ),
    );
  }
}
