import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/theme_provider.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({
    super.key,
    // required this.providerOfTheme,
  });

  // final ThemeProvider providerOfTheme;

  @override
  Widget build(BuildContext context) {
    // and he adds the theme provider into the widget itself.
    // HOWEVER, I have TWO toggle widgets, so this may not be the most efficient way.
    // final providerOfThemeLocal = Provider.of<ThemeProvider>(context);
    // VS Code is complaining that this cannot be const... 
    ThemeProvider providerOfThemeLocal = Provider.of<ThemeProvider>(context);
    return IconButton(
      iconSize: 40,
      onPressed: providerOfThemeLocal.toggleDarkMode,
      icon: providerOfThemeLocal.isDarkMode
          ? const Icon(Icons.nightlight_outlined)
          : const Icon(Icons.wb_sunny_outlined),
    );
  }
}