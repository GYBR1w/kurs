import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserAvatar extends StatelessWidget {
  final String? imagePath;
  final double size;
  final VoidCallback? onTap;
  final bool isEditable;

  const UserAvatar({
    Key? key,
    this.imagePath,
    this.size = 80,
    this.onTap,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: _buildImage(),
            ),
            if (isEditable)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    if (imagePath!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        placeholder: (context, url) => _buildLoadingIndicator(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    if (kIsWeb) {
      // Для веб используем NetworkImage
      return Image.network(
        imagePath!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      // Для мобильных платформ используем FileImage
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[100],
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: size * 0.5,
            color: Colors.grey[400],
          ),
          if (!isEditable)
            Positioned(
              bottom: size * 0.15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Нет фото',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.12,
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
      width: size,
      height: size,
      color: Colors.grey[100],
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
