import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['API_BASE_URL']!;

Future<List<dynamic>> fetchProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/products'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}

Future<void> addProduct(String name, double price, int stock) async {
  final response = await http.post(
    Uri.parse('$baseUrl/products/add'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'name': name, 'price': price, 'stock': stock}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to add product');
  }
}

Future<void> reduceStock(String productId, int newStock) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/api/products/$productId'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'stock': newStock}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to reduce stock');
  }
}

Future<void> recordSale(
    List<Map<String, dynamic>> productsToCheckout, String description) async {
  final response = await http.post(
    Uri.parse('$baseUrl/sales'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'products': productsToCheckout,
      'date': DateTime.now().toIso8601String(),
      'description': description,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to record sale');
  }
}

Future<List<dynamic>> fetchFinancialRecords() async {
  final response = await http.get(Uri.parse('$baseUrl/financial-records'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load financial records');
  }
}

Future<double> fetchTotalIncome() async {
  final response =
      await http.get(Uri.parse('$baseUrl/financial-records/total-income'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['totalIncome'];
  } else {
    throw Exception('Failed to load total income');
  }
}
