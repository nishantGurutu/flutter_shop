import 'package:flutter/material.dart';
import 'package:shop/utils/extensions/text_extension.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text("© 2026 Krishi Saathi", style: context.h2),
    );
  }
}
