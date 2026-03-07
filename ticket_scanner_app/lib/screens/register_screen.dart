import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_button.dart';
import '../widgets/input_field.dart';
import '../core/utils/validator.dart';
import '../core/utils/snackbar_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  String _role = 'attendee';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      role: _role,
    );

    if (mounted) {
      if (success) {
        context.go('/home');
      } else {
        SnackBarHelper.error(context, auth.error ?? 'Registration failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A237E)),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account 🎫',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 6),
              Text(
                'Register to start booking event tickets.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppInputField(
                      label: 'Full Name',
                      controller: _nameCtrl,
                      icon: Icons.person_outline,
                      validator: Validator.name,
                    ),
                    const SizedBox(height: 14),
                    AppInputField(
                      label: 'Email',
                      controller: _emailCtrl,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.email,
                    ),
                    const SizedBox(height: 14),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return AppInputField(
                          label: 'Password',
                          controller: _passCtrl,
                          icon: Icons.lock_outline,
                          obscure: auth.isObscure,
                          suffix: IconButton(
                            icon: Icon(auth.isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: auth.toggleObscure,
                          ),
                          validator: Validator.password,
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return AppInputField(
                          label: 'Confirm Password',
                          controller: _confirmPassCtrl,
                          icon: Icons.lock_reset,
                          obscure: auth.isObscureConfirm,
                          suffix: IconButton(
                            icon: Icon(auth.isObscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: auth.toggleObscureConfirm,
                          ),
                          validator: (v) =>
                              Validator.confirmPassword(v, _passCtrl.text),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Role selector
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.badge_outlined,
                              color: Color(0xFF1A237E)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _role,
                                items: const [
                                  DropdownMenuItem(
                                      value: 'attendee',
                                      child: Text('Attendee')),
                                  DropdownMenuItem(
                                      value: 'admin', child: Text('Admin')),
                                ],
                                onChanged: (v) =>
                                    setState(() => _role = v ?? 'attendee'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => LoadingButton(
                        label: 'Register',
                        isLoading: auth.isLoading,
                        onPressed: auth.isLoading ? null : _submit,
                        icon: Icons.how_to_reg,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ',
                            style: TextStyle(color: Colors.grey.shade600)),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text('Sign In',
                              style: TextStyle(
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
