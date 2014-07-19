package fr.univmobile.ios.it;

import java.lang.reflect.Method;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import fr.univmobile.it.commons.AbstractScenariosTest;
import fr.univmobile.it.commons.AppiumEnabledTest;
import fr.univmobile.it.commons.AppiumEnabledTestPhasedEngine;

@RunWith(Parameterized.class)
public class AllScenariosTest extends AbstractScenariosTest {

	@Parameters(name = "{1}.{2}.{3}_{0}")
	public static Iterable<Object[]> parameters() throws Exception {

		return AbstractScenariosTest.loadParametersForScenarioClasses( //
				Scenarios001.class);
	}

	public AllScenariosTest(final String normalizedDeviceName, //
			final String scenarioClassSimpleName, //
			final String scenarioMethodName, //
			final String engineSimpleName, //
			final String deviceName, //
			final Class<? extends AppiumEnabledTest> scenariosClass, //
			final Method scenarioMethod, //
			final AppiumEnabledTestPhasedEngine engine) {

		super(normalizedDeviceName, //
				scenarioClassSimpleName, //
				scenarioMethodName, //
				engineSimpleName, //
				deviceName, //
				scenariosClass, //
				scenarioMethod, //
				engine);
	}
}
