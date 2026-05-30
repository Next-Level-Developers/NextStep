// lib/core/utils/salary_formatter.dart

class SalaryFormatter {
  SalaryFormatter._();

  /// Converts a salary in paise (integer) to a Lakhs Per Annum (LPA) double.
  /// 1 LPA = 1,000,000 paise (Wait: 1 Lakh = 100,000 Rupees. 1 Rupee = 100 paise.
  /// So 1 Lakh = 10,000,000 paise.)
  static double paiseToLpa(int paise) {
    return paise / 10000000;
  }

  /// Formats a double LPA value into a user-friendly string (e.g., 4 or 4.5).
  static String formatLpaValue(double lpa) {
    if (lpa % 1 == 0) {
      return lpa.toInt().toString();
    } else {
      return lpa.toStringAsFixed(1);
    }
  }

  /// Formats a min and max salary range in paise to a string like "₹4–8 LPA".
  static String formatRange(int? minPaise, int? maxPaise) {
    if (minPaise == null && maxPaise == null) {
      return 'Salary dynamic';
    }

    if (minPaise != null && maxPaise == null) {
      final minLpa = paiseToLpa(minPaise);
      return '₹${formatLpaValue(minLpa)}+ LPA';
    }

    if (minPaise == null && maxPaise != null) {
      final maxLpa = paiseToLpa(maxPaise);
      return 'Up to ₹${formatLpaValue(maxLpa)} LPA';
    }

    final minLpa = paiseToLpa(minPaise!);
    final maxLpa = paiseToLpa(maxPaise!);

    if (minLpa == maxLpa) {
      return '₹${formatLpaValue(minLpa)} LPA';
    }

    return '₹${formatLpaValue(minLpa)}–${formatLpaValue(maxLpa)} LPA';
  }
}
