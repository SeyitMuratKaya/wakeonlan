import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool customColorSelected = false;
  bool autoDarkModeSelected = false;
  bool darkModeSelected = false;
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "App Theme",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text("Dark Mode"),
                  trailing: Switch(
                    onChanged: !autoDarkModeSelected
                        ? (bool value) {
                            setState(() {
                              darkModeSelected = value;
                            });
                          }
                        : null,
                    value: darkModeSelected,
                  ),
                ),
                ListTile(
                  title: const Text("Auto Dark Mode"),
                  trailing: Switch(
                    onChanged: (bool value) {
                      setState(() {
                        autoDarkModeSelected = value;
                      });
                    },
                    value: autoDarkModeSelected,
                  ),
                ),
                ListTile(
                  title: const Text("Custom Color"),
                  trailing: Switch(
                    onChanged: (bool value) {
                      setState(() {
                        customColorSelected = value;
                      });
                    },
                    value: customColorSelected,
                  ),
                ),
                Visibility(
                  visible: customColorSelected,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Colors.primaries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FilledButton(
                            onPressed: () {
                              debugPrint(Colors.primaries[index].toString());
                              setState(() {
                                selectedColor = index;
                              });
                            },
                            style: FilledButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.primaries[index],
                            ),
                            child: selectedColor == index
                                ? const Icon(Icons.check)
                                : null);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
