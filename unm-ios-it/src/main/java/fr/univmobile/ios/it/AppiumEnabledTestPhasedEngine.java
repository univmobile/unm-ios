package fr.univmobile.ios.it;

import static com.google.common.base.Preconditions.checkNotNull;
import io.appium.java_client.AppiumDriver;

import java.io.IOException;
import java.lang.reflect.Method;

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

	public final void setScenariosClass(
			final Class<? extends AppiumEnabledTest> scenariosClass) {

		this.scenariosClass = checkNotNull(scenariosClass, "scenariosClass");
	}

	public final void setScenarioMethod(final Method scenarioMethod) {

		this.scenarioMethod = checkNotNull(scenarioMethod, "scenarioMethod");
	}

	private Method scenarioMethod;

	private Class<? extends AppiumEnabledTest> scenariosClass;

	protected final String customizeFilename(final String filename) {

		return scenariosClass.getSimpleName() + "/" //
				+ scenarioMethod.getName() + "/" + filename;
	}

	public final String getScenarioId() {

		return scenariosClass.getSimpleName() + "+" //
				+ scenarioMethod.getName();
	}
	
	public abstract void clearErrors();
	
	public abstract boolean hasErrors();
}
