package fr.univmobile.ios.it;

import static com.google.common.base.Preconditions.checkNotNull;
import static org.junit.Assert.assertFalse;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

@RunWith(Parameterized.class)
public abstract class AbstractScenariosTest {

	protected static Iterable<Object[]> loadParameters(
			final Class<?>... classes) throws Exception {

		final List<Object[]> parameters = new ArrayList<Object[]>();

		loadParameters(parameters, //
				new AppiumEnabledTestCaptureEngine(), classes);

		loadParameters(parameters, //
				new AppiumEnabledTestCheckerEngine(), classes);

		return parameters;
	}

	private static void loadParameters(final Collection<Object[]> parameters,
			final AppiumEnabledTestPhasedEngine engine, //
			final Class<?>... classes) {

		for (final Class<?> clazz : classes) {

			if (!AppiumEnabledTest.class.isAssignableFrom(clazz)) {
				throw new IllegalArgumentException(
						"Scenarios class should extends "
								+ AppiumEnabledTest.class.getSimpleName()
								+ ": " + clazz);
			}

			final Annotation scenariosAnnotation = clazz
					.getAnnotation(Scenarios.class);

			if (scenariosAnnotation == null) {
				throw new IllegalArgumentException(
						"Scenarios class should be annotated with @"
								+ Scenarios.class.getSimpleName() + ": "
								+ clazz);
			}

			final String classSimpleName = clazz.getSimpleName();

			for (final Method method : clazz.getMethods()) {

				final Annotation scenarioAnnotation = method
						.getAnnotation(Scenario.class);

				if (scenarioAnnotation == null) {
					continue;
				}

				final String methodName = method.getName();

				parameters.add(new Object[] { classSimpleName, //
						methodName, //
						engine.getSimpleName(), //
						clazz.asSubclass(AppiumEnabledTest.class), //
						method, //
						engine });
			}
		}
	}

	protected AbstractScenariosTest(final String scenarioClassSimpleName, //
			final String scenarioMethodName, //
			final String engineSimpleName, //
			final Class<? extends AppiumEnabledTest> scenariosClass, //
			final Method scenarioMethod, //
			final AppiumEnabledTestPhasedEngine engine) {

		this.scenariosClass = checkNotNull(scenariosClass, "scenariosClass");
		this.scenarioMethod = checkNotNull(scenarioMethod, "scenarioMethod");
		this.engine = checkNotNull(engine, "engine");
	}

	private final Class<? extends AppiumEnabledTest> scenariosClass;
	private final Method scenarioMethod;
	private final AppiumEnabledTestPhasedEngine engine;

	@Test
	public void run() throws Exception {

		// 0. OBJECT INSTANCE

		final AppiumEnabledTest instance = scenariosClass.newInstance();

		engine.setScenariosClass(scenariosClass);
		engine.setScenarioMethod(scenarioMethod);

		instance.setEngine(engine);

		// 1. SETUP

		engine.clearErrors();
		
		instance.setUp();

		try {

			scenarioMethod.invoke(instance);

			assertFalse("There were errors.", engine.hasErrors());

		} finally {

			// 9. TEARDOWN

			instance.tearDown();
		}
	}
}
