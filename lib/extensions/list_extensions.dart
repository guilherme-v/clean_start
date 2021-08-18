extension ListExtensions<T extends Comparable<T>> on List<T> {
  void sorted({bool ascending = true}) {
    ascending
        ? sort((T a, T b) => a.compareTo(b))
        : sort((T a, T b) => b.compareTo(a));
  }
}
