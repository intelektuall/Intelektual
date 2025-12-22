import 'package:flutter/material.dart';
import 'analytics_service.dart';

class AnalyticsWrapper extends StatefulWidget {
  final Widget child;
  final String screenName;

  const AnalyticsWrapper({
    Key? key,
    required this.child,
    required this.screenName,
  }) : super(key: key);

  @override
  _AnalyticsWrapperState createState() => _AnalyticsWrapperState();
}

class _AnalyticsWrapperState extends State<AnalyticsWrapper> with WidgetsBindingObserver {
  DateTime? _screenEnterTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _trackScreenView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _trackScreenExit();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _trackScreenExit();
        break;
      case AppLifecycleState.resumed:
        _trackScreenView();
        break;
      default:
        break;
    }
  }

  void _trackScreenView() {
    _screenEnterTime = DateTime.now();
    AnalyticsService.trackInteraction('screen_view');
    AnalyticsService.trackFeatureUsage(widget.screenName);
  }

  void _trackScreenExit() {
    if (_screenEnterTime != null) {
      final duration = DateTime.now().difference(_screenEnterTime!);
      AnalyticsService.trackPerformance(
        'screen_duration_${widget.screenName}',
        duration.inMilliseconds,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => AnalyticsService.trackInteraction('touch'),
      child: GestureDetector(
        onTap: () => AnalyticsService.trackInteraction('tap'),
        onLongPress: () => AnalyticsService.trackInteraction('long_press'),
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}