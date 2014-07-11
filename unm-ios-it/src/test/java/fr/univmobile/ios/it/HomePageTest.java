package fr.univmobile.ios.it;

import org.junit.Test;

public class HomePageTest extends AbstractUnivMobileAppiumTest {

	@Test
	public void testHomePage_titleIsUnivMobile() throws Exception {

		takeScreenshot("home.png");
	}
}
