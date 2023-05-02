import 'package:json_annotation/json_annotation.dart';

import 'biography.dart';
import 'powerstats.dart';
import 'server_image.dart';

part 'superhero.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab, explicitToJson: true)
class Superhero {
  final String id;
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;

  Superhero({
    required this.name,
    required this.biography,
    required this.image,
    required this.id,
    required this.powerstats,
  });

  factory Superhero.fromJson(final Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);

  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}
