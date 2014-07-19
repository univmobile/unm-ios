package fr.univmobile.ios.it;

import static fr.univmobile.it.commons.AppiumCapabilityType.APP;
import static fr.univmobile.it.commons.AppiumCapabilityType.DEVICE;
import static fr.univmobile.it.commons.AppiumCapabilityType.DEVICE_NAME;
import static fr.univmobile.it.commons.AppiumCapabilityType.PLATFORM_NAME;
import static fr.univmobile.it.commons.AppiumCapabilityType.PLATFORM_VERSION;
import static org.openqa.selenium.remote.CapabilityType.BROWSER_NAME;
import static org.openqa.selenium.remote.CapabilityType.PLATFORM;
import io.appium.java_client.AppiumDriver;

import java.io.File;
import java.net.URL;

import org.apache.commons.io.FileUtils;
import org.junit.Ignore;
import org.junit.Test;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.remote.DesiredCapabilities;

import fr.univmobile.it.commons.EnvironmentUtils;

public class SimpleAppiumTest {

	@Test
	@Ignore
	public void testAppiumSimple() throws Exception {

		final DesiredCapabilities capabilities = new DesiredCapabilities();

		capabilities.setCapability(BROWSER_NAME, "iOS");

		capabilities.setCapability(PLATFORM, "Mac");
		capabilities.setCapability(PLATFORM_NAME, "iOS");
		capabilities.setCapability(PLATFORM_VERSION,
				EnvironmentUtils.getCurrentPlatformVersion());

		capabilities.setCapability(DEVICE, "iPhone Simulator");
		capabilities.setCapability(DEVICE_NAME, "iPhone Retina (4-inch)");
		// "iPhone");
		// "iPhone Retina (3.5-inch)");

		final File app = new File(
				"/Users/dandriana/Library/Developer/Xcode/DerivedData/UnivMobile-hkgpereuqofjldgxrixppsvcdulv/Build/Products/Debug-iphonesimulator/UnivMobile.app");

		capabilities.setCapability(APP, app.getAbsolutePath());

		final AppiumDriver driver = new AppiumDriver(new URL(
				"http://localhost:4723/wd/hub"), capabilities);
		try {

			final File file = // ((TakesScreenshot) augmentedDriver)
			driver.getScreenshotAs(OutputType.FILE);

			FileUtils.copyFile(file, //
					new File("target", "testAppiumSimple.png"));

			System.out.println(file.getCanonicalPath());

		} finally {
			driver.quit();
		}
	}
}
