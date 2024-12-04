import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/models/quote.dart';
import 'package:myapp/style.dart';
import 'package:myapp/views/tabs/home/controller.dart';

import '../../subpages/screenshot_screen/view.dart';
import 'controller.dart';

class AiChatScreen extends StatelessWidget {
  AiChatScreen({super.key});
  final controller = Get.put(AiQuoteController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quotes Assistant",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.generatedContent.length,
                itemBuilder: (context, index) {
                  final item = controller.generatedContent[index];
                  if (item is Quote) {
                    return QuoteMessageWidget(quote: item);
                  } else {
                    return TextMessageWidget(text: item.toString());
                  }
                },
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.isTrue
                ? Padding(
                    padding: EdgeInsets.only(
                        bottom: 16, left: 16, top: 10, right: 19),
                    child: TypingIndicator(
                      showIndicator: controller.isLoading.isTrue,
                    ),
                  )
                : const SizedBox(),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final textFieldController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLength: 15,
              controller: textFieldController,
              // style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Ask for a quote...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (text) =>
                  text.isEmpty ? null : controller.sendMessage(text),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => IconButton(
              onPressed: controller.isLoading.isTrue
                  ? null
                  : () => controller.sendMessage(
                        textFieldController.text,
                      ),
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
              ),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteMessageWidget extends StatelessWidget {
  const QuoteMessageWidget({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final gradient = _getDynamicGradient(context, quote.isFromUser);

    return Align(
      alignment:
          quote.isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          Get.to(
              () => ScreenshotScreen(
                    selectedtheme:
                        Get.find<HomeController>().selectedTheme.value,
                    data: quote,
                  ),
              transition: Transition.downToUp);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: quote.isFromUser
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: context.theme.colorScheme.surfaceContainer)
              : BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote.text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (!quote.isFromUser && quote.author != null) ...[
                const SizedBox(height: 4),
                Text(
                  '- ${quote.author}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getDynamicGradient(BuildContext context, bool isFromUser) {
    final theme = Theme.of(context);
    final List<List<Color>> gradients = [
      // [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
      [primaryColor2, theme.colorScheme.errorContainer],
    ];

    final gradientIndex = isFromUser
        ? Random().nextInt(gradients.length)
        : Random().nextInt(gradients.length);

    return LinearGradient(
      colors: gradients[gradientIndex],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.showIndicator = false,
    this.bubbleColor = const Color(0xFF646b7f),
    this.flashingCircleDarkColor = const Color(0xFF333333),
    this.flashingCircleBrightColor = primaryColor2,
  });

  final bool showIndicator;
  final Color bubbleColor;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;
  late Animation<double> _indicatorSpaceAnimation;
  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..addListener(() {
        setState(() {});
      });

    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ).drive(Tween<double>(begin: 0.0, end: 60.0));

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    if (widget.showIndicator) {
      _appearanceController.forward();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _appearanceController.forward();
      } else {
        _appearanceController.reverse();
        _repeatingController.stop();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appearanceController,
      builder: (context, child) {
        return SizedBox(
          height: _indicatorSpaceAnimation.value,
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleBubble(color: widget.bubbleColor),
          const SizedBox(width: 10),
          AnimatedDots(
            flashingCircleDarkColor: widget.flashingCircleDarkColor,
            flashingCircleBrightColor: widget.flashingCircleBrightColor,
            dotIntervals: _dotIntervals,
            repeatingController: _repeatingController,
          ),
        ],
      ),
    );
  }
}

class CircleBubble extends StatelessWidget {
  const CircleBubble({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome);
  }
}

class AnimatedDots extends StatelessWidget {
  const AnimatedDots({
    super.key,
    required this.flashingCircleDarkColor,
    required this.flashingCircleBrightColor,
    required this.dotIntervals,
    required this.repeatingController,
  });

  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;
  final List<Interval> dotIntervals;
  final AnimationController repeatingController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: repeatingController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _dotColor(index),
              ),
            );
          },
        );
      }),
    );
  }

  Color _dotColor(int index) {
    final progress = repeatingController.value;
    final interval = dotIntervals[index];
    if (progress > interval.begin && progress < interval.end) {
      return flashingCircleBrightColor;
    }
    return flashingCircleDarkColor;
  }
}
