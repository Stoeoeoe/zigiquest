import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../app/app.dart';
import '../core/database/app_database.dart';
import '../core/services/achievements.dart';
import '../core/services/active_session_store.dart';
import '../core/services/engagement_preferences.dart';
import '../core/services/notification_service.dart';
import '../core/services/rating_service.dart';
import '../core/services/session_persistence.dart';
import '../core/services/sync_coordinator.dart';
import '../core/services/sync_status.dart';
import '../core/services/auth_service.dart';
import '../core/services/collection_repository.dart';
import '../core/services/location_service.dart';
import '../core/services/profile_service.dart';
import '../core/services/progression.dart';
import '../core/services/session_photo_service.dart';
import 'discover_content.dart';
import 'visualization/zigi_pile.dart';

part 'screen_state.dart';
part 'today_screen.dart';
part 'history_screen.dart';
part 'quests_screen.dart';
part 'session_screen.dart';
part 'profile_screen.dart';
part 'settings_screen.dart';
