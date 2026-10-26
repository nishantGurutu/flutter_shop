import 'package:flutter/material.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  void _showAddCustomerForm() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => FormDialog(
        title: 'Add New Customer',
        saveButtonText: 'Create Customer',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Customer Name',
              hintText: 'Enter customer name',
              controller: nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              hintText: 'Enter email address',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
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
              label: 'Address',
              hintText: 'Enter address',
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

  static const List<Map<String, dynamic>> _customers = [
    {
      'id': '1',
      'name': 'Ramesh Kumar',
      'email': 'ramesh.kumar@example.com',
      'phone': '+91 98765 43210',
      'address': 'Rampur Kalan, Shahjahanpur, UP',
      'orders': 45,
      'totalSpent': 125800,
      'joinedDate': '2023-06-15',
    },
    {
      'id': '2',
      'name': 'Suresh Singh',
      'email': 'suresh.singh@example.com',
      'phone': '+91 98765 43211',
      'address': 'Bareilly, UP',
      'orders': 32,
      'totalSpent': 89500,
      'joinedDate': '2023-07-22',
    },
    {
      'id': '3',
      'name': 'Rajesh Sharma',
      'email': 'rajesh.sharma@example.com',
      'phone': '+91 98765 43212',
      'address': 'Lucknow, UP',
      'orders': 68,
      'totalSpent': 198200,
      'joinedDate': '2023-05-10',
    },
    {
      'id': '4',
      'name': 'Amit Patel',
      'email': 'amit.patel@example.com',
      'phone': '+91 98765 43213',
      'address': 'Kanpur, UP',
      'orders': 25,
      'totalSpent': 67400,
      'joinedDate': '2023-08-05',
    },
    {
      'id': '5',
      'name': 'Vikram Yadav',
      'email': 'vikram.yadav@example.com',
      'phone': '+91 98765 43214',
      'address': 'Agra, UP',
      'orders': 54,
      'totalSpent': 145600,
      'joinedDate': '2023-04-18',
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
                'Customers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddCustomerForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Add Customer',
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
                        'Email',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Total Spent',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Joined',
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
                  rows: _customers.map((customer) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF2E7D32),
                                child: Text(
                                  customer['name']
                                      .toString()
                                      .split(' ')
                                      .map((e) => e[0])
                                      .take(2)
                                      .join(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                customer['name'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            customer['email'],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Text(
                            customer['phone'],
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${customer['orders']}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        DataCell(
                          Text(
                            '₹${customer['totalSpent']}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            customer['joinedDate'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
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
        _buildStatCard('Total Customers', '856', Colors.blue, Icons.people),
        const SizedBox(width: 16),
        _buildStatCard(
          'Active',
          '720',
          const Color(0xFF2E7D32),
          Icons.check_circle,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'New This Month',
          '42',
          const Color(0xFFF9A825),
          Icons.person_add,
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Total Revenue',
          '₹12.5L',
          Colors.purple,
          Icons.attach_money,
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
}
