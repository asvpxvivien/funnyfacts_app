import 'package:flutter/material.dart';
import 'package:funfacts/providers/themeProvider.dart';
import 'package:funfacts/widgets/themeSwitcher.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _version = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0';
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'ouvrir le lien: $url'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'À propos',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Funny Facts',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version $_version',
                  style: GoogleFonts.poppins(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Une application pour découvrir des faits amusants et intéressants.',
                  style: GoogleFonts.poppins(height: 1.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Développé par asvpxvivien',
                  style: GoogleFonts.poppins(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Paramètres",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Apparence
            _buildSectionHeader('Apparence', Icons.palette_rounded),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: Column(
                children: [
                  const Themeswitcher(),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.text_fields_rounded,
                    title: 'Taille de police',
                    subtitle: 'Bientôt disponible',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité bientôt disponible'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Données
            _buildSectionHeader('Données', Icons.storage_rounded),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.cloud_sync_rounded,
                    title: 'Synchronisation',
                    subtitle: 'Synchroniser avec le cloud',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fonctionnalité bientôt disponible'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.download_rounded,
                    title: 'Télécharger hors ligne',
                    subtitle: 'Accéder aux facts sans internet',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fonctionnalité bientôt disponible'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Support
            _buildSectionHeader('Support', Icons.help_outline_rounded),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.star_rounded,
                    title: 'Noter l\'application',
                    subtitle: 'Donnez votre avis sur le store',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Merci pour votre soutien !'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.bug_report_rounded,
                    title: 'Signaler un bug',
                    subtitle: 'Aidez-nous à améliorer l\'app',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () => _launchUrl('mailto:support@funfacts.com'),
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'À propos',
                    subtitle: 'Version et informations',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: _showAboutDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Légal
            _buildSectionHeader('Légal', Icons.gavel_rounded),
            const SizedBox(height: 12),
            _buildSettingsCard(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Politique de confidentialité',
                    subtitle: 'Comment nous protégeons vos données',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () => _launchUrl('https://example.com/privacy'),
                  ),
                  const Divider(),
                  _buildSettingsTile(
                    icon: Icons.description_rounded,
                    title: 'Conditions d\'utilisation',
                    subtitle: 'Termes et conditions',
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onTap: () => _launchUrl('https://example.com/terms'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Funny Facts',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version $_version',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
