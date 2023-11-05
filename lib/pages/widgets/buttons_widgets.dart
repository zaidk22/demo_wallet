import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final VoidCallback onPressed;

  const CustomButton({
    required this.icon,
    required this.label,
    required this.amount,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 1,
        child: Column(
          children: [
            Text(amount),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                Text(label),
              ],
            )
          ],
        ),
      ),
    );
  }
}
