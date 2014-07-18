package fr.univmobile.ios.it;

import org.junit.Test;

@Scenarios("Scénarios simples")
@DeviceNames({ "iPhone Retina (3.5-inch)", "iPhone Retina (4-inch)" })
public class Scenarios001 extends AppiumEnabledTest {

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

	public static final int PAUSE = 2000;
	public static final int DELAY_SCREENSHOT = 160;

	@Scenario("Aller-retour sur la liste des Régions")
	@Test
	public void sc002() throws Exception {

		takeScreenshot("home_beforeRegions.png");

		pause(PAUSE);

		savePageSource("pageSource.xml");

		futureScreenshot(DELAY_SCREENSHOT, "home_swappingToRegions.png");

		elementById("button-choisirUniversité").click();

		pause(PAUSE);

		takeScreenshot("regions.png");

		pause(PAUSE);

		futureScreenshot(DELAY_SCREENSHOT, "home_swappingFromRegions.png");

		elementByName("Retour").click();

		pause(PAUSE);

		takeScreenshot("home_afterRegions.png");
	}
}
