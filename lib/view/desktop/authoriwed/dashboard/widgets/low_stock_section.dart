import 'package:flutter/material.dart';
import 'package:shop/utils/const_image.dart';

class LowStockSection extends StatelessWidget {
  const LowStockSection({super.key});

  static const _products = [
    {
      'name': 'DAP (18:46:0)',
      'stock': 'Stock: 5 Bags',
      'image': dapImage,
    },
    {
      'name': 'Urea (46% N)',
      'stock': 'Stock: 8 Bags',
      'image': ureaImage,
    },
    {
      'name': 'NPK (19:19:19)',
      'stock': 'Stock: 12 Bags',
      'image': dapImage,
    },
    {
      'name': 'MOP (00:00:60)',
      'stock': 'Stock: 15 Bags',
      'image': ureaImage,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Low Stock Products',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A))),
              TextButton.icon(
                onPressed: () {},
                icon: const Text('View All',
                    style: TextStyle(
                        color: Color(0xFF2E7D32), fontSize: 13)),
                label: const Icon(Icons.arrow_forward,
                    size: 14, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._products.map((p) => _LowStockRow(
                name: p['name']!,
                stock: p['stock']!,
                image: p['image']!,
              )),
          const SizedBox(height: 4),
          const Divider(),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Text('View All Products',
                  style: TextStyle(
                      color: Color(0xFF2E7D32), fontSize: 13)),
              label: const Icon(Icons.arrow_forward,
                  size: 14, color: Color(0xFF2E7D32)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LowStockRow extends StatelessWidget {
  final String name;
  final String stock;
  final String image;

  const _LowStockRow({
    required this.name,
    required this.stock,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          // Product image
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 12),

          // Name + stock
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(stock,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          // View Product button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: const Text('View Product'),
          ),
        ],
      ),
    );
  }
}
