import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

/// The legal pages, in the order the app lists them. Ids match GET /v1/legal/:id.
const legalPages = <(String, String, IconData)>[
  ('terms', 'Terms of Use', Icons.description_outlined),
  ('privacy', 'Privacy Policy', Icons.lock_outline_rounded),
  ('community', 'Community Guidelines', Icons.favorite_border_rounded),
  ('grievance', 'Grievance Officer', Icons.support_agent_rounded),
  ('delete-account', 'Deleting your account', Icons.person_remove_outlined),
];

final legalPageProvider = FutureProvider.autoDispose
    .family<GetLegalPage200Response, String>((ref, id) {
      final api = ref.read(apiProvider);
      return api.call(() => api.legal.getLegalPage(id));
    });

/// Profile → Legal: list of policies.
class LegalIndexScreen extends StatelessWidget {
  const LegalIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalScaffold(
      title: 'Legal & policies',
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              for (final (i, (id, title, icon)) in legalPages.indexed) ...[
                if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
                ListTile(
                  key: ValueKey('legal-$id'),
                  leading: Icon(icon, color: AppColors.pinkSoft),
                  title: Text(title),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/legal/$id'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One policy, rendered natively from the server's blocks.
class LegalPageScreen extends ConsumerWidget {
  const LegalPageScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(legalPageProvider(id));
    final fallbackTitle = legalPages
        .firstWhere((p) => p.$1 == id, orElse: () => (id, 'Legal', Icons.info))
        .$2;
    return _LegalScaffold(
      title: page.valueOrNull?.title ?? fallbackTitle,
      children: page.when(
        loading: () => const [
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
        error: (e, _) => [
          const SizedBox(height: 40),
          Text(friendlyError(e), style: AppText.body(15), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => ref.invalidate(legalPageProvider(id)),
              child: const Text('Try again'),
            ),
          ),
        ],
        data: (p) => [
          if (p.draft)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Text(
                'Draft — some company details are still being filled in.',
                style: AppText.body(13, color: AppColors.warning),
              ),
            ),
          // The page title is already in the header.
          for (final b in p.blocks.skipWhile((b) => b.type == LegalBlockTypeEnum.h1))
            _Block(block: b),
        ],
      ),
    );
  }
}

class _LegalScaffold extends StatelessWidget {
  const _LegalScaffold({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: AppText.heading(22),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.block});
  final LegalBlock block;

  @override
  Widget build(BuildContext context) {
    final b = block;
    switch (b.type) {
      case LegalBlockTypeEnum.h1:
      case LegalBlockTypeEnum.h2:
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 6),
          child: _Rich(spans: b.spans, style: AppText.heading(b.type == LegalBlockTypeEnum.h1 ? 22 : 17)),
        );
      case LegalBlockTypeEnum.p:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _Rich(spans: b.spans),
        );
      case LegalBlockTypeEnum.ul:
      case LegalBlockTypeEnum.ol:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, item) in b.items.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          b.type == LegalBlockTypeEnum.ol ? '${i + 1}.' : '•',
                          style: AppText.body(15, color: AppColors.pinkSoft),
                        ),
                      ),
                      Expanded(child: _Rich(spans: item.spans)),
                    ],
                  ),
                ),
            ],
          ),
        );
      case LegalBlockTypeEnum.table:
        // Two-column tables (data → how long) read best as stacked cards on a phone.
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              for (final row in b.rows)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (i, cell) in row.cells.indexed)
                        Padding(
                          padding: EdgeInsets.only(top: i == 0 ? 0 : 4),
                          child: _Rich(
                            spans: cell.spans,
                            style: i == 0
                                ? AppText.body(15, weight: FontWeight.w700)
                                : AppText.body(14, color: AppColors.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
    }
  }
}

class _Rich extends StatelessWidget {
  const _Rich({required this.spans, this.style});
  final List<LegalSpan> spans;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? AppText.body(15, color: AppColors.textMuted);
    return Text.rich(
      TextSpan(
        style: base.copyWith(height: 1.5),
        children: [
          for (final s in spans)
            TextSpan(
              text: s.text,
              style: TextStyle(
                fontWeight: s.bold == true ? FontWeight.w700 : null,
                fontStyle: s.italic == true ? FontStyle.italic : null,
                color: s.href != null
                    ? AppColors.pinkSoft
                    : s.bold == true
                    ? Colors.white
                    : null,
                decoration: s.href != null ? TextDecoration.underline : null,
                decorationColor: AppColors.pinkSoft,
              ),
              // Links to other policies open inside the app.
              recognizer: s.href != null && legalPages.any((p) => p.$1 == s.href)
                  ? (TapGestureRecognizer()..onTap = () => context.push('/legal/${s.href}'))
                  : null,
            ),
        ],
      ),
    );
  }
}
