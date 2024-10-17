import 'package:mysql1/mysql1.dart';

class Bd {

  Bd();

  Future<MySqlConnection> createConnection() async {
    var settings = new ConnectionSettings(
      host: 'localhost',        // Exemple : 'localhost' ou l'adresse de votre serveur
      port: 3306,                // Port MySQL, généralement 3306
      user: 'root', // Nom d'utilisateur MySQL
      password: 'root',     // Mot de passe MySQL
      db: 'bons_coins',   // Nom de la base de données
    );

    return await MySqlConnection.connect(settings);
  }

}