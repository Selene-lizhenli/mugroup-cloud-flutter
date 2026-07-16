import 'package:cloud/pages/inspection/const.dart';
import 'package:flutter/material.dart';

class InspectionBottomButtons extends StatelessWidget {
  final Function(int) onPressed;
  final bool isSubmitting;
  final int submittingStatus;

  const InspectionBottomButtons({
    super.key,
    required this.onPressed,
    required this.isSubmitting,
    required this.submittingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            _buildActionBtn(
              label: inspectionStatusLabelMap[3]!,
              icon: Icons.cancel,
              color: Colors.red,
              status: 3,
              isSubmitting: isSubmitting,
              submittingStatus: submittingStatus,
              onPressed: () => onPressed(3),
            ),
            const SizedBox(width: 12),
            _buildActionBtn(
              label: inspectionStatusLabelMap[2]!,
              icon: Icons.warning_amber,
              color: Colors.orange,
              status: 2,
              isSubmitting: isSubmitting,
              submittingStatus: submittingStatus,
              onPressed: () => onPressed(2),
            ),
            const SizedBox(width: 12),
            _buildActionBtn(
              label: inspectionStatusLabelMap[1]!,
              icon: Icons.check_circle,
              color: Colors.green,
              status: 1,
              isSubmitting: isSubmitting,
              submittingStatus: submittingStatus,
              onPressed: () => onPressed(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn({
    required String label,
    required icon,
    required Color color,
    required int status,
    required bool isSubmitting,
    required int submittingStatus,
    required VoidCallback onPressed,
  }) {
    final bool isThisSubmitting = isSubmitting && submittingStatus == status;

    return Expanded(
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withOpacity(0.5),
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isThisSubmitting) ...[
              const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 4),
            ],
            Text(
              isThisSubmitting ? '提交中' : label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 2),
            Icon(icon, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
