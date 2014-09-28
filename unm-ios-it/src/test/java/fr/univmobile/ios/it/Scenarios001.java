package fr.univmobile.ios.it;

import static fr.univmobile.backend.core.impl.ConnectionType.MYSQL;
import static fr.univmobile.testutil.PropertiesUtils.getSettingsTestRefProperty;
import static fr.univmobile.testutil.PropertiesUtils.getTestProperty;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Before;
import org.junit.Test;

import fr.univmobile.backend.it.TestBackend;
import fr.univmobile.it.commons.AppiumIOSEnabledTest;
import fr.univmobile.it.commons.DeviceNames;
import fr.univmobile.it.commons.EnvironmentUtils;
import fr.univmobile.it.commons.Scenario;
import fr.univmobile.it.commons.Scenarios;

@Scenarios("Scénarios simples")
@DeviceNames({ "iPhone Retina (3.5-inch)", "iPhone Retina (4-inch)" })
public class Scenarios001 extends AppiumIOSEnabledTest {

	@Before
	public void setUpData() throws Exception {

		// "/tmp/unm-mobileweb/dataDir"
		final String dataDir = TestBackend.readBackendAppDataDir(new File(
				"target", "unm-backend-app-noshib/WEB-INF/web.xml"));

		final Connection cxn = DriverManager.getConnection(//
				getTestProperty("mysql.url"), //
				getTestProperty("mysql.username"), //
				getSettingsTestRefProperty("mysql.password.ref"));
		try {

			TestBackend.setUpData("001", new File(dataDir), MYSQL, cxn);

		} finally {
			cxn.close();
		}
	}

	@Scenario("Aller-retour sur la page « À Propos »")
	@Test
	public void sc001() throws Exception {

		takeScreenshot("home.png");

		elementById("label-homePageTitle").shouldBeVisible();
		elementById("label-homePageTitle").textShouldEqualTo("UnivMobile");
		elementById("textView-buildInfo").shouldBeHidden();

		// Don’t ask me why running only one swipe doesn’t work.

		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);

		takeScreenshot("about.png");

		elementById("label-homePageTitle").shouldBeHidden();
		elementById("textView-buildInfo").shouldBeVisible();

		// Don’t ask me why running only one swipe doesn’t work.

		swipe(80, 414, 77, 168, 800);
		swipe(80, 414, 77, 168, 800);
		swipe(80, 414, 77, 168, 800);

		takeScreenshot("home2.png");

		elementById("label-homePageTitle").shouldBeVisible();
		elementById("textView-buildInfo").shouldBeHidden();
	}

	@Scenario("Recharger les données")
	@Test
	public void sc004() throws Exception {

		takeScreenshot("home.png");

		// Don’t ask me why running only one swipe doesn’t work.

		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);

		takeScreenshot("about1.png");

		elementById("button-dataRefresh").click();

		pause(PAUSE);

		takeScreenshot("about2.png");

		savePageSource("about2.xml");
		
		elementById("button-okCloseAbout").click();

		pause(PAUSE);

		takeScreenshot("home2.png");

		elementById("button-choisirUniversité").click();

		pause(PAUSE);

		takeScreenshot("regions.png");

		elementById("table-regions-bretagne").click(); // Bretagne

		pause(PAUSE);

		takeScreenshot("universities.png");

		elementById("table-universities-rennes1").click(); // Univ. de Rennes 1

		pause(PAUSE);

		takeScreenshot("home_afterUniversities.png");
	}

	public static final int PAUSE = 2000;
	public static final int DELAY_SCREENSHOT = 160;

	@Scenario("Aller-retour sur la liste des Régions")
	@Test
	public void sc002() throws Exception {

		takeScreenshot("home_beforeRegions.png");

		pause(PAUSE);

		savePageSource("homeSource.xml");

		futureScreenshot(DELAY_SCREENSHOT, "home_swappingToRegions.png");

		elementById("button-choisirUniversité").click();

		pause(PAUSE);

		takeScreenshot("regions.png");

		savePageSource("regionsSource.xml");

		// pause(PAUSE); // ?

		futureScreenshot(DELAY_SCREENSHOT, "home_swappingFromRegions.png");

		elementByName("Retour").click();

		pause(PAUSE);

		takeScreenshot("home_afterRegions.png");
	}

	@Scenario("Sélection d’une université")
	@Test
	public void sc003() throws Exception {

		takeScreenshot("home_beforeRegions.png");

		pause(PAUSE);

		// savePageSource("pageSource.xml");

		futureScreenshot(DELAY_SCREENSHOT, "home_swappingToRegions.png");

		elementById("button-choisirUniversité").click();

		pause(PAUSE);

		takeScreenshot("regions.png");

		savePageSource("regionsSource.xml");

		// pause(PAUSE); // ?

		futureScreenshot(DELAY_SCREENSHOT, "regions_swappingToUniversities.png");

		elementById("table-regions-unrpcl").click(); // Limousin/Poitou-Ch.

		pause(PAUSE);

		takeScreenshot("universities.png");

		savePageSource("universitiesSource.xml");

		futureScreenshot(DELAY_SCREENSHOT, "universities_swappingToHome.png");

		elementById("table-universities-ul").click(); // Université de Limoges

		pause(PAUSE);

		takeScreenshot("home_afterUniversities.png");

		savePageSource("home_afterUniversitiesSource.xml");
	}

	private static String navUpName = null;
	private static String navUpXPath = null;

	@Scenario("Géocampus")
	@Test
	public void Geocampus_000() throws Exception {

		pause(PAUSE);

		takeScreenshot("home.png");

		elementById("button-Géocampus").click();

		pause(PAUSE);

		takeScreenshot("geocampus_list.png");

		savePageSource("geocampus_list.xml");

		// getDriver().findElement(By.xpath("//UIATabBar[1]/UIAButton[2]"))
		// .click();
		elementByXPath("//UIATabBar[1]/UIAButton[2]").click();
		// elementById("Plan").click();

		pause(PAUSE);

		takeScreenshot("geocampus_map.png");

		// elementById("link-poiNav-3792").click(); // Cergy Pointoise

		// pause(2000);

		// takeScreenshot("geocampus_map_infoWindow.png");

		elementById("label-poi-name").click();

		pause(PAUSE);

		takeScreenshot("geocampus_details.png");

		savePageSource("geocampus_details.xml");

		if (navUpName == null && navUpXPath == null) {

			boolean IOS_6 = false;

			final String platformVersion = EnvironmentUtils
					.getCurrentPlatformVersion("iOS");

			System.out.println("Found platformVersion: " + platformVersion);

			if (platformVersion.startsWith("6")) {
				IOS_6 = true;
			}

			// To find these values, launch the Appium Inspector.
			//
			if (IOS_6) { // IOS_6
				// navUpXPath = "//UIANavigationBar[1]/UIAButton[1]";
				navUpXPath = null;
				navUpName = "POIs";
			} else { // IOS_7
				navUpXPath = "//UIANavigationBar[2]/UIAButton[2]";
				navUpName = null;
			}
		}

		if (navUpName != null) {
			elementByName(navUpName).click();
			// elementByName("POIs").click(); // ?
		} else {
			elementByXPath(navUpXPath).click();
		}

		pause(PAUSE);

		takeScreenshot("geocampus_back_to_map.png");
	}

	@Scenario("Géocampus, commentaires")
	@Test
	public void Geocampus_001() throws Exception {

		pause(PAUSE);
		takeScreenshot("home.png");
		elementById("button-Géocampus").click();
		pause(PAUSE);
		takeScreenshot("geocampus_list.png");
		elementByXPath("//UIATabBar[1]/UIAButton[2]").click();
		// elementByName("Plan").click();
		pause(PAUSE);
		takeScreenshot("geocampus_map.png");
		elementById("label-poi-name").click();
		pause(PAUSE);
		takeScreenshot("geocampus_details.png");
		elementByXPath("//UIATabBar[1]/UIAButton[2]").click();
		// elementByName("Commentaires").click();
		pause(PAUSE);
		takeScreenshot("comments.png");
	}
}
