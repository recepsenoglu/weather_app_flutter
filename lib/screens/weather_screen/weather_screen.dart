import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/daily_forecast_model.dart';
import '../../models/hourly_forecast_model.dart';
import '../../models/info_model.dart';
import '../../models/weather_element_models/sys_model.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/info_box.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/styled_box.dart';
import 'weather_screen_provider.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherScreenProvider>(
      create: (context) => WeatherScreenProvider(),
      child: Consumer<WeatherScreenProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            strokeWidth: 4,
            displacement: AppSizes.getHeight(0.15),
            onRefresh: provider.refresh,
            color: Theme.of(context).colorScheme.onSurface,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                toolbarHeight: 0,
                systemOverlayStyle:
                    Theme.of(context).brightness == Brightness.light
                        ? SystemUiOverlayStyle.dark
                        : SystemUiOverlayStyle.light,
              ),
              body: SizedBox(width: double.infinity, child: _getBody(provider)),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(WeatherScreenProvider provider) {
    if (provider.showLoading) return const LoadingShimmers();

    if (provider.locationCouldNotGet) {
      return NoLocationWidget(
          errorText: provider.errText, onRefresh: provider.refresh);
    }
    if (provider.hasError) {
      return DataCouldNotGet(onRefresh: provider.refresh);
    }
    return _WeatherScreenBody(provider: provider);
  }
}

class _WeatherScreenBody extends StatelessWidget {
  const _WeatherScreenBody({required this.provider});

  final WeatherScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSizes.getSymmetricPadding(0.03, 0.00),
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          LanguageWidget(
            loading: provider.loading,
            changeLanguage: provider.changeLanguage,
          ),
          CurrentWeather(
            location: provider.district,
            description: provider.currentWeatherModel!.weather.main,
            tempurature: provider.currentWeatherModel!.main.temperature,
            minMaxTemp: provider.currentWeatherModel!.main.minMaxTemperature,
            feelsLikeTemp:
                provider.currentWeatherModel!.main.feelsLikeTemperature,
            iconUrl: provider.currentWeatherModel!.weather.iconUrl,
          ),
          SizedBox(height: AppSizes.getHeight(0.04)),
          HourlyForecast(provider: provider),
          RisesAndSetsInfo(sys: provider.currentWeatherModel?.sys),
          DailyForecast(provider: provider),
          WeatherHighlights(
            infoList: provider.currentWeatherModel?.info,
            sunrise: provider.currentWeatherModel?.sys?.sunrise!
                .getHourFromTimestamp(),
            sunset: provider.currentWeatherModel?.sys?.sunset!
                .getHourFromTimestamp(),
          ),
        ],
      ),
    );
  }
}

class LanguageWidget extends StatelessWidget {
  const LanguageWidget(
      {super.key, required this.loading, required this.changeLanguage});

  final bool loading;
  final Function(BuildContext) changeLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.getHeight(0.06),
      margin: EdgeInsets.only(top: AppSizes.getHeight(0.01)),
      child: Visibility(
        visible: !loading,
        replacement: Container(
          padding: EdgeInsets.only(
            top: AppSizes.getHeight(0.028),
            bottom: AppSizes.getHeight(0.027),
          ),
          child: LinearProgressIndicator(
            backgroundColor:
                Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onBackground),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: loading ? null : () => changeLanguage(context),
              style: TextButton.styleFrom(
                elevation: 4,
                backgroundColor: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    context.locale.languageCode == "en" ? "English" : "Türkçe",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontSize: AppSizes.getWidth(0.04),
                        ),
                  ),
                  SizedBox(width: AppSizes.getWidth(0.01)),
                  Image.asset(
                    context.locale.languageCode == "en"
                        ? AppImages.en.assetName
                        : AppImages.tr.assetName,
                    width: AppSizes.getWidth(0.08),
                    height: AppSizes.getWidth(0.08),
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

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({
    super.key,
    required this.tempurature,
    required this.description,
    required this.location,
    required this.minMaxTemp,
    required this.feelsLikeTemp,
    required this.iconUrl,
  });

  final String tempurature;
  final String description;
  final String location;
  final String minMaxTemp;
  final String feelsLikeTemp;
  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.getHorizontalPadding(0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tempurature,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: AppSizes.getWidth(0.14),
                    ),
              ),
              SizedBox(height: AppSizes.getHeight(0.004)),
              Text(
                description,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: AppSizes.getWidth(0.05),
                    ),
              ),
              SizedBox(height: AppSizes.getHeight(0.03)),
              Row(
                children: [
                  Text(
                    location,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontSize: AppSizes.getWidth(0.05),
                        ),
                  ),
                  Icon(
                    Icons.location_on,
                    size: AppSizes.getWidth(0.05),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.getHeight(0.005)),
              Text(
                "$minMaxTemp • ${"feelsLike".tr(args: [feelsLikeTemp])}",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: AppSizes.getWidth(0.04),
                    ),
              ),
            ],
          ),
          Image.network(
            iconUrl,
            width: AppSizes.getWidth(0.3),
            height: AppSizes.getWidth(0.3),
          ),
        ],
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key, required this.provider});

  final WeatherScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    if (!provider.hasHourlyForecast) return Container();

    return StyledBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${provider.currentWeatherModel?.weather.description.capitalizeFirst()}. ${"low".tr(args: [
                  provider.currentWeatherModel?.main.lowestTemperature ?? "-"
                ])}",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSurface,
            height: AppSizes.getHeight(0.03),
            thickness: 0.3,
          ),
          SizedBox(
            height: AppSizes.getWidth(0.28),
            child: ListView.builder(
              itemCount: 12,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final HourlyForecastItemModel item =
                    provider.hourlyForecastModel!.list[index];
                return Padding(
                  padding: AppSizes.getHorizontalPadding(0.015),
                  child: Column(
                    children: [
                      Text(
                        item.dt.getHourFromTimestamp(),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: AppSizes.getWidth(0.03),
                                ),
                      ),
                      Image.network(
                        item.weather.iconUrl,
                        width: AppSizes.getWidth(0.1),
                        height: AppSizes.getWidth(0.1),
                      ),
                      Text(
                        item.main.temperatureFixed,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: AppSizes.getWidth(0.035),
                            ),
                      ),
                      SizedBox(height: AppSizes.getWidth(0.03)),
                      Row(
                        children: [
                          Icon(
                            item.pop < 0.3
                                ? Icons.water_drop_outlined
                                : Icons.water_drop,
                            size: AppSizes.getWidth(0.03),
                            color: Colors.lightBlue,
                          ),
                          Text(
                            item.popPercent,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  fontSize: AppSizes.getWidth(0.03),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DailyForecast extends StatelessWidget {
  const DailyForecast({super.key, required this.provider});

  final WeatherScreenProvider provider;

  @override
  Widget build(BuildContext context) {
    if (!provider.hasDailyForecast) return Container();

    return StyledBox(
      child: Container(
        height: AppSizes.getWidth(0.62),
        padding: AppSizes.getSymmetricPadding(0.02, 0.005),
        child: ListView.separated(
          itemCount: provider.dailyForecastModel!.list.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return SizedBox(height: AppSizes.getWidth(0.025));
          },
          itemBuilder: (context, index) {
            final DailyForecastItemModel item =
                provider.dailyForecastModel!.list[index];
            return Row(
              children: [
                Text(
                  item.day.tr(),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: AppSizes.getWidth(0.042),
                      ),
                ),
                const Spacer(),

                /// Rain percent
                SizedBox(
                  width: AppSizes.getWidth(0.14),
                  child: Row(
                    children: [
                      Icon(
                        item.pop < 25
                            ? Icons.water_drop_outlined
                            : Icons.water_drop,
                        size: AppSizes.getWidth(0.03),
                        color: Colors.lightBlue,
                      ),
                      SizedBox(width: AppSizes.getWidth(0.01)),
                      Text(
                        item.popPercent,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: AppSizes.getWidth(0.03),
                                ),
                      ),
                    ],
                  ),
                ),

                /// Day icon
                Image.network(
                  item.dayIconUrl,
                  width: AppSizes.getWidth(0.08),
                  height: AppSizes.getWidth(0.08),
                ),

                /// Night icon
                Image.network(
                  item.nightIconUrl,
                  width: AppSizes.getWidth(0.08),
                  height: AppSizes.getWidth(0.08),
                ),

                SizedBox(width: AppSizes.getWidth(0.02)),

                /// Min-Max temp
                Text(
                  provider.currentWeatherModel!.main.minMaxTemperature
                      .replaceAll(" /", ""),
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: AppSizes.getWidth(0.04),
                      ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RisesAndSetsInfo extends StatelessWidget {
  const RisesAndSetsInfo({super.key, this.sys});

  final SysModel? sys;

  @override
  Widget build(BuildContext context) {
    if (sys == null) return Container();

    return StyledBox(
      child: Padding(
        padding: AppSizes.getVerticalPadding(0.015),
        child: Column(
          children: [
            Text(
              sys!.isDayTime ? 'dontMissTheSunset'.tr() : 'riseAndShine'.tr(),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: AppSizes.getWidth(0.04),
                  ),
            ),
            SizedBox(height: AppSizes.getHeight(0.002)),
            Text(
              sys!.isDayTime
                  ? 'sunSetWillBeAt'.tr(args: [sys!.sunsetTime])
                  : 'sunRiseWillBeAt'.tr(args: [sys!.sunriseTime]),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontSize: AppSizes.getWidth(0.04),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherHighlights extends StatelessWidget {
  const WeatherHighlights({
    super.key,
    required this.infoList,
    required this.sunrise,
    required this.sunset,
  });

  final List<InfoModel>? infoList;
  final String? sunrise;
  final String? sunset;

  @override
  Widget build(BuildContext context) {
    if (infoList == null) return Container();
    final int length = infoList!.length + 1;
    double neededWidth = 1;
    if (length > 4) {
      neededWidth = length > 6 ? 1.85 : 1.4;
    }
    return SizedBox(
      height: AppSizes.getWidth(neededWidth),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.getHeight(0.02),
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          infoList!.length + 1,
          (index) {
            if (index < infoList!.length) {
              final InfoModel info = infoList![index];
              return InfoBox(
                title: info.title.tr(),
                image: info.image,
                value: info.value,
              );
            }

            if (sunrise == null || sunset == null) return Container();

            return StyledBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "sunrise".tr(),
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: AppSizes.getWidth(0.038),
                                ),
                      ),
                      Text(
                        "sunset".tr(),
                        textAlign: TextAlign.end,
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: AppSizes.getWidth(0.038),
                                ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sunrise!,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: AppSizes.getWidth(0.038),
                                ),
                      ),
                      Text(
                        sunset!,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontSize: AppSizes.getWidth(0.038),
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.getHeight(0.01)),
                  Image.asset(
                    AppImages.sun.assetName,
                    width: AppSizes.getWidth(0.12),
                    height: AppSizes.getWidth(0.12),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoadingShimmers extends StatelessWidget {
  const LoadingShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: AppSizes.getSymmetricPadding(0.03, 0.00),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSizes.getHeight(0.06)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: AppSizes.getWidth(0.4),
                      height: AppSizes.getWidth(0.15),
                    ),
                    SizedBox(height: AppSizes.getHeight(0.02)),
                    ShimmerBox(
                      width: AppSizes.getWidth(0.2),
                      height: AppSizes.getWidth(0.05),
                    ),
                    SizedBox(height: AppSizes.getHeight(0.035)),
                    ShimmerBox(
                      width: AppSizes.getWidth(0.3),
                      height: AppSizes.getWidth(0.05),
                    ),
                    SizedBox(height: AppSizes.getHeight(0.01)),
                    ShimmerBox(
                      width: AppSizes.getWidth(0.4),
                      height: AppSizes.getWidth(0.05),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: AppSizes.getWidth(0.05)),
                  child: ShimmerBox(
                    width: AppSizes.getWidth(0.2),
                    height: AppSizes.getWidth(0.2),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.getHeight(0.055)),
            ShimmerBox(
              width: double.infinity,
              height: AppSizes.getWidth(0.45),
            ),
            SizedBox(height: AppSizes.getHeight(0.02)),
            ShimmerBox(
              width: double.infinity,
              height: AppSizes.getWidth(0.23),
            ),
            SizedBox(height: AppSizes.getHeight(0.02)),
            ShimmerBox(
              width: double.infinity,
              height: AppSizes.getWidth(0.6),
            ),
          ],
        ));
  }
}

class DataCouldNotGet extends StatelessWidget {
  const DataCouldNotGet({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.getHorizontalPadding(0.04).copyWith(
        bottom: AppSizes.getHeight(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.getWidth(0.2),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: AppSizes.getHeight(0.03)),
          Text(
            'weatherDataCouldNotGet'.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: AppSizes.getHeight(0.025)),
          CustomButton(
            text: AppStrings.refresh,
            onPressed: onRefresh,
            color: Theme.of(context).colorScheme.onSurface,
            textColor: Theme.of(context).colorScheme.surface,
          ),
        ],
      ),
    );
  }
}

class NoLocationWidget extends StatelessWidget {
  const NoLocationWidget(
      {super.key, required this.errorText, required this.onRefresh});

  final String errorText;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.getHorizontalPadding(0.04).copyWith(
        bottom: AppSizes.getHeight(0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: AppSizes.getWidth(0.2),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: AppSizes.getHeight(0.03)),
          Text(
            errorText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: AppSizes.getHeight(0.025)),
          Text(
            AppStrings.locationDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: AppSizes.getHeight(0.025)),
          CustomButton(
            onPressed: onRefresh,
            text: AppStrings.refresh,
            color: Theme.of(context).colorScheme.onSurface,
            textColor: Theme.of(context).colorScheme.surface,
          ),
        ],
      ),
    );
  }
}
