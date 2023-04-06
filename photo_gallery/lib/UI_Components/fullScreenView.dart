import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_gallery/UI_Components/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroExample extends StatefulWidget {
  static const routeName = '/splash';
  final String imageUrl;
  final String uniqueId;
  final String title;

  const HeroExample({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.uniqueId,
  }) : super(key: key);
  @override
  _HeroExampleState createState() => _HeroExampleState();
}

class _HeroExampleState extends State<HeroExample> {
  double imageHeight = 350;
  double imageWidth = 350;

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: "Photo View",
      showGoBack: true,
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HeroPhotoViewRouteWrapper(
                  imageProvider: NetworkImage(
                    widget.imageUrl.toString(),
                  ),
                ),
              ),
            );
          },
          child: Center(
            child: Hero(
              tag: widget.uniqueId.toString(),
              child: CachedNetworkImage(
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.fitWidth,
                imageUrl: widget.imageUrl,
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 30,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
