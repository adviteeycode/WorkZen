import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/theme/provider/theme_provider.dart';

class AnimatedThemeToggle extends StatefulWidget {
  const AnimatedThemeToggle({super.key});

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _switchSlide;

  // animation absolute positions
  final double beginPos = -24;
  final double endPos = 24;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _switchSlide = Tween<double>(
      begin: beginPos,
      end: endPos,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    // FIX: Wait until first frame → then sync without visual jump
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isDark = Provider.of<ThemeProvider>(
        context,
        listen: false,
      ).isDarkTheme;
      if (isDark) {
        _controller.value = 1; // direct jump to end (RIGHT)
      } else {
        _controller.value = 0; // direct to start (LEFT)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkTheme;

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme();
        if (isDark) {
          _controller.reverse(); // dark → light
        } else {
          _controller.forward(); // light → dark
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 42,
        width: 86,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black, Colors.blueGrey.shade800]
                : [Colors.white, Colors.blue.shade100],
          ),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(isDark ? 0.45 : 0.15),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Sun icon (Left)
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.light_mode_rounded, size: 20),
            ),

            // Moon icon (Right)
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.dark_mode_rounded, size: 20),
            ),

            // Sliding knob
            AnimatedBuilder(
              animation: _switchSlide,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(_switchSlide.value, 0),
                  child: Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.blueGrey.shade900, Colors.black]
                            : [Colors.white, Colors.grey.shade200],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.5 : 0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
