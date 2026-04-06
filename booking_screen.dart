import 'package:flutter/material.dart';

import '../models/business_model.dart';
import '../models/service_model.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final Business business;
  final ServiceModel service;

  const BookingScreen({
    super.key,
    required this.business,
    required this.service,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  bool _loading = false;

  // فلاغ بسيط لتشغيل الأنيميشن
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    // نشغّل الأنيميشن بعد أول فريم
    Future.microtask(() {
      if (mounted) {
        setState(() => _animate = true);
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitBooking() async {
    setState(() => _loading = true);

    // HH:mm
    final String startTime =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    final result = await BookingService.createBooking(
      business: widget.business,
      service: widget.service,
      bookingDate: _selectedDate,
      startTime: startTime,
    );

    setState(() => _loading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحجز بنجاح ✅')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'فشل إنشاء الحجز',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
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
          child: Column(
            children: [
              // ───── Top bar ─────
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'تأكيد الحجز',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.event_available_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ───── Business + Service card ─────
                        _FadeSlideIn(
                          animate: _animate,
                          delayMs: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade800,
                                  Colors.grey.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white.withOpacity(0.12),
                                  ),
                                  child: const Icon(
                                    Icons.spa_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.business.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        s.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_rounded,
                                            size: 16,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${s.duration ?? 0} دقيقة',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            Icons.price_check_rounded,
                                            size: 16,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${s.price.toStringAsFixed(2)} AED',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
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

                        const SizedBox(height: 24),

                        _FadeSlideIn(
                          animate: _animate,
                          delayMs: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'اختيار الوقت',
                                style:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // ───── Date & Time cards ─────
                              Row(
                                children: [
                                  Expanded(
                                    child: _PickerCard(
                                      title: 'تاريخ الحجز',
                                      value:
                                          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                                      icon:
                                          Icons.calendar_today_rounded,
                                      onTap: _pickDate,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _PickerCard(
                                      title: 'وقت البدء',
                                      value:
                                          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                      icon: Icons.access_time_rounded,
                                      onTap: _pickTime,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        _FadeSlideIn(
                          animate: _animate,
                          delayMs: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ملخص الحجز',
                                style:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'سيتم حجز خدمة "${s.name}" في ${widget.business.name} '
                                'بتاريخ ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} '
                                'في الساعة ${_selectedTime.format(context)}.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        _FadeSlideIn(
                          animate: _animate,
                          delayMs: 200,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                backgroundColor:
                                    const Color(0xFF6750F3),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _loading ? null : _submitBooking,
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
                                      'تأكيد الحجز الآن',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

// ───────────────────────── Picker Card ─────────────────────────

class _PickerCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _PickerCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF6750F3)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Fade + Slide Widget ─────────────────────────

class _FadeSlideIn extends StatelessWidget {
  final bool animate;
  final int delayMs;
  final Widget child;

  const _FadeSlideIn({
    required this.animate,
    required this.delayMs,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const double startOffset = 30.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: animate ? startOffset : 0.0,
        end: 0.0,
      ),
      duration: Duration(milliseconds: 480 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // value من 30 -> 0
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
      child: child,
    );
  }
}
