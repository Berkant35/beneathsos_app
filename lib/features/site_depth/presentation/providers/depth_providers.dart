import 'package:beneathsos_app/core/sessions/presentation/providers/session_providers.dart';
import 'package:beneathsos_app/features/site_depth/domain/set_depth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'depth_providers.g.dart';

/// Stores the depth of a search.
@Riverpod(keepAlive: true)
SetDepth setDepth(Ref ref) => SetDepth(ref.watch(sessionStoreProvider));
