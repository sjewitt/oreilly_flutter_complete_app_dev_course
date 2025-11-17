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

void main() {
  // as before, we need to wrap this in a change notifier:

  // for #7.8 theme provider, we need another change notifier provider...
  // so how do we add > 1 provider to the context?
  // we need to wrap the changenotifierprovider with a MULTIPROVIDER widget:
  runApp(
    MultiProvider(
      providers: [
        // Provider<Something>(create: (_) => Something()),
        // from tooltip hint:
        // Provider<TipCalculatorModel>(create: (context) => TipCalculatorModel(),),
        // Provider<ThemeProvider>(create: (context) => ThemeProvider(),)
        // from course:
        ChangeNotifierProvider(create: (context) => TipCalculatorModel()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      // from course:
      child: const MyApp(),
      // child: ChangeNotifierProvider(
      //   // why does he remove the BuildContext type here? It works anyway with
      //   // that included...
      //   create: (context) => TipCalculatorModel(),
      //   child: const MyApp(),
      // ),
      // builder: (context, child){
      //   final
      // },
      // child: ChangeNotifierProvider(
      //   // why does he remove the BuildContext type here? It works anyway with
      //   // that included...
      //   create: (context) => TipCalculatorModel(),
      //   child: const MyApp(),
      // ),
    ),
    // const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final toplevelTheme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'UTip App',

      // for light/dark mode bit, he changes this theme setup to:
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      // he also notes the scope problem with - for me - `providerOfTheme`, so
      // he copies to here - but it can be a different var:
      theme: toplevelTheme.currentTheme,
      // so we probably don't need the programmatic one below.
      // actually we DO, the one here is just reading, whereas the one
      // below provides the actual logic.
      // but I probably don't need the stylimng bit I added...
      // No I don't...
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

  // switch test
  bool _testSwitchVal = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // from course material, for comparison (see console logs):

    // and here, I could use the provider.of() ??
    final providerOfUTIPModel = Provider.of<TipCalculatorModel>(context);

    // and from the multiprovider list above, we can instantiate another
    // provider - a Theme provider in this case:
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
          // he adds an IconButton instead:
          IconButton(
            iconSize: 40,
            onPressed: providerOfTheme.toggleDarkMode,
            // can I do a function here to return an Icon?
            //// yes, use a ternary operator here from ThemeProvider:
            icon: providerOfTheme.isDarkMode
                ? Icon(Icons.nightlight_outlined)
                : Icon(Icons.wb_sunny_outlined),
            // Icon(Icons.wb_sunny_outlined,
          ),
          Switch(
            onChanged: (newVal) {
              setState(() {
                _testSwitchVal = !_testSwitchVal;
                // if (_testSwitchVal)
                //   _testSwitchVal = false;
                // else
                //   _testSwitchVal = true;
                // and update the value
                _testSwitchVal = newVal;
              });
              //or:
              // onChanged: providerOfTheme.toggleDarkMode, // and THIS is why you changed to an icon switch instead...
            },
            padding: EdgeInsets.all(20),
            value: _testSwitchVal,
          ),
          Text("$_testSwitchVal"),

          // iconSize: 50,
          // ),
        ],
      ),

      body: //Container(
          //child: // here, add the Consumer and wrap around the Column, as everything is inside this
          Consumer<TipCalculatorModel>(
            builder:
                (BuildContext ctx, TipCalculatorModel tipModel, Widget? child) {
                  return (Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,

                    children: [
                      TotalPerPersonHeader(
                        theme: theme,
                        // theme: providerOfTheme.currentTheme,
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
                                // theme: providerOfTheme.currentTheme,
                                personCount: tipModel.personCount,
                                onDecrement: tipModel.decrementCounter,
                                onIncrement: tipModel.incrementCounter,
                              ),

                              // make tip percent display consistent:
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
                                // theme: providerOfTheme.currentTheme,
                                finalTipTotalOutput:
                                    tipModel.finalTipTotalOutput,
                              ),

                              // Text("Tip: ${tipPercentPerPerson.round()}%"),
                              // Here, I need to pass in the
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
    // );
  }
}
