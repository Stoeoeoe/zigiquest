library;

import 'dart:async' as async;
import 'dart:convert';
import 'dart:math';
import 'dart:ui' show ImageFilter;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Transform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import 'zigi_sprite_data.dart';

part 'zigi_pile/zigi_pile_view.dart';
part 'zigi_pile/zigi_game.dart';
part 'zigi_pile/zigi_state_store.dart';
part 'zigi_pile/zigi_effects.dart';
part 'zigi_pile/zigi_painters.dart';
part 'zigi_pile/environments/environment.dart';
part 'zigi_pile/environments/forest_environment.dart';
part 'zigi_pile/environments/river_environment.dart';
part 'zigi_pile/environments/city_environment.dart';
part 'zigi_pile/environments/parking_environment.dart';
part 'zigi_pile/environments/environment_registry.dart';
