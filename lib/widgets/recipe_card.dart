import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'dart:math' as math;

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final bool isFavorite;
  final Function(bool)? onFavoriteChanged;

  const RecipeCard({
    Key? key,
    required this.recipe,
    this.onTap,
    this.showFavoriteButton = true,
    this.isFavorite = false,
    this.onFavoriteChanged,
  }) : super(key: key);

  Future<void> _showRemoveConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Удалить из избранного?'),
          content: Text(
            'Вы уверены, что хотите удалить "${recipe.title}" из избранного?',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Отмена',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      onFavoriteChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecipeImage(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            _buildInfoChip(Icons.timer, '${recipe.cookingTime} мин'),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              Icons.restaurant_menu,
                              recipe.difficulty,
                              color: _getDifficultyColor(recipe.difficulty),
                            ),
                          ],
                        ),
                      ),
                      if (showFavoriteButton)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (isFavorite) {
                                _showRemoveConfirmationDialog(context);
                              } else {
                                onFavoriteChanged?.call(true);
                              }
                            },
                            customBorder: const CircleBorder(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey.shade600,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              Image.network(
                recipe.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImageError(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImageLoading();
                },
              )
            else
              _buildImageError(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: PatternPainter(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.restaurant,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Фото недоступно',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoading() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'легкий':
        return Colors.green;
      case 'средний':
        return Colors.orange;
      case 'сложный':
        return Colors.red;
      default:
        return Colors.grey.shade600;
    }
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 20.0;
    final xCount = (size.width / spacing).ceil() + 1;
    final yCount = (size.height / spacing).ceil() + 1;

    // Рисуем сетку из маленьких значков
    for (var i = 0; i < xCount; i++) {
      for (var j = 0; j < yCount; j++) {
        final x = i * spacing;
        final y = j * spacing;

        // Добавляем случайное смещение для каждого значка
        final offset = math.Random(i * yCount + j).nextDouble() * 4 - 2;

        // Рисуем маленький значок еды
        canvas.save();
        canvas.translate(x + offset, y + offset);
        canvas.rotate(math.Random(i * yCount + j).nextDouble() * math.pi / 6 -
            math.pi / 12);

        // Рисуем простой значок
        final path = Path()
          ..moveTo(-3, -3)
          ..lineTo(3, 3)
          ..moveTo(-3, 3)
          ..lineTo(3, -3);

        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
