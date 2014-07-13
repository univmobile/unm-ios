package fr.univmobile.ios.it;

import org.junit.Test;

public class HomePageTest extends AbstractUnivMobileAppiumTest {

	@Test
	// public void testHomePage_titleIsUnivMobile() throws Exception {
	public void testHomePage_display() throws Exception {

		takeScreenshot("home.png");

		savePageSource("pageSource.xml");

		// Don’t ask me why one only swipe doesn’t work.

		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);
		swipe(80, 168, 77, 414, 800);

		takeScreenshot("about.png");

		// Don’t ask me why one only swipe doesn’t work.

		swipe(80, 414, 77, 168, 800);
		swipe(80, 414, 77, 168, 800);
		swipe(80, 414, 77, 168, 800);

		takeScreenshot("home2.png");
	}
}
