import 'package:flutter/material.dart';

/// Freight Suggestion Chip Widget
class FreightSuggestionChip extends StatelessWidget {
  final double suggestedAmount;
  final VoidCallback onUse;

  const FreightSuggestionChip({
    super.key,
    required this.suggestedAmount,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Suggested freight: ₹${suggestedAmount.toStringAsFixed(0)} (based on similar trips)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onUse,
            child: const Text('Use'),
          ),
        ],
      ),
    );
  }
}

/// Driver Suggestion Chip Widget
class DriverSuggestionChip extends StatelessWidget {
  final String driverName;
  final String reason;
  final VoidCallback? onTap;

  const DriverSuggestionChip({
    super.key,
    required this.driverName,
    required this.reason,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              color: theme.colorScheme.secondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested driver: $driverName',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reason,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.secondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Expense Warning Dialog
class ExpenseWarningDialog extends StatelessWidget {
  final double enteredAmount;
  final double averageAmount;
  final String category;
  final VoidCallback onProceed;
  final VoidCallback onCancel;

  const ExpenseWarningDialog({
    super.key,
    required this.enteredAmount,
    required this.averageAmount,
    required this.category,
    required this.onProceed,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentageHigher = ((enteredAmount / averageAmount - 1) * 100).toStringAsFixed(0);
    
    return AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.orange,
        size: 48,
      ),
      title: const Text('High Expense Amount'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This $category expense is unusually high:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _buildComparisonRow(
            'Entered Amount',
            '₹${enteredAmount.toStringAsFixed(0)}',
            Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildComparisonRow(
            'Your Average',
            '₹${averageAmount.toStringAsFixed(0)}',
            theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$percentageHigher% higher than usual',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Would you like to proceed with this amount?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Review'),
        ),
        ElevatedButton(
          onPressed: onProceed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Proceed Anyway'),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Credit Warning Banner Widget
class CreditWarningBanner extends StatelessWidget {
  final String partyName;
  final double outstandingBalance;
  final String severity;
  final VoidCallback? onTap;

  const CreditWarningBanner({
    super.key,
    required this.partyName,
    required this.outstandingBalance,
    required this.severity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = severity == 'HIGH' ? Colors.red : Colors.orange;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Credit Limit Warning',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          severity,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$partyName has outstanding balance of ₹${outstandingBalance.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Consider collecting payment before creating new trips',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color,
              ),
          ],
        ),
      ),
    );
  }
}

/// Category Auto-Detection Chip
class CategoryDetectionChip extends StatelessWidget {
  final String category;
  final VoidCallback? onDismiss;

  const CategoryDetectionChip({
    super.key,
    required this.category,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: theme.colorScheme.secondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Auto-detected category: $category',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
