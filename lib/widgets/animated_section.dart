part of '../custom_dropdown.dart';

class _AnimatedSection extends StatefulWidget {
  final bool expand;
  final VoidCallback animationDismissed;
  final Widget child;
  final double axisAlignment;

  const _AnimatedSection({
    this.expand = false,
    required this.animationDismissed,
    required this.child,
    required this.axisAlignment,
  });

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;
  late void Function(AnimationStatus) _statusListener;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    runExpand();
  }

  void prepareAnimations() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _statusListener = (status) {
      if (status == AnimationStatus.dismissed) {
        // Protección extra con mounted
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          widget.animationDismissed();
        });
      }
    };

    animController.addStatusListener(_statusListener);

    animation = CurvedAnimation(
      parent: animController,
      curve: Curves.linearToEaseOut,
    );
  }

  void runExpand() {
    if (!mounted) return; // protección adicional
    if (widget.expand) {
      animController.forward();
    } else {
      animController.reverse();
    }
  }

  @override
  void didUpdateWidget(_AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    runExpand();
  }

  @override
  void dispose() {
    animController.removeStatusListener(_statusListener);
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        axisAlignment: widget.axisAlignment,
        sizeFactor: animation,
        child: widget.child,
      ),
    );
  }
}
