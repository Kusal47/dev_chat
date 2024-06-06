import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../resources/colors.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({super.key, this.height, this.width, required this.imageUrl, this.radius});
  final double? height;
  final double? width;
  final String imageUrl;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 50),
      child: CachedNetworkImage(
        height: height ?? 60,
        width: width ?? 60,
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircleAvatar(
            radius: 50, backgroundColor: primaryColor, child: Icon(Icons.person)),
        errorWidget: (context, url, error) => const CircleAvatar(
            radius: 50, backgroundColor: primaryColor, child: Icon(Icons.person)),
      ),
    );
  }
}
