import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProducts() async {
  final response = await http.get(Uri.parse(
      'https://mobile-dev-backend-f97728e716db.herokuapp.com/api/products'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load products');
  }
}

Future<void> addProduct(String name, double price, int stock) async {
  final response = await http.post(
    Uri.parse(
        'https://mobile-dev-backend-f97728e716db.herokuapp.com/api/products/add'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'name': name, 'price': price, 'stock': stock}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to add product');
  }
}

Future<void> reduceStock(String productId, int newStock) async {
  final response = await http.patch(
    Uri.parse(
        'https://mobile-dev-backend-f97728e716db.herokuapp.com/api/products/$productId'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'stock': newStock}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to reduce stock');
  }
}

Future<void> recordSale(List<Map<String, dynamic>> productsToCheckout) async {
  for (var product in productsToCheckout) {
    final response = await http.post(
      Uri.parse(
          'https://mobile-dev-backend-f97728e716db.herokuapp.com/api/sales'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to record sale for product ${product['productId']}');
    }
  }
}

Future<List<dynamic>> fetchFinancialRecords() async {
  final response = await http.get(Uri.parse(
      'https://mobile-dev-backend-f97728e716db.herokuapp.com/api/financial-records'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load financial records');
  }
}

Future<double> fetchTotalIncome() async {
  final response = await http.get(Uri.parse(
      'https://mobile-dev-backend-f97728e716db.herokuapp.com/api/financial-records/total-income'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['totalIncome'];
  } else {
    throw Exception('Failed to load total income');
  }
}

// izin numpang kode api kak
Future<Map<String, String>> fetchRandomQuote() async {
  final response = await http.get(
    Uri.parse('https://api.api-ninjas.com/v1/quotes'),
    headers: {'X-Api-Key': 'xQwTQVVKPrKIbrHRsu4ynw==viZG6wzkk4UnN0uv'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return {
      'quote': data[0]['quote'],
      'author': data[0]['author'],
    };
  } else {
    throw Exception('Failed to load quote');
  }
}
