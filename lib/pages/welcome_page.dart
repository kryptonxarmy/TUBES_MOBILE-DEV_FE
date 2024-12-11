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
      backgroundColor: Colors.white70, // Background color putih tulang
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Admin Page',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 40),
              _buildGlassButton(
                context,
                icon: Icons.admin_panel_settings,
                label: 'Cashier',
                page: const AdminPage(),
                color: Colors.blue.shade200,
              ),
              SizedBox(height: 20),
              _buildGlassButton(
                context,
                icon: Icons.add_shopping_cart,
                label: 'Add Product',
                page: const AddProductPage(),
                color: Colors.pink.shade200,
              ),
              SizedBox(height: 20),
              _buildGlassButton(
                context,
                icon: Icons.receipt_long,
                label: 'Financial Records',
                page: const FinancialRecordsPage(),
                color: Colors.green.shade200,
              ),
            ],
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
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
    );
  }
}
