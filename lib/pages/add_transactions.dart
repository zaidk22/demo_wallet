import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallet/pages/home_page.dart';

import '../models/transaction.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  bool isRecieved = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  File? selectedImage;
  final FlutterContactPicker _contactPicker = new FlutterContactPicker();
  Contact? _contact;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Customer Name'),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Enter customer name',
                    suffixIcon: IconButton(
                        onPressed: () {
                          _pickContact();
                      
                        },
                        icon: const Icon(Icons.contact_phone))),
              ),
              const SizedBox(height: 16.0),
              const Text('Customer Image'),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Text('Pick from Gallery'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: const Text('Take a Photo'),
                  ),
                ],
              ),
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.file(
                    selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const Text('Mobile Number'),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration:  InputDecoration(
                  hintText: 'Enter mobile number',
                  suffixIcon: IconButton(onPressed: (){
                     _pickContact();
                  }, icon: const Icon(Icons.contact_phone))
                  
                ),
                
                
              ),
              const SizedBox(height: 16.0),
              const Text('Amount Paid/Received'),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Toggle: Paid/Received Full or Partial Amount'),
              Row(
                children: [
                  const Text('Paid'),
                  Switch(
                    value: isRecieved,
                    onChanged: (value) {
                      setState(() {
                        isRecieved = value;
                      });
                    },
                  ),
                  const Text('Received'),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _saveTransaction(selectedImage?.path);
                },
                child: const Text('Add Income/Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveTransaction(String? imagePath) async {
    final name = nameController.text;
    final amount = amountController.text;

    // Validate name and amount fields
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a customer name')),
      );
      return;
    }

    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final double amountValue = double.tryParse(amount) ?? 0.0;

    if (amountValue == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than zero')),
      );
      return;
    }

    if (imagePath == null || imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer image')),
      );
      return;
    }

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      date: DateTime.now(),
      imagePath: imagePath,
      amount: amountValue.toStringAsFixed(2),
      type: isRecieved ? "Received" : "Paid",
    );

    try {
      final transactionsBox = Hive.box<Transaction>("transactions");
      transactionsBox.add(transaction);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added')),
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
     
    }
  }

  Future<void> _pickContact() async {
    Contact? contact = await _contactPicker.selectContact();
    if (contact != null) {
      setState(() {
        nameController.text = contact.fullName ?? "";
        phoneController.text = contact.phoneNumbers?.first ?? "";
      });
    }
  }
}
