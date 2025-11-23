import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/models/user.dart';
import 'package:workzen/providers/employee_provider.dart';

class EmployeeDetailPage extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailPage({super.key, required this.employeeId});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _basicSalaryController;
  late TextEditingController _pfRateController;
  late TextEditingController _ptRateController;
  late TextEditingController _bankAccountController;
  late TextEditingController _bankNameController;
  late TextEditingController _ifscCodeController;

  bool _isEditing = false;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(
        context,
        listen: false,
      ).getEmployeeById(widget.employeeId);
    });
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _basicSalaryController = TextEditingController();
    _pfRateController = TextEditingController();
    _ptRateController = TextEditingController();
    _bankAccountController = TextEditingController();
    _bankNameController = TextEditingController();
    _ifscCodeController = TextEditingController();
  }

  void _populateControllers(User employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
    _emailController.text = employee.email;
    _phoneController.text = employee.phone ?? '';
    _addressController.text = employee.address ?? '';
    _cityController.text = employee.city ?? '';
    _stateController.text = employee.state ?? '';
    _zipCodeController.text = employee.zipCode ?? '';
    _basicSalaryController.text = employee.basicSalary?.toString() ?? '';
    _pfRateController.text = employee.pfRate?.toString() ?? '';
    _ptRateController.text = employee.ptRate?.toString() ?? '';
    _bankAccountController.text = employee.bankAccount ?? '';
    _bankNameController.text = employee.bankName ?? '';
    _ifscCodeController.text = employee.ifscCode ?? '';
    _selectedRole = employee.role.toString().split('.').last;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _basicSalaryController.dispose();
    _pfRateController.dispose();
    _ptRateController.dispose();
    _bankAccountController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    final employee = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    ).currentEmployee;

    if (employee == null) return;

    try {
      final updatedEmployee = employee.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        address: _addressController.text.isEmpty
            ? null
            : _addressController.text,
        city: _cityController.text.isEmpty ? null : _cityController.text,
        state: _stateController.text.isEmpty ? null : _stateController.text,
        zipCode: _zipCodeController.text.isEmpty
            ? null
            : _zipCodeController.text,
        basicSalary: _basicSalaryController.text.isEmpty
            ? null
            : double.tryParse(_basicSalaryController.text),
        pfRate: _pfRateController.text.isEmpty
            ? null
            : double.tryParse(_pfRateController.text),
        ptRate: _ptRateController.text.isEmpty
            ? null
            : double.tryParse(_ptRateController.text),
        bankAccount: _bankAccountController.text.isEmpty
            ? null
            : _bankAccountController.text,
        bankName: _bankNameController.text.isEmpty
            ? null
            : _bankNameController.text,
        ifscCode: _ifscCodeController.text.isEmpty
            ? null
            : _ifscCodeController.text,
      );

      final success = await Provider.of<EmployeeProvider>(
        context,
        listen: false,
      ).updateEmployee(employee.userId, updatedEmployee);

      if (success) {
        setState(() => _isEditing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee updated successfully')),
          );
        }
      } else {
        if (mounted) {
          final error = Provider.of<EmployeeProvider>(
            context,
            listen: false,
          ).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update employee: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        elevation: 0,
        actions: [
          if (!_isEditing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final employee = Provider.of<EmployeeProvider>(
                      context,
                      listen: false,
                    ).currentEmployee;
                    if (employee != null) {
                      _populateControllers(employee);
                      setState(() => _isEditing = true);
                    }
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _isEditing = false),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveEmployee,
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, _) {
          if (employeeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final employee = employeeProvider.currentEmployee;

          if (employee == null) {
            return Center(
              child: Text(
                employeeProvider.errorMessage ?? 'Employee not found',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          if (!_isEditing && _firstNameController.text.isEmpty) {
            _populateControllers(employee);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information Section
                _buildSection(context, 'Personal Information', [
                  _buildTextField(
                    'First Name',
                    _firstNameController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Last Name',
                    _lastNameController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Email',
                    _emailController,
                    enabled: false, // Email typically shouldn't be editable
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Phone',
                    _phoneController,
                    enabled: _isEditing,
                  ),
                ]),
                const SizedBox(height: 32),

                // Address Section
                _buildSection(context, 'Address', [
                  _buildTextField(
                    'Address',
                    _addressController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('City', _cityController, enabled: _isEditing),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'State',
                    _stateController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Zip Code',
                    _zipCodeController,
                    enabled: _isEditing,
                  ),
                ]),
                const SizedBox(height: 32),

                // Employment Information Section
                _buildSection(context, 'Employment Information', [
                  if (!_isEditing)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildReadOnlyField(
                        'Role',
                        _selectedRole ?? 'N/A',
                        context,
                      ),
                    ),
                  _buildTextField(
                    'Basic Salary',
                    _basicSalaryController,
                    enabled: _isEditing,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'PF Rate (%)',
                    _pfRateController,
                    enabled: _isEditing,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'PT Rate (%)',
                    _ptRateController,
                    enabled: _isEditing,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ]),
                const SizedBox(height: 32),

                // Bank Information Section
                _buildSection(context, 'Bank Information', [
                  _buildTextField(
                    'Bank Account Number',
                    _bankAccountController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Bank Name',
                    _bankNameController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'IFSC Code',
                    _ifscCodeController,
                    enabled: _isEditing,
                  ),
                ]),
                const SizedBox(height: 32),

                // Additional Information
                _buildSection(context, 'Additional Information', [
                  _buildReadOnlyField('Employee ID', employee.userId, context),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'Joined Date',
                    employee.createdAt.toString().split(' ')[0],
                    context,
                  ),
                  const SizedBox(height: 16),
                  _buildReadOnlyField(
                    'Last Updated',
                    employee.updatedAt.toString().split(' ')[0],
                    context,
                  ),
                ]),
                const SizedBox(height: 32),

                // Delete Button
                if (_isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showDeleteConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Delete Employee',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text(
          'Are you sure you want to delete this employee? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _deleteEmployee();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEmployee() async {
    final employee = Provider.of<EmployeeProvider>(
      context,
      listen: false,
    ).currentEmployee;

    if (employee == null) return;

    try {
      final success = await Provider.of<EmployeeProvider>(
        context,
        listen: false,
      ).deleteEmployee(employee.userId);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee deleted successfully')),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting employee: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
