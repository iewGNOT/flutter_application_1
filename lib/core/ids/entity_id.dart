final class EntityId {
  EntityId(this.value) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, 'value', 'Entity id cannot be blank.');
    }
  }

  final String value;

  @override
  String toString() => value;
}
