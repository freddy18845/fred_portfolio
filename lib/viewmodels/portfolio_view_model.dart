import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../data/portfolio_repository.dart';
import '../models/card_info.dart';
import '../models/experience.dart';
import '../models/faq_item.dart';
import '../models/process_step.dart';
import '../models/profile.dart';

enum SectionId { home, work, about, process, contact }

/// Holds all page state and exposes the data the views render.
class PortfolioViewModel extends ChangeNotifier {
  PortfolioViewModel(this._repository);

  final PortfolioRepository _repository;

  /// One key per section so the nav can scroll to it.
  final Map<SectionId, GlobalKey> sectionKeys = {
    for (final id in SectionId.values) id: GlobalKey(),
  };

  int? _openFaq = 0;
  int? get openFaq => _openFaq;

  Profile get profile => _repository.profile;
  List<CardInfo> get projects => _repository.projects;
  List<Experience> get experience => _repository.experience;
  List<ProcessStep> get processSteps => _repository.processSteps;
  List<CardInfo> get education => _repository.education;
  List<FaqItem> get faq => _repository.faq;

  void scrollTo(SectionId id) {
    final context = sectionKeys[id]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(context,
        duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
  }

  void toggleFaq(int index) {
    _openFaq = _openFaq == index ? null : index;
    notifyListeners();
  }

  void openLink(String url) => launchLink(url);
  void emailMe() => launchLink('mailto:${profile.personalEmail}');

  void chatOnWhatsApp() {
    final phone = profile.whatsapp.replaceAll(RegExp(r'\D'), '');
    final text = Uri.encodeComponent(
        'Hi Fred, I found your portfolio and would like to talk.');
    launchLink('https://wa.me/$phone?text=$text');
  }
}
