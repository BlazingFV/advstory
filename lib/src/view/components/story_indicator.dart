import 'dart:ui';

import 'package:advstory/src/model/style/indicator_style.dart';
import 'package:advstory/src/view/story_view.dart';
import 'package:flutter/material.dart';

/// Indicator view for the [StoryView]
class StoryIndicator extends StatefulWidget {
  /// Creates indicators for the every story in the cluster.
  ///
  /// Indicators before [activeIndicatorIndex] will be filled with
  /// [IndicatorStyle]' valueColor and the rest will be filled with
  /// with  backgroundColor.
  const StoryIndicator({
    required this.count,
    required this.activeIndicatorIndex,
    required this.controller,
    required this.style,
    Key? key,
  }) : super(key: key);

  /// Indicator progress controller.
  final AnimationController controller;

  /// The number of indicators to display.
  final int count;

  /// Currently viewed story index. This index is filled with [IndicatorStyle]'s
  /// valueColor and animation is applied.
  final int activeIndicatorIndex;

  final IndicatorStyle style;

  @override
  State<StoryIndicator> createState() => _StoryIndicatorState();
}

class _StoryIndicatorState extends State<StoryIndicator>
    with TickerProviderStateMixin {
  /// Story progress indicator controller.
  late Animation<double> _animation;
  double get width => (window.physicalSize / window.devicePixelRatio).width;

  @override
  void initState() {
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(widget.controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final indicatorWidth = (MediaQuery.of(context).size.width -
                (widget.count * widget.style.spacing +
                    widget.style.padding * 2)) /
            widget.count;

        final indicators = List.generate(
          widget.count,
          (index) {
            if (index != widget.activeIndicatorIndex) {
              final isBefore = index < widget.activeIndicatorIndex;
              return SizedBox(
                width: indicatorWidth,
                height: widget.style.height,
                child: LinearProgressIndicator(
                  backgroundColor: widget.style.backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isBefore
                        ? widget.style.valueColor
                        : widget.style.backgroundColor,
                  ),
                  value: isBefore ? 1 : 0,
                  minHeight: widget.style.height,
                ),
              );
            } else {
              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return SizedBox(
                    width: indicatorWidth,
                    height: widget.style.height,
                    child: LinearProgressIndicator(
                      backgroundColor: widget.style.backgroundColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.style.valueColor,
                      ),
                      value: _animation.value,
                      minHeight: widget.style.height,
                    ),
                  );
                },
              );
            }
          },
        );

        return SizedBox(
          width: width,
          height: widget.style.height + 16,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: widget.style.padding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: indicators,
            ),
          ),
        );
      },
    );
  }
}