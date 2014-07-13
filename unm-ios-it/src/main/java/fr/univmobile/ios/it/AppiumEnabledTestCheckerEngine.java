package fr.univmobile.ios.it;

import static com.google.common.base.Preconditions.checkNotNull;
import static org.apache.commons.lang3.CharEncoding.UTF_8;
import static org.apache.commons.lang3.StringUtils.isBlank;
import static org.apache.commons.lang3.StringUtils.substringAfter;
import static org.apache.commons.lang3.StringUtils.substringBetween;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;

import org.apache.commons.io.FileUtils;

public class AppiumEnabledTestCheckerEngine extends
		AppiumEnabledTestPhasedEngine implements ElementCheckObserver {

	@Override
	public void setUp() throws Exception {

		final File file = new File("target/screenshots",
				customizeFilename("capture.log"));

		lines = FileUtils.readLines(file, UTF_8).iterator();

		clearErrors();
	}

	@Nullable
	private Iterator<String> lines;

	@Override
	public void tearDown() throws Exception {

		// assertFalse("There were errors.", hasErrors());
	}

	@Override
	public void takeScreenshot(final String filename) throws IOException {

		// do nothing: Rely on previous capture
	}

	@Override
	public void savePageSource(final String filename) throws IOException {

		// do nothing: Rely on previous capture
	}

	@Override
	public final void pause(final int ms) throws InterruptedException {

		// do nothing
	}

	@Override
	public final void futureScreenshot(final int ms, final String filename)
			throws IOException {

		// do nothing: Rely on previous capture
	}

	@Override
	public void swipe(final int startX, final int startY, final int endX,
			final int endY, final int durationMs) throws IOException {

		// do nothing: Rely on previous capture
	}

	@Override
	public ElementChecker elementById(final String id) throws IOException {

		final String lineId;

		while (lines.hasNext()) {

			final String line = lines.next();

			if (isBlank(line) || line.startsWith("#")) {
				continue;
			}

			lineId = line.substring(0, line.length() - 1);

			if (!lineId.equals(id)) {
				throw new IOException("Expected id: <" + id + ">, but was: <"
						+ lineId + ">");
			}

			break;
		}

		final ElementCheckerWithAttributes element = new ElementCheckerWithAttributes(
				this, id);

		while (lines.hasNext()) {

			final String line = lines.next();

			if (isBlank(line) || line.startsWith("#") || !line.startsWith("  ")) {
				break;
			}

			final String attributeName = substringBetween(line, "  ", ":");

			final String attributeValue = substringAfter(line, ": ");

			element.addAttribute(attributeName, attributeValue);
		}

		return element;
	}

	@Override
	public String getSimpleName() {

		return "checker";
	}

	@Override
	public void notifyCheck(final String label, final boolean condition,
			final String message) {

		if (condition) {

			System.out.println(label + ": OK");

		} else {

			System.err.println("** ERROR: " + label + " (" + message + ")");

			errors.add(label);
		}
	}

	private final List<String> errors = new ArrayList<String>();

	@Override
	public void clearErrors() {

		errors.clear();
	}

	@Override
	public boolean hasErrors() {

		return !errors.isEmpty();
	}
}

class ElementCheckerWithAttributes implements ElementChecker {

	public ElementCheckerWithAttributes(final ElementCheckObserver observer,
			final String id) {

		this.observer = checkNotNull(observer, "observer");
		this.id = checkNotNull(id, "id");
	}

	private final ElementCheckObserver observer;
	private final String id;

	public void addAttribute(final String name, final String value) {

		attributes.put(name, value);
	}

	private final Map<String, String> attributes = new HashMap<String, String>();

	@Override
	public void textShouldBe(final String ref) throws IOException {

		final String text = attributes.get("text");

		observer.notifyCheck(id + ".textShouldBe: " + ref, ref.equals(text),
				"expected: <" + ref + ">, but was: <" + text + ">");
	}

	@Override
	public void shouldBeVisible() throws IOException {

		observer.notifyCheck(id + ".shouldBeVisible",
				"true".equals(attributes.get("visible")), "Element is hidden.");
	}

	@Override
	public void shouldBeHidden() throws IOException {

		observer.notifyCheck(id + ".shouldBeHidden",
				!"true".equals(attributes.get("visible")),
				"Element is visible.");
	}
}

interface ElementCheckObserver {

	void notifyCheck(String label, boolean condition, String message);
}