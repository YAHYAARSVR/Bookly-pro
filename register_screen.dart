import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();

  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final result = await AuthService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      passwordConfirmation: _password2Controller.text.trim(),
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحساب بنجاح 🎉')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Registration failed')),
      );
    }
  }

  /// ويدجت صغيرة نعيد استخدامها لعمل فِيد + سلايد لكل قسم
 Widget _fadeSlide({
  required Widget child,
  required int index,
}) {
  const double startOffset = 26.0;

  return TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: startOffset, end: 0.0),
    duration: Duration(milliseconds: 420 + (index * 90)),
    curve: Curves.easeOutCubic,
    builder: (context, value, _) {
      // value: 26 -> 0
      final double t = (value / startOffset).clamp(0.0, 1.0);
      final double opacity = 1 - t;

      return Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, value),
          child: child,
        ),
      );
    },
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
              Color(0xFF9575FF),
              Color(0xFF6750F3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                children: [
                  // زر الرجوع دائري فوق
                  _fadeSlide(
                    index: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // الهيدر (الصورة + النص)
                  _fadeSlide(
                    index: 1,
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          backgroundImage: AssetImage(
                            'assets/images/spa.jpg', // تأكد إن المسار صح في pubspec.yaml
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'إنشاء حساب جديد',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'انضم لآلاف المستخدمين واحجز خدمتك بسهولة 🌟',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // الكارد
                  _fadeSlide(
                    index: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
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
                                'بياناتك الشخصية',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'كم خطوة بسيطة ونجهز حسابك ✨',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // الاسم
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'الاسم الكامل',
                                prefixIcon:
                                    const Icon(Icons.person_outline_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'الاسم مطلوب' : null,
                            ),
                            const SizedBox(height: 14),

                            // الإيميل
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'الإيميل',
                                prefixIcon:
                                    const Icon(Icons.email_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
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

                            // الباسورد
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure1,
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                prefixIcon: const Icon(
                                    Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure1
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscure1 = !_obscure1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
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
                            const SizedBox(height: 14),

                            // تأكيد الباسورد
                            TextFormField(
                              controller: _password2Controller,
                              obscureText: _obscure2,
                              decoration: InputDecoration(
                                labelText: 'تأكيد كلمة المرور',
                                prefixIcon:
                                    const Icon(Icons.lock_reset_rounded),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure2
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscure2 = !_obscure2),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              validator: (v) {
                                if (v != _passwordController.text) {
                                  return 'كلمتا المرور غير متطابقتين';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 22),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  backgroundColor:
                                      const Color(0xFF9575FF),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: _loading ? null : _register,
                                child: _loading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'إنشاء حساب',
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

                  const SizedBox(height: 14),

                  _fadeSlide(
                    index: 3,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'لديك حساب بالفعل؟ سجّل الدخول',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
