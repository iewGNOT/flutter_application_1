T enumByName<T extends Enum>(Iterable<T> values, String name) {
  return values.firstWhere(
    (value) => value.name == name,
    orElse: () =>
        throw ArgumentError.value(name, 'name', 'Unknown enum name for $T.'),
  );
}
