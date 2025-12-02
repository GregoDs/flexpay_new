import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/bookings/ui/bookings.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/ui/chama_home/chama_home.dart';
import 'package:flexpay/features/flexchama/ui/registration_chama/opt_chama_screen.dart';
import 'package:flexpay/features/goals/ui/goals.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/ui/homescreen.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation.dart';
import 'package:flexpay/features/navigation/sidemenu.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';

class NavigationWrapper extends StatefulWidget {
  final int initialIndex;
  final UserModel userModel;

  const NavigationWrapper({
    Key? key,
    this.initialIndex = 0,
    required this.userModel,
  }) : super(key: key);

  @override
  State<NavigationWrapper> createState() => NavigationWrapperState();
}

class NavigationWrapperState extends State<NavigationWrapper> {
  late int _currentIndex;
  bool showOnBoard = true;

  void setTabIndex(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // ✅ Fetch Chama profile once at startup
    Future.microtask(() {
      context.read<ChamaCubit>().fetchChamaUserProfile();
    });
  }

  void _onTabTapped(int index) async {
    // If user is moving away from Bookings to Home
    if (_currentIndex == 3 && index == 0) {
      // Trigger refresh when returning home
      final homeCubit = context.read<HomeCubit>();
      homeCubit.fetchUserWallet();
      homeCubit.fetchLatestTransactions();
    }

    // Simply update index — no Navigator.push here
    setState(() => _currentIndex = index);
  }

  void _onOptIn() => setState(() => showOnBoard = false);

  List<Widget> get _pages => [
    /// Home
    SideMenuWrapper(
      child: HomeScreen(isDarkModeOn: false, userModel: widget.userModel),
    ),

    /// Bookings
    const BookingsPage(),

    /// Goals
    const GoalsPage(),

    /// FlexChama
    BlocListener<ChamaCubit, ChamaState>(
      listener: (context, state) {
        if (state is ChamaError) {
          CustomSnackBar.showError(
            context,
            title: "Oops!",
            message: state.message,
          );
          if (_currentIndex != 0) setState(() => _currentIndex = 0);
        }
      },
      child: BlocBuilder<ChamaCubit, ChamaState>(
        builder: (context, state) {
          if (state is ChamaNotMember) {
            return OnBoardFlexChama(
              onOptIn: _onOptIn,
              userModel: widget.userModel,
              onBackPressed: () => setState(
                () => _currentIndex = 0,
              ),
            );
          }

          if (state is ChamaProfileFetched ||
              state is ChamaSavingsFetched ||
              state is ChamaSavingsLoading) {
            final profile = (state is ChamaProfileFetched)
                ? state.profile
                : (state is ChamaSavingsFetched)
                ? state.savingsResponse.data?.chamaDetails
                : (state as ChamaSavingsLoading).previousProfile;

            if (showOnBoard) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => showOnBoard = false);
              });
            }

            return FlexChama(profile: profile);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    ),

    /// Merchants
    MerchantsScreen(),
  ];

  final List<BottomNavBarItem> _navItems = [
    BottomNavBarItem(icon: Icons.home, label: "Home"),
    BottomNavBarItem(icon: Icons.savings, label: "Bookings"),
    BottomNavBarItem(icon: Icons.credit_card, label: "Goals"),
    BottomNavBarItem(icon: Icons.people, label: "Chama"),
    BottomNavBarItem(icon: Icons.store, label: "Merchants"),
  ];

  @override
  Widget build(BuildContext context) {
    final hideNavBar =
        _currentIndex == 3 &&
        showOnBoard; // Fixed: should be index 3 (Chama), not 2 (Goals)

    // ✅ Clean build — no local BlocProviders required
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }

        // If on Home, allow system back (exit app)
        return true;
      },
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: hideNavBar
            ? null
            : BottomNavBar(
                currentIndex: _currentIndex,
                onTabTapped: _onTabTapped,
                items: _navItems,
              ),
      ),
    );
  }
}
