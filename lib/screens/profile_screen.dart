import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:ui';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: AppTheme.backgroundDark.withOpacity(0.8),
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
            ),
            leading: IconButton(
              onPressed: () {},
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
            ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppTheme.backgroundDark,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Profile Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primary,
                                width: 4,
                              ),
                              image: const DecorationImage(
                                image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDWkT0IPFzNwJRh0PhcbonKr_DomlPDAocaWOWisyws8lfscEl-4QEEYGLlYeMTXZw8HSIFD6llmvNFyV-EfLtNJcYbAE1IO1r3ZO7TDaNzqGYmSnFIfurtZW-Di72vV7L4OqoWESq_WYijWEBMqvBpLLyUEEQUJcUivMQj95uS6GLr3NJ4wCcqGSfcYSMbPEjM1paFYqcA2smMWUC-NDrzcxtf8oBBkg_onkUm1paN0UANyIdisPedQKBqoCJ7BFMM346zLOEnMhZv'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -4,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'LEVEL 9',
                                style: TextStyle(
                                  color: AppTheme.backgroundDark,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppTheme.primary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'San Francisco, CA',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.group,
                              size: 12,
                              color: AppTheme.primary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Friends Only',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Row(
                    children: [
                      _buildStatCard('42', 'FRIENDS'),
                      const SizedBox(width: 12),
                      _buildStatCard('7', 'CITIES'),
                      const SizedBox(width: 12),
                      _buildStatCard('Explorer', 'BADGE'),
                    ],
                  ),
                ),

                // Visibility Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
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
                              'Make My Pin Visible',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Share your live spot with nearby explorers',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.primary.withOpacity(0.6),
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
                ),

                // Meetup Grid
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Past Meetups',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'View all',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: [
                          _buildMeetupItem(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCf_7XjnUXu-IkZJJ9chAyyHi8cP2WCFAEPEN0WFSsj8AK6wWHhT-lKz-nd5FrUqVAGakDR4EMyRcZBR5u5epy-RASZDvIopAZrkhrgntMUqjgHFZB37n2NWzJrNZKU6zg2A0AL2f55pd0d5gbRuDqFc7ZaCFV8Rm1JmLal9Eul_Q6l4rIMAn1gYaJ2ek9O4_8wo4FEcJpsgByur--1Lyx0ejhyYrb7slIZfiDo4FB92Y3OzYaEsgX7pUAUn0xwhzY4bUOJCGshnzjE',
                            'SF',
                          ),
                          _buildMeetupItem(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuD8SGrGlB7v19PdaOCi6TCCV_ygdajU_y_Ts0ePDLWlD4hf4b6PYslRaEvhb0ArDvaRmNDc_dKGcFmryKTn4YuA01vKjYCspgsGNNlfbfnRF9XTkDDH3e4bRnioqtmoeWTvT21n3IhMAQrMsw0Pns2qkNUgGQUZGehi1CvvM2s5EWoiElxdzPQv1Cm3W-Z07pL3rFTLAAICFTp7W5gO65H4vjXh9VY-8owPBa-aLdsX-BXiKbg1EeNlZrAr8_otczvy7FM45auSAzFf',
                            'LA',
                          ),
                          _buildMeetupItem(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCh9kuB8ur_udV5-7x0bJWX1p_Mib442eASAmv2xC1lL6Qs9LkcOtqmZRFBvWGWfRyQyqdpvyhTxyz9K3duNnyNcuwxac760IdKl4u3tADzx6O3U_TC7XlQU0WCOSjNqrT8cZsQ13fuICFMjZcgQJ93BPVwMENMGPvoEhIU-QfLG3GW2rhhghmYAwZyFv87XYdzvQjqa5CZYgb2WSdoEEA86EnQrK8eaj6QS8Wz9YtxaiLY9vG-SMPbv7y7R8cK8DdHi8UcP1DkqUBY',
                            'NYC',
                          ),
                          _buildMeetupItem(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAfNsB-ey5vslIl7fIun59UZGXMvGbg0xzacfOqtV9V0cMUTdvipNmeNErcaNYtqUgancb5ePOi828w9uYmzs-bCSqNsJpsLrCYRDigOSqnaAlVskykjj8mj4e2MRXLbccTFty0w3NFdthG2dorgLUKQ1x4-XxyI1NNgeCMpP06baVKv_D2nm7UTiW4TKuQIh0jV0Wc99vGrJtzRc1fqT566I4IdhMRaIIo-qjMi-ozKjw_ahMXEwHNhnLKqapAE32sP1mtwh3X3tAG',
                            'CHI',
                          ),
                          _buildMeetupItem(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDg7D3nara8kqP86CVCtR8-Om9WlVEZtQsKthBJoUgk2lqZNiIE69nG5zE4wIt04Xfjvr4FUuwAgBcaSXKXKl-D4hN3TaeVVPXX5X5KK1cKWOxZDfd_x6yy5o9zdJ2bMj3IuNN6tQG81-KmWtIuDhY8U45Kbr1CB4nXdevcYKdOgmpkRjYt7unWUp_u4lmkmZryGjoPmboo6BjflBfRitdhHD7d6JrzcOzKXORgzyeWbbJFQCgvHKB55cDegCM_YtzytgNOSrZH6lGo',
                            'SEA',
                          ),

                          // Add Photo placeholder
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.primary.withOpacity(0.2),
                                width: 2,
                                style: BorderStyle.none, // Can't easily do dashed border in basic container
                              ),
                            ),
                            child: Icon(
                              Icons.add_photo_alternate,
                              color: AppTheme.primary.withOpacity(0.4),
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80), // Padding for bottom nav
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: AppTheme.primary.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetupItem(String imageUrl, String location) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 8,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
