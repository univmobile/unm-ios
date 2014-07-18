package fr.univmobile.ios.it;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class EnvironmentUtilsTest {

	@Test
	public void testGetPlatformVersion() throws Exception {

		final String platformVersion = EnvironmentUtils
				.getCurrentPlatformVersion();

		assertEquals("7.1", platformVersion);
	}
}
