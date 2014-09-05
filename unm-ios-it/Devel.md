# Développement : unm-ios-it

Documentation parente : [README.md](README.md "Documentation parente : unm-ios-it/README.md") — _Tests d’intégration de l’application iOS UnivMobile_

### Installation sur un poste de développement

Testé avec : 

  * Mac OS X 10.8.5 / Mac OS X 10.9.4
  * JDK 1.6 / JDK 7
  * Maven 3.0.4 / Maven 3.2.1
  
Vérifier que le poste a accès aux repositories Nexus suivants :

  * [http://univmobile.vswip.com/nexus/content/repositories/](http://univmobile.vswip.com/nexus/content/repositories/)
  * [http://repo.avcompris.net/content/repositories/](http://repo.avcompris.net/content/repositories/)
  
En ligne de commande :

    > git clone https://github.com/univmobile/unm-ios
    > cd unm-ios-it
    > mvn -U test-compile
    
Note : l’option « -U » (--update-snapshots) permet de forcer la récupération des mises à jour des dépendances snapshots auprès des repositories Nexus, même s’il s’agit du POM parent.

Pour permettre à Eclipse d’ouvrir le projet :

    > mvn eclipse:eclipse
    
… ou ouvrir le projet dans Eclipse avec les plugins adéquats.

### Configuration de Xcode et d’Appium

Les tests Java s’appuient sur l’iOS SDK par défaut de l’environnement courant, et déclarent avec l’annotation Java @DeviceNames les tailles d’écrans avec lesquels lancer les tests.

Exemples : 

  * Sur un Mac OS X 10.9.4 avec Xcode 5.1.1 installé (iOS SDK par défaut = 7.1), la classe de tests Scenarios001 lancera des captures d’écrans pour : iOS 7.1 — iPhone Retina (3.5-inch), et : iOS 7.1 — iPhone (Retina 4-inch).
  * Sur un Mac OS X 10.8.5 avec Xcode 4.6.3 installé (iOS SDK par défaut = 6.1), la classe de tests Scenarios001 lancera des captures d’écrans pour : iOS 6.1 — iPhone Retina (3.5-inch), et : iOS 6.1 — iPhone Retina (4-inch).

La configuration Xcode 5.1.1 ne permet donc pas d’exécuter les tests et d’enregistrer des captures d’écrans en iOS 6.1, mais uniquement en 7.1.
  
Noter que la configuration Mac OS X 10.9.4 + Xcode 4.6.3 ne permet pas d’exécuter correctement les tests Appium en intégration continue, car il est alors demandé à chaque test : « Instruments wants permission to analyze other processes. Type your password to allow this. » et on ne peut pas débloquer ce message une fois pour toutes, contrairement à ce qui se passe sous Mac OS X 10.8.5.

Un bug peut empêcher d’exécuter les tests en iOS 6 + iPhone Retina (4-inch) : les écrans apparaissent systématiquement en 3.5-inch, malgré le
code Java
`capabilities.setCapability(DEVICE_NAME, 
"iPhone Retina (4-inch)");`
Dans ce cas, configurer Appium à travers sa GUI, avec : Force Device = iPhone Retina (4-inch). Les écrans 4-inch apparaîtront, et les écrans 3.5-inch spécifiés par le code Java également.

Les jobs Jenkins ont été exécutés :

  * sur un node Mac OS X 10.9.4 + Xcode 5.1.1 pour les screenshots iOS 7.1,
  * sur un node Mac OS X 10.8.5 + Xcode 4.6.3 pour les screenshots iOS 6.1.

Utiliser xcode-select pour sélectionner la version de Xcode par défaut. Exemple sur un Mac où Xcode 5.1.1 et Xcode 4.6.3 sont installés :

    > xcode-select --switch /Applications/Xcode-4.6.3.app/Contents/Developer
    
Pour vérifier :

    $ xcode-select --print-path
    /Applications/Xcode-4.6.3.app/Contents/Developer

### Lancement des tests

Depuis Eclipse, clic droit sur la classe Scenarios001 : les méthodes de tests (chaque méthode correspond à un scénario) de Scenarios001 seront lancées sur Appium avec l’iOS SDK par défaut et la taille de device par défaut. 

Depuis Eclipse, clic droit sur la classe AllScenariosTest : les méthodes de tests (= scénarios) de Scenarios001, etc. seront lancées sur Appium avec l’iOS SDK par défaut, et avec toutes les tailles de devices déclarées avec l’annotation @DeviceNames dans les classes de test telles que Scenarios001.

Avec Maven :

    > mvn test