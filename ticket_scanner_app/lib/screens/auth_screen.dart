import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../core/utils/snackbar_helper.dart';
import '../core/utils/validator.dart';

class AuthScreen extends StatefulWidget {
  final bool initialIsRegister;
  const AuthScreen({super.key, this.initialIsRegister = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  // Login controllers
  final _loginEmailCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();

  // Register controllers
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regConfirmPassCtrl = TextEditingController();

  bool _rememberMe = false;
  bool _agreeTerms = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIsRegister ? 1 : 0,
    );
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPassCtrl.dispose();
    _regNameCtrl.dispose();
    _regEmailCtrl.dispose();
    _regPassCtrl.dispose();
    _regConfirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(_loginEmailCtrl.text.trim(), _loginPassCtrl.text);
    if (mounted) {
      if (success) context.go('/home');
      else SnackBarHelper.error(context, auth.error ?? 'Login failed');
    }
  }

  Future<void> _handleRegister() async {
    if (!_registerFormKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      SnackBarHelper.error(context, 'Please agree to terms & conditions');
      return;
    }
    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _regNameCtrl.text.trim(),
      email: _regEmailCtrl.text.trim(),
      password: _regPassCtrl.text,
      role: 'attendee',
    );
    if (mounted) {
      if (success) context.go('/home');
      else SnackBarHelper.error(context, auth.error ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo placeholder
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.qr_code_scanner, color: theme.primaryColor, size: 36),
              ),
              const SizedBox(height: 32),

              // Unified Card
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 440),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Custom Tab Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Row(
                            children: [
                              _buildTab('Login', 0),
                              _buildTab('Register', 1),
                            ],
                          ),
                          // Animated Indicator
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            alignment: _tabController.index == 0
                                ? Alignment.bottomLeft
                                : const Alignment(-0.35, 1.0),
                            child: Container(
                              width: 60,
                              height: 3,
                              margin: const EdgeInsets.only(left: 30),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Full width gray underline
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey.withValues(alpha: 0.05),
                          ),
                        ],
                      ),
                    ),

                    // Form Content
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.05),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _tabController.index == 0 ? _buildLoginForm() : _buildRegisterForm(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              Text(
                '© 2026 Ticket Scanner. Modern Event Management.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isActive = _tabController.index == index;
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: () => _tabController.animateTo(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? theme.primaryColor : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final theme = Theme.of(context);
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('LoginForm'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Keep your tickets organized and always ready.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _loginEmailCtrl,
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.alternate_email,
            validator: Validator.email,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _loginPassCtrl,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validator.password,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                  ),
                  Text('Remember me', style: theme.textTheme.bodySmall),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Forgot?', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('Sign in', _handleLogin),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade100)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('OR', style: theme.textTheme.bodySmall),
              ),
              Expanded(child: Divider(color: Colors.grey.shade100)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.g_mobiledata, Colors.red.withValues(alpha: 0.1)),
              const SizedBox(width: 20),
              _socialIcon(Icons.apple, Colors.black.withValues(alpha: 0.1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    final theme = Theme.of(context);
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('RegisterForm'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Join Us', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Create your account to start scanning tickets.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _regNameCtrl,
            label: 'Full Name',
            hint: 'Your Name',
            icon: Icons.person_outline,
            validator: Validator.name,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _regEmailCtrl,
            label: 'Email Address',
            hint: 'name@example.com',
            icon: Icons.alternate_email,
            validator: Validator.email,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _regPassCtrl,
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validator.password,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _regConfirmPassCtrl,
            label: 'Confirm Password',
            hint: '••••••••',
            icon: Icons.lock_reset,
            isPassword: true,
            validator: (v) => Validator.confirmPassword(v, _regPassCtrl.text),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                activeColor: theme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                onChanged: (v) => setState(() => _agreeTerms = v ?? false),
              ),
              Expanded(
                child: Text('I agree to the Terms', style: theme.textTheme.bodySmall),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('Sign up', _handleRegister),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : onPressed,
            child: auth.isLoading
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(label),
          ),
        );
      }
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Icon(icon, size: 28, color: Colors.grey.shade700),
    );
  }
}

