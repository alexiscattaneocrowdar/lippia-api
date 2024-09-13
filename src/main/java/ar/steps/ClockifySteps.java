package ar.steps;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.lippia.api.lowcode.Engine;
import io.lippia.api.lowcode.steps.StepsInCommon;
import io.lippia.api.service.CommonService;

import java.io.UnsupportedEncodingException;
import java.time.Instant;

public class ClockifySteps {

    Engine engine = new Engine();
    CommonService commonService = new CommonService();

    ThreadLocal<String> uniqueProjectName = new ThreadLocal<>();

    @And("^set unique value of key (\\S+) in body (\\S+)$")
    public void set(String key, String in) {
        uniqueProjectName.set(generateUniqueName());
        this.engine.set(uniqueProjectName.get(), key, in);
    }

    @Then("^response ([^\\s].+) should be the unique value$")
    public void response(String path) throws UnsupportedEncodingException {
        this.engine.responseMatcher(path, uniqueProjectName.get());
    }

    public static String generateUniqueName() {
        return "Project-" + Instant.now().toEpochMilli();
    }
}
