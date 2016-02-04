package com.howtodoinjava.dao;

import com.howtodoinjava.entity.UserEntity;
import com.howtodoinjava.entity.UserRoleEntity;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Yasaman on 2015-11-10.
 */
@Repository(value = "userDao")
public class UserDaoImpl implements UserDAO {
    //Session factory injected by spring context
    @Autowired
    private SessionFactory sessionFactory;

    //This method will be called when a employee object is added
    @Override
    public void registerUser(String firstName, String lastName, String userName, String password) {
        UserEntity userEntity = new UserEntity();
        userEntity.setUsername(userName);
        userEntity.setPassword(password);
        userEntity.setFirstname(firstName);
        userEntity.setLastname(userName);
        userEntity.setCurrquestion(0);
        userEntity.setEnabled(true);
        this.sessionFactory.getCurrentSession().save(userEntity);
        UserRoleEntity userRoleEntity = new UserRoleEntity();
        userRoleEntity.setRole("rrr");
        userRoleEntity.setUser(userEntity);
        this.sessionFactory.getCurrentSession().save(userRoleEntity);
        System.out.println("URE ID: "+userRoleEntity.getId());
    }

}
