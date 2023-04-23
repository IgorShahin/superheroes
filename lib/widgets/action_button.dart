import 'package:flutter/widgets.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SuperheroesColors.blue,
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: SuperheroesColors.whiteText),
        ),
      ),
    );
  }
}
