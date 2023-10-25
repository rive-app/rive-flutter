/// Helper for getting a valid enum at an index (or default to the first one).
T enumAt<T>(List<T> values, int index) =>
    index < values.length ? values[index] : values.first;
