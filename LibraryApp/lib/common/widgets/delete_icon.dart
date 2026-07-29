import 'package:flutter/material.dart';

/// Icon "xoá" dùng chung cho toàn app — đồng nhất icon + màu đỏ.
/// Size truyền vào theo từng nơi sử dụng để giữ nguyên kích thước cũ.
class DeleteIcon extends StatelessWidget {
  final double? size;

  const DeleteIcon({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.delete_outline, color: Colors.red, size: size);
  }
}
