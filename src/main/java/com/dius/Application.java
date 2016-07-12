package com.dius;

import com.dius.repository.NotificationRepository;
import com.dius.repository.entity.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class Application {

    @Autowired
    private NotificationRepository notificationRepository;

    public static void main(String[] args) {
        try (ConfigurableApplicationContext configurableApplicationContext = SpringApplication.run(Application.class, args)) {
            Application app = configurableApplicationContext.getBean(Application.class);
            app.run(args);
        }
    }

    private void run(String[] args) {
        System.out.println("Started application");

        notificationRepository.save(Notification.builder().title("First Notification").text("Hurray! Got the first notification using lambda.").build());

        notificationRepository.findByTitle("First Notification").forEach(notification -> System.out.println(notification.toString()));
    }
}
