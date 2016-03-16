package com.howtodoinjava.service;

import com.howtodoinjava.dao.UserDAO;
import com.howtodoinjava.entity.History;
import com.howtodoinjava.entity.UserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by Yasaman on 2015-11-10.
 */
@Service(value = "userManager")
public class UserManagerImpl implements UserManager{
    @Autowired
    UserDAO userDAO;

    public UserDAO getUserDAO() {
        return userDAO;
    }

    public void setUserDAO(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    @Override
    @Transactional
    public void registerUser(String firstName, String lastName, String userName, String password){
        userDAO.registerUser(firstName, lastName, userName, password);}

    @Override
    @Transactional
    public void addToHistory(History history) {
        userDAO.addToHistory(history);
    }

    @Override
    @Transactional
    public UserEntity findUserByUsername(String remoteUser) {
        return userDAO.findUserByUsername(remoteUser);
    }

    @Override
    @Transactional
    public List<History> findHistoryByUserId(Integer userId) {
        return userDAO.findHistoryByUserId(userId);
    }

    @Override
    @Transactional
    public History findHistoryById(Integer historyId) {
        return userDAO.findHistoryById(historyId);
    }
}
