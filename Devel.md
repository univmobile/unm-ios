# Développement : unm-ios

Documentation parente : [README.md](README.md "Documentation parente : unm-ios/README.md") _Application iOS UnivMobile_

### Documentation Doxygen

La documentation Doxygen et le Maven Generated Site sont accessibles depuis l’adresse suivante :
[Maven Generated Site](http://univmobile.vswip.com/nexus/content/sites/pub/unm-ios/0.0.4/ "Maven Generated Site: unm-ios:0.0.4")

### Installation sur un poste de développement

Testé avec : 

  * Mac OS X 10.8.5 / Mac OS X 10.9.4
  * Xcode 5.1.1
  * JDK 1.6 / JDK 7 pour la partie Maven
  * Maven 3.0.4 / Maven 3.2.1
  
Pour Maven, vérifier que le poste a accès aux repositories Nexus suivants :

  * [http://univmobile.vswip.com/nexus/content/repositories/](http://univmobile.vswip.com/nexus/content/repositories/)
  * [http://repo.avcompris.net/content/repositories/](http://repo.avcompris.net/content/repositories/)
  
En ligne de commande :

    > git clone https://github.com/univmobile/unm-ios

### Construction de l’archive .ipa (device) depuis Jenkins

Utiliser le script src/main/shell/xcodebuild_archive.sh

Ce script positionne les variables BUILD_DISPLAY_NAME, BUILD_ID, BUILD_NUMBER et GIT_COMMIT dans UnivMobile-Info.plist, qui seront ensuite affichées dans l’écran « À propos » de l’application iOS.

Job Jenkins : unm-ios_xcode

### Tests XCTest

Pour lancer les tests depuis Xcode :
    
    * menu Product, Scheme, UnivMobileTests

Pour les lancer depuis Jenkins, le script src/main/shell/xcodebuild_test.sh 
les lance effectivement, mais fait d’autres choses, comme l’archivage
des résultats des tests dans GitHub (projet unm-ios-ut-results dans le repository 
unm-integration),
et du dossier .app créé, dans /var/xcodebuild_test-apps

### Construction de l’archive .app (iOS Simulator) en ligne de commande

Le script src/main/shell/xcodebuild_test.sh lance les tests XCTest du projet Xcode
UnivMobile en ligne de commande,
puis archive les résultats dans GitHub
(projet unm-ios-ut-results dans le repository 
unm-integration),
et le dossier .app créé,
dans /var/xcodebuild_test-apps avec un timestamp.

C’est ce dossier, avec timestamp, qui sera utilisé par les jobs Jenkins de tests
d’intégration unm-ios-it : jobs Jenkins unm-ios-it et unm-ios-it_ios6.

On ne peut pas lancer xcodebuild_test.sh depuis une instance Jenkins sur une autre machine,
mais uniquement depuis la machine Mac OS X elle-même.

Cette obligation de lancer xcodebuild_test.sh dans un environnement Aqua vient d’une contrainte apple quant à l’exécution de la commande « xcodebuild test », qu’utilise précisément xcodebuild_test.sh.

Il a été étudié d’installer Jenkins sur la machine Mac OS X elle-même, et de faire publier les résultats par cette instance Jenkins vers l’instance Jenkins centrale, 
mais cela ne donnait pas les résultats attendus (résultats publiés partiels, et manque de sécurité).

Le processus suivant a été mis en place :

  1. Polling du repository GitHub unm-ios pour détecter les modifications.
  2. En cas de modification, récupération (git pull), et lancement des tests XCTest, construction de l’archive .app.
  3. Sauvegarde du fichier de log dans le projet unm-ios-ut-results du repository GitHub unm-integration.
  4. Sauvegarde avec timestamp du dossier .app construit dans un répertoire partagé /var/xcodebuild_test-apps.
  
Puis, analyse des résultats XCTest côté Jenkins :

  1. Le projet unm-ios-ut-results a des tests JUnit qui analysent le fichier de log résultant des tests XCTest.
  2. Pour chaque test XCTest passé, un test JUnit passe dans Jenkins.
  3. Pour chaque test XCTest en erreur, un test JUnit est en erreur dans Jenkins : cela permet de détecter les problèmes dans le projet Xcode unm-ios.
  4. 

Puis, tests d’intégration depuis Jenkins :

  * Les jobs unm-ios-it et unm-ios-it_ios6 utilisent l’archive .app sauvegardée avec timestamp dans le répertoire partagé /var/xcodebuild_test-apps
  
Job Jenkins :
 
 * pour lancer les tests XCTest : aucun
 * pour analyser les résultats des tests XCTest : unm-ios-ut-results
