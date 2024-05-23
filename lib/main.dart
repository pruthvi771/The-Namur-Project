import 'package:active_ecommerce_flutter/features/auth/services/auth_bloc/auth_bloc.dart';
import 'package:active_ecommerce_flutter/features/auth/services/auth_repository.dart';
import 'package:active_ecommerce_flutter/features/auth/services/firestore_repository.dart';
import 'package:active_ecommerce_flutter/features/profile/services/friends_bloc/friends_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/hive_bloc/hive_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/misc_bloc/misc_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_bloc/rent_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/rent_repository.dart';
import 'package:active_ecommerce_flutter/utils/profile_completion_bloc/profile_completion_bloc.dart';
import 'package:active_ecommerce_flutter/utils/hive_models/models.dart'
    as hiveModels;
import 'package:active_ecommerce_flutter/features/profile/services/profile_bloc/profile_bloc.dart';
import 'package:active_ecommerce_flutter/features/profile/services/weather_section_bloc/weather_section_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_bloc/buy_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/buy_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_bloc/cart_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/cart_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_bloc/checkout_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/checkout_repository.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_bloc/sell_bloc.dart';
import 'package:active_ecommerce_flutter/features/sellAndBuy/services/sell_repository.dart';
import 'package:active_ecommerce_flutter/features/weather/bloc/weather_bloc.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/presenter/currency_presenter.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/features/auth/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/features/profile/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/splash_screen.dart';
import 'package:active_ecommerce_flutter/utils/translation_bloc/translation_bloc.dart';
import 'package:active_ecommerce_flutter/utils/translation_bloc/translation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';
import 'app_config.dart';
import 'package:one_context/one_context.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'lang_config.dart';
import 'package:firebase_core/firebase_core.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(hiveModels.AddressAdapter());
  Hive.registerAdapter(hiveModels.LandAdapter());
  Hive.registerAdapter(hiveModels.CropAdapter());
  Hive.registerAdapter(hiveModels.AnimalAdapter());
  Hive.registerAdapter(hiveModels.ProfileDataAdapter());
  Hive.registerAdapter(hiveModels.PrimaryLocationAdapter());
  Hive.registerAdapter(hiveModels.SecondaryLocationsAdapter());
  Hive.registerAdapter(hiveModels.CropCalendarItemAdapter());
  Hive.registerAdapter(hiveModels.CropCalendarDataAdapter());
  await Hive.openBox<hiveModels.ProfileData>('profileDataBox3');
  await Hive.openBox<hiveModels.PrimaryLocation>('primaryLocationBox');
  await Hive.openBox<hiveModels.SecondaryLocations>('secondaryLocationsBox');
  await Hive.openBox<hiveModels.CropCalendarData>('cropCalendarDataBox');

  SharedPreferences preferences = await SharedPreferences.getInstance();

  Locale? currentLocale;

  preferences.getString("locale");
  if (preferences.getString("locale") == null) {
    preferences.setString("locale", "en");
  } else {
    currentLocale = Locale(preferences.getString("locale")!);
  }

  runApp(
    SharedValue.wrapApp(
      BlocProvider(
        create: (context) => TranslationBloc(),
        child: MyApp(
          locale: currentLocale,
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Locale? locale;

  const MyApp({super.key, required this.locale});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _currentLocale;

  @override
  void initState() {
    if (widget.locale == null) {
      _currentLocale = Locale('en');
    } else {
      _currentLocale = widget.locale!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    AuthRepository authRepository = AuthRepository();
    FirestoreRepository firestoreRepository = FirestoreRepository();
    SellRepository sellRepository = SellRepository();
    BuyRepository buyRepository = BuyRepository();
    CartRepository cartRepository = CartRepository();
    CheckoutRepository checkoutRepository = CheckoutRepository();

    return MultiBlocProvider(
        providers: [
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(),
          ),
          BlocProvider<CheckoutBloc>(
            create: (context) => CheckoutBloc(
              checkoutRepository: checkoutRepository,
              cartRepository: cartRepository,
            ),
          ),
          BlocProvider(
            create: (context) => WeatherSectionBloc(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: authRepository,
              firestoreRepository: firestoreRepository,
            ),
          ),
          BlocProvider<SellBloc>(
            create: (context) => SellBloc(
              authRepository: authRepository,
              sellRepository: sellRepository,
            ),
          ),
          BlocProvider<BuyBloc>(
            create: (context) => BuyBloc(
              buyRepository: buyRepository,
            ),
          ),
          BlocProvider<HiveBloc>(
            create: (context) => HiveBloc(),
          ),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(cartRepository: cartRepository),
          ),
          BlocProvider<RentBloc>(
            create: (context) => RentBloc(
              authRepository: authRepository,
              rentRepository: RentRepository(),
            ),
          ),
          BlocProvider<FriendsBloc>(
            create: (context) => FriendsBloc(),
          ),
          BlocProvider<MiscBloc>(
            create: (context) => MiscBloc(),
          ),
          BlocProvider<ProfileCompletionBloc>(
            create: (context) => ProfileCompletionBloc(),
          ),
        ],
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LocaleProvider()),
              ChangeNotifierProvider(create: (context) => CartCounter()),
              ChangeNotifierProvider(create: (context) => CurrencyPresenter()),
            ],
            child: BlocListener<TranslationBloc, TranslationState>(
              listener: (context, state) {
                if (state is TranslationDataReceived) {
                  setState(() {
                    _currentLocale = state.locale;
                  });
                }
              },
              child: MaterialApp(
                initialRoute: "/",
                routes: {
                  "/": (context) => SplashScreen(),
                  "/address": (context) => Address(),
                  "/category_list": (context) => CategoryList(
                      parentCategoryId: 0,
                      isBaseCategory: true,
                      parentCategoryName: "",
                      isTopCategory: false),
                  "/login": (context) => Login(),
                  "/main": (context) => Main(),
                  "/profile": (context) => Profile(),
                },
                builder: OneContext().builder,
                navigatorKey: OneContext().navigator.key,
                title: AppConfig.app_name,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: false,
                  primaryColor: MyTheme.white,
                  scaffoldBackgroundColor: MyTheme.white,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme:
                      GoogleFonts.publicSansTextTheme(textTheme).copyWith(
                    bodyLarge:
                        GoogleFonts.publicSans(textStyle: textTheme.bodyLarge),
                    bodyMedium: GoogleFonts.publicSans(
                        textStyle: textTheme.bodyMedium, fontSize: 12),
                  ),
                ),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: LangConfig().supportedLocales(),
                locale: _currentLocale,
              ),
            )));
  }
}
