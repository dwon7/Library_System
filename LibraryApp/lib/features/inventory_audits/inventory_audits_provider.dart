import 'package:get/get.dart';
import 'package:library_app/core/api_client.dart';

import '../../models/ressponses/inventory_audit_detail_res.dart';

class InventoryAuditsProvider {
  final ApiClient _client = Get.find<ApiClient>();

  // API #9b: getCountByStatus (IC) | GET /api/inventorychecks/count?status=
  Future<int> getCountByStatus(int status) async {
    final response = await _client.dio.get('/inventorychecks/count', queryParameters: {'status': status});
    return ApiClient.asInt(response.data);
  }

  // API #11: getAuditsByStatus | GET /api/inventorychecks/list?status=
  Future<List<InventoryAuditDetailRes>> getAuditsByStatus(int status) async {
    final response = await _client.dio.get('/inventorychecks/list', queryParameters: {'status': status});
    final data = ApiClient.asList(response.data);
    return data.map((e) => InventoryAuditDetailRes.fromJson(e)).toList();
  }
}
