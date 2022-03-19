import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // IS OK?
    String _themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: SizedBox(
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              //first container
              height: 20,
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    // color: Colors.white,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: null,
                ),
              ),
            ),
            SizedBox(
              //second container
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.light_mode_outlined),
                      const Text('Light'),
                      Radio(
                        value: 'Light',
                        groupValue: _themeMode,
                        onChanged: (val) {
                          _themeMode = val as String;
                          Provider.of<ThemeProvider>(context, listen: false)
                              .setSelectedTheme('Light');
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.light_mode),
                      const Text('Dark'),
                      Radio(
                        value: 'Dark',
                        groupValue: _themeMode,
                        onChanged: (val) {
                          _themeMode = val as String;
                          Provider.of<ThemeProvider>(context, listen: false)
                              .setSelectedTheme('Dark');
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.light_mode_sharp),
                      const Text('System'),
                      Radio(
                        value: 'System',
                        groupValue: _themeMode,
                        onChanged: (val) {
                          _themeMode = val as String;
                          Provider.of<ThemeProvider>(context, listen: false)
                              .setSelectedTheme('System');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
