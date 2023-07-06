package feature;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Test;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import java.io.File;
import java.util.*;
import org.apache.commons.io.FileUtils;

public class KarateTestParallel {
    private static Results results;
    private final int THREAD_COUNT = 1;

    @AfterAll
    public static void tearDown() {
        assertTrue(results.getFailCount() == 0);
    }

    @Test
    void KarateTestParallel() {
        results = Runner.path("classpath:feature").tags("~@ignore").outputCucumberJson(true).parallel(THREAD_COUNT);
        generateReport(results.getReportDir());
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "Test Automation Results");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }
}