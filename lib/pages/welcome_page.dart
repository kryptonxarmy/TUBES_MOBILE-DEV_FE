import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'admin_page.dart';
import 'add_product_page.dart';
import 'financial_records_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF4CAF50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Financial Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GlassmorphicContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 450,
                  borderRadius: 20,
                  blur: 15,
                  border: 2,
                  linearGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderGradient: const LinearGradient(
                    colors: [Colors.white70, Colors.white10],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildGlassButton(
                          context,
                          icon: Icons.admin_panel_settings,
                          label: 'Cashier',
                          page: const AdminPage(),
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 20),
                        _buildGlassButton(
                          context,
                          icon: Icons.add_shopping_cart,
                          label: 'Add Product',
                          page: const AddProductPage(),
                          color: Colors.pinkAccent,
                        ),
                        const SizedBox(height: 20),
                        _buildGlassButton(
                          context,
                          icon: Icons.receipt_long,
                          label: 'Financial Records',
                          page: const FinancialRecordsPage(),
                          color: Colors.greenAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget page,
      required Color color}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 70,
        borderRadius: 12,
        blur: 10,
        border: 1,
        linearGradient: LinearGradient(
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [color.withOpacity(0.7), color.withOpacity(0.2)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
