unm-ios-it
==========

Tests d’intégration de l’application iOS UnivMobile.

Ces tests s’appuient sur Appium, qui pilote le simulateur iOS sur la machine cible.

Les méthodes de tests décrivent de petits scénarios.

Des captures d’écrans sont prises, dans target/screenshots/

Dans un environnement Jenkins,
le projet **unm-devel-it** dans **unm-integration**
a pour but de collecter les différentes captures d’écrans prises par les tests (il y a un job pour les captures en iOS 7 et un job pour les captures en iOS 6) et de les agréger dans une page HTML.

