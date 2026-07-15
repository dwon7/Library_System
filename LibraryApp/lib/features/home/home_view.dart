// lib/modules/home/home_view.dart
import 'package:curved_navigation_bar_pro/curved_navigation_bar_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/utils/tab_wrapper.dart';
import 'package:library_app/features/books/books_view.dart';
import 'package:library_app/features/borrow_cards/borrow_cards_view.dart';
import 'package:library_app/features/dashboard/dashboard_controller.dart';
import 'package:library_app/features/inventory_audits/inventory_audits_view.dart';
import 'package:library_app/features/inventory_ledgers/inventory_ledgers_view.dart';
import '../books/books_controller.dart';
import '../books/books_provider.dart';
import '../borrow_cards/borrow_cards_controller.dart';
import '../borrow_cards/borrow_cards_provider.dart';
import '../dashboard/dashboard_view.dart';
import '../dashboard/dashboard_provider.dart';
import '../inventory_audits/inventory_audits_controller.dart';
import '../inventory_audits/inventory_audits_provider.dart';
import '../inventory_ledgers/inventory_ledgers_controller.dart';
import '../inventory_ledgers/inventory_ledgers_provider.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ĐÂY LÀ PHẦN BODY ĐÃ ĐƯỢC HOÀN THIỆN ĐẦY ĐỦ PAGES:
      body: Obx(() {
        final current = controller.currentTabIndex.value;
        return IndexedStack(
          index: current,
          children: [
            // Tab 0: Tổng quan (Màn hình lưới 6 menu phụ của bạn hoặc Dashboard)
            GetXTabWrapper<DashboardController>(
              controllerBuilder: () => DashboardController(DashboardProvider()),
              child: DashboardView(),
            ),

            // Tab 1: Quản lý Sách (Chỉ init 3 file của sách khi bấm trúng tab này)
            GetXTabWrapper<BooksController>(
              controllerBuilder: () => BooksController(BooksProvider()),
              child: BooksView(),
            ),

            // Tab 2: Phiếu Mượn Sách
            GetXTabWrapper<BorrowCardsController>(
              controllerBuilder: () => BorrowCardsController(BorrowCardsProvider()),
              child: BorrowCardsView(),
            ),

            // Tab 3: Phiếu Kiểm Kê
            GetXTabWrapper<InventoryAuditsController>(
              controllerBuilder: () => InventoryAuditsController(InventoryAuditsProvider()),
              child: InventoryAuditsView(),
            ),

            // Tab 4: Nhập / Xuất Kho
            GetXTabWrapper<InventoryLedgersController>(
              controllerBuilder: () => InventoryLedgersController(InventoryLedgersProvider()),
              child: InventoryLedgersView(),
            ),
          ],
        );
      }),

      bottomNavigationBar: Obx(() {
        final currentTab = controller.currentTabIndex.value;

        return CurvedNavigationBarPro(
          barHeight: 90,
          fabSink: 20,
          fabGap: 8,
          cornerRadius: 17,
          notchShoulderRadius: 17,
          contentPadding: 19,
          navbarStyle: CNBPStyles.minimalMono,
          activeIconSize: 26,
          inactiveIconSize: 26,
          inactiveColor: Colors.grey,
          inactiveTextStyle: const TextStyle(fontFamily: 'sora'),
          shadowColor: Colors.black.withValues(alpha: 0.1),
          activeTextStyle: const TextStyle(
            fontFamily: 'sora',
            fontWeight: FontWeight.w600,
          ),
          items: buildTabItems(),
          currentIndex: currentTab,
          onTap: (i) {
            controller.updateTab(i);
          },
        );
      }),
    );
  }

  List<CurvedNavigationItemPro> buildTabItems() {
    return [
      const CurvedNavigationItemPro(
        inactiveIcon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
        label: 'Tổng quan',
      ),
      const CurvedNavigationItemPro(
        inactiveIcon: Icons.book_outlined,
        activeIcon: Icons.book_rounded,
        label: 'Sách',
      ),
      const CurvedNavigationItemPro(
        inactiveIcon: Icons.add_card_outlined,
        activeIcon: Icons.add_card_rounded,
        label: 'Mượn sách',
      ),
      const CurvedNavigationItemPro(
        inactiveIcon: Icons.pageview_outlined,
        activeIcon: Icons.pageview_rounded,
        label: 'Kiểm kê',
      ),
      const CurvedNavigationItemPro(
        inactiveIcon: Icons.swap_vert_outlined,
        activeIcon: Icons.swap_vert_rounded,
        label: 'Nhập/Xuất',
      ),
    ];
  }
}