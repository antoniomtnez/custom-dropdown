part of '../custom_dropdown.dart';

class _AnimatedSection extends StatefulWidget {
  final bool expand;
  final VoidCallback animationDismissed;
  final Widget child;
  final double axisAlignment;

  const _AnimatedSection({
    super.key,
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
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {

          SchedulerBinding.instance.addPostFrameCallback((_) {
            widget.animationDismissed();
          });
  


  }


  @override
  void didUpdateWidget(_AnimatedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
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
