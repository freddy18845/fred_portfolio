import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'data/portfolio_repository.dart';
import 'viewmodels/portfolio_view_model.dart';
import 'views/home_page.dart';

void main() {
  final viewModel = PortfolioViewModel(const InMemoryPortfolioRepository());
  runApp(PortfolioApp(viewModel: viewModel));
}

class PortfolioApp extends StatelessWidget {
  final PortfolioViewModel viewModel;
  const PortfolioApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    debugPrint('>>> RUNNING LATEST CODE');
    return MaterialApp(
      title: 'Fred Oppong – Software Developer',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: HomePage(viewModel: viewModel),
    );
  }
}
