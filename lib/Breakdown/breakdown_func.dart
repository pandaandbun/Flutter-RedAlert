import '../Database/missing_person_database.dart';

class BreakdownFunc {
  List<Person> people;

  BreakdownFunc({this.people});

  Map<String, int> getByCity() {
    Map<String, int> breakdown = {};

    for (Person person in people) {
      String location = person.province + "*" + person.city;

      // if (location.split("-").length > 2) {
      //   print("----------------------------------------");
      //   print(person.firstName + " " + person.lastName);
      //   print(location);
      // }

      if (!breakdown.containsKey(location)) {
        breakdown[location] = 0;
      }
      breakdown[location] += 1;
    }
    return breakdown;
  }

  Map<String, int> getByProvince() {
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
