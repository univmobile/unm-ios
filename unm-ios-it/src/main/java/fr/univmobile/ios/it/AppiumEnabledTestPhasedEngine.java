package fr.univmobile.ios.it;

import static com.google.common.base.Preconditions.checkNotNull;
import io.appium.java_client.AppiumDriver;

import java.io.IOException;
import java.lang.reflect.Method;

import javax.annotation.Nullable;

import org.openqa.selenium.WebElement;

abstract class AppiumEnabledTestPhasedEngine implements AppiumEnabledTestEngine {

	public abstract String getSimpleName();

	@Override
	public final WebElement findElementById(String id) throws IOException {

		throw new IllegalStateException(
				"Because it’s using a phased engine, a scenario test should not call findElementById().");
	}

	@Override
	public final AppiumDriver getDriver() {

		throw new IllegalStateException(
				"Because it’s using a phased engine, a scenario test should not call getDriver().");
	}

	@Nullable
	public final String getPlatformName() {
		
		return platformName;
	}

	public final void setPlatformName(final String platformName) {

		this.platformName = checkNotNull(platformName, "platformName");
	}

	@Nullable
	public final String getPlatformVersion() {
		
		return platformVersion;
	}

	@Nullable
	public final void setPlatformVersion(final String platformVersion) {

		this.platformVersion = checkNotNull(platformVersion, "platformVersion");
	}

	public final String getDeviceName() {
		
		return deviceName;
	}

	public final void setDeviceName(final String deviceName) {

		this.deviceName = checkNotNull(deviceName, "deviceName");
	}

	public final Class<? extends AppiumEnabledTest> getScenariosClass() {
		
		return scenariosClass;
	}

	public final void setScenariosClass(
			final Class<? extends AppiumEnabledTest> scenariosClass) {

		this.scenariosClass = checkNotNull(scenariosClass, "scenariosClass");
	}

	public final Method getScenarioMethod() {
		
		return scenarioMethod;
	}
	
	public final void setScenarioMethod(final Method scenarioMethod) {

		this.scenarioMethod = checkNotNull(scenarioMethod, "scenarioMethod");
	}

	private String platformName; // e.g. "iOS"
	private String platformVersion; // e.g. "7.1"
	private String deviceName; // e.g. "iPhone Retina (4-inch)"
	private Class<? extends AppiumEnabledTest> scenariosClass;
	private Method scenarioMethod;

	protected final String customizeFilename(final String filename) {

		final String normalizedDeviceName = AbstractScenariosTest
				.normalizeDeviceName(deviceName);

		// e.g. "iOS_7.0/iPhoneRetina_4-inch/MyScenario001/scenario4/login.png"

		return platformName + "_" + platformVersion + "/" //
				+ normalizedDeviceName + "/" //
				+ scenariosClass.getSimpleName() + "/" //
				+ scenarioMethod.getName() + "/" //
				+ filename;
	}

	public final String getScenarioId() {

		return scenariosClass.getSimpleName() + "." //
				+ scenarioMethod.getName() + "." //
				+ getSimpleName() + "_" //
				+ AbstractScenariosTest.normalizeDeviceName(deviceName);
	}

	//public abstract void clearErrors();

	abstract boolean hasErrors();
}
