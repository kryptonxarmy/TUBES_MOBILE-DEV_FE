import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'admin_page.dart';
import 'add_product_page.dart';
import 'financial_records_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Warna pastel abu terang
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Lottie Animation
                Lottie.network(
                  'https://assets3.lottiefiles.com/packages/lf20_49rdyysj.json',
                  height: 200,
                ),
                const SizedBox(height: 20),
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 80,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Welcome, Admin! 👋',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage your business effortlessly',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Button Navigasi
                _buildRoundedButton(
                  context,
                  icon: Icons.point_of_sale_outlined,
                  label: 'Cashier',
                  color: Colors.blue.shade300,
                  page: const AdminPage(),
                ),
                const SizedBox(height: 20),
                _buildRoundedButton(
                  context,
                  icon: Icons.add_shopping_cart_outlined,
                  label: 'Add Product',
                  color: Colors.pink.shade300,
                  page: const AddProductPage(),
                ),
                const SizedBox(height: 20),
                _buildRoundedButton(
                  context,
                  icon: Icons.receipt_long_outlined,
                  label: 'Financial Records',
                  color: Colors.green.shade300,
                  page: const FinancialRecordsPage(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required Widget page}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
