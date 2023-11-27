import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/daily_forecast_model.dart';
import '../../models/hourly_forecast_model.dart';
import '../../models/info_model.dart';
import '../../utils/app_images.dart';
import '../../utils/app_sizes.dart';
import '../../utils/app_strings.dart';
import '../../utils/extensions.dart';
import '../../widgets/custom_button.dart';
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
            strokeWidth: 3,
            displacement: 130,
            color: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.background,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: provider.refresh,
            child: Scaffold(
              // drawer: Padding(
              //   padding: EdgeInsets.only(top: AppSizes.getHeight(0.07)),
              //   child: Drawer(
              //     elevation: 0,
              //     width: AppSizes.getWidth(0.8),
              //     backgroundColor: Theme.of(context).colorScheme.surface,
              //     surfaceTintColor: Theme.of(context).colorScheme.surface,
              //     child: ListView(
              //       padding: AppSizes.getSymmetricPadding(0.02, 0.01),
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             IconButton(
              //               iconSize: AppSizes.getWidth(0.06),
              //               icon: const Icon(Icons.settings_outlined),
              //               onPressed: () {
              //                 Navigator.pop(context);
              //               },
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              appBar: AppBar(
                elevation: 0,
                systemOverlayStyle:
                    Theme.of(context).brightness == Brightness.light
                        ? SystemUiOverlayStyle.dark
                        : SystemUiOverlayStyle.light,
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: 0,
                leadingWidth: AppSizes.getWidth(0.2),
                // leading: Padding(
                //   padding: AppSizes.getHorizontalPadding(0.04),
                //   child: Builder(
                //     builder: (context) {
                //       return IconButton(
                //         iconSize: AppSizes.getWidth(0.06),
                //         icon: const Icon(Icons.menu_rounded),
                //         onPressed: () {
                //           // Scaffold.of(context).openDrawer();
                //         },
                //       );
                //     },
                //   ),
                // ),
                // actions: [
                //   if (!provider.loading)
                //     IconButton(
                //       iconSize: AppSizes.getWidth(0.08),
                //       icon: const Icon(Icons.not_listed_location_rounded),
                //       onPressed: () {
                //         provider.changeLocation();
                //       },
                //     ),
                // ],
              ),

              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (provider.initialized)
                    SingleChildScrollView(
                      padding: AppSizes.getSymmetricPadding(0.03, 0.00),
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          if (provider.locationCouldNotGet)
                            NoLocationWidget(
                              errorText: provider.errText,
                              onRefresh: provider.refresh,
                            )
                          else if (provider.hasCurrentWeather)
                            Column(
                              children: [
                                SizedBox(height: AppSizes.getHeight(0.06)),
                                CurrentWeather(
                                  tempurature: provider
                                      .currentWeatherModel!.main.temperature,
                                  description: provider
                                      .currentWeatherModel!.weather.main,
                                  location: provider.district,
                                  minMaxTemp: provider.currentWeatherModel!.main
                                      .minMaxTemperature,
                                  feelsLikeTemp: provider.currentWeatherModel!
                                      .main.feelsLikeTemperature,
                                  iconUrl: provider
                                      .currentWeatherModel!.weather.iconUrl,
                                ),
                                SizedBox(height: AppSizes.getHeight(0.04)),
                                if (provider.hasHourlyForecast)
                                  StyledBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${provider.currentWeatherModel?.weather.description.capitalizeFirst()}. ${provider.currentWeatherModel?.main.lowestTemperature}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontSize:
                                                    AppSizes.getWidth(0.04),
                                              ),
                                        ),
                                        Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          height: AppSizes.getHeight(0.03),
                                          thickness: 0.3,
                                        ),
                                        SizedBox(
                                          height: AppSizes.getHeight(0.14),
                                          child: ListView.builder(
                                            itemCount:
                                                provider.hourlyForecastModel !=
                                                        null
                                                    ? 12
                                                    : 0,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final HourlyForecastItemModel
                                                  item = provider
                                                      .hourlyForecastModel!
                                                      .list[index];
                                              return Padding(
                                                padding: AppSizes
                                                    .getHorizontalPadding(
                                                        0.015),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      item.dt
                                                          .getHourFromTimestamp(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                            fontSize: AppSizes
                                                                .getWidth(0.03),
                                                          ),
                                                    ),
                                                    Image.network(
                                                      item.weather.iconUrl,
                                                      width: AppSizes.getWidth(
                                                          0.1),
                                                      height: AppSizes.getWidth(
                                                          0.1),
                                                    ),
                                                    Text(
                                                      item.main
                                                          .temperatureFixed,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium!
                                                          .copyWith(
                                                            fontSize: AppSizes
                                                                .getWidth(
                                                                    0.035),
                                                          ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            AppSizes.getHeight(
                                                                0.02)),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          item.pop < 0.3
                                                              ? Icons
                                                                  .water_drop_outlined
                                                              : Icons
                                                                  .water_drop,
                                                          size:
                                                              AppSizes.getWidth(
                                                                  0.03),
                                                          color:
                                                              Colors.lightBlue,
                                                        ),
                                                        Text(
                                                          item.popPercent,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineSmall!
                                                              .copyWith(
                                                                fontSize: AppSizes
                                                                    .getWidth(
                                                                        0.03),
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
                                  ),
                                SunriseSunsetInfo(
                                  title: provider
                                      .currentWeatherModel!.sys!.getSunTitle,
                                  time: provider
                                      .currentWeatherModel!.sys!.getSunTime,
                                ),
                                if (provider.hasDailyForecast)
                                  StyledBox(
                                    child: Container(
                                      height: AppSizes.getHeight(0.3),
                                      padding: AppSizes.getSymmetricPadding(
                                          0.02, 0.005),
                                      child: ListView.separated(
                                        itemCount: provider
                                            .dailyForecastModel!.list.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                              height:
                                                  AppSizes.getHeight(0.012));
                                        },
                                        itemBuilder: (context, index) {
                                          final DailyForecastItemModel item =
                                              provider.dailyForecastModel!
                                                  .list[index];
                                          return Row(
                                            children: [
                                              /// Day name
                                              Text(
                                                item.day,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                      fontSize:
                                                          AppSizes.getWidth(
                                                              0.042),
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
                                                          ? Icons
                                                              .water_drop_outlined
                                                          : Icons.water_drop,
                                                      size: AppSizes.getWidth(
                                                          0.03),
                                                      color: Colors.lightBlue,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            AppSizes.getWidth(
                                                                0.01)),
                                                    Text(
                                                      item.popPercent,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall!
                                                          .copyWith(
                                                            fontSize: AppSizes
                                                                .getWidth(0.03),
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

                                              SizedBox(
                                                  width:
                                                      AppSizes.getWidth(0.02)),

                                              /// Min-Max temp
                                              Text(
                                                provider.currentWeatherModel!
                                                    .main.minMaxTemperature
                                                    .replaceAll(" /", ""),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                      fontSize:
                                                          AppSizes.getWidth(
                                                              0.04),
                                                    ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                InfoGrid(
                                  infoList: provider.currentWeatherModel?.info,
                                  sunrise: provider
                                      .currentWeatherModel?.sys?.sunrise!
                                      .getHourFromTimestamp(),
                                  sunset: provider
                                      .currentWeatherModel?.sys?.sunset!
                                      .getHourFromTimestamp(),
                                ),
                              ],
                            )
                          else
                            DataCouldNotGet(onRefresh: provider.refresh)
                        ],
                      ),
                    ),
                  Visibility(
                    visible: !provider.initialized,
                    child: Positioned(
                      top: AppSizes.getHeight(0.08),
                      child: Container(
                        width: AppSizes.getWidth(0.09),
                        height: AppSizes.getWidth(0.09),
                        padding: AppSizes.getPadding(0.015),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
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

class DataCouldNotGet extends StatelessWidget {
  const DataCouldNotGet({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.getHorizontalPadding(0.04)
          .copyWith(top: AppSizes.getHeight(0.35)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.weatherDataCouldNotGet,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: AppStrings.refresh,
            onPressed: onRefresh,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
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
      padding: AppSizes.getSymmetricPadding(0.04, 0.00),
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
                "$minMaxTemp $feelsLikeTemp",
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

class SunriseSunsetInfo extends StatelessWidget {
  const SunriseSunsetInfo({super.key, this.title, this.time});

  final String? title;
  final String? time;

  @override
  Widget build(BuildContext context) {
    if (time == null) return Container();

    return StyledBox(
      child: Padding(
        padding: AppSizes.getVerticalPadding(0.015),
        child: Column(
          children: [
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: AppSizes.getWidth(0.04),
                  ),
            ),
            SizedBox(height: AppSizes.getHeight(0.002)),
            Text(
              time!,
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

class InfoGrid extends StatelessWidget {
  const InfoGrid({
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

    return SizedBox(
      height: AppSizes.getWidth(1),
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
                image: info.image,
                title: info.title,
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
                        "Sunrise",
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: AppSizes.getWidth(0.038),
                                ),
                      ),
                      Text(
                        "Sunset",
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

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.image,
    required this.title,
    required this.value,
  });

  final String image;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return StyledBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: AppSizes.getWidth(0.09),
            height: AppSizes.getWidth(0.09),
          ),
          SizedBox(height: AppSizes.getHeight(0.015)),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: AppSizes.getWidth(0.042),
                ),
          ),
          SizedBox(height: AppSizes.getHeight(0.005)),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: AppSizes.getWidth(0.04),
                ),
          ),
        ],
      ),
    );
  }
}

class StyledBox extends StatelessWidget {
  const StyledBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSizes.getSymmetricPadding(0.04, 0.015),
      margin: AppSizes.getVerticalPadding(0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: child,
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
      padding: AppSizes.getHorizontalPadding(0.04)
          .copyWith(top: AppSizes.getHeight(0.35)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorText),
          const SizedBox(height: 10),
          CustomButton(
            text: AppStrings.refresh,
            onPressed: onRefresh,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.getHeight(0.35)),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
