package fr.univmobile.ios.it;

import org.junit.Test;

@Scenarios("Scénarios simples")
public class UnivMobileScenarios001 extends AppiumEnabledTest {

	@Scenario("Aller-retour sur la page « À Propos »")
	@Test
	public void sc001() throws Exception {

		takeScreenshot("home.png");
		
		elementById("label-homePageTitle").shouldBeVisible();
		elementById("label-homePageTitle").textShouldBe("UnivMobile");
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
	
	@Scenario("Aller-retour sur la liste des Régions")
	@Test
	public void sc002() throws Exception {
		
		takeScreenshot("home_beforeRegions.png");

		futureScreenshot(200, "home_swappingToRegions.png");

		elementById("button-choisirUniversité").click();

		pause(2000);

		takeScreenshot("regions.png");
	}
}
