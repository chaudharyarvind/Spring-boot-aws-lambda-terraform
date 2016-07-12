package com.dius;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.dius.repository.NotificationRepository;
import com.dius.repository.entity.Notification;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

import java.io.IOException;

@SpringBootApplication
public class PostHandler implements RequestHandler<Object, Object> {

    @Autowired
    private NotificationRepository notificationRepository;

    @Setter
    private Object input;

    @Setter
    private Context context;

    @Override
    public Object handleRequest(Object input, Context context) {
        final String[] args = new String[0];
        try (ConfigurableApplicationContext configurableApplicationContext = SpringApplication.run(Application.class, args)) {
            PostHandler app = configurableApplicationContext.getBean(PostHandler.class);
            app.setContext(context);
            app.setInput(input);
            app.run(args);
            return "Notification got successfully created.";
        } catch (Exception ex) {
            context.getLogger().log("Error " + ex.getMessage());
            return "Error happened while creating the notification";
        }
    }

    private void run(String... strings) throws IOException {

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_FIELD_NAMES, true);

        Gson gson = new Gson();
        final String inputJson = gson.toJson(input);

        Notification notification = objectMapper.readValue(inputJson, Notification.class);

        notificationRepository.save(notification);


    }
}
