package fr.univmobile.ios.it;

import static com.google.common.base.Preconditions.checkNotNull;
import io.appium.java_client.AppiumDriver;

import java.io.IOException;

import javax.annotation.Nullable;

import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.WebElement;

public abstract class AppiumEnabledTest implements
		AppiumEnabledTestEngine {

	@Override
	public AppiumDriver getDriver() {

		return checkedEngine().getDriver();
	}

	private AppiumEnabledTestEngine checkedEngine() {

		if (engine == null) {
			throw new IllegalStateException("engine == null");
		}

		return engine;
	}

	@Nullable
	private AppiumEnabledTestEngine engine;

	final void setEngine(final AppiumEnabledTestEngine engine) {

		this.engine = checkNotNull(engine, "engine");
	}

	@Before
	@Override
	public final void setUp() throws Exception {

		if (engine == null) {

			engine = new AppiumEnabledTestDefaultEngine();
		}

		checkedEngine().setUp();
	}

	@After
	@Override
	public final void tearDown() throws Exception {

		checkedEngine().tearDown();
	}

	@Override
	public final void takeScreenshot(final String filename) throws IOException {

		checkedEngine().takeScreenshot(filename);
	}

	@Override
	public final void swipe(final int startX, final int startY, final int endX,
			final int endY, final int durationMs) throws IOException {

		checkedEngine().swipe(startX, startY, endX, endY, durationMs);
	}

	@Override
	public final void savePageSource(final String filename) throws IOException {

		checkedEngine().savePageSource(filename);
	}

	@Override
	public final WebElement findElementById(final String id) throws IOException {

		return checkedEngine().findElementById(id);
	}

	@Override
	public final ElementChecker elementById(final String id) throws IOException {

		return checkedEngine().elementById(id);
	}
}
