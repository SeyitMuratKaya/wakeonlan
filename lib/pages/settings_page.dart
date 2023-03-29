import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SettingsItem(
            itemTitle: "App Theme",
            card: Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Dark Mode"),
                    trailing: Switch(
                      onChanged: !appTheme.autoThemeModeSelected
                          ? (bool value) {
                              appTheme.darkModeSelected = value;
                            }
                          : null,
                      value: appTheme.darkModeSelected,
                    ),
                  ),
                  ListTile(
                    title: const Text("Auto Theme Mode"),
                    trailing: Switch(
                      onChanged: (bool value) {
                        appTheme.autoThemeModeSelected = value;
                      },
                      value: appTheme.autoThemeModeSelected,
                    ),
                  ),
                  ListTile(
                    title: const Text("Custom Color"),
                    trailing: Switch(
                      onChanged: (bool value) {
                        appTheme.customColorSelected = value;
                        appTheme.color =
                            Colors.primaries[appTheme.selectedColor];
                      },
                      value: appTheme.customColorSelected,
                    ),
                  ),
                  Visibility(
                    visible: appTheme.customColorSelected,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: Colors.primaries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return FilledButton(
                              onPressed: () {
                                appTheme.selectedColor = index;
                                appTheme.color = Colors.primaries[index];
                              },
                              style: FilledButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.primaries[index],
                              ),
                              child: appTheme.selectedColor == index
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : null);
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatefulWidget {
  const SettingsItem({super.key, required this.itemTitle, required this.card});

  final String itemTitle;
  final Card card;

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  widget.itemTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
              ],
            ),
          ),
          widget.card
        ],
      ),
    );
  }
}
