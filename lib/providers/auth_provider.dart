import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoes_store_app/models/auth_state.dart';
import 'package:shoes_store_app/providers/auth_notifier.dart';

final authProvider =  StateNotifierProvider<AuthNotifier,AuthState>((ref) => AuthNotifier(ref));