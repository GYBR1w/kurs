import 'package:flutter/material.dart';

class FallbackImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final IconData fallbackIcon;
  final double iconSize;
  final Color iconColor;
  final bool isCircle;

  const FallbackImage({
    Key? key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.fallbackIcon = Icons.image_outlined,
    this.iconSize = 24,
    this.iconColor = Colors.grey,
    this.isCircle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: isCircle ? null : borderRadius,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: ClipRRect(
        borderRadius: isCircle 
            ? BorderRadius.circular(width / 2) 
            : (borderRadius ?? BorderRadius.zero),
        child: imageUrl == null || imageUrl!.isEmpty
            ? _buildFallback()
            : Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) => _buildFallback(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingIndicator();
                },
              ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            fallbackIcon,
            size: iconSize,
            color: iconColor,
          ),
          Positioned(
            bottom: height * 0.15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Изображение недоступно',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
