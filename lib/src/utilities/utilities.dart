/// Szudzik's function for hashing two ints together
int szudzik(int a, int b) {
  assert(a != null && b != null);
  // a and b must be >= 0

  int x = a.abs();
  int y = b.abs();
  return x >= y ? x * x + x + y : x + y * y;
}
