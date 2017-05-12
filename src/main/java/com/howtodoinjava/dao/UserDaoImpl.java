package com.howtodoinjava.dao;

import com.howtodoinjava.entity.*;
import org.hibernate.Hibernate;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
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

    @Override
    public void addToHistory(History history) {
        this.sessionFactory.getCurrentSession().save(history);
    }

    @Override
    public UserEntity findUserByUsername(String remoteUser) {
        UserEntity theUser = (UserEntity) this.sessionFactory.getCurrentSession().createCriteria(UserEntity.class)
                .add(Restrictions.eq("username", remoteUser)).uniqueResult();
        Hibernate.initialize(theUser.getUserroles());
//        Hibernate.initialize(theUser.getHistoryList());
        return theUser;

    }

    @Override
    public List<History> findHistoryByUserId(Integer userId) {
        List<History> results = new ArrayList<History>();
        results = this.sessionFactory.getCurrentSession().createCriteria(History.class).createAlias("user","u").add(Restrictions.eq("u.id",userId)).addOrder(Order.asc("createDate")).list();
        return results;
    }

    @Override
    public History findHistoryById(Integer historyId) {
        History theHistory = (History) this.sessionFactory.getCurrentSession().createCriteria(History.class).createAlias("user","u").add(Restrictions.eq("id", historyId)).uniqueResult();
        Hibernate.initialize(theHistory);
        Hibernate.initialize(theHistory.getUser());
//        Hibernate.initialize(theHistory.getUser().getHistoryList());
        return theHistory;
    }

    @Override
    public void update(UserEntity user) {
        this.sessionFactory.getCurrentSession().update(user);
    }

    @Override
    public void update(Settings settings) {
        this.sessionFactory.getCurrentSession().update(settings);
    }

    @Override
    public List<PostalCodeLookup> selectAllPostalCodeMappings() {
        List<PostalCodeLookup> results = this.sessionFactory.getCurrentSession().createCriteria(PostalCodeLookup.class).list();
        return results;
    }

}
