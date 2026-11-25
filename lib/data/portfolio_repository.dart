import 'dart:ui';

import '../models/card_info.dart';
import '../models/experience.dart';
import '../models/faq_item.dart';
import '../models/process_step.dart';
import '../models/profile.dart';

/// Source of portfolio content. Swap the implementation to load from an API.
abstract interface class PortfolioRepository {
  Profile get profile;
  List<CardInfo> get projects;
  List<Experience> get experience;
  List<ProcessStep> get processSteps;
  List<CardInfo> get education;
  List<FaqItem> get faq;
}

class InMemoryPortfolioRepository implements PortfolioRepository {
  const InMemoryPortfolioRepository();

  @override
  Profile get profile => const Profile(
    name: 'Fred Oppong',
    role: 'Software Developer · Mobile payments engineer',
    location: 'Accra, Ghana',
    phone: '+233-560718845/+233-542158570',
    workEmail: 'foppong@sovereign-pay.com',
    personalEmail: 'fredoppong89@gmail.com',
    linkedIn: 'https://linkedin.com/in/fred-oppong-370054193',
    whatsapp: '233560718845',
    headline: 'Secure mobile payments that work across Africa.',
    aboutLead:
    'Flutter apps for fintech: 3+ years building secure, high-performance Android, Web and Desktop apps.',
    quote: 'Focused on reliable, scalable and well-tested mobile experiences.',
    achievement:
    'Optimized for low-power devices, fast and reliable on the budget solutions common across Africa.',
    skills: [
      'Flutter',
      'Dart',
      'Kotlin',
      'Java',
      'Firebase',
      'SQL',
      'Git',
      'Agile',
      'Figma',
    ],
  );

  // Card convention (matches the redesign):
  //  - tags[0] is the platform (shown as orange text); the rest are pills.
  //  - subtitle line 1 says what you built; line 2 is the country (no '#').
  @override
  List<CardInfo> get projects => const [
    CardInfo(
        title: 'Grants withdrawal app',
        subtitle:
        'Built the secure login and payout flow that lets grant recipients collect their payments at retail tills.'
            '\nSouth Africa',
        assets: 'assets/images/mojo_money.png',
        tags: ['Android', 'Government', 'Payments'],
        colors: [Color(0xFF2B2B2B), Color(0xFF4B3A35)]),
    CardInfo(
        title: 'Food ordering app',
        subtitle:
        'Delivery ordering with NFC card payments and Mobile Money checkout, live on the Play Store.'
            '\nZimbabwe',
        assets: 'assets/images/slice_mobile.png',
        link:
        'https://play.google.com/store/apps/details?id=com.soveriegn_pay.ltd.slice_mobile_app',
        tags: ['iOS · Android', 'Food & retail', 'Flutter'],
        colors: [Color(0xFFE8583A), Color(0xFFF2A48F)]),
    CardInfo(
        title: 'Food ordering kiosk',
        subtitle:
        'Self-service ordering that sends payment requests straight to certified POS and Speedpoint terminals.'
            '\nZimbabwe',
        // TODO: replace with a flow diagram: Kiosk -> Payment request -> POS / Speedpoint
        assets: '',
        tags: ['Kiosk', 'Retail', 'Self-service'],
        colors: [Color(0xFF1F3A4D), Color(0xFF4F8AA8)]),
    CardInfo(
        title: 'Core banking integration',
        subtitle:
        'Built a desktop app that processes debit and prepaid card transactions through the core banking system.'
            '\nEswatini',
        // TODO: replace with a flow diagram: Banking app -> T24 -> Postilion
        assets: '',
        tags: ['Desktop', 'Banking', 'T24', 'Postilion'],
        colors: [Color(0xFF3B2F4F), Color(0xFF8B6FB5)]),
  ];

  @override
  List<Experience> get experience => const [
    Experience('Sovereign Payment Solution',
        'System Analyst & Software Engineer', '2024'),
    Experience('Sovereign Payment Solution', 'Mobile Engineer', '2023'),
    Experience('First Atlantic Bank', 'IT Support', '2021'),
    Experience('Accra Institute of Technology', 'BSc Computer Science', '2023'),
  ];

  @override
  List<ProcessStep> get processSteps => const [
    ProcessStep('01', 'Analyze',
        'I work with clients and stakeholders to understand business requirements before designing the solution.'),
    ProcessStep('02', 'Build',
        'Flutter and Dart with BLoC, Provider or MVVM, plus REST and payment gateway integration.'),
    ProcessStep('03', 'Test',
        'I test payment flows, error handling and user experience to catch issues before release.'),
    ProcessStep('04', 'Deploy',
        'I lead rollouts of enterprise payment solutions in several African countries.'),
  ];

  @override
  List<CardInfo> get education => const [
    CardInfo(
        title: 'HND Computer Science',
        subtitle: 'Accra Technical University',
        period: '2016 – 2019',
        tags: ['Diploma'],
        colors: [Color(0xFF1F3A4D), Color(0xFF4F8AA8)]),
    CardInfo(
        title: 'Introduction to Data Science',
        subtitle: 'LinkedIn Learning',
        period: 'Feb 2020',
        tags: ['Certificate'],
        colors: [Color(0xFF3B2F4F), Color(0xFF8B6FB5)]),
    CardInfo(
        title: 'Usable Security',
        subtitle: 'University of Maryland',
        period: 'Jan 2022',
        tags: ['Certificate'],
        colors: [Color(0xFFE8583A), Color(0xFFF2A48F)]),
    CardInfo(
        title: 'BSc Computer Science',
        subtitle: 'Accra Institute of Technology',
        period: '2023 – 2025',
        tags: ['Degree'],
        colors: [Color(0xFF2B2B2B), Color(0xFF4B3A35)]),
  ];

  @override
  List<FaqItem> get faq => const [
    FaqItem('What do you build?',
        'Cross-platform Flutter apps for iOS and Android, mostly in fintech, with secure authentication and payment flows.'),
    FaqItem('Which payment methods do you integrate?',
        'NFC card payments, Mobile Money, POS and Speedpoint devices, and third-party payment gateways through REST APIs.'),
    FaqItem('Is mobile the only kind of app you can build?',
        'No. I have also built web, website and desktop applications over the years.'),
    FaqItem('Can you work with design teams?',
        'Yes. I work in agile teams with UX/UI designers, use Figma for UI work, and take customer feature requests directly.'),
    FaqItem('Do you work across countries?',
        'Yes. I have deployed payment solutions in several African countries, working directly with clients.'),
    FaqItem('How can we get in touch?',
        'Email fredoppong89@gmail.com or foppong@sovereign-pay.com, or call +233-560718845.'),
  ];
}