import 'dart:collection';

const _minIndex = FractionalIndex.min();
const _maxIndex = FractionalIndex.max();

abstract class FractionallyIndexedList<T> extends ListBase<T> {
  final List<T> _values;
  FractionalIndex orderOf(T value);
  List<T> get values => _values;

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  T operator [](int index) => _values[index];

  @override
  void operator []=(int index, T value) => _values[index] = value;

  FractionallyIndexedList({
    List<T> values,
    bool initOrder = true,
  }) : _values = values ?? <T>[] {
    if (_values.isEmpty || !initOrder) {
      return;
    }
    // Otherwise spread them evenly across our range using 1/2 as the midpoint.
    int mid = _values.length ~/ 2;
    var midIndex = const FractionalIndex(1, 2);
    setOrderOf(_values[mid], midIndex);

    var lastIndex = midIndex;
    for (int i = mid + 1; i < _values.length; i++) {
      var index = FractionalIndex.between(lastIndex, _maxIndex);
      setOrderOf(_values[i], index);
      lastIndex = index;
    }

    lastIndex = midIndex;
    for (int i = mid - 1; i >= 0; i--) {
      var index = FractionalIndex.between(_minIndex, lastIndex);
      setOrderOf(_values[i], index);
      lastIndex = index;
    }
  }

  FractionallyIndexedList.raw(List<T> values) : _values = values ?? <T>[];

  void setOrderOf(T value, FractionalIndex order);

  /// Set the fractional indices to match the current order of the items. This
  /// is a pretty heavy operation as it could change the fractional index of
  /// every item in the list. Should be used sparingly for cases that really
  /// require it.
  void setFractionalIndices() {
    var previousIndex = _minIndex;
    for (final item in _values) {
      var index = FractionalIndex.between(previousIndex, _maxIndex);
      setOrderOf(item, index);
      previousIndex = index;
    }
  }

  int _compareIndex(T a, T b) {
    return orderOf(a).compareTo(orderOf(b));
  }

  void sortFractional() => _values.sort(_compareIndex);

  bool validateFractional([FractionalIndex minimum]) {
    var previousIndex = minimum ?? _minIndex;

    bool wasValid = true;
    for (final item in _values) {
      var order = orderOf(item);
      if (order == null) {
        wasValid = false;
        continue;
      }
      if (order.compareTo(previousIndex) > 0) {
        previousIndex = order;
      }
    }
    if (wasValid) {
      return true;
    }

    for (final item in _values) {
      if (orderOf(item) == null) {
        var index = FractionalIndex.between(previousIndex, _maxIndex);
        setOrderOf(item, index);
        previousIndex = index;
      }
    }
    return false;
  }

  @override
  void add(T item) {
    assert(!contains(item));
    _values.add(item);
  }

  @override
  bool remove(Object element) => _values.remove(element);

  void append(T item) {
    assert(!contains(item));
    var previousIndex = _values.isEmpty ? _minIndex : orderOf(_values.last);
    setOrderOf(item, FractionalIndex.between(previousIndex, _maxIndex));
    _values.add(item);
  }

  /// Gets the next fractional index safely, most of the other methods here
  /// assume the index list is valid, this one does not. It'll find the best
  /// next index. It's meant to be used to help implementations patch up their
  /// lists as necessary.
  FractionalIndex get nextFractionalIndex {
    var previousIndex = _minIndex;
    for (final item in _values) {
      var order = orderOf(item);
      if (order == null) {
        continue;
      }
      if (order.compareTo(previousIndex) > 0) {
        previousIndex = order;
      }
    }
    return FractionalIndex.between(previousIndex, _maxIndex);
  }

  void prepend(T item) {
    assert(!contains(item));
    var firstIndex = _values.isEmpty ? _maxIndex : orderOf(_values.first);
    setOrderOf(item, FractionalIndex.between(_minIndex, firstIndex));
    _values.add(item);
  }

  void moveToEnd(T item) {
    var previousIndex = _values.isEmpty ? _minIndex : orderOf(_values.last);
    setOrderOf(item, FractionalIndex.between(previousIndex, _maxIndex));
  }

  void moveToStart(T item) {
    var firstIndex = _values.isEmpty ? _maxIndex : orderOf(_values.first);
    setOrderOf(item, FractionalIndex.between(_minIndex, firstIndex));
  }

  void move(T item, {T before, T after}) {
    setOrderOf(
        item,
        FractionalIndex.between(before != null ? orderOf(before) : _minIndex,
            after != null ? orderOf(after) : _maxIndex));
  }

  void reverse() {
    var indices = <FractionalIndex>[];
    for (final item in _values) {
      indices.add(orderOf(item));
    }

    var length = _values.length;
    for (int i = 0; i < length; i++) {
      setOrderOf(_values[i], indices[length - 1 - i]);
    }
    sortFractional();
  }
}

class FractionalIndex {
  final int numerator;
  final int denominator;

  const FractionalIndex(this.numerator, this.denominator)
      : assert(numerator < denominator);

  const FractionalIndex.min()
      : numerator = 0,
        denominator = 1;
  const FractionalIndex.max()
      : numerator = 1,
        denominator = 1;

  int compareTo(FractionalIndex other) {
    return numerator * other.denominator - denominator * other.numerator;
  }

  FractionalIndex combine(FractionalIndex other) {
    return FractionalIndex(
        numerator + other.numerator, denominator + other.denominator);
  }

  factory FractionalIndex.between(FractionalIndex a, FractionalIndex b) {
    return FractionalIndex(
            a.numerator + b.numerator, a.denominator + b.denominator)
        .reduce();
  }

  FractionalIndex reduce() {
    int x = numerator, y = denominator;
    while (y != 0) {
      int t = y;
      y = x % y;
      x = t;
    }
    return FractionalIndex(numerator ~/ x, denominator ~/ x);
  }

  bool operator <(FractionalIndex other) {
    return compareTo(other) < 0;
  }

  bool operator >(FractionalIndex other) {
    return compareTo(other) > 0;
  }

  @override
  bool operator ==(Object other) =>
      other is FractionalIndex &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => szudzik(numerator, denominator);

  @override
  String toString() => '$numerator/$denominator';
}

/// Szudzik's function for hashing two ints together
int szudzik(int a, int b) {
  // a and b must be >= 0
  int x = a.abs();
  int y = b.abs();
  return x >= y ? x * x + x + y : x + y * y;
}
