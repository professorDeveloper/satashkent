import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/question.dart';

class QuestionLabels {
  static String type(QuestionType t) {
    switch (t) {
      case QuestionType.singleChoice:
        return 'singleChoiceLabel'.tr();
      case QuestionType.multiChoice:
        return 'multiChoiceLabel'.tr();
      case QuestionType.input:
        return 'inputLabel'.tr();
      case QuestionType.multiInput:
        return 'multiInputLabel'.tr();
      case QuestionType.inputOption:
        return 'inputOptionLabel'.tr();
      case QuestionType.unknown:
        return '—';
    }
  }

  static String complexity(QuestionComplexity c) {
    switch (c) {
      case QuestionComplexity.easy:
        return 'EASY';
      case QuestionComplexity.medium:
        return 'MEDIUM';
      case QuestionComplexity.hard:
        return 'HARD';
      case QuestionComplexity.unknown:
        return '—';
    }
  }

  static String subject(QuestionSubject s) {
    switch (s) {
      case QuestionSubject.math:
        return 'Math';
      case QuestionSubject.english:
        return 'English';
      case QuestionSubject.apCalculus:
        return 'AP Calculus';
      case QuestionSubject.apChemistry:
        return 'AP Chemistry';
      case QuestionSubject.apCsA:
        return 'AP CS A';
      case QuestionSubject.apMacro:
        return 'AP Macro';
      case QuestionSubject.apMicro:
        return 'AP Micro';
      case QuestionSubject.apBiology:
        return 'AP Biology';
      case QuestionSubject.apStatistics:
        return 'AP Statistics';
      case QuestionSubject.apPhysicsC:
        return 'AP Physics C';
      case QuestionSubject.unknown:
        return '—';
    }
  }

  static String status(QuestionStatus s) {
    switch (s) {
      case QuestionStatus.newOne:
        return 'statusNew'.tr();
      case QuestionStatus.correct:
        return 'statusCorrect'.tr();
      case QuestionStatus.wrong:
        return 'statusIncorrect'.tr();
      case QuestionStatus.unknown:
        return '—';
    }
  }

  static Color complexityColor(QuestionComplexity c) {
    switch (c) {
      case QuestionComplexity.easy:
        return const Color(0xFF239B5C);
      case QuestionComplexity.medium:
        return const Color(0xFFE89B2D);
      case QuestionComplexity.hard:
        return const Color(0xFFD63A3A);
      case QuestionComplexity.unknown:
        return const Color(0xFF8A8A92);
    }
  }

  static IconData typeIcon(QuestionType t) {
    switch (t) {
      case QuestionType.singleChoice:
        return Icons.radio_button_checked_rounded;
      case QuestionType.multiChoice:
        return Icons.check_box_rounded;
      case QuestionType.input:
        return Icons.text_fields_rounded;
      case QuestionType.multiInput:
        return Icons.dynamic_form_rounded;
      case QuestionType.inputOption:
        return Icons.input_rounded;
      case QuestionType.unknown:
        return Icons.help_outline_rounded;
    }
  }
}
