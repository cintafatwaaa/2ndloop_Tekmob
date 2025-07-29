import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _selectedRole = 'seller';

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA68E73), // warna latar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ---------- Logo ----------
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo-2ndloop.png',
                      width: MediaQuery.of(context).size.width * 0.35,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                const Text(
                  'Create New Account',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 30),

                // ---------- Input fields ----------
                _buildLabel("Name/Shop Name"),
                _buildInputField(_nameController, "Enter your name/shop name"),
                const SizedBox(height: 16),

                _buildLabel("Username"),
                _buildInputField(_usernameController, "Enter your username"),
                const SizedBox(height: 16),

                _buildLabel("Email Address"),
                _buildInputField(
                  _emailController,
                  "Enter your email address",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                _buildLabel("Password"),
                _buildPasswordField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  isVisible: _isPasswordVisible,
                  onToggle:
                      () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                ),
                const SizedBox(height: 16),

                _buildLabel("Confirm Password"),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: "Enter your confirm password",
                  isVisible: _isConfirmPasswordVisible,
                  onToggle:
                      () => setState(
                        () =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible,
                      ),
                ),
                const SizedBox(height: 24),

                // ---------- Role selection ----------
                Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'seller',
                          groupValue: _selectedRole,
                          onChanged: (v) => setState(() => _selectedRole = v!),
                          title: const Text(
                            'seller/shop',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'admin',
                          groupValue: _selectedRole,
                          onChanged: (v) => setState(() => _selectedRole = v!),
                          title: const Text(
                            'Admin',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ---------- Sign‑Up button ----------
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return ElevatedButton(
                        onPressed:
                            authProvider.isLoading
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Validate password confirmation
                                    if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Password tidak cocok'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    final success = await authProvider.signUp(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      name: _nameController.text.trim(),
                                      username: _usernameController.text.trim(),
                                      role: _selectedRole,
                                    );

                                    if (success && mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Akun berhasil dibuat! Silakan login.',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      context.go('/login');
                                    } else if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            authProvider.errorMessage ??
                                                'Gagal membuat akun',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFA68E73),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 0,
                        ),
                        child:
                            authProvider.isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFA68E73),
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Sign Up',
                                  style: TextStyle(fontSize: 16),
                                ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ---------- Back to Login ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        "Back to Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- helper widgets ----------
  Widget _buildLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 14),
    ),
  );

  Widget _buildInputField(
    TextEditingController controller,
    String hintText, {
    TextInputType? keyboardType,
  }) {
    return Container(
      color: Colors.white, // kotak polos tanpa border radius
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      color: Colors.white, // kotak polos tanpa border radius
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
