import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/screens/weather_screen/weather_screen_provider.dart';
import 'package:weather_app_flutter/utils/app_sizes.dart';
import 'package:weather_app_flutter/utils/app_strings.dart';
import 'package:weather_app_flutter/widgets/custom_button.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherScreenProvider>(
      create: (context) => WeatherScreenProvider(),
      child: Consumer<WeatherScreenProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Weather'),
            ),
            body: SingleChildScrollView(
              padding: AppSizes.getSymmetricPadding(0.05, 0.02),
              child: Column(
                children: [
                  if (provider.loading)
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.getHeight(0.35)),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (provider.locationCouldNotGet)
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.getHeight(0.35)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(provider.errText),
                          const SizedBox(height: 10),
                          CustomButton(
                            text: AppStrings.refresh,
                            onPressed: provider.refresh,
                          ),
                        ],
                      ),
                    )
                  else
                    const Column(
                      children: [
                        
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
