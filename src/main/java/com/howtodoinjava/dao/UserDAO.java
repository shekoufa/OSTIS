package com.howtodoinjava.dao;

import com.howtodoinjava.entity.UserEntity;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by Yasaman on 2015-11-10.
 */

public interface UserDAO {


    //This method will be called when a employee object is added
    void registerUser(String firstName, String lastName, String userName, String password);
}
