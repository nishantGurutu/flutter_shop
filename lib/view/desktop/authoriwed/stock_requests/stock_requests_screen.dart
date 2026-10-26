import 'package:flutter/material.dart';
import 'package:shop/view/desktop/widget/form_dialog.dart';

class StockRequestsScreen extends StatefulWidget {
  const StockRequestsScreen({super.key});

  @override
  State<StockRequestsScreen> createState() => _StockRequestsScreenState();
}

class _StockRequestsScreenState extends State<StockRequestsScreen> {
  String _selectedFilter = 'All';

  void _showAddStockRequestForm() {
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();
    final priorityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => FormDialog(
        title: 'New Stock Request',
        saveButtonText: 'Submit Request',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              label: 'Priority',
              hintText: 'High, Medium, Low',
              controller: priorityController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Reason',
              hintText: 'Enter reason for request',
              controller: reasonController,
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

  static const List<Map<String, dynamic>> _requests = [
    {
      'id': 'REQ-001',
      'product': 'Urea (46% N)',
      'requestedBy': 'Ramesh Kumar',
      'quantity': 100,
      'unit': '45 kg',
      'requestDate': '2024-05-10',
      'expectedDate': '2024-05-15',
      'status': 'pending',
      'priority': 'high',
    },
    {
      'id': 'REQ-002',
      'product': 'DAP (18:46:0)',
      'requestedBy': 'Suresh Singh',
      'quantity': 50,
      'unit': '50 kg',
      'requestDate': '2024-05-08',
      'expectedDate': '2024-05-12',
      'status': 'approved',
      'priority': 'medium',
    },
    {
      'id': 'REQ-003',
      'product': 'Potash (MOP)',
      'requestedBy': 'Rajesh Sharma',
      'quantity': 80,
      'unit': '50 kg',
      'requestDate': '2024-05-05',
      'expectedDate': '2024-05-10',
      'status': 'completed',
      'priority': 'low',
    },
    {
      'id': 'REQ-004',
      'product': 'NPK (19:19:19)',
      'requestedBy': 'Amit Patel',
      'quantity': 40,
      'unit': '50 kg',
      'requestDate': '2024-05-09',
      'expectedDate': '2024-05-14',
      'status': 'rejected',
      'priority': 'high',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRequests = _selectedFilter == 'All'
        ? _requests
        : _requests.where((r) => r['status'] == _selectedFilter.toLowerCase()).toList();

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
                'Stock Requests',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showAddStockRequestForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Request', style: TextStyle(fontSize: 13)),
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
          _buildFilters(),
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
                    DataColumn(label: Text('Request ID', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Product', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Requested By', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Quantity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Request Date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Priority', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                    DataColumn(label: Text('Action', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey))),
                  ],
                  rows: filteredRequests.map((request) {
                    Color statusColor;
                    String statusText;
                    switch (request['status']) {
                      case 'pending':
                        statusColor = const Color(0xFFF9A825);
                        statusText = 'Pending';
                        break;
                      case 'approved':
                        statusColor = Colors.blue;
                        statusText = 'Approved';
                        break;
                      case 'completed':
                        statusColor = const Color(0xFF2E7D32);
                        statusText = 'Completed';
                        break;
                      case 'rejected':
                        statusColor = const Color(0xFFC62828);
                        statusText = 'Rejected';
                        break;
                      default:
                        statusColor = Colors.grey;
                        statusText = 'Unknown';
                    }
                    Color priorityColor;
                    String priorityText;
                    switch (request['priority']) {
                      case 'high':
                        priorityColor = const Color(0xFFC62828);
                        priorityText = 'High';
                        break;
                      case 'medium':
                        priorityColor = const Color(0xFFF9A825);
                        priorityText = 'Medium';
                        break;
                      case 'low':
                        priorityColor = const Color(0xFF2E7D32);
                        priorityText = 'Low';
                        break;
                      default:
                        priorityColor = Colors.grey;
                        priorityText = 'Unknown';
                    }
                    return DataRow(
                      cells: [
                        DataCell(Text(request['id'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)))),
                        DataCell(Text(request['product'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text(request['requestedBy'], style: const TextStyle(fontSize: 13))),
                        DataCell(Text('${request['quantity']} ${request['unit']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                        DataCell(Text(request['requestDate'], style: TextStyle(color: Colors.grey[600], fontSize: 12))),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              priorityText,
                              style: TextStyle(
                                color: priorityColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          request['status'] == 'pending'
                              ? Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 18),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel, color: Color(0xFFC62828), size: 18),
                                      onPressed: () {},
                                    ),
                                  ],
                                )
                              : IconButton(
                                  icon: const Icon(Icons.visibility, color: Colors.blue, size: 18),
                                  onPressed: () {},
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

  Widget _buildFilters() {
    final filters = ['All', 'Pending', 'Approved', 'Completed', 'Rejected'];
    return Row(
      children: filters.map((filter) {
        final isSelected = _selectedFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FilterChip(
            label: Text(filter, style: TextStyle(fontSize: 13)),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              }
            },
            selectedColor: const Color(0xFF2E7D32).withOpacity(0.1),
            checkmarkColor: const Color(0xFF2E7D32),
            backgroundColor: Colors.grey[100],
            side: BorderSide.none,
          ),
        );
      }).toList(),
    );
  }
}
