part of '../../zigi_pile.dart';

const containerStyles = <String, Environment>{
  'glass_jar': CityEnvironment(),
  'forest_glass': ForestEnvironment(),
  'amber_glass': RiverEnvironment(),
  'night_glass': ParkingEnvironment(),
};
Environment _environmentOf(String key) =>
    containerStyles[key] ?? containerStyles['glass_jar']!;
String sceneAssetFor(String style) => _environmentOf(style).sceneAsset;

Map<String, String> containerStyleLabels(BuildContext context) => {
  for (final entry in containerStyles.entries) entry.key: entry.value.label(context),
};
