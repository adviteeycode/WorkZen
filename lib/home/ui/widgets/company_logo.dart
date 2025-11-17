import 'package:flutter/material.dart';

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text("WorkZen", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(width: 8),
          Image.network(
            "https://png.pngtree.com/png-clipart/20190604/original/pngtree-creative-company-logo-png-image_1197025.jpg",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
