package com.howtodoinjava.service;

import com.howtodoinjava.entity.UserEntity;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by Yasaman on 2015-11-10.
 */
public interface UserManager {
    @Transactional
    void registerUser(String firstName, String lastName, String userName, String password);
}
