import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  bool _animate = false; // نستخدمها لتشغيل الأنيميشن بعد أول فريم

  @override
  void initState() {
    super.initState();

    // نفعّل الأنيميشن بعد ما تبني الشاشة أول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _animate = true);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() => _loading = false);

      if (result['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // ويدجت تساعدنا نعمل Slide + Fade لأي جزء مع انيميشن
 Widget _animatedSection({
  required int index,
  required Widget child,
}) {
  final delay = 80 * index;

  return TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 40.0, end: 0.0),
    duration: Duration(milliseconds: 550 + delay),
    curve: Curves.easeOutCubic,
    builder: (context, double value, childWidget) {
      // value من 40 → 0
      final double opacity =
          _animate ? 1.0 - (value / 40.0).clamp(0.0, 1.0) : 0.0;

      final double offsetY = _animate ? value : 40.0;

      return Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: childWidget,
        ),
      );
    },
    child: child,
  );
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6750F3),
              Color(0xFF9575FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // دوائر شفافة كخلفية
              Positioned(
                top: -40,
                right: -30,
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -40,
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ───── Logo / Title ─────
                      _animatedSection(
                        index: 0,
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                'assets/images/default_service.jpg',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Bookly Pro',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'سجل دخولك واحجز خدمتك خلال ثواني ✨',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ───── Card ─────
                      _animatedSection(
                        index: 1,
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.fromLTRB(20, 20, 20, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 20,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'تسجيل الدخول',
                                    style: theme.textTheme.titleLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'أهلاً برجوعك 👋',
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Email
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType:
                                      TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'الإيميل',
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'الإيميل مطلوب';
                                    }
                                    if (!v.contains('@')) {
                                      return 'أدخل إيميل صحيح';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),

                                // Password
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    labelText: 'كلمة المرور',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons
                                                .visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                      onPressed: () => setState(
                                          () => _obscure = !_obscure),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'كلمة المرور مطلوبة';
                                    }
                                    if (v.length < 6) {
                                      return 'الحد الأدنى 6 أحرف';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 8),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'نسيت كلمة المرور؟',
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: const Color(0xFF6750F3),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18),
                                      ),
                                      backgroundColor:
                                          const Color(0xFF6750F3),
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: _loading ? null : _login,
                                    child: _loading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'تسجيل الدخول',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ───── Register link ─────
                      _animatedSection(
                        index: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ما عندك حساب؟',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'أنشئ حساب جديد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
