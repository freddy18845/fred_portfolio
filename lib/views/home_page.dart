import 'package:flutter/material.dart';
import 'package:freddyKing_portfolio/views/widgets/whatsapp_button.dart';

import '../viewmodels/portfolio_view_model.dart';
import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/education_section.dart';
import 'sections/faq_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/process_section.dart';
import 'sections/projects_section.dart';
import 'sections/reel_section.dart';
import 'sections/skills_section.dart';

/// Composes the sections. Contains no data or logic, only wiring to the view model.
class HomePage extends StatelessWidget {
  final PortfolioViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final vm = viewModel;
        final keys = vm.sectionKeys;
        return Scaffold(
          floatingActionButton: WhatsAppButton(onPressed: vm.chatOnWhatsApp),
          body: SingleChildScrollView(
            child: Column(children: [
              KeyedSubtree(
                key: keys[SectionId.home],
                child: HeroSection(profile: vm.profile, onNavigate: vm.scrollTo),
              ),
              KeyedSubtree(
                key: keys[SectionId.work],
                child: ProjectsSection(projects: vm.projects, onGetInTouch: vm.emailMe, onOpenLink: vm.openLink,),
              ),
              const ReelSection(),
              KeyedSubtree(
                key: keys[SectionId.about],
                child: AboutSection(
                    profile: vm.profile, experience: vm.experience, onOpenLink: vm.openLink),
              ),
              KeyedSubtree(
                key: keys[SectionId.process],
                child: ProcessSection(steps: vm.processSteps),
              ),
              SkillsSection(profile: vm.profile),
              KeyedSubtree(
                key: keys[SectionId.contact],
                child: ContactSection(profile: vm.profile, onEmail: vm.emailMe),
              ),
              EducationSection(items: vm.education),
              FaqSection(items: vm.faq, openIndex: vm.openFaq, onToggle: vm.toggleFaq),
              FooterSection(
                  profile: vm.profile, onNavigate: vm.scrollTo, onOpenLink: vm.openLink),
            ]),
          ),
        );
      },
    );
  }
}
