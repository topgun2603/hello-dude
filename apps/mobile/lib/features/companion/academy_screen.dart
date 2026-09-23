import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

const _green = Color(0xFF10B981);

final academyProvider = FutureProvider.autoDispose<GetAcademy200Response>((
  ref,
) {
  final api = ref.watch(apiProvider);
  return api.call(() => api.companion.getAcademy());
});

/// Design: Training.dc.html — progress, current lesson, all lessons.
class AcademyScreen extends ConsumerWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final academy = ref.watch(academyProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: academy.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: _green)),
            error: (e, _) => Center(child: Text(friendlyError(e))),
            data: (a) {
              final current = a.lessons
                  .where((l) => l.status == AcademyLessonStatusEnum.available)
                  .firstOrNull;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Back',
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 12),
                      Text('Companion academy', style: AppText.heading(22)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${a.passed} of ${a.total} lessons done',
                    style: AppText.body(15, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: a.total == 0 ? 0 : a.passed / a.total,
                      minHeight: 10,
                      color: _green,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (current != null)
                    _LessonCard(lesson: current, highlight: true)
                  else
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0x2610B981),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        a.videoUnlocked
                            ? 'All lessons done and video calls are unlocked. 🎉'
                            : 'All lessons done! Video calls unlock after a quick review of your record.',
                        style: AppText.body(15, weight: FontWeight.w600),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'All lessons',
                    style: AppText.heading(17, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  for (final l in a.lessons) _LessonCard(lesson: l),
                  const SizedBox(height: 8),
                  Text(
                    'Finish all lessons to unlock video calls.',
                    textAlign: TextAlign.center,
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.lesson, this.highlight = false});
  final AcademyLesson lesson;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final (sub, icon, color) = switch (lesson.status) {
      AcademyLessonStatusEnum.done => (
        '${lesson.minutes} min · Done',
        Icons.check_circle_rounded,
        _green,
      ),
      AcademyLessonStatusEnum.available => (
        '${lesson.minutes} min read + ${lesson.quiz.length}-question quiz',
        Icons.play_circle_fill_rounded,
        const Color(0xFF6EE7B7),
      ),
      _ => (
        '${lesson.minutes} min · Unlocks next',
        Icons.lock_outline_rounded,
        AppColors.textSecondary,
      ),
    };
    final open = lesson.status != AcademyLessonStatusEnum.locked;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: highlight ? const Color(0x2610B981) : AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlight ? const Color(0x6610B981) : AppColors.cardBorder,
        ),
      ),
      child: ListTile(
        enabled: open,
        onTap: open
            ? () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => _LessonScreen(lesson)))
            : null,
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          '${lesson.position}. ${lesson.title}',
          style: AppText.body(15, weight: FontWeight.w700),
        ),
        subtitle: Text(
          sub,
          style: AppText.body(12.5, color: AppColors.textSecondary),
        ),
        trailing: open ? const Icon(Icons.chevron_right_rounded) : null,
      ),
    );
  }
}

class _LessonScreen extends ConsumerStatefulWidget {
  const _LessonScreen(this.lesson);
  final AcademyLesson lesson;

  @override
  ConsumerState<_LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<_LessonScreen> {
  late final List<int?> _answers = List.filled(widget.lesson.quiz.length, null);
  List<bool>? _result;
  bool _busy = false;

  Future<void> _submit() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(
        () => api.companion.answerLessonQuiz(
          widget.lesson.id,
          AnswerLessonQuizRequest(answers: _answers.map((a) => a!).toList()),
        ),
      );
      setState(() => _result = r.correct);
      if (r.passed) {
        ref.invalidate(academyProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lesson ${widget.lesson.position} passed!')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.lesson;
    final done = l.status == AcademyLessonStatusEnum.done;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${l.position} · ${l.title}',
                      style: AppText.heading(20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.body,
                  style: AppText.body(
                    15.5,
                    color: AppColors.textMuted,
                    height: 1.6,
                  ),
                ),
              ),
              if (!done) ...[
                const SizedBox(height: 24),
                Text('Quick quiz', style: AppText.heading(18)),
                Text(
                  'Get every answer right to pass.',
                  style: AppText.body(13, color: AppColors.textSecondary),
                ),
                for (final (i, q) in l.quiz.indexed) ...[
                  const SizedBox(height: 16),
                  Text(
                    '${i + 1}. ${q.q}',
                    style: AppText.body(15, weight: FontWeight.w700),
                  ),
                  if (_result != null && !_result![i])
                    Text(
                      'Not quite — try again',
                      style: AppText.body(12.5, color: AppColors.danger),
                    ),
                  RadioGroup<int>(
                    groupValue: _answers[i],
                    onChanged: (v) => setState(() {
                      _answers[i] = v;
                      _result = null;
                    }),
                    child: Column(
                      children: [
                        for (final (j, o) in q.options.indexed)
                          RadioListTile<int>(
                            value: j,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            activeColor: _green,
                            title: Text(o),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                GradientButton(
                  label: 'Check answers',
                  loading: _busy,
                  onPressed: _answers.contains(null) ? null : _submit,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
