import 'package:go_router/go_router.dart';
import 'package:sevanta_delivery_partner/routes/app_routes.dart';
import 'package:sevanta_delivery_partner/views/screens/authendication/login.dart';
import 'package:sevanta_delivery_partner/views/screens/authendication/otp_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/authendication/splash.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/dashboard/dashboard.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/dashboard/delivery_details.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/dashboard/new_delivery_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/earnings/earning_details.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/earnings/earning_history.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/earnings/earnings_dashboard.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/earnings/payout_status.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/main_dashboard.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/search_location.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/orders/active_orders_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/orders/my_orders_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/orders/order_details_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/pickup/pickup_details_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/pickup/seller_confirmation_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/pickup/verify_pickup_screen.dart';
import 'package:sevanta_delivery_partner/views/screens/main_dashboard/settings/settings.dart';
import 'package:sevanta_delivery_partner/views/screens/personal_information/document_information.dart';
import 'package:sevanta_delivery_partner/views/screens/personal_information/location_information.dart';
import 'package:sevanta_delivery_partner/views/screens/personal_information/profile_information.dart';
import 'package:sevanta_delivery_partner/views/screens/personal_information/vehicle_information.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/${AppRoutes.splash}',
    routes: [
      GoRoute(
        path: '/${AppRoutes.splash}',
        name: AppRoutes.splash,
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: '/${AppRoutes.login}',
        name: AppRoutes.login,
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/${AppRoutes.verifyOTP}',
        name: AppRoutes.verifyOTP,
        builder: (context, state) {
          final mobile = state.extra as String;
          return OtpScreen(mobileNumber: mobile);
        },
      ),
      GoRoute(
        path: '/${AppRoutes.personalInformation}',
        name: AppRoutes.personalInformation,
        builder: (context, state) {
          return ProfileInformation();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.vehicleInformation}',
        name: AppRoutes.vehicleInformation,
        builder: (context, state) {
          return VehicleInformation();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.documentInformation}',
        name: AppRoutes.documentInformation,
        builder: (context, state) {
          return DocumentInformation();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.locationInformation}',
        name: AppRoutes.locationInformation,
        builder: (context, state) {
          return LocationInformation();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.pickLocation}',
        name: AppRoutes.pickLocation,
        builder: (context, state) {
          return PickLocation();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.deliveryDetails}',
        name: AppRoutes.deliveryDetails,
        builder: (context, state) {
          return const DeliveryDetails();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.earningHistory}',
        name: AppRoutes.earningHistory,
        builder: (context, state) {
          return const EarningHistory();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.earningDetails}',
        name: AppRoutes.earningDetails,
        builder: (context, state) {
          return const EarningDetails();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.payoutStatus}',
        name: AppRoutes.payoutStatus,
        builder: (context, state) {
          return const PayoutStatus();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.profile}',
        name: AppRoutes.profile,
        builder: (context, state) {
          return const Settings();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.newDelivery}',
        name: AppRoutes.newDelivery,
        builder: (context, state) {
          return const NewDeliveryScreen();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.newDeliveryRequest}',
        name: AppRoutes.newDeliveryRequest,
        builder: (context, state) {
          return const NewDeliveryScreen();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.pickupDetails}',
        name: AppRoutes.pickupDetails,
        builder: (context, state) {
          return const PickupDetailsScreen();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.verifyPickup}',
        name: AppRoutes.verifyPickup,
        builder: (context, state) {
          return const VerifyPickupScreen();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.sellerConfirmation}',
        name: AppRoutes.sellerConfirmation,
        builder: (context, state) {
          return const SellerConfirmationScreen();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.orderDetails}',
        name: AppRoutes.orderDetails,
        builder: (context, state) {
          return const OrderDetailsScreen();
        },
      ),
      GoRoute(
        path: '/${AppRoutes.activeOrders}',
        name: AppRoutes.activeOrders,
        builder: (context, state) {
          return const ActiveOrdersScreen();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final bool isLogin = state.extra is bool
              ? state.extra as bool
              : false;
          return MainDashboard(
            navigationShell: navigationShell,
            isLogin: isLogin,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${AppRoutes.mainDashboard}',
                name: AppRoutes.mainDashboard,
                builder: (context, state) => const Dashboard(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${AppRoutes.mainDashboard}/orders',
                name: AppRoutes.orders,
                builder: (context, state) => const MyOrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${AppRoutes.mainDashboard}/${AppRoutes.earningsDashboard}',
                name: AppRoutes.earningsDashboard,
                builder: (context, state) => const EarningsDashboard(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${AppRoutes.mainDashboard}/${AppRoutes.settings}',
                builder: (context, state) => const Settings(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
