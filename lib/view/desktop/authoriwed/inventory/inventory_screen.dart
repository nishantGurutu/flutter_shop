import 'package:flutter/material.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  void _showAddStockForm() {
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => FormDialog(
        title: 'Add Stock',
        saveButtonText: 'Add Stock',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Product',
              hintText: 'Select or enter product name',
              controller: productController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Quantity',
                    hintText: 'Enter quantity',
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    label: 'Unit',
                    hintText: 'e.g., 50 kg',
                    controller: unitController,
                  ),
                ),
              ],
            ),
          ],
        ),
        onSave: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  static const List<Map<String, dynamic>> _inventory = [
    {
      'product': 'Urea (46% N)',
      'sku': 'SKU-001',
      'category': 'Fertilizer',
      'currentStock': 150,
      'minStock': 50,
      'unit': '45 kg',
      'status': 'in_stock',
    },
    {
      'product': 'DAP (18:46:0)',
      'sku': 'SKU-002',
      'category': 'Fertilizer',
      'currentStock': 35,
      'minStock': 40,
      'unit': '50 kg',
      'status': 'low_stock',
    },
    {
      'product': 'Potash (MOP)',
      'sku': 'SKU-003',
      'category': 'Fertilizer',
      'currentStock': 200,
      'minStock': 50,
      'unit': '50 kg',
      'status': 'in_stock',
    },
    {
      'product': 'NPK (19:19:19)',
      'sku': 'SKU-004',
      'category': 'Fertilizer',
      'currentStock': 12,
      'minStock': 30,
      'unit': '50 kg',
      'status': 'out_of_stock',
    },
    {
      'product': 'Insecticide Pro',
      'sku': 'SKU-005',
      'category': 'Pesticide',
      'currentStock': 45,
      'minStock': 20,
      'unit': '500 ml',
      'status': 'in_stock',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F6FA),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inventory Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddStockForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Stock', style: TextStyle(fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStats(),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Product', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('SKU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Current Stock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Min Stock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Action', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                  ],
                  rows: _inventory.map((item) {
                    Color statusColor;
                    String statusText;
                    switch (item['status']) {
                      case 'in_stock':
                        statusColor = const Color(0xFF2E7D32);
                        statusText = 'In Stock';
                        break;
                      case 'low_stock':
                        statusColor = const Color(0xFFF9A825);
                        statusText = 'Low Stock';
                        break;
                      case 'out_of_stock':
                        statusColor = const Color(0xFFC62828);
                        statusText = 'Out of Stock';
                        break;
                      default:
                        statusColor = Colors.grey;
                        statusText = 'Unknown';
                    }
                    return DataRow(
                      cells: [
                        DataCell(Text(item['product'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)))),
                        DataCell(Text(item['sku'], style: TextStyle(color: Colors.grey[600], fontSize: 12))),
                        DataCell(Text(item['category'], style: const TextStyle(fontSize: 13))),
                        DataCell(
                          Text(
                            '${item['currentStock']} ${item['unit']}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(Text('${item['minStock']} ${item['unit']}', style: const TextStyle(fontSize: 13))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.history, color: Colors.orange, size: 18),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatCard('Total Products', '128', Colors.blue, Icons.inventory),
        const SizedBox(width: 16),
        _buildStatCard('In Stock', '115', const Color(0xFF2E7D32), Icons.check_circle),
        const SizedBox(width: 16),
        _buildStatCard('Low Stock', '8', const Color(0xFFF9A825), Icons.warning),
        const SizedBox(width: 16),
        _buildStatCard('Out of Stock', '5', const Color(0xFFC62828), Icons.cancel),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
