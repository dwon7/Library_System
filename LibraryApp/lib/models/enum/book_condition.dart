enum BookCondition {
  usable(1, "Còn sử dụng"),
  torn(2, "Rách nát"),
  lost(3, "Mất"),
  notInventoried(4, "Chưa kiểm kê");

  final int value;
  final String label;

  const BookCondition(this.value, this.label);
}
