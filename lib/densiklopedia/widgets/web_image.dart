// web_image.dart

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

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

  @override
  Widget build(BuildContext context) {
    // Registrasi view factory
    final uniqueId = imageUrl; // Gunakan identifikasi unik

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      uniqueId,
      (int viewId) => html.ImageElement()
        ..src = imageUrl
        ..style.width = '100%'
        ..style.height = '100%',
    );

    return SizedBox(
      height: height,
      width: width,
      child: HtmlElementView(viewType: uniqueId),
    );
  }
}
