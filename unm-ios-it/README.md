unm-ios-it
==========

_Tests d’intégration de l’application iOS UnivMobile_

Documentation parente : [unm-ios](../README.md "Documentation parente : unm-ios/README.md") — _Application iOS UnivMobile_

Documentation de même niveau :

  * [Développement : unm-ios-it](Devel.md "Documentation : unm-ios-it/Devel.md") 
  
Ces tests s’appuient sur Appium, qui pilote le simulateur iOS sur la machine cible.

Les méthodes de tests décrivent de petits scénarios.

Exemple dans Scenarios001.java en itération 2 :

    @Scenario("Géocampus, commentaires")
	@Test
	public void Geocampus_001() throws Exception {

		pause(2000);
		takeScreenshot("home.png");
		elementById("button-Géocampus").click();
		pause(2000);
		takeScreenshot("geocampus_list.png");
		elementByXPath("//UIATabBar[1]/UIAButton[2]").click();
		pause(2000);
		takeScreenshot("geocampus_map.png");
		elementById("label-poi-name").click();
		pause(2000);
		takeScreenshot("geocampus_details.png");
		elementByXPath("//UIATabBar[1]/UIAButton[2]").click();
		pause(2000);
		takeScreenshot("comments.png");
	}

Les identifiants (« elementById() ») correspondent aux accessibilityIdentifier du code source (Xcode).

Les chemins XPath (« elementByXPath() ») correspondent aux chemins trouvés en
analysant les écrans dans Appium Inspector.

En lançant ces tests, des captures d’écrans sont prises, dans target/screenshots/

Dans un environnement Jenkins,
le projet unm-devel-it dans le repository GitHub unm-integration
a pour but de collecter les différentes captures d’écrans prises par les tests (il y a un job pour les captures en iOS 7 et un job pour les captures en iOS 6) et de les agréger dans une page HTML.

![](src/site/images/screenshot-scenario-ios.png?raw=true =600x "Screenshot Scénario")

Page live : [UnivMobile iOS — Scénarios](http://univmobile.vswip.com/job/unm-devel-it/lastSuccessfulBuild/artifact/unm-devel-it/target/unm-ios-it-scenarios-dump.html)

Jobs Jenkins :

  * [http://univmobile.vswip.com/job/unm-ios-it/](http://univmobile.vswip.com/job/unm-ios-it/) (iOS 7)
  * [http://univmobile.vswip.com/job/unm-ios-it_ios6/](http://univmobile.vswip.com/job/unm-ios-it_ios6/) (iOS 6)

Ces jobs s’appuient sur l’archive .app (iOS Simulator) créée
par un script xcodebuild_test.sh lancé en ligne de commande dans une GUI Mac OS X, et mise à disposition
avec timestamp dans un répertoire partagé /var/xcodebuild_test-apps
