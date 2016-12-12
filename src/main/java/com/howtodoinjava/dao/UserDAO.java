package com.howtodoinjava.dao;

import com.howtodoinjava.entity.History;
import com.howtodoinjava.entity.Settings;
import com.howtodoinjava.entity.UserEntity;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * Created by Yasaman on 2015-11-10.
 */

public interface UserDAO {


    //This method will be called when a employee object is added
    void registerUser(String firstName, String lastName, String userName, String password);
    void addToHistory(History history);

    UserEntity findUserByUsername(String remoteUser);

    List<History> findHistoryByUserId(Integer userId);

    History findHistoryById(Integer historyId);
    void update(UserEntity user);
    void update(Settings settings);
}
