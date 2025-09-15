import 'package:basketball_app/widgets/share_message.dart';
import 'package:basketball_app/widgets/share_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:basketball_app/models/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Choose if you want to display the mean or quantile of the statistics
            const SizedBox(height: 16),
            Text('Statistic settings',
                style: Theme.of(context).textTheme.titleMedium),
            const Text(
                'Select which statistics to display as mean or quantile'),
            SwitchListTile(
              title: const Text('Display Release Height as Mean'),
              value: context.watch<SettingsProvider>().showReleaseHeightMean,
              onChanged: (bool value) {
                context.read<SettingsProvider>().toggleReleaseHeightFormat();
              },
            ),
            SwitchListTile(
              title: const Text('Display Release Time as Mean'),
              value: context.watch<SettingsProvider>().showReleaseTimeMean,
              onChanged: (bool value) {
                context.read<SettingsProvider>().toggleReleaseTimeFormat();
              },
            ),
            SwitchListTile(
              title: const Text('Display Shot Depth as Mean'),
              value: context.watch<SettingsProvider>().showShotDepthMean,
              onChanged: (bool value) {
                context.read<SettingsProvider>().toggleShotDepthFormat();
              },
            ),
            SwitchListTile(
              title: const Text('Display Shot Position as Mean'),
              value: context.watch<SettingsProvider>().showShotPositionMean,
              onChanged: (bool value) {
                context.read<SettingsProvider>().toggleShotPositionFormat();
              },
            ),
            SwitchListTile(
              title: const Text('Display Entry Angle as Mean'),
              value: context.watch<SettingsProvider>().showEntryAngleMean,
              onChanged: (bool value) {
                context.read<SettingsProvider>().toggleEntryAngleFormat();
              },
            ),
            const SizedBox(height: 16),
            //Choose if you want to use audio feedback
            Text('Audio settings',
                style: Theme.of(context).textTheme.titleMedium),
            const Text('Toggle audio feedback'),
            SwitchListTile(
              title: const Text('Use Audio Feedback'),
              value: context.watch<SettingsProvider>().useAudio,
              onChanged: (bool value) {
                context.read<SettingsProvider>().toggleUseAudio();
              },
            ),
            //Choose statistics to recieve feedback on
            const SizedBox(height: 16), 
            //Variables to determine the size of the ball, rim and rim height used for video processing
            const SizedBox(height: 16),
            Text('Ball settings',
                style: Theme.of(context).textTheme.titleMedium),
            const Text(
                'Enter the size of your ball, rim and rim height in inches'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                initialValue:
                    context.watch<SettingsProvider>().ballSize.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Enter the size of your basketball (Default: 9.5)',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (String value) {
                  context
                      .read<SettingsProvider>()
                      .updateBallSize(double.parse(value));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                initialValue:
                    context.watch<SettingsProvider>().rimSize.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Enter the size of your rim (Default: 18)',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (String value) {
                  try {
                    context
                        .read<SettingsProvider>()
                        .updateRimSize(double.parse(value));
                  } catch (e) {
                    context
                      .read<SettingsProvider>()
                      .updateRimSize(0.0);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                initialValue:
                    context.watch<SettingsProvider>().rimHeight.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Enter the height of your rim (Default: 120)',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (String value) {
                  context
                      .read<SettingsProvider>()
                      .updateRimHeight(double.parse(value));
                },
              ),
            ),
            //Widget to share statistics with ability to make a custom message using buttons on the side
            const SizedBox(height: 16),
            Text('Share settings',
                style: Theme.of(context).textTheme.titleMedium),
            const Text(
                'The message to share your statistics with your friends or coaches'),
            const Tooltip(
              message:
                  'This calculates statistics over the last month, use the stats screen to view all time stats.',
              triggerMode: TooltipTriggerMode.tap,
              child: Icon(Icons.info),
            ),
            ShareMessage(),
            const SharePopup(),
          ],
        ),
      ),
    );
  }
}
