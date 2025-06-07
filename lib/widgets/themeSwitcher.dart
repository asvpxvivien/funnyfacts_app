import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:funfacts/providers/themeProvider.dart';
import 'package:google_fonts/google_fonts.dart';

class Themeswitcher extends StatefulWidget {
  const Themeswitcher({super.key});

  @override
  State<Themeswitcher> createState() => _ThemeswitcherState();
}

class _ThemeswitcherState extends State<Themeswitcher>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _onThemeChanged(bool isDark) {
    _iconController.forward().then((_) {
      _iconController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icône avec animation
          AnimatedBuilder(
            animation: _iconRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _iconRotation.value * 3.14159,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    themeProvider.isDarkModeChecked
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 16),

          // Texte principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mode d'affichage",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  themeProvider.isDarkModeChecked
                      ? "Mode sombre activé"
                      : "Mode clair activé",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Switch personnalisé
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Switch(
              value: themeProvider.isDarkModeChecked,
              onChanged: (value) {
                _onThemeChanged(value);
                themeProvider.updateMode(darkMode: value);
              },
              activeColor: colorScheme.primary,
              activeTrackColor: colorScheme.primaryContainer,
              inactiveThumbColor: colorScheme.outline,
              inactiveTrackColor: colorScheme.surfaceVariant,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
