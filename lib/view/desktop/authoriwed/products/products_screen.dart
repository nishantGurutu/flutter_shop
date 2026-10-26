import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  void _showAddProductForm() {
    final nameController = TextEditingController();
    final subtitleController = TextEditingController();
    final priceController = TextEditingController();
    final unitController = TextEditingController();
    final stockController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => FormDialog(
        title: 'Add New Product',
        saveButtonText: 'Create Product',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Product Name',
              hintText: 'Enter product name',
              controller: nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Subtitle',
              hintText: 'Enter product subtitle',
              controller: subtitleController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Category',
              hintText: 'Enter category',
              controller: categoryController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Price',
                    hintText: '₹0',
                    controller: priceController,
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
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Stock Quantity',
              hintText: 'Enter stock quantity',
              controller: stockController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        onSave: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  static const List<Map<String, dynamic>> _products = [
    {
      'id': 'urea_001',
      'name': 'Urea (46% N)',
      'subtitle': 'Nitrogen Fertilizer',
      'price': 266,
      'unit': '45 kg',
      'rating': 4.5,
      'reviewCount': 230,
      'category': 'Fertilizer',
      'inStock': true,
      'discount': 0,
      'stock': 150,
    },
    {
      'id': 'dap_001',
      'name': 'DAP (18:46:0)',
      'subtitle': 'Di-Ammonium Phosphate',
      'price': 1350,
      'unit': '50 kg',
      'rating': 4.6,
      'reviewCount': 180,
      'category': 'Fertilizer',
      'inStock': true,
      'discount': 5,
      'stock': 85,
    },
    {
      'id': 'potash_001',
      'name': 'Potash (MOP)',
      'subtitle': 'Muriate of Potash',
      'price': 720,
      'unit': '50 kg',
      'rating': 4.3,
      'reviewCount': 120,
      'category': 'Fertilizer',
      'inStock': true,
      'discount': 0,
      'stock': 200,
    },
    {
      'id': 'npk_001',
      'name': 'NPK (19:19:19)',
      'subtitle': 'Complete Fertilizer',
      'price': 1450,
      'unit': '50 kg',
      'rating': 4.4,
      'reviewCount': 95,
      'category': 'Fertilizer',
      'inStock': true,
      'discount': 10,
      'stock': 60,
    },
    {
      'id': 'pesticide_001',
      'name': 'Insecticide Pro',
      'subtitle': 'Broad Spectrum',
      'price': 450,
      'unit': '500 ml',
      'rating': 4.2,
      'reviewCount': 85,
      'category': 'Pesticide',
      'inStock': true,
      'discount': 15,
      'stock': 45,
    },
    {
      'id': 'fungicide_001',
      'name': 'Fungicide Guard',
      'subtitle': 'Fungal Control',
      'price': 380,
      'unit': '250 gm',
      'rating': 4.1,
      'reviewCount': 67,
      'category': 'Pesticide',
      'inStock': false,
      'discount': 0,
      'stock': 0,
    },
  ];

  static const List<String> _categories = ['All', 'Fertilizer', 'Pesticide'];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((product) {
      final matchesSearch =
          product['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['subtitle'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesCategory =
          _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

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
                'Products Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddProductForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Add Product',
                  style: TextStyle(fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSearchAndFilters(),
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
                    DataColumn(
                      label: Text(
                        'Product',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Stock',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                  rows: filteredProducts.map((product) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.agriculture,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  Text(
                                    product['subtitle'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product['category'],
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (product['discount'] > 0)
                                Text(
                                  '₹${NumberFormat('#,##0').format(product['price'] * (100 - product['discount']) / 100)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              Text(
                                '₹${NumberFormat('#,##0').format(product['price'])}',
                                style: TextStyle(
                                  decoration: product['discount'] > 0
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: product['discount'] > 0
                                      ? Colors.grey
                                      : null,
                                  fontSize: product['discount'] > 0 ? 12 : 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            '${product['stock']} ${product['unit']}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product['rating']} (${product['reviewCount']})',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: product['inStock']
                                  ? const Color(0xFF2E7D32).withOpacity(0.1)
                                  : const Color(0xFFC62828).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              product['inStock'] ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                color: product['inStock']
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
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
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 18,
                                ),
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

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
