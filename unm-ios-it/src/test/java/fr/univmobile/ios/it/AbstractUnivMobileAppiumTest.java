package fr.univmobile.ios.it;

import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.APP;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.DEVICE;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.DEVICE_NAME;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.PLATFORM_NAME;
import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.openqa.selenium.remote.CapabilityType.BROWSER_NAME;
import static org.openqa.selenium.remote.CapabilityType.PLATFORM;
import io.appium.java_client.AppiumDriver;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.Augmenter;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

public abstract class AbstractUnivMobileAppiumTest {

	public interface AppiumCapabilityType {

		String APP = "app";
		String DEVICE = "device";
		String DEVICE_NAME = "deviceName";
		String PLATFORM_NAME = "platformName";
	}

	@Before
	public final void setUp() throws Exception {

		// 1. LAUNCH THE iOS APP

		// final String BUNDLE_ID = "fr.univmobile.UnivMobile";

		final File app = new File(
				PropertiesUtils.getTestProperty("AppPath")
						);

		final DesiredCapabilities capabilities = new DesiredCapabilities();

		capabilities.setCapability(BROWSER_NAME, "iOS");

		capabilities.setCapability(PLATFORM, "Mac");
		capabilities.setCapability(PLATFORM_NAME, "iOS");

		capabilities.setCapability(DEVICE, "iPhone Simulator");

		capabilities.setCapability(DEVICE_NAME, "iPhone Retina (4-inch)");

		capabilities.setCapability(APP, app.getAbsolutePath());

		driver = new RemoteWebDriver(new URL("http://localhost:4723/wd/hub"),
				capabilities);
	}

	protected WebDriver driver;

	protected final void takeScreenshot(final String filename)
			throws IOException {

		System.out.println("Taking screenshot: " + filename + "...");

		final WebDriver augmentedDriver = new Augmenter().augment(driver);

		final File srcFile = ((TakesScreenshot) augmentedDriver)
				.getScreenshotAs(OutputType.FILE);

		final File dir = new File("target", "screenshots");

		if (!dir.exists()) {
			dir.mkdir();
		}

		FileUtils.copyFile(srcFile, new File(dir, filename), true);
	}

	protected final void swipe(final int startX, final int startY,
			final int endX, final int endY, final int durationMs)
			throws IOException {

		((AppiumDriver) driver).swipe(30, 30, 40, 130, 500);
	}

	protected final void savePageSource(final String filename)
			throws IOException {

		System.out.println("Saving pageSource: " + filename + "...");

		final String xml = driver.getPageSource();

		final File dir = new File("target", "screenshots");

		if (!dir.exists()) {
			dir.mkdir();
		}

		FileUtils.write(new File(dir, filename), xml, UTF_8);
	}

}
