import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/loading_button.dart';
import '../widgets/error_card.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.qr_code_scanner,
                      size: 44, color: Colors.white),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Welcome Back 👋',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in to manage your event tickets.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),

              // Error
              Consumer<AuthProvider>(
                builder: (_, auth, __) {
                  if (auth.error == null) return const SizedBox.shrink();
                  return Column(
                    children: [
                      ErrorCard(
                        message: auth.error!,
                        onDismiss: auth.clearError,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppInputField(
                      label: 'Email',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppInputField(
                      label: 'Password',
                      controller: _passCtrl,
                      obscure: _obscure,
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                            _obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Password is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => LoadingButton(
                        label: 'Sign In',
                        isLoading: auth.isLoading,
                        onPressed: _submit,
                        icon: Icons.login,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/register'),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Color(0xFF1A237E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
