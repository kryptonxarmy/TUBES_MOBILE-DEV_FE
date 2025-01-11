import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Financial Records',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(offset: Offset(1, 2), blurRadius: 4.0, color: Colors.black26)],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 83, 155, 249), Color.fromARGB(255, 22, 91, 39)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // **Total Income Section**
              FutureBuilder<double>(
                future: totalIncome,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: 120,
                      borderRadius: 20,
                      blur: 15,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: const LinearGradient(
                        colors: [Colors.white30, Colors.white10],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: const LinearGradient(
                        colors: [Colors.white70, Colors.white10],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total Income',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // **Financial Records List**
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: financialRecords,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

                    var recordsData = snapshot.data ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: recordsData.length,
                      itemBuilder: (context, index) {
                        var record = recordsData[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GlassmorphicContainer(
                            width: double.infinity,
                            height: 90,
                            borderRadius: 15,
                            blur: 10,
                            alignment: Alignment.bottomCenter,
                            border: 2,
                            linearGradient: const LinearGradient(
                              colors: [Colors.white30, Colors.white10],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderGradient: const LinearGradient(
                              colors: [Colors.white70, Colors.white10],
                            ),
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: record['type'] == 'income'
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  record['type'] == 'income'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: record['type'] == 'income' ? Colors.green : Colors.red,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                record['description'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Amount: Rp ${record['amount']}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Text(
                                record['type'].toUpperCase(),
                                style: TextStyle(
                                  color: record['type'] == 'income' ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
