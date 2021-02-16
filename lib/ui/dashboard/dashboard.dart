import 'package:expense_manager/data/datasource/language_data.dart';
import 'package:expense_manager/data/language/app_localization.dart';
import 'package:expense_manager/core/routes.dart';
import 'package:expense_manager/ui/dashboard/dashboard_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:expense_manager/ui/app/app_state.dart';

class Dashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final vm = watch(dashboardViewModelProvider);
    return ProviderListener<DashboardViewModel>(
        provider: dashboardViewModelProvider,
        onChange: (context, model) async {},
        child: SafeArea(
          top: true,
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLocalization.of(context).getTranslatedVal("home_title").text.xl2.make().pOnly(left: 8),
                    DarkModeSwitch(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LanguageDropDown(),
                    ),
                    Icon(Icons.settings_outlined).p16().onInkTap(() {
                      Navigator.pushNamed(context, AppRoutes.setting);
                    })
                  ],
                ),
                "${NumberFormat.simpleCurrency().currencySymbol}${vm.total.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}"
                    .text
                    .bold
                    .xl5
                    .make()
                    .pSymmetric(h: 16),
                8.heightBox,
                "${NumberFormat.simpleCurrency().currencySymbol}${vm.today.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")} Today"
                    .text
                    .green500
                    .make()
                    .pOnly(left: 18),
                16.heightBox,
                PageView1(
                  vm: vm,
                ),
              ],
            ),
          ),
        ));
  }
}

class PageView1 extends StatefulWidget {
  final DashboardViewModel vm;

  PageView1({@required this.vm}) : super();

  @override
  _PageViewState createState() => _PageViewState();
}

class _PageViewState extends State<PageView1> {
  PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmoothPageIndicator(
          controller: controller,
          count: 2,
          effect: JumpingDotEffect(
            activeDotColor: Vx.black,
            dotHeight: 8,
            dotWidth: 8,
          ),
        ),
        PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          children: [
            Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                          widget.vm.onGraphItemTeach(pieTouchResponse);
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 8,
                        centerSpaceRadius: 80,
                        sections: widget.vm.graphList),
                  ),
                ),
                GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 5),
                  scrollDirection: Axis.vertical,
                  children: widget.vm.list
                      .map((list) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 16,
                                color: list.category.iconColor,
                              ),
                              8.widthBox,
                              list.category.name.text.make()
                            ],
                          ).box.height(12).make())
                      .toList(),
                ).pSymmetric(h: 16).expand()
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: widget.vm.list
                  .map((e) => Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            e.category.icon,
                            color: Vx.white,
                          )
                              .box
                              .p12
                              .height(80)
                              .withDecoration(BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                color: e.category.iconColor,
                              ))
                              .make(),
                          e.category.name.text.bold.base.ellipsis
                              .make()
                              .pSymmetric(v: 4, h: 8)
                              .expand(),
                          LineChart(widget.vm.getLineChatData(e)).h(40).w(80),
                          16.widthBox,
                          "${NumberFormat.simpleCurrency().currencySymbol}${e.total.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}"
                              .text
                              .lg
                              .make()
                              .w(50)
                        ],
                      ).card.zero.withRounded(value: 8).p8.make())
                  .toList(),
            ),
          ],
        ).expand()
      ],
    ).expand();
  }
}


class DarkModeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.read(appStateNotifier);
    return Switch(
      value: appState.isDarkModeEnabled,
      onChanged: (enabled) {
        if (enabled) {
          appState.setDarkTheme();
        } else {
          appState.setLightTheme();
        }
      },
    );
  }
}

class LanguageDropDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.read(appStateNotifier);
    return DropdownButton(
      onChanged: (Language language) {
        print(language.languageCode);
        Locale _tempLocale = Locale(language.languageCode, 'BR');
        appState.changeLocale(switchToLocale: _tempLocale);
      },
      icon: Icon(
        Icons.language_outlined,
      ),
      items: Language.languageList()
          .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
              value: lang,
              child: Row(
                children: <Widget>[Text(lang.flag), Text(lang.languageCode)],
              )))
          .toList(),
    );
  }
}


