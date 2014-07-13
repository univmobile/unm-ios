package fr.univmobile.ios.it;

import java.lang.reflect.Method;

import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

@RunWith(Parameterized.class)
public class AllScenariosTest extends AbstractScenariosTest {

	@Parameters(name = "{0}.{1}.{2}")
	public static Iterable<Object[]> parameters() throws Exception {

		return AbstractScenariosTest
				.loadParameters(UnivMobileScenarios001.class);
	}

	public AllScenariosTest(final String scenarioClassSimpleName, //
			final String scenarioMethodName, //
			final String engineSimpleName, //
			final Class<? extends AppiumEnabledTest> scenariosClass, //
			final Method scenarioMethod, //
			final AppiumEnabledTestPhasedEngine engine) {

		super(scenarioClassSimpleName, scenarioMethodName, engineSimpleName, //
				scenariosClass, scenarioMethod, engine);
	}
}
