import 'dart:convert';

class Pokemon {
  final String name;
  final String img;
  final List<String> type;

  Pokemon({
    required this.name,
    required this.img,
    required this.type,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'] ?? 'Nome desconhecido',
      img: json['img'] ?? '',
      type: List<String>.from(json['type'].map((x) => x.toString())),
    );
  }
}
List<Pokemon> parsePokemons(String responseBody) {
  final Map<String, dynamic> parsedJson = json.decode(responseBody);
  final List<dynamic> pokemonJsonList = parsedJson['pokemon'];
  return pokemonJsonList
      .map((json) => Pokemon.fromJson(json))
      .toList();
}