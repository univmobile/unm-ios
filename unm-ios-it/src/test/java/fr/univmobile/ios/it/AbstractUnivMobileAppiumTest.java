package fr.univmobile.ios.it;

import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.APP;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.DEVICE;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.DEVICE_NAME;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.PLATFORM_NAME;
import static fr.univmobile.ios.it.AbstractUnivMobileAppiumTest.AppiumCapabilityType.PLATFORM_VERSION;
import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.apache.commons.lang3.StringUtils.substringBeforeLast;
import static org.openqa.selenium.remote.CapabilityType.BROWSER_NAME;
import static org.openqa.selenium.remote.CapabilityType.PLATFORM;
import io.appium.java_client.AppiumDriver;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.Augmenter;
import org.openqa.selenium.remote.DesiredCapabilities;

import fr.univmobile.testutil.PropertiesUtils;

public abstract class AbstractUnivMobileAppiumTest {

	public interface AppiumCapabilityType {

		String APP = "app";
		String DEVICE = "device";
		String DEVICE_NAME = "deviceName";
		String PLATFORM_NAME = "platformName";
		String PLATFORM_VERSION = "platformVersion";
	}

	private static File app; // the "UnivMobile.app" local directory

	@Before
	public final void setUp() throws Exception {

		// 1. LAUNCH THE iOS APP

		// final String BUNDLE_ID = "fr.univmobile.UnivMobile";

		if (app == null) {

			final String appPath;

			final String appPathProperty = PropertiesUtils
					.getTestProperty("AppPath");

			if (!appPathProperty.contains("UnivMobile-(lastimport).app")) {

				appPath = appPathProperty;

			} else {

				// e.g.
				// "/var/xcodebuild_test-apps/UnivMobile-20140712-090711.app"

				appPath = getMostRecentAppPah(appPathProperty);
			}

			app = new File(appPath);

			System.out.println("Using: " + app.getCanonicalPath());
		}

		final DesiredCapabilities capabilities = new DesiredCapabilities();

		capabilities.setCapability(BROWSER_NAME, "iOS");

		capabilities.setCapability(PLATFORM, "Mac");
		capabilities.setCapability(PLATFORM_NAME, "iOS");
		capabilities.setCapability(PLATFORM_VERSION, "7.1");

		capabilities.setCapability(DEVICE, "iPhone Simulator");
		capabilities.setCapability(DEVICE_NAME, "iPhone Retina (4-inch)");

		capabilities.setCapability(APP, app.getAbsolutePath());

		driver = new AppiumDriver(new URL("http://localhost:4723/wd/hub"),
				capabilities);
	}

	private static String getMostRecentAppPah(final String appPathProperty)
			throws FileNotFoundException, IOException {

		System.out.println("Using UnivMobile-(lastimport).app: "
				+ appPathProperty + "...");

		final File appRepo = new File(substringBeforeLast(appPathProperty, "/"));

		if (!appRepo.isDirectory()) {
			throw new FileNotFoundException("Cannot find APP_REPO for: "
					+ appPathProperty);
		}

		final File touched_after_lastimport = new File(appRepo,
				"touched_after_lastimport");

		if (!touched_after_lastimport.exists()) {
			throw new FileNotFoundException(appRepo.getCanonicalPath() + "/"
					+ touched_after_lastimport.getName());
		}

		final long touchedAt = touched_after_lastimport.lastModified();

		final String touchedAtAsString = new DateTime(touchedAt)
				.toString(DateTimeFormat.forPattern("YYYYMMdd-HHmmss"));

		System.out.println(touched_after_lastimport + ".modified: "
				+ touchedAtAsString);

		String mostRecentAppDirName = null;

		// e.g. "UnivMobile-20140712-090711.app"

		for (final File appDir : appRepo.listFiles()) {

			final String appDirName = appDir.getName();

			if (!appDirName.startsWith("UnivMobile-")
					|| !appDirName.endsWith(".app")) {
				continue;
			}

			System.out.println("  appDir.name: " + appDirName);

			final String dirModifiedAtString = appDirName.substring(
					appDirName.length() - 19, appDirName.length() - 4);

			System.out.println("        .modified: " + dirModifiedAtString);

			if (touchedAtAsString.compareTo(dirModifiedAtString) >= 0) {

				if (mostRecentAppDirName == null
						|| mostRecentAppDirName.compareTo(appDirName) < 0) {

					mostRecentAppDirName = appDirName;
				}
			}
		}

		if (mostRecentAppDirName == null) {
			throw new FileNotFoundException(appRepo.getCanonicalPath()
					+ "/UnivMobile-(lastimport).app");
		}

		final String mostRecentAppPath = appRepo.getCanonicalPath() + "/"
				+ mostRecentAppDirName;

		System.out.println("Found most recent: " + mostRecentAppPath);

		final File mostRecentApp = new File(mostRecentAppPath);

		final String HOME = System.getenv("HOME");

		final String appPath = HOME + "/tmp/UnivMobile.app";

		final File appDest = new File(appPath);

		if (appDest.exists()) {

			FileUtils.deleteDirectory(appDest);
		}

		System.out.println("Copying into: " + appPath + "...");

		FileUtils.copyDirectory(mostRecentApp, appDest);

		return appPath;
	}

	@After
	public final void tearDown() throws Exception {

		if (driver != null) {

			driver.quit();

			driver = null;
		}
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

		final JavascriptExecutor javascriptExecutor = (JavascriptExecutor) driver;

		final Map<String, Double> swipe = new HashMap<String, Double>();

		final double durationDouble = durationMs / 1000.0d;

		swipe.put("touchCount", 1d);
		swipe.put("startX", (double) startX);
		swipe.put("startY", (double) startY);
		swipe.put("endX", (double) endX);
		swipe.put("endY", (double) endY);
		swipe.put("duration", durationDouble);

		javascriptExecutor.executeScript("mobile: swipe", swipe);
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
