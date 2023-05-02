import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

import '../blocs/main_bloc.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.indigo,
        ),
        child: Row(
          children: [
            Container(
              color: Colors.white24,
              width: 70,
              height: 70,
              child: CachedNetworkImage(
                  imageUrl: superheroInfo.imageUrl,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: SuperheroesColors.blue,
                          value: progress.progress,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Image.asset(
                        SuperHeroesImages.unknown,
                        height: 62,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    superheroInfo.name.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: SuperheroesColors.whiteText),
                  ),
                  Text(
                    superheroInfo.realName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: SuperheroesColors.whiteText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
