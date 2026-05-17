import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/question_detail.dart';
import 'comment_tile.dart';

class CommentsList extends StatelessWidget {
  final bool loading;
  final List<QuestionComment> comments;

  const CommentsList({
    super.key,
    required this.loading,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && comments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.brand,
            ),
          ),
        ),
      );
    }
    if (comments.isEmpty) {
      final muted =
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(
            'commentsEmpty'.tr(),
            style: TextStyle(fontSize: 13.5, color: muted),
          ),
        ),
      );
    }
    final list = comments.reversed.toList(growable: false);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => CommentTile(item: list[i]),
    );
  }
}

class CommentComposer extends StatefulWidget {
  final String draft;
  final bool posting;
  final String? error;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;

  const CommentComposer({
    super.key,
    required this.draft,
    required this.posting,
    required this.error,
    required this.onChanged,
    required this.onSend,
  });

  @override
  State<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.draft);

  @override
  void didUpdateWidget(covariant CommentComposer old) {
    super.didUpdateWidget(old);
    if (widget.draft != _controller.text) {
      _controller.text = widget.draft;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canSend =
        !widget.posting && _controller.text.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.error != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.error!,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'commentWritePlaceholder'.tr(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              width: 48,
              child: Material(
                color: canSend
                    ? AppColors.brand
                    : scheme.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: canSend ? widget.onSend : null,
                  child: Center(
                    child: widget.posting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            size: 20,
                            color: canSend
                                ? Colors.white
                                : scheme.onSurface.withValues(alpha: 0.4),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
