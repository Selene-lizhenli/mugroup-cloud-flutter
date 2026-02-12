    // 判断是否是春节时段
    final isSpringFestival = () {
      // 春节特殊时间段：
      // 2025-02-10 ~ 2025-02-26
      // 2027-01-30 ~ 2027-02-15
      // 2028-01-18 ~ 2028-02-02
      final now = DateTime.now();
      final d = DateTime(now.year, now.month, now.day);
      bool inRange(DateTime start, DateTime end) =>
          !d.isBefore(start) && !d.isAfter(end);

      final time = DateTime(2026, 2, 10);
      final endTime = DateTime(2026, 2, 26);
      final is2026F = inRange(time, endTime);
      final is2027F = inRange(DateTime(2027, 1, 30), DateTime(2027, 2, 15));
      final is2028F = inRange(DateTime(2028, 1, 18), DateTime(2028, 2, 2));

      final res = is2026F || is2027F || is2028F;
      return res;
    }();