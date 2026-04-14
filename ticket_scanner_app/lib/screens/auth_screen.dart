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

  final Color _accentColor = const Color(0xFF7C3AED); // Muted Purple
  final Color _textPrimary = const Color(0xFF1E293B); // Dark Slate
  final Color _placeholderColor = const Color(0xFF94A3B8); // Soft Gray
  final Color _bgColor = const Color(0xFFF8FAFC); // Very Soft Off-White

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
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: -5,
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
                                : const Alignment(-0.35, 1.0), // Approximate for 2 tabs
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: 60, // Width of underline
                                  height: 2,
                                  margin: const EdgeInsets.only(left: 30), // Padding to align under text
                                  decoration: BoxDecoration(
                                    color: _accentColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }
                            ),
                          ),
                          // Full width gray underline
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey.withValues(alpha: 0.1),
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
              
              const SizedBox(height: 24),
              // Subtle Decor
              Opacity(
                opacity: 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: _textPrimary, shape: BoxShape.circle),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool isActive = _tabController.index == index;
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
              color: isActive ? _accentColor : _placeholderColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('LoginForm'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your credentials to continue',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: _placeholderColor,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _loginEmailCtrl,
            label: 'Email',
            hint: 'name@example.com',
            icon: Icons.alternate_email,
            validator: Validator.email,
          ),
          const SizedBox(height: 16),
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
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: _accentColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      onChanged: (v) => setState(() => _rememberMe = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember me',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _textPrimary),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot password?',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('Sign in', _handleLogin),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.1))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Or continue with',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: _placeholderColor),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.withValues(alpha: 0.1))),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon('assets/icons/google.png', Colors.red.withValues(alpha: 0.05)),
              const SizedBox(width: 20),
              _socialIcon('assets/icons/apple.png', Colors.black.withValues(alpha: 0.05)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('RegisterForm'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create an account',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(
            controller: _regNameCtrl,
            label: 'Full Name',
            hint: 'Your full name',
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
            hint: 'Create a password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validator.password,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _regConfirmPassCtrl,
            label: 'Confirm Password',
            hint: 'Check your password',
            icon: Icons.lock_reset,
            isPassword: true,
            validator: (v) => Validator.confirmPassword(v, _regPassCtrl.text),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agreeTerms,
                  activeColor: _accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'I agree to the Terms & Conditions',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActionButton('Sign up', _handleRegister),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(0),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, color: _placeholderColor),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(color: _accentColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          cursorColor: _accentColor,
          style: GoogleFonts.plusJakartaSans(fontSize: 15, color: _textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(color: _placeholderColor, fontSize: 13),
            prefixIcon: Icon(icon, color: _placeholderColor, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: _accentColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            ),
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
          height: 48,
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            ).copyWith(
              elevation: WidgetStateProperty.resolveWith<double>((states) {
                if (states.contains(WidgetState.hovered)) return 4;
                return 0;
              }),
            ),
            child: auth.isLoading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      }
    );
  }

  Widget _socialIcon(String asset, Color color) {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: const Icon(Icons.star_outline, size: 24, color: Colors.grey), // Mock icons for now
    );
  }
}

