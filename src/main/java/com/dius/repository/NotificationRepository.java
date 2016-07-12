package com.dius.repository;

import com.dius.repository.entity.Notification;
import org.socialsignin.spring.data.dynamodb.repository.EnableScan;
import org.springframework.data.repository.CrudRepository;

import java.util.Set;

/**
 * Created by arvind on 11/07/16.
 */
@EnableScan
public interface NotificationRepository extends CrudRepository<Notification, String> {

    Set<Notification> findByTitle(String title);
}
