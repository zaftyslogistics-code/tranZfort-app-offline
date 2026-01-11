import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Quick Action FAB with Speed Dial
/// Provides quick access to common actions from any screen
class QuickActionFAB extends StatefulWidget {
  final VoidCallback onStartTrip;
  final VoidCallback onAddExpense;
  final VoidCallback onScanBill;
  final VoidCallback onRecordPayment;
  final VoidCallback onAddFuel;

  const QuickActionFAB({
    super.key,
    required this.onStartTrip,
    required this.onAddExpense,
    required this.onScanBill,
    required this.onRecordPayment,
    required this.onAddFuel,
  });

  @override
  State<QuickActionFAB> createState() => _QuickActionFABState();
}

class _QuickActionFABState extends State<QuickActionFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleAction(VoidCallback action) {
    _toggle();
    Future.delayed(const Duration(milliseconds: 100), action);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

        // Action Buttons
        ..._buildActionButtons(theme),

        // Main FAB
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _expandAnimation.value * math.pi / 4,
                child: Icon(
                  _isExpanded ? Icons.close : Icons.add,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActionButtons(ThemeData theme) {
    final actions = [
      _ActionButton(
        icon: Icons.directions_car,
        label: 'Start Trip',
        color: theme.colorScheme.primary,
        onPressed: () => _handleAction(widget.onStartTrip),
      ),
      _ActionButton(
        icon: Icons.receipt_long,
        label: 'Add Expense',
        color: Colors.orange,
        onPressed: () => _handleAction(widget.onAddExpense),
      ),
      _ActionButton(
        icon: Icons.camera_alt,
        label: 'Scan Bill',
        color: Colors.purple,
        onPressed: () => _handleAction(widget.onScanBill),
      ),
      _ActionButton(
        icon: Icons.payment,
        label: 'Record Payment',
        color: Colors.green,
        onPressed: () => _handleAction(widget.onRecordPayment),
      ),
      _ActionButton(
        icon: Icons.local_gas_station,
        label: 'Add Fuel',
        color: Colors.red,
        onPressed: () => _handleAction(widget.onAddFuel),
      ),
    ];

    return List.generate(actions.length, (index) {
      return AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          final offset = (actions.length - index) * 70.0;
          return Positioned(
            bottom: 16 + (offset * _expandAnimation.value),
            right: 16,
            child: Opacity(
              opacity: _expandAnimation.value,
              child: Transform.scale(
                scale: _expandAnimation.value,
                child: actions[index],
              ),
            ),
          );
        },
      );
    });
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Button
        FloatingActionButton(
          heroTag: label,
          mini: true,
          backgroundColor: color,
          onPressed: onPressed,
          child: Icon(icon, color: Colors.white),
        ),
      ],
    );
  }
}
