import 'package:beneathsos_app/core/l10n_extension.dart';
import 'package:beneathsos_app/core/widgets/app_scaffold.dart';
import 'package:beneathsos_app/features/home/presentation/widgets/home_actions.dart';
import 'package:beneathsos_app/features/home/presentation/widgets/home_footer.dart';
import 'package:beneathsos_app/features/home/presentation/widgets/readiness_banner.dart';
import 'package:beneathsos_ui/beneathsos_ui.dart';
import 'package:flutter/material.dart';

/// Entry point: logo, one message, "Start a search" and "I am trapped". Scrolls at large text.
class HomeScreen extends StatelessWidget {
  /// Creates the home screen.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return AppScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: BeneathSpacing.l),
                  Center(
                    child: BeneathLogo.lockup(semanticLabel: l10n.logoLabel),
                  ),
                  const Spacer(),
                  Text(
                    l10n.homeHeadline,
                    style: text.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: BeneathSpacing.m),
                  Text(
                    l10n.homeBody,
                    style: text.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  const SizedBox(height: BeneathSpacing.xl),
                  const ReadinessBanner(),
                  const SizedBox(height: BeneathSpacing.m),
                  const HomeActions(),
                  const SizedBox(height: BeneathSpacing.l),
                  const HomeFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
