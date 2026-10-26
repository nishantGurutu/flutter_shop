import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _selectedFilter = 'All';

  void _showAddOrderForm() {
    final customerController = TextEditingController();
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => FormDialog(
        title: 'Add New Order',
        saveButtonText: 'Create Order',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Customer Name',
              hintText: 'Enter customer name',
              controller: customerController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              hintText: 'Enter phone number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Product',
              hintText: 'Enter product name',
              controller: productController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Quantity',
              hintText: 'Enter quantity',
              controller: quantityController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Delivery Address',
              hintText: 'Enter delivery address',
              controller: addressController,
              maxLines: 3,
            ),
          ],
        ),
        onSave: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  static const List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-784512',
      'orderDate': '2024-05-01T10:30:00',
      'status': 'delivered',
      'totalAmount': 2660,
      'items': [
        {'name': 'Urea (46% N)', 'quantity': 10, 'price': 266},
      ],
      'customer': 'Ramesh Kumar',
      'paymentMethod': 'Cash on Delivery',
    },
    {
      'id': 'ORD-784513',
      'orderDate': '2024-04-28T14:15:00',
      'status': 'onTheWay',
      'totalAmount': 1350,
      'items': [
        {'name': 'DAP (18:46:0)', 'quantity': 1, 'price': 1350},
      ],
      'customer': 'Suresh Singh',
      'paymentMethod': 'UPI',
    },
    {
      'id': 'ORD-784514',
      'orderDate': '2024-04-25T09:00:00',
      'status': 'confirmed',
      'totalAmount': 2170,
      'items': [
        {'name': 'Potash (MOP)', 'quantity': 1, 'price': 720},
        {'name': 'NPK (19:19:19)', 'quantity': 1, 'price': 1450},
      ],
      'customer': 'Rajesh Sharma',
      'paymentMethod': 'Cash on Delivery',
    },
    {
      'id': 'ORD-784515',
      'orderDate': '2024-04-20T16:45:00',
      'status': 'cancelled',
      'totalAmount': 450,
      'items': [
        {'name': 'Insecticide Pro', 'quantity': 1, 'price': 450},
      ],
      'customer': 'Amit Patel',
      'paymentMethod': 'UPI',
    },
    {
      'id': 'ORD-784516',
      'orderDate': '2024-05-02T11:20:00',
      'status': 'processing',
      'totalAmount': 266,
      'items': [
        {'name': 'Urea (46% N)', 'quantity': 1, 'price': 266},
      ],
      'customer': 'Vikram Yadav',
      'paymentMethod': 'Cash on Delivery',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return const Color(0xFF2E7D32);
      case 'onTheWay':
        return const Color(0xFF1565C0);
      case 'confirmed':
        return const Color(0xFF8BC34A);
      case 'processing':
        return const Color(0xFFF9A825);
      case 'cancelled':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'delivered':
        return 'Delivered';
      case 'onTheWay':
        return 'On the Way';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Processing';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _selectedFilter == 'All'
        ? _orders
        : _orders.where((o) => o['status'] == _selectedFilter).toList();

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
                'Orders Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddOrderForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Order', style: TextStyle(fontSize: 13)),
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
          _buildStats(),
          const SizedBox(height: 24),
          _buildFilters(),
          const SizedBox(height: 20),
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
                        'Order ID',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Customer',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Items',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Payment',
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
                  rows: filteredOrders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            order['id'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            order['customer'],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Text(
                            DateFormat(
                              'dd MMM yyyy, hh:mm a',
                            ).format(DateTime.parse(order['orderDate'])),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${order['items'].length} item(s)',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Text(
                            '₹${NumberFormat('#,##0').format(order['totalAmount'])}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            order['paymentMethod'],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                order['status'],
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getStatusText(order['status']),
                              style: TextStyle(
                                color: _getStatusColor(order['status']),
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
        _buildStatCard(
          'Total Orders',
          '1,248',
          Colors.blue,
          Icons.receipt_long,
        ),
        const SizedBox(width: 16),
        _buildStatCard('Pending', '86', const Color(0xFFF9A825), Icons.pending),
        const SizedBox(width: 16),
        _buildStatCard(
          'Delivered',
          '1,102',
          const Color(0xFF2E7D32),
          Icons.check_circle,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Cancelled',
          '60',
          const Color(0xFFC62828),
          Icons.cancel,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
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

  Widget _buildFilters() {
    final filters = [
      'All',
      'processing',
      'confirmed',
      'onTheWay',
      'delivered',
      'cancelled',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                filter == 'All' ? 'All Orders' : _getStatusText(filter),
                style: const TextStyle(fontSize: 13),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: const Color(0xFF2E7D32).withOpacity(0.1),
              checkmarkColor: const Color(0xFF2E7D32),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF2E7D32)
                      : Colors.grey[300]!,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
