# Test-Logindaten für Dartverein App

Für Entwicklungs- und Testzwecke wurden folgende Logindaten eingerichtet:

## Verfügbare Test-Accounts:

| Benutzername | Passwort   | Beschreibung |
|--------------|------------|--------------|
| `admin`      | `admin123` | Administrator-Account |
| `test`       | `test123`  | Standard-Test-Account |
| `user`       | `password` | Einfacher Test-User |
| `dartverein` | `dart2024` | Vereins-Account |
| `player1`    | `123456`   | Spieler-Account |
| `demo`       | `demo123`  | Demo-Account |

## Funktionsweise:

- Die App prüft zuerst, ob die eingegebenen Daten zu den Test-Credentials passen
- Falls ja, wird ein Test-Token generiert und der Login ist erfolgreich
- Falls nein, wird versucht, sich über die echte API anzumelden
- Bei Test-Logins wird kein echter Server kontaktiert

## Verwendung:

1. App starten
2. Einen der obigen Benutzernamen eingeben
3. Das entsprechende Passwort eingeben
4. "Login" drücken
5. Sie werden automatisch zum Hauptmenü weitergeleitet

## Hinweise:

- Diese Test-Credentials sind nur für die Entwicklung gedacht
- In der Produktionsversion sollten diese entfernt oder durch eine Konfiguration gesteuert werden
- Die Test-Tokens sind temporär und werden bei jedem Login neu generiert