import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funfacts/screens/settings_screen.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<dynamic> facts = [];
  bool isLoading = true;
  int currentIndex = 0;
  PageController pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  // Couleurs dégradées pour les cartes
  final List<List<Color>> gradientColors = [
    [Color(0xFF2193b0), Color(0xFF6dd5ed)],
    [Color(0xFFcc2b5e), Color(0xFF753a88)],
    [Color(0xFFee9ca7), Color(0xFFffdde1)],
    [Color(0xFF42275a), Color(0xFF734b6d)],
    [Color(0xFFbdc3c7), Color(0xFF2c3e50)],
    [Color(0xFF56ab2f), Color(0xFFa8e063)],
    [Color(0xFF614385), Color(0xFF516395)],
    [Color(0xFFe65c00), Color(0xFFF9D423)],
    [Color(0xFF1488CC), Color(0xFF2B32B2)],
    [Color(0xFFf46b45), Color(0xFFeea849)],
  ];

  void getData() async {
    try {
      Response response = await Dio().get(
        "https://raw.githubusercontent.com/asvpxvivien/flutter_funfacts_api/refs/heads/main/funnyfacts.json",
      );
      facts = jsonDecode(response.data);
      isLoading = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      setState(() {});
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Erreur de connexion'),
            content: const Text(
              'Impossible de charger les facts. Vérifiez votre connexion internet.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  getData();
                },
                child: const Text('Réessayer'),
              ),
            ],
          ),
    );
  }

  void _shareCurrentFact() {
    if (facts.isNotEmpty && currentIndex < facts.length) {
      Share.share(
        '${facts[currentIndex]}\n\n- Partagé depuis Funny Facts',
        subject: 'Fact intéressant',
      );
    }
  }

  void _copyToClipboard() {
    if (facts.isNotEmpty && currentIndex < facts.length) {
      Clipboard.setData(ClipboardData(text: facts[currentIndex]));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Fact copié dans le presse-papiers'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _goToRandomFact() {
    if (facts.isNotEmpty) {
      final random = Random();
      final randomIndex = random.nextInt(facts.length);
      pageController.animateToPage(
        randomIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Funny Facts",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: _goToRandomFact,
            icon: const Icon(Icons.shuffle_rounded),
            tooltip: 'Fact aléatoire',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: colorScheme.primary,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Chargement des facts...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )
              : facts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_rounded,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun fact disponible',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vérifiez votre connexion internet',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: getData,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Indicateur de progression
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${currentIndex + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          ' / ${facts.length}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: (currentIndex + 1) / facts.length,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(
                                  colors:
                                      gradientColors[currentIndex %
                                          gradientColors.length],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cartes de facts
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemCount: facts.length,
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: _cardAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _cardAnimation.value,
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Card(
                                    elevation: 8,
                                    shadowColor: gradientColors[index %
                                            gradientColors.length][0]
                                        .withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors:
                                              gradientColors[index %
                                                  gradientColors.length],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.lightbulb_outline_rounded,
                                              size: 48,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Text(
                                              facts[index],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // Boutons d'action
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.copy_rounded,
                          label: 'Copier',
                          onPressed: _copyToClipboard,
                        ),
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          label: 'Partager',
                          onPressed: _shareCurrentFact,
                        ),
                        _buildActionButton(
                          icon: Icons.favorite_rounded,
                          label: 'Favoris',
                          onPressed: () {
                            // TODO: Implémenter les favoris
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fonctionnalité bientôt disponible',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Indication de swipe
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_left_rounded,
                          color: colorScheme.onSurface.withOpacity(0.5),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Glissez pour naviguer',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.swipe_right_rounded,
                          color: colorScheme.onSurface.withOpacity(0.5),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          onPressed: onPressed,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          elevation: 2,
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
