import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          // Background Texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD8_loXkuOONAyjfXeTaUVevC1xXPGQ9arJJvL8naTbwNpg4CL7QFEQYBlPhFEMCy-P6RKKS4PPpr6vcmtZHqS4VeBvRC6UhynYQTxI35q6Ox4QCInlF1-FDU23cjCpYrZ7aA1uJhvYrRO393mE0NEDR4xdjda9gXUDJg523d9NFHtUkSWw8fzc9QUdJrYJKO-X_LdeRXYmFeOqSwm9IDUON9--1qccUUSZhQu0BiTbAIqi_Xadn8Pi5r99Nkd8ha645C1C_gVBkzyQ',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Decorative Blurs
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondary.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Navigation
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'FindFriends',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundDark.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF334155).withOpacity(0.5),
                          ),
                        ),
                        child: const Icon(
                          Icons.more_horiz,
                          color: Color(0xFF94A3B8), // slate-400
                        ),
                      ),
                    ],
                  ),
                ),

                // Hero Logo Section
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Glowing FF High-Five Logo
                      Container(
                        width: 192,
                        height: 192,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [AppTheme.primary, AppTheme.secondary],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.5),
                              blurRadius: 50,
                              spreadRadius: -12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 176,
                            height: 176,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.backgroundDark,
                            ),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [AppTheme.primary, AppTheme.secondary],
                                ).createShader(bounds),
                                child: const Icon(
                                  Icons.pan_tool,
                                  size: 72,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      const Text(
                        'See friends nearby.',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'Make real ones.',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          letterSpacing: -0.5,
                          color: AppTheme.primary,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 48.0),
                        child: Text(
                          'Connect with people around you in real-time through live location discovery.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF94A3B8), // slate-400
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer / Interaction Section
                Container(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 48, top: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppTheme.backgroundDark,
                        AppTheme.backgroundDark.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Toggle Component
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Open to Friends Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your location is visible to friends',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: true,
                              onChanged: (val) {},
                              activeColor: AppTheme.primary,
                              activeTrackColor: AppTheme.primary.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Primary Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/map');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.backgroundDarkMap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 10,
                            shadowColor: AppTheme.primary.withOpacity(0.4),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
