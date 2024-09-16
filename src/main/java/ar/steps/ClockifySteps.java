package ar.steps;

import com.crowdar.api.rest.APIManager;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Then;
import io.lippia.api.lowcode.Engine;
import io.lippia.api.lowcode.steps.StepsInCommon;
import io.lippia.api.service.CommonService;
import org.testng.asserts.SoftAssert;

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

    @And("^the response should contain projects with \"(.*)\" in the name$")
    public void containName(String name) {
        StepsInCommon stepsInCommon = new StepsInCommon();
        JsonArray jsonArray = JsonParser.parseString((String) APIManager.getLastResponse().getResponse()).getAsJsonArray();
        for(int i = 0; i<jsonArray.size(); i++){
            stepsInCommon.response("$[" + i + "].name","contains",name);
        }
    }

    //And the response should only contain projects named "Software Development"
    //And the response should contain only archived projects
    //And the response should contain projects with at least one of the specified client IDs
    //And the response should contain projects with at least one of the specified user IDs
    //And the response should contain projects with active clients
    //And the response should contain projects sorted by name in ascending order
    //And the response should contain a maximum of 50 projects on the first page
    //And the response should contain only public projects
}
