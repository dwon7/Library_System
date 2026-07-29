import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart'
    show BindingsBuilder;
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:library_app/features/book_detail/book_detail_controller.dart';
import 'package:library_app/features/book_detail/book_detail_provider.dart';
import 'package:library_app/features/book_detail/book_detail_view.dart';
import 'package:library_app/features/borrow_card_detail/borrow_card_detail_controller.dart';
import 'package:library_app/features/borrow_card_detail/borrow_card_detail_provider.dart';
import 'package:library_app/features/borrow_card_detail/borrow_card_detail_view.dart';
import 'package:library_app/features/borrow_cards/borrow_cards_controller.dart';
import 'package:library_app/features/borrow_cards/borrow_cards_provider.dart';
import 'package:library_app/features/borrow_cards/borrow_cards_view.dart';
import 'package:library_app/features/list_borrow_cards/list_borrow_cards_controller.dart';
import 'package:library_app/features/list_borrow_cards/list_borrow_cards_view.dart';
import 'package:library_app/features/home/home_controller.dart';
import 'package:library_app/features/home/home_provider.dart';
import 'package:library_app/features/home/home_view.dart';
import 'package:library_app/features/new_borrow_card/new_borrow_card_controller.dart';
import 'package:library_app/features/new_borrow_card/new_borrow_card_provider.dart';
import 'package:library_app/features/inventory_audits/inventory_audits_controller.dart';
import 'package:library_app/features/inventory_audits/inventory_audits_provider.dart';
import 'package:library_app/features/inventory_audits/inventory_audits_view.dart';
import 'package:library_app/features/list_inventory_audits/list_inventory_audits_controller.dart';
import 'package:library_app/features/list_inventory_audits/list_inventory_audits_view.dart';
import 'package:library_app/features/inventory_ledger_detail/inventory_ledger_detail_controller.dart';
import 'package:library_app/features/inventory_ledger_detail/inventory_ledger_detail_provider.dart';
import 'package:library_app/features/inventory_ledger_detail/inventory_ledger_detail_view.dart';
import 'package:library_app/features/inventory_ledgers/inventory_ledgers_controller.dart';
import 'package:library_app/features/inventory_ledgers/inventory_ledgers_provider.dart';
import 'package:library_app/features/inventory_ledgers/inventory_ledgers_view.dart';
import 'package:library_app/features/list_inventory_ledgers/list_inventory_ledgers_controller.dart';
import 'package:library_app/features/list_inventory_ledgers/list_inventory_ledgers_view.dart';
import 'package:library_app/features/new_borrow_card/new_borrow_card_controller.dart';
import 'package:library_app/features/new_borrow_card/new_borrow_card_provider.dart';
import 'package:library_app/features/new_borrow_card/new_borrow_card_view.dart';
import 'package:library_app/features/new_inventory_ledger/new_inventory_ledger_controller.dart';
import 'package:library_app/features/new_inventory_ledger/new_inventory_ledger_provider.dart';
import 'package:library_app/features/new_inventory_ledger/new_inventory_ledger_view.dart';
import 'package:library_app/features/book_edit/book_edit_controller.dart';
import 'package:library_app/features/book_edit/book_edit_provider.dart';
import 'package:library_app/features/book_edit/book_edit_view.dart';
import 'package:library_app/features/new_book/new_book_controller.dart';
import 'package:library_app/features/new_book/new_book_provider.dart';
import 'package:library_app/features/new_book/new_book_view.dart';
import 'package:library_app/features/new_inventory_audit/new_inventory_audit_controller.dart';
import 'package:library_app/features/new_inventory_audit/new_inventory_audit_provider.dart';
import 'package:library_app/features/new_inventory_audit/new_inventory_audit_view.dart';
import '../features/qr_scanner/qr_scanner_controller.dart';
import '../features/qr_scanner/qr_scanner_provider.dart';
import '../features/qr_scanner/qr_scanner_view.dart';
import '../features/inventory_audit_detail/inventory_audit_detail_controller.dart';
import '../features/inventory_audit_detail/inventory_audit_detail_provider.dart';
import '../features/inventory_audit_detail/inventory_audit_detail_view.dart';
import '../features/login/login_controller.dart';
import '../features/login/login_provider.dart';
import '../features/login/login_view.dart';
import 'app_pages.dart';

class AppRoute {
  AppRoute._();

  static final List<GetPage> routes = [
    GetPage(
      name: AppPages.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        final provider = LoginProvider();
        Get.lazyPut<LoginProvider>(() => provider);
        Get.lazyPut<LoginController>(() => LoginController(provider));
      }),
    ),
    GetPage(
      name: AppPages.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        final provider = HomeProvider();
        Get.lazyPut<HomeProvider>(() => provider);
        Get.lazyPut<HomeController>(() => HomeController(provider));
      }),
    ),
    GetPage(
      name: AppPages.bookDetail,
      page: () => const BookDetailView(),
      binding: BindingsBuilder(() {
        final bookId = Get.arguments as String? ?? '';
        final provider = BookDetailProvider();
        Get.lazyPut<BookDetailProvider>(() => provider);
        Get.lazyPut<BookDetailController>(
          () => BookDetailController(provider, bookId: bookId),
        );
      }),
    ),
    GetPage(
      name: AppPages.borrowCards,
      page: () => const BorrowCardsView(),
      binding: BindingsBuilder(() {
        final provider = BorrowCardsProvider();
        Get.lazyPut<BorrowCardsProvider>(() => provider);
        Get.lazyPut<BorrowCardsController>(
          () => BorrowCardsController(provider),
        );
      }),
    ),
    GetPage(
      name: AppPages.listBorrowCards,
      page: () => const ListBorrowCardsView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map? ?? {};
        final status = args['status'] as int? ?? 0;
        final title = args['title'] as String? ?? 'Danh sách phiếu mượn';
        final provider = BorrowCardsProvider();
        Get.lazyPut<BorrowCardsProvider>(() => provider);
        Get.lazyPut<ListBorrowCardsController>(
          () =>
              ListBorrowCardsController(provider, status: status, title: title),
        );
      }),
    ),
    GetPage(
      name: AppPages.borrowCardDetail,
      page: () => const BorrowCardDetailView(),
      binding: BindingsBuilder(() {
        final cardId = Get.arguments as String? ?? '';
        final provider = BorrowCardDetailProvider();
        Get.lazyPut<BorrowCardDetailProvider>(() => provider);
        Get.lazyPut<BorrowCardDetailController>(
          () => BorrowCardDetailController(provider, cardId: cardId),
        );
      }),
    ),
    GetPage(
      name: AppPages.newBorrowCard,
      page: () => const NewBorrowCardView(),
      binding: BindingsBuilder(() {
        final provider = NewBorrowCardProvider();
        Get.lazyPut<NewBorrowCardProvider>(() => provider);
        Get.lazyPut<NewBorrowCardController>(
          () => NewBorrowCardController(provider),
        );
      }),
    ),
    GetPage(
      name: AppPages.inventoryLedgers,
      page: () => const InventoryLedgersView(),
      binding: BindingsBuilder(() {
        final provider = InventoryLedgersProvider();
        Get.lazyPut<InventoryLedgersProvider>(() => provider);
        Get.lazyPut<InventoryLedgersController>(
          () => InventoryLedgersController(provider),
        );
      }),
    ),
    GetPage(
      name: AppPages.listInventoryLedgers,
      page: () => const ListInventoryLedgersView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map? ?? {};
        final type = args['type'] as int? ?? 0;
        final title = args['title'] as String? ?? 'Danh sách phiếu kho';
        final provider = InventoryLedgersProvider();
        Get.lazyPut<InventoryLedgersProvider>(() => provider);
        Get.lazyPut<ListInventoryLedgersController>(
          () => ListInventoryLedgersController(
            provider,
            ledgerType: type,
            title: title,
          ),
        );
      }),
    ),
    GetPage(
      name: AppPages.inventoryLedgerDetail,
      page: () => const InventoryLedgerDetailView(),
      binding: BindingsBuilder(() {
        final ledgerId = Get.arguments as String? ?? '';
        final provider = InventoryLedgerDetailProvider();
        Get.lazyPut<InventoryLedgerDetailProvider>(() => provider);
        Get.lazyPut<InventoryLedgerDetailController>(
          () => InventoryLedgerDetailController(provider, ledgerId: ledgerId),
        );
      }),
    ),
    GetPage(
      name: AppPages.newInventoryLedger,
      page: () => const NewInventoryLedgerView(),
      binding: BindingsBuilder(() {
        final provider = NewInventoryLedgerProvider();
        Get.lazyPut<NewInventoryLedgerProvider>(() => provider);
        Get.lazyPut<NewInventoryLedgerController>(
          () => NewInventoryLedgerController(provider),
        );
      }),
    ),
    GetPage(
      name: AppPages.inventoryAudits,
      page: () => const InventoryAuditsView(),
      binding: BindingsBuilder(() {
        final provider = InventoryAuditsProvider();
        Get.lazyPut<InventoryAuditsProvider>(() => provider);
        Get.lazyPut<InventoryAuditsController>(
          () => InventoryAuditsController(provider),
        );
      }),
    ),
    GetPage(
      name: AppPages.listInventoryAudits,
      page: () => const ListInventoryAuditsView(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map? ?? {};
        final status = args['status'] as int? ?? 0;
        final title = args['title'] as String? ?? 'Danh sách phiếu kiểm kê';
        final provider = InventoryAuditsProvider();
        Get.lazyPut<InventoryAuditsProvider>(() => provider);
        Get.lazyPut<ListInventoryAuditsController>(
          () => ListInventoryAuditsController(
            provider,
            status: status,
            title: title,
          ),
        );
      }),
    ),
    GetPage(
      name: AppPages.newInventoryAudit,
      page: () => const NewInventoryAuditView(),
      binding: BindingsBuilder(() {
        final provider = NewInventoryAuditProvider();
        Get.lazyPut<NewInventoryAuditProvider>(() => provider);
        Get.lazyPut<NewInventoryAuditController>(
          () => NewInventoryAuditController(provider),
        );
      }),
    ),
    GetPage(
      name: AppPages.bookEdit,
      page: () => const BookEditView(),
      binding: BindingsBuilder(() {
        final bookId = Get.arguments as String? ?? '';
        final provider = BookEditProvider();
        Get.lazyPut<BookEditProvider>(() => provider);
        Get.lazyPut<BookEditController>(
          () => BookEditController(provider, bookId: bookId),
        );
      }),
    ),
    GetPage(
      name: AppPages.newBook,
      page: () => const NewBookView(),
      binding: BindingsBuilder(() {
        final provider = NewBookProvider();
        Get.lazyPut<NewBookProvider>(() => provider);
        Get.lazyPut<NewBookController>(() => NewBookController(provider));
      }),
    ),
    GetPage(
      name: AppPages.qrscanner,
      page: () => const QrScannerView(),
      binding: BindingsBuilder(() {
        final auditId = Get.arguments as String? ?? '';
        final provider = QrScannerProvider();
        Get.lazyPut<QrScannerProvider>(() => provider);
        Get.lazyPut<QrScannerController>(
          () => QrScannerController(provider, auditId: auditId),
        );
      }),
    ),
    GetPage(
      name: AppPages.inventoryAuditDetail,
      page: () => const InventoryAuditDetailView(),
      binding: BindingsBuilder(() {
        final auditId = Get.arguments as String? ?? '';
        final provider = InventoryAuditDetailProvider();
        Get.lazyPut<InventoryAuditDetailProvider>(() => provider);
        Get.lazyPut<InventoryAuditDetailController>(
          () => InventoryAuditDetailController(provider, auditId: auditId),
        );
      }),
    ),
  ];
}
