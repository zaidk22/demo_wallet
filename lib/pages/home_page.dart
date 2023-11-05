import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wallet/pages/add_transactions.dart';

import '../helper/global_functions.dart';
import '../models/transaction.dart';
import 'widgets/buttons_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AddTransaction(),
              ));
            },
            icon: const Icon(
              Icons.attach_money,
            ),
            label: const Text("Add transcation")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    icon: Icons.attach_money,
                    label: "Income",
                    amount: '\u{20B9} 2000',
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    icon: Icons.attach_money,
                    label: "Expense",
                    amount: '\u{20B9} 2000',
                    onPressed: () {},
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    icon: Icons.attach_money,
                    label: "To Be Paid",
                    amount: '\u{20B9} 0',
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    icon: Icons.attach_money,
                    label: "To Be Recieved",
                    amount: '\u{20B9} 0',
                    onPressed: () {},
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<Transaction>>(
              future: getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data?.length == 0) {
                  return Center(child: Text("No transactions added"));
                } else {
                  final transactions = snapshot.data ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return ListTile(
                        title: Text(transaction.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Amount: \u{20B9} ${transaction.amount}"),
                            Text("Date: ${formatDate(transaction.date)}"),
                            Text("Type: ${transaction.type}"),
                          ],
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              FileImage(File(transaction.imagePath)),
                        ),
                      );
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<Transaction>> getTransactions() async {
    final transactionsBox = await Hive.openBox<Transaction>("transactions");
    return transactionsBox.values.toList();
  }
}
