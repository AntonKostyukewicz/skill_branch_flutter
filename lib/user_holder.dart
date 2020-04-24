import 'models/user.dart';
import 'models/user.dart';
import 'string_util.dart';

class UserHolder {
  Map<String, User> users = {};

  void registerUser(String name, String phone, String email) {
    User user = User(name: name, phone: phone, email: email);

    print(user.toString());

    if (!users.containsKey(user.login)) {
      users[user.login] = user;
    } else {
      throw Exception('A user with this name already exists');
    }
  }

  User registerUserByEmail(String fullName, String email) {
    User user = User(name: fullName, email: email);

    print(user.toString());

    if (!users.containsKey(user.email)) {
      users[user.email] = user;
      return user;
    }
    throw Exception('A user with this email already exists');
  }

  User registerUserByPhone(String fullName, String phone) {
    User user = User(name: fullName, phone: phone);

    print(user.toString());

    if (!users.containsKey(user.phone)) {
      users[user.phone] = user;
      return user;
    }
    throw Exception('A user with this phone already exists');
  }

  User findUserInFriends(String fullName, User user) {
    if (users.containsKey(fullName)) {
      if (users[fullName].friends.contains(user)) {
        return user;
      } else {
        throw Exception("${user.login} is not a friend of the login");
      }
    }
    throw Exception("$fullName is not found");
  }

  User getUserByLogin(String login) {
    if (users.containsKey(login)) {
      return users[login];
    }
    throw Exception("$login is not found");
  }

  void setFriends(String login, List<User> friends) {
    if (users.containsKey(login)) {
      users[login].friends.addAll(friends);
    } else {
      throw Exception("User $login is not found");
    }
  }

  List<User> importUsers(List<String> stringList) {
    List<User> userList = List();
    if (stringList.isNotEmpty) {
      stringList.forEach((str) {
        userList.add(_parseUserString(str));
      });
    }
    return userList;
  }

  User _parseUserString(String userString) {
    List<String> splittedList = userString.split(";\n");
    String name = splittedList[0].trim();
    String phone = splittedList[2].trim();
    String email = splittedList[1].trim();
    return User(name: name, phone: phone, email: email);
  }

}