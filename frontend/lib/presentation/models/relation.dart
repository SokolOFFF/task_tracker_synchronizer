import 'dart:collection';

sealed class Relation {
  const Relation();
}

class OneToOneRelation extends Relation {
  const OneToOneRelation();
}

class ComplexRelation extends Relation {
  final HashMap<String, String> relatinos;
  const ComplexRelation(this.relatinos);
}

class NotInclude extends Relation {
  const NotInclude();
}

enum RelationType { oneToOne, complex, notInclude }
