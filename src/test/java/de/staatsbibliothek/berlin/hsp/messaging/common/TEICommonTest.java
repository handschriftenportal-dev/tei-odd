package de.staatsbibliothek.berlin.hsp.messaging.common;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.xmlunit.matchers.CompareMatcher.isSimilarTo;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.junit.jupiter.api.Test;
import org.xmlunit.builder.Input;
import org.xmlunit.diff.DefaultNodeMatcher;
import org.xmlunit.diff.ElementSelectors;

/**
 * @author Piotr.Czarnecki@sbb.spk-berlin.de
 * @since 24.02.22
 */
class TEICommonTest {

  public static final DefaultNodeMatcher NODE_MATCHER = new DefaultNodeMatcher(ElementSelectors.byNameAndAllAttributes);
  private static Logger logger = Logger.getLogger(TEICommonTest.class.getName());

  public void testTEI2HSP() throws IOException {
    Path generated = Path.of("target/testHSP2TEI/");
    Path original = Path.of("target/testMXML2TEI/");

    compareDirectories(generated, original);
  }

  private void compareDirectories(Path generated, Path original) throws IOException {
    final Path source = generated.toAbsolutePath();
    final Path target = original.toAbsolutePath();
    Files.walkFileTree(source,
        new SimpleFileVisitor<Path>() {
          @Override
          public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
              throws IOException {
            compareXMLFiles(file, target.resolve(source.relativize(file)));
            return FileVisitResult.CONTINUE;
          }
        });
  }

  private void compareXMLFiles(Path generated, Path source) throws IOException {
    String gen = generated.toString();
    String org = source.toString();
    logger.log(Level.INFO, "Comparing gen:'" + gen + "' with the org: '" + org + "'");
    logger.log(Level.INFO, "Comparing gen:'" + gen + "' with the org: '" + org + "'");
    try (ReadableByteChannel sourceChannel = FileChannel.open(source, StandardOpenOption.READ);
        ReadableByteChannel generatedChannel = FileChannel.open(generated, StandardOpenOption.READ)) {
      assertThat("TEI2HSP for: " + gen, Input.from(sourceChannel), isSimilarTo(Input.from(generatedChannel))
        .ignoreWhitespace()
        .normalizeWhitespace()
        .ignoreComments()
        .ignoreElementContentWhitespace()
          .withNodeMatcher(NODE_MATCHER));
    }
  }

}
