import 'package:flutter/material.dart';

/// FAB icon "+" dùng chung cho các màn danh sách (thêm mới bản ghi).
class AddFab extends StatelessWidget {
  final String heroTag;
  final VoidCallback onPressed;

  const AddFab({
    super.key,
    required this.heroTag,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: onPressed,
      child: const Icon(Icons.add, color: Colors.white, size: 40),
    );
  }
}
