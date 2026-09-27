import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/device_list.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/filter_bar.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/presence_log.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/recording_bar.dart';
import 'package:beneathsos_app/features/field_test/presentation/widgets/scan_status_bar.dart';
import 'package:flutter/material.dart';

/// Field test tool: scanner control, recording, filters, devices and identity log.
class FieldTestScreen extends StatelessWidget {
  /// Creates the screen.
  const FieldTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        title: l10n.fieldTestTitle,
        padded: false,
        bottom: TabBar(
          tabs: [
            Tab(text: l10n.tabDevices),
            Tab(text: l10n.tabEvents),
          ],
        ),
        body: const Column(
          children: [
            ScanStatusBar(),
            RecordingBar(),
            FilterBar(),
            Expanded(
              child: TabBarView(children: [DeviceList(), PresenceLog()]),
            ),
          ],
        ),
      ),
    );
  }
}
