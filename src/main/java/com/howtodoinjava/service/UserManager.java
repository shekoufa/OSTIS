package com.howtodoinjava.service;

import com.howtodoinjava.entity.History;
import com.howtodoinjava.entity.UserEntity;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by Yasaman on 2015-11-10.
 */
public interface UserManager {
    @Transactional
    void registerUser(String firstName, String lastName, String userName, String password);
    @Transactional
    void addToHistory(History history);
    @Transactional
    UserEntity findUserByUsername(String remoteUser);
    @Transactional
    List<History> findHistoryByUserId(Integer userId);
    @Transactional
    History findHistoryById(Integer historyId);
}
