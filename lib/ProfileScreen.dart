import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';
import 'models/recipe.dart';
import 'package:fl_chart/fl_chart.dart';
import 'unlogin.dart';
import 'dart:io';
import 'edit_profile_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/user_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfile>(
      builder: (context, userProfile, child) {
        final stats = _calculateStats(userProfile);
        
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black87),
                onPressed: () {
                  userProfile.logout().then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const UnloginScreen()),
                    );
                  });
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await userProfile.loadFromPrefs();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, userProfile),
                      const SizedBox(height: 24),
                      _buildStatCards(stats),
                      const SizedBox(height: 24),
                      _buildCookingChart(stats),
                      const SizedBox(height: 24),
                      _buildFavoriteCategories(userProfile),
                      const SizedBox(height: 24),
                      _buildActionButtons(context, userProfile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile userProfile) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          UserAvatar(
            imagePath: userProfile.avatar,
            size: 100,
            isEditable: false,
          ),
          const SizedBox(height: 16),
          Text(
            userProfile.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userProfile.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Редактировать профиль',
              ),
              const SizedBox(width: 24),
              IconButton(
                onPressed: () => _shareProfile(context, userProfile),
                icon: const Icon(Icons.share_outlined),
                tooltip: 'Поделиться профилем',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards(Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Избранных рецептов',
            stats['totalFavorites'].toString(),
            Icons.favorite,
            Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Среднее время готовки',
            '${stats['avgCookingTime'].round()} мин',
            Icons.timer,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCookingChart(Map<String, dynamic> stats) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Сложность рецептов',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: stats['difficultyStats']['Легкий'].toDouble(),
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.orange,
                          value: stats['difficultyStats']['Средний'].toDouble(),
                          title: '',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: stats['difficultyStats']['Сложный'].toDouble(),
                          title: '',
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Легкий', Colors.green, stats['difficultyStats']['Легкий']),
                        const SizedBox(height: 8),
                        _buildLegendItem('Средний', Colors.orange, stats['difficultyStats']['Средний']),
                        const SizedBox(height: 8),
                        _buildLegendItem('Сложный', Colors.red, stats['difficultyStats']['Сложный']),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($value)',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFavoriteCategories(UserProfile userProfile) {
    final categories = _getFavoriteCategories(userProfile);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Любимые категории',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text('${entry.key} (${entry.value})'),
                    backgroundColor: Colors.grey[100],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, UserProfile userProfile) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Выйти', style: TextStyle(color: Colors.red)),
          onTap: () => _logout(context, userProfile),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: Colors.white,
        ),
      ],
    );
  }

  Map<String, dynamic> _calculateStats(UserProfile userProfile) {
    final favorites = userProfile.favoriteRecipes;
    
    // Подсчет средней длительности готовки
    double avgCookingTime = 0;
    if (favorites.isNotEmpty) {
      avgCookingTime = favorites.fold(0, (sum, recipe) => sum + recipe.cookingTime) / favorites.length;
    }

    // Подсчет статистики по сложности
    final difficultyStats = {
      'Легкий': 0,
      'Средний': 0,
      'Сложный': 0,
    };

    for (var recipe in favorites) {
      difficultyStats[recipe.difficulty] = difficultyStats[recipe.difficulty]! + 1;
    }

    return {
      'totalFavorites': favorites.length,
      'avgCookingTime': avgCookingTime,
      'difficultyStats': difficultyStats,
    };
  }

  Map<String, int> _getFavoriteCategories(UserProfile userProfile) {
    final categoryCount = <String, int>{};
    for (var recipe in userProfile.favoriteRecipes) {
      categoryCount[recipe.category] = (categoryCount[recipe.category] ?? 0) + 1;
    }
    return Map.fromEntries(
      categoryCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value))
    );
  }

  void _shareProfile(BuildContext context, UserProfile userProfile) {
    final message = '''
FlavorCraft - Профиль пользователя
Имя: ${userProfile.name}
Email: ${userProfile.email}
Количество рецептов: ${userProfile.favoriteRecipes.length}
''';
    Share.share(message);
  }

  void _logout(BuildContext context, UserProfile userProfile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              await userProfile.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const UnloginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
