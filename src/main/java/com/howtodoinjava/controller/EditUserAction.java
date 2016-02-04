package com.howtodoinjava.controller;

import com.howtodoinjava.entity.UserEntity;
import com.howtodoinjava.service.UserManager;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.logging.Logger;

/**
 * Created by Yasaman on 2015-11-10.
 */
public class EditUserAction extends ActionSupport implements Preparable {
    private static final long serialVersionUID = 1L;

    //Logger configured using log4j
    private static final Logger logger = Logger.getLogger(String.valueOf(EditEmployeeAction.class));

    @Autowired
    private UserManager userManager;

    private UserEntity userEntity;
    private String firstname;
    private String lastname;
    private String username;
    private String password;

    public String registerUser(){
        logger.info("registerUser method called");
        userManager.registerUser( firstname, lastname, username, password);
        return SUCCESS;
    }

    @Override
    public void prepare() throws Exception {
        userEntity = null;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public static Logger getLogger() {
        return logger;
    }

    public UserManager getUserManager() {
        return userManager;
    }

    public void setUserManager(UserManager userManager) {
        this.userManager = userManager;
    }

    public UserEntity getUserEntity() {
        return userEntity;
    }

    public void setUserEntity(UserEntity userEntity) {
        this.userEntity = userEntity;
    }

    public String getfirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
