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
  AnimationController? _animController;
  Animation<double>? _animation;
  bool _isDisposed = false;

  AnimationController get animController => _animController!;
  Animation<double> get animation => _animation!;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    prepareAnimations();
    _scheduleInitialExpand();
  }

  void prepareAnimations() {
    if (_isDisposed) return;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener(_handleAnimationStatus);

    _animation = CurvedAnimation(
      parent: _animController!,
      curve: Curves.linearToEaseOut,
    );
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (_isDisposed || !mounted) return;

    if (status == AnimationStatus.dismissed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && mounted && context.findRenderObject() != null) {
          widget.animationDismissed();
        }
      });
    }
  }

  void _scheduleInitialExpand() {
    if (_isDisposed || !mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted) {
        _handleExpand();
      }
    });
  }

  void _handleExpand() {
    if (_isDisposed || !mounted || _animController == null) return;

    try {
      final controller = _animController!;
      if (!controller.isAnimating) {
        if (widget.expand && controller.status != AnimationStatus.completed) {
          controller.forward();
        } else if (!widget.expand && controller.status != AnimationStatus.dismissed) {
          controller.reverse();
        }
      }
    } catch (e) {
      // Ignorar errores de animación durante la navegación
    }
  }

  @override
  void didUpdateWidget(_AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleExpand();
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_animController != null) {
      if (_animController!.isAnimating) {
        _animController!.stop();
      }
      _animController!.dispose();
      _animController = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed || _animation == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _animation!,
      child: SizeTransition(
        axisAlignment: widget.axisAlignment,
        sizeFactor: _animation!,
        child: widget.child,
      ),
    );
  }
}
