import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../models/ressponses/inventory_ledger_detail_res.dart';

class InventoryLedgersProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API #13: getCountByType | GET /api/stocktransactions/count?type=
  Future<int> getCountByType(int type) async {
    final response = await _client.dio.get('/stocktransactions/count', queryParameters: {'type': type});
    return ApiClient.asInt(response.data);
  }

  // API #14: getLedgersByType | GET /api/stocktransactions/list?type=
  Future<List<InventoryLedgerDetailRes>> getLedgersByType(int type) async {
    final response = await _client.dio.get('/stocktransactions/list', queryParameters: {'type': type});
    final data = ApiClient.asList(response.data);
    return data.map((e) => InventoryLedgerDetailRes.fromJson(e)).toList();
  }
}
