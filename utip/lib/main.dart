// see https://stackoverflow.com/questions/75097840/is-double-and-double-are-different-thing-in-dart-and-if-it-is-can-anyone-explain
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utip/providers/theme_provider.dart';
import 'package:utip/providers/tip_calculator_model.dart';
import 'package:utip/widgets/bill_amt_text_field.dart';
import 'package:utip/widgets/person_counter.dart';
import 'package:utip/widgets/tip_percent_slider.dart';
import 'package:utip/widgets/tip_total_amt.dart';
import 'package:utip/widgets/total_per_person_header.dart';
import 'package:utip/widgets/toggle_theme_button.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TipCalculatorModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final toplevelTheme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'UTip App',
      theme: toplevelTheme.currentTheme,
      home: const UTip(),
    );
  }
}

class UTip extends StatefulWidget {
  const UTip({super.key});

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  int personCount = 0;
  bool _testSwitchVal = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final providerOfUTIPModel = Provider.of<TipCalculatorModel>(context);
    final providerOfTheme = Provider.of<ThemeProvider>(context);
    debugPrint("${providerOfTheme.currentTheme}");
    debugPrint("${providerOfTheme.currentTheme.colorScheme}");

    double totalPP = providerOfUTIPModel.totalPP;
    double totalT = providerOfUTIPModel.totalT;

    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("UTip"),
        actions: [
          // the extract widget at 08:30 is what I missed
          // he them removes the theme
          // ToggleThemeButton(providerOfTheme: providerOfTheme),
          ToggleThemeButton(),
          // and does *something* wit the scope of the theme?? The red error underline is missing required arg of theme provider...
          // he takes the themeProvider (`providerOfTheme`) from above...
          
          // my tests:
          // take THIS, and amend as pe above - extract ToggleThemeSwitch,
          // and move the logic to a provider as per above/extracted widget.
          Switch(
            // this WORKS, but the toggle doesn't change...
            // onChanged:(value) => {providerOfTheme.toggleDarkModeWithReturnVal()},
            
            // onChanged:(value) => {debugPrint(value.toString())},
            // onChanged: providerOfTheme.toggleDarkModeWithReturnVal(),
            onChanged: (newVal) {
              setState(() { // not sure how to extract this to a provider
                _testSwitchVal = !_testSwitchVal;
                _testSwitchVal = newVal;
                providerOfTheme.toggleDarkMode(); // This works too. This should go into a provider
              });
            },
            padding: EdgeInsets.all(20),
            value: _testSwitchVal,
          ),
          Text("$_testSwitchVal"),
        ],
      ),

      body:
        Consumer<TipCalculatorModel>(
          builder:
              (BuildContext ctx, TipCalculatorModel tipModel, Widget? child) {
                return (Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,

                  children: [
                    TotalPerPersonHeader(
                      theme: theme,
                      style: style,
                      finalCostPerPersonOutput:
                          tipModel.finalCostPerPersonOutput,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),

                        child: Column(
                          children: [
                            BillAmtTextField(
                              personCount: tipModel.personCount,
                              tipPercentPerPerson:
                                  tipModel.tipPercentPerPerson,
                              handleBillAmount: tipModel.handleBillAmount,
                            ),

                            PersonCounter(
                              theme: theme,
                              personCount: tipModel.personCount,
                              onDecrement: tipModel.decrementCounter,
                              onIncrement: tipModel.incrementCounter,
                            ),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Tip percent:",
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  "${tipModel.tipPercentPerPerson.round()}%",
                                ),
                              ],
                            ),

                            TipTotalAmount(
                              theme: theme,
                              finalTipTotalOutput:
                                  tipModel.finalTipTotalOutput,
                            ),
                            TipPercentSlider(
                              sliderPos: tipModel.sliderPos,
                              tipPercentPerPerson:
                                  tipModel.tipPercentPerPerson,
                              setSliderValue: tipModel.setSliderValue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
              },
          ),
    );
  }
}

// class ToggleThemeButton extends StatelessWidget {
//   const ToggleThemeButton({
//     super.key,
//     // required this.providerOfTheme,
//   });

//   // final ThemeProvider providerOfTheme;

//   @override
//   Widget build(BuildContext context) {
//     // and he adds the theme provider into the widget itself.
//     // HOWEVER, I have TWO toggle widgets, so this may not be the most efficient way.
//     final providerOfThemeLocal = Provider.of<ThemeProvider>(context);
//     return IconButton(
//       iconSize: 40,
//       onPressed: providerOfThemeLocal.toggleDarkMode,
//       icon: providerOfThemeLocal.isDarkMode
//           ? Icon(Icons.nightlight_outlined)
//           : Icon(Icons.wb_sunny_outlined),
//     );
//   }
// }
