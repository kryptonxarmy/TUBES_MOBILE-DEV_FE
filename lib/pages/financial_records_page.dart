import 'package:flutter/material.dart';
import '/services/api_service.dart';

class FinancialRecordsPage extends StatefulWidget {
  const FinancialRecordsPage({super.key});

  @override
  _FinancialRecordsPageState createState() => _FinancialRecordsPageState();
}

class _FinancialRecordsPageState extends State<FinancialRecordsPage> {
  late Future<List<dynamic>> financialRecords;
  late Future<double> totalIncome;

  @override
  void initState() {
    super.initState();
    financialRecords = fetchFinancialRecords();
    totalIncome = fetchTotalIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Records'),
      ),
      body: Column(
        children: [
          FutureBuilder<double>(
            future: totalIncome,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Income: \$${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: financialRecords,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var recordsData = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: recordsData.length,
                  itemBuilder: (context, index) {
                    var record = recordsData[index];
                    return ListTile(
                      title: Text(record['description']),
                      subtitle: Text('Amount: \$${record['amount']}'),
                      trailing: Text(record['type']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}