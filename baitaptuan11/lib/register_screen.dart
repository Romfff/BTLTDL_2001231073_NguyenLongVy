import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_scaffold.dart';
import 'dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2004),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': _fullNameController.text.trim(),
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
          'phoneNumber': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'email': _emailController.text.trim(),
          'dateOfBirth': _dobController.text.trim(),
        }),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        await showMessageDialog(
          context,
          title: 'Thanh cong',
          message: 'Dang ky thanh cong. Vui long dang nhap.',
        );
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        await showMessageDialog(
          context,
          title: 'Loi',
          message: 'Ten dang nhap hoac email da ton tai',
        );
      }
    } catch (e) {
      if (!mounted) return;
      await showMessageDialog(
        context,
        title: 'Loi',
        message: 'Da xay ra loi: $e',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _fullNameController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _phoneController.clear();
    _addressController.clear();
    _emailController.clear();
    _dobController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Dang ky',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              _textField(_fullNameController, 'Ho va ten', Icons.person),
              _textField(
                _usernameController,
                'Ten dang nhap',
                Icons.person_outline,
              ),
              _passwordField(_passwordController, 'Mat khau'),
              _passwordField(
                _confirmPasswordController,
                'Nhap lai mat khau',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui long nhap lai mat khau';
                  }
                  if (value != _passwordController.text) {
                    return 'Mat khau nhap lai khong khop';
                  }
                  return null;
                },
              ),
              _textField(
                _phoneController,
                'So dien thoai',
                Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui long nhap so dien thoai';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
                    return 'So dien thoai khong hop le';
                  }
                  return null;
                },
              ),
              _textField(_addressController, 'Dia chi', Icons.home),
              _textField(
                _emailController,
                'Email',
                Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui long nhap email';
                  }
                  if (!RegExp(
                    r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value.trim())) {
                    return 'Email khong hop le';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    labelText: 'Ngay sinh',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui long nhap ngay sinh'
                      : null,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Dang ky'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _resetForm,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        keyboardType: keyboardType,
        validator:
            validator ??
            (value) => value == null || value.trim().isEmpty
                ? 'Vui long nhap $label'
                : null,
      ),
    );
  }

  Widget _passwordField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return _textField(
      controller,
      label,
      Icons.lock,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Vui long nhap mat khau';
            }
            if (!RegExp(
              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$',
            ).hasMatch(value)) {
              return 'Mat khau phai co chu cai, so va ky tu dac biet';
            }
            return null;
          },
    );
  }
}
