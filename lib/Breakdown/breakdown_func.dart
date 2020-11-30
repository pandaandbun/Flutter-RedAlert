import '../Database/missing_person_database.dart';

class BreakdownFunc {
  List<Person> people;
  Set<String> provinces = Set();
  String currentTable;

  Map<String, int> _ctiyStat = {};
  Map<String, int> _provinceStat = {};

  BreakdownFunc({this.people});

  // ----------------------------------------

  Map<String, int> get byCity {
    currentTable = 'City';

    if (_ctiyStat.isEmpty) {
      _ctiyStat = _getByCity();
    }
    return _ctiyStat;
  }

  Map<String, int> get byProvince {
    currentTable = 'Province';

    if (_provinceStat.isEmpty) {
      _provinceStat = _getByProvince();
    }
    return _provinceStat;
  }

  // ----------------------------------------

  Map<String, int> _getByCity() {
    Map<String, int> breakdown = {};

    for (Person person in people) {
      String location = person.province + "*" + person.city;

      provinces.add(person.province);

      if (!breakdown.containsKey(location)) {
        breakdown[location] = 0;
      }
      breakdown[location] += 1;
    }
    return breakdown;
  }

  Map<String, int> _getByProvince() {
    Map<String, int> breakdown = {};

    for (Person person in people) {
      String location = person.province;

      if (!breakdown.containsKey(location)) {
        breakdown[location] = 0;
      }
      breakdown[location] += 1;
    }
    return breakdown;
  }
}
