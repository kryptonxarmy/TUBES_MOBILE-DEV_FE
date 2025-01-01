import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '/services/api_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  void _submitProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await addProduct(
          nameController.text,
          double.parse(priceController.text),
          int.parse(stockController.text),
        );
        
        // Clear form after successful submission
        nameController.clear();
        priceController.clear();
        stockController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Product added successfully'),
            backgroundColor: Colors.green.withOpacity(0.7),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding product: ${e.toString()}'),
            backgroundColor: Colors.red.withOpacity(0.7),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade600,
              Colors.deepPurple.shade400,
            ],
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
                      'Add New Product',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: 20,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.2),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildGlassTextFormField(
                                controller: nameController,
                                labelText: 'Product Name',
                                icon: Icons.label_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildGlassTextFormField(
                                controller: priceController,
                                labelText: 'Product Price',
                                icon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product price';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildGlassTextFormField(
                                controller: stockController,
                                labelText: 'Product Stock',
                                icon: Icons.inventory_outlined,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter product stock';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              _buildSubmitButton(),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildGlassTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          errorStyle: TextStyle(color: Colors.red.shade200),
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        validator: validator,
        cursorColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitProduct,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 60,
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.green.withOpacity(0.1),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Add Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}