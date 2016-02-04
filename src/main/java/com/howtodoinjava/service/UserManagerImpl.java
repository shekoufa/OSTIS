package com.howtodoinjava.service;

import com.howtodoinjava.dao.UserDAO;
import com.howtodoinjava.entity.UserEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
}
