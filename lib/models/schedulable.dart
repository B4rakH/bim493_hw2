/// Adds a simple on/off schedule to any device that mixes it in.
mixin Schedulable {
  DateTime? _scheduledTime;

  DateTime? get scheduledTime => _scheduledTime;

  bool get hasSchedule => _scheduledTime != null;

  void schedule(DateTime time) => _scheduledTime = time;

  void cancelSchedule() => _scheduledTime = null;

  String get scheduleInfo {
    final time = _scheduledTime;
    if (time == null) return 'No schedule';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return 'Scheduled at $hour:$minute';
  }
}
