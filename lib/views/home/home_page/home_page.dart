import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../../../core/components/animated_page_switcher.dart';
import '../../../core/components/internet_wrapper.dart';
import '../../../core/controllers/auth/auth_controller.dart';
import '../../../core/controllers/category/categories_controller.dart';
import '../../../core/controllers/config/config_controllers.dart';
import '../../../core/controllers/notifications/notification_toggle.dart';
import '../../../core/controllers/posts/categories_post_controller.dart';
import '../../../core/controllers/posts/popular_posts_controller.dart';
import '../../../core/models/category.dart';
import 'components/category_tab_view.dart';
import 'components/home_app_bar.dart';
import 'components/loading_feature_post.dart';
import 'components/loading_home_page.dart';
import 'components/trending_tab.dart';

class HomePage extends ConsumerStatefulWidget with WidgetsBindingObserver{
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<CategoryModel> _feturedCategories = [];

  bool _isLoading = true;
  void updateUI() {
    if (mounted) setState(() {});
  }

  /// Set Categories and update the UI
  Future<void> _setCategories() async {
    _isLoading = true;
    updateUI();
    try {
      _feturedCategories =
          await ref.read(categoriesController.notifier).getFeaturedCategories();
      _tabController =
          TabController(length: _feturedCategories.length, vsync: this);
    } on Exception {
      _tabController = TabController(length: 1, vsync: this);
    }
    _isLoading = false;
    updateUI();
  }

  Future<void> requestNotificationPermission() async {
    ref.read(notificationStateProvider(context));
  }

  final _adUnitId = 'R-M-2540919-3';
  late final _adRequestConfiguration = AdRequestConfiguration(adUnitId: _adUnitId);
  AppOpenAd? _appOpenAd;
  late Future<AppOpenAdLoader> _appOpenAdLoader = _createAppOpenAdLoader();

  /// Tabs
  late TabController _tabController;
  static var isAdShowing = false;
  static var isColdStartAdShown = false;

  Future<AppOpenAdLoader> _createAppOpenAdLoader() {
    return AppOpenAdLoader.create(
      onAdLoaded: (AppOpenAd appOpenAd) {
        // The ad was loaded successfully. Now you can handle it.
        _appOpenAd = appOpenAd;

        if (!isColdStartAdShown) {
          _showAdIfAvailable();
          isColdStartAdShown = true;
        }
      },
      onAdFailedToLoad: (error) {
        // Ad failed for to load with error
        // Attempting to load a new ad from the OnAdFailedToLoad event is strongly discouraged.
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _setCategories();
    ref.read(authController);
    requestNotificationPermission();
    WidgetsBinding.instance.addObserver(this);
    MobileAds.initialize();
    _appOpenAdLoader = _createAppOpenAdLoader();
    _loadAppOpenAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final popularPosts = ref.watch(popularPostsController);
    final showLogo =
        ref.watch(configProvider).value?.showTopLogoInHome ?? false;
    if (_isLoading) {
      return LoadingHomePage(showLogoInHome: showLogo);
    } else {
      return InternetWrapper(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            HomeAppBarWithTab(
              categories: _feturedCategories,
              tabController: _tabController,
              forceElevated: innerBoxIsScrolled,
              showLogoInHome: showLogo,
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: List.generate(
              _feturedCategories.length,
              (index) {
                if (index == 0) {
                  return TransitionWidget(
                    child: popularPosts.map(
                      data: ((data) => TrendingTabSection(
                            posts: data.value,
                          )),
                      error: (t) => Text(t.toString()),
                      loading: (t) => const LoadingFeaturePost(),
                    ),
                  );
                } else {
                  return Container(
                    color: Theme.of(context).cardColor,
                    child: CategoryTabView(
                      arguments: CategoryPostsArguments(
                        categoryId: _feturedCategories[index].id,
                        isHome: true,
                      ),
                      key: ValueKey(_feturedCategories[index].slug),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
  Future<void> _loadAppOpenAd() async {
    final adLoader = await _appOpenAdLoader;
    await adLoader.loadAd(adRequestConfiguration: _adRequestConfiguration);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _showAdIfAvailable();
    }
  }

  void _setAdEventListener({required AppOpenAd appOpenAd }) {
    appOpenAd.setAdEventListener(
        eventListener: AppOpenAdEventListener(
            onAdShown: () {
              // Called when an ad is shown.
              isAdShowing = true;
            },
            onAdFailedToShow: (error) {
              _clearAppOpenAd();
              _loadAppOpenAd();
            },
            onAdDismissed: () {
              isAdShowing = false;
              _clearAppOpenAd();
              _loadAppOpenAd();
            },
            onAdClicked: () {
            },
            onAdImpression: (data) {
            }
        )
    );
  }

  Future<void> _showAdIfAvailable() async {
    var appOpenAd = _appOpenAd;
    if (appOpenAd != null && !isAdShowing) {
      _setAdEventListener(appOpenAd: appOpenAd);
      await appOpenAd.show();
      await appOpenAd.waitForDismiss();
    } else {
      _loadAppOpenAd();
    }
  }

  void _clearAppOpenAd() {
    _appOpenAd?.destroy();
    _appOpenAd = null;
  }
}
