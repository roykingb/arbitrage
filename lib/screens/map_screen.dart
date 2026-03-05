import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:ui';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDarkMap,
      body: Stack(
        children: [
          // Simulated Map Area
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCRhVvlLuVlqu6ikLFP4fLNhUtBZCyfi4-GiZ2-aJXMtEp4bs4FFyo1xqbFN4eLqKPKuoEL7dtY01OKWFl_EX7G5A7EEKZ_YTdkSLQLUq2D8bBZLOVPo_V5NWDMZhGh74IW9X17zPXR37RuNaZHIWRAguLIHSwQVPHz_W2gB7HXOxZSpWjYbigfOc5bJ3Uc1afIewB1QuqkYnxJD3w7Dbnxm6IrZnwkh6braoIE_H0FiZnaKioTcmaT8WIBrfwPr5q2noEAyczeZIO0',
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.saturation,
              ),
            ),
          ),

          // Map Markers / Pins
          // Social Density Cluster 1
          Positioned(
            top: MediaQuery.of(context).size.height * 0.33,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.15),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.6],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.backgroundDarkMap,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '12',
                      style: TextStyle(
                        color: AppTheme.backgroundDarkMap,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Social Density Cluster 2
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            right: MediaQuery.of(context).size.width * 0.33,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.6],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.backgroundDarkMap,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '24',
                      style: TextStyle(
                        color: AppTheme.backgroundDarkMap,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Individual Pin 1
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.33,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.backgroundDarkMap,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuC9v1Ve-NQI9rOztVsRNspfFxFpPSiLWHrQLgwpAQptVjAMybxZbpRhxaLexS6RDZt8jJeI6bidrOcPXb7Ykt6c0L9hTR2Fz1Jv-3bAg8ZV6naGjdTRwRIRpFGnWPIM4CD7Gj8Y0LuWjvg2V9G7zRDaGnN5E1ykKKIevQjT8t_7EsHOF4Z91I1vAfsaC8spgKHp9YFvcAvhkMZ3Ygc6FJJrYX99b2JxNaxNg4GWnBKz2fzxyVttBKw9qFzHlQz5trvb7P0ibjto66uD'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Individual Pin 2
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            right: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.backgroundDarkMap,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDTm6Xtov4f5ByctzLipNZP_4lh3Xed0Db-AgmUANsnMr9fU2MKvYNQA4Ar3upBjSfcTZ05YU4-9TYF8I9fcFPwULZptA97-_2kQ1T1u8o9f-Qw781RJH8YoMqCpNG7y7od_I2iocJ5L2syRif49X0Hp6_cSJgagigNqIyF8w7DabFi9f9b0A-e5Hp1iyJmq_vRYx1cIQR1WpsOXyzjcs_edCi3aq-M2C_frSAb2Mh3wsotSJFuNK69c-VE1vI8-bElwzXY_9j8nh5l'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Top Status Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.verified,
                            color: AppTheme.backgroundDarkMap,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'PLATONIC ONLY',
                            style: TextStyle(
                              color: AppTheme.backgroundDarkMap,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B), // slate-800
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF334155), // slate-700
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.view_in_ar,
                            color: Color(0xFFE2E8F0), // slate-200
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primary,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                            image: const DecorationImage(
                              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBeIg75hawMs61yUczs1UFiVp5PbDUs-TfQHkvyksW8AFkKwfO3Kli24zR2X29YLNNizWnijZU_OX25nwjZViONGkRRJNPlLE7_fwfEm6ZJa70MQa57nD5dcWPniagS4oL0ON3qkBB1IB100XuNAZHjy86Y7Xvbrwx0iwJC-aHc0G0lxn_aXsDTLgfcDAVi51ZPWYqdULxKsGF6r6BG0sMNdu2Jz3RiXYXTNX4Qz6_3nbDiFZC-9dbGSq2UnMXXct5EuGgcK_hEiYOh'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Controls
          Positioned(
            right: 24,
            top: MediaQuery.of(context).size.height * 0.5 - 60,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B), // slate-800
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF334155), // slate-700
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        color: const Color(0xFFCBD5E1), // slate-300
                      ),
                      Container(
                        height: 1,
                        width: 24,
                        color: const Color(0xFF334155), // slate-700
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove),
                        color: const Color(0xFFCBD5E1), // slate-300
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B), // slate-800
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF334155), // slate-700
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Bottom UI Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Search & Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundDarkMap.withOpacity(0.7),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Color(0xFF94A3B8), // slate-400
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Find people or interests...',
                                      style: TextStyle(
                                        color: Color(0xFF64748B), // slate-500
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.tune,
                                    color: AppTheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                              icon: Icons.groups,
                              label: 'High Density',
                              isPrimary: true,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              icon: Icons.social_distance,
                              label: 'Within 2km',
                              isPrimary: false,
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              icon: Icons.sports_tennis,
                              label: 'Activities',
                              isPrimary: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Share Location Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: AppTheme.backgroundDarkMap,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                      shadowColor: AppTheme.primary.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.share_location,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Share Live Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom Tab Bar
                const BottomNavBar(currentIndex: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? AppTheme.primary : const Color(0xFF1E293B).withOpacity(0.8), // slate-800
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary ? Colors.transparent : const Color(0xFF334155), // slate-700
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isPrimary ? AppTheme.backgroundDarkMap : const Color(0xFFE2E8F0), // slate-200
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
              color: isPrimary ? AppTheme.backgroundDarkMap : const Color(0xFFE2E8F0), // slate-200
            ),
          ),
        ],
      ),
    );
  }
}
