import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class WebImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const WebImage({
    Key? key,
    required this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
  }) : super(key: key);

  String _getProxiedUrl(String url) {
    return "https://cors-proxy.fringe.zone/${url}";
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _getProxiedUrl(imageUrl),
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) {
        print('Error loading image: $error');
        return Container(
          color: Colors.grey[200],
          child: const Icon(Icons.error),
        );
      }
    );
  }
}