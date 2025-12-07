

class SnackItem {
  final String name;
  final String det;
  final int price;
  int quan;

  SnackItem({
    required this.name,
    required this.det,
    required this.price,
    this.quan = 0,
  });

  int get totalPrice => price * quan;
}
