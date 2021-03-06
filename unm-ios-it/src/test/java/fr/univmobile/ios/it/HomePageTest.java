package fr.univmobile.ios.it;

import org.junit.Test;

import fr.univmobile.it.commons.AppiumIOSEnabledTest;

public class HomePageTest extends AppiumIOSEnabledTest {

	@Test
	public void testHomePage_display() throws Exception {

		takeScreenshot("home.png");

		savePageSource("pageSource.xml");

		// Don’t ask me why running only one swipe doesn’t work.

		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);

		takeScreenshot("about.png");

		// Don’t ask me why running only one swipe doesn’t work.

		swipe(80, 414, 77, 168, 800);
		swipe(80, 414, 77, 168, 800);
		swipe(80, 414, 77, 168, 800);

		takeScreenshot("home2.png");
	}

	@Test
	public void testHomePage_goToRegionsPage() throws Exception {

		takeScreenshot("home_beforeRegions.png");

		pause(2000);

		futureScreenshot(600, "home_swappingToRegions.png");

		findElementById("button-choisirUniversité").click();

		pause(2000);

		takeScreenshot("regions.png");
	}
}
