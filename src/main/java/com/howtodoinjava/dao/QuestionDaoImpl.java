package com.howtodoinjava.dao;

import com.howtodoinjava.entity.Employee;
import com.howtodoinjava.entity.QuestionEntity;
import com.howtodoinjava.entity.UserEntity;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Yasaman on 2015-10-21.
 */
@Repository(value = "questionDAO")
public class QuestionDaoImpl implements QuestionDAO {
    //Session factory injected by spring context
    @Autowired
    private SessionFactory sessionFactory;

    //This method will be called when a employee object is added
    @Override
    public void addQuestion(QuestionEntity questionEntity) {
        this.sessionFactory.getCurrentSession().save(questionEntity);
    }

    //This method return list of employees in database
    @SuppressWarnings("unchecked")
    @Override
    public List<QuestionEntity> findAllQuestions() {
        return this.sessionFactory.getCurrentSession().createCriteria(QuestionEntity.class).list();
    }

    //Deletes a employee by it's id
    @Override
    public void deleteQuestion(Integer questionNo) {
        QuestionEntity question = (QuestionEntity) sessionFactory.getCurrentSession()
                .createCriteria(QuestionEntity.class).add(Restrictions.eq("questionNo",questionNo)).uniqueResult();
        if (null != question) {
            this.sessionFactory.getCurrentSession().delete(question);
        }
    }

    @Override
    public QuestionEntity findNextQuestion() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserEntity currUser = (UserEntity) this.sessionFactory.getCurrentSession().createCriteria(UserEntity.class)
                .add(Restrictions.eq("username",userDetails.getUsername() )).uniqueResult();
        Integer quNo = (Integer) this.sessionFactory.getCurrentSession().createCriteria(QuestionEntity.class)
                .setProjection(Projections.max("questionNo")).uniqueResult();
        if(!(quNo < currUser.getCurrquestion()+1)){
            QuestionEntity nextQuestion = (QuestionEntity) this.sessionFactory.getCurrentSession().createCriteria(QuestionEntity.class)
                    .add(Restrictions.eq("questionNo", (currUser.getCurrquestion()) + 1)).uniqueResult();
            return nextQuestion;
        }else {
            QuestionEntity nextQuestion = (QuestionEntity) this.sessionFactory.getCurrentSession().createCriteria(QuestionEntity.class)
                    .add(Restrictions.eq("questionNo", (currUser.getCurrquestion()) + 1)).uniqueResult();
            return nextQuestion;
        }
    }

    @Override
    public QuestionEntity findPreQuestion() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserEntity currUser = (UserEntity) this.sessionFactory.getCurrentSession().createCriteria(UserEntity.class)
                .add(Restrictions.eq("username", userDetails.getUsername())).uniqueResult();
        if(currUser.getCurrquestion() -1 > 0){
            QuestionEntity preQuestion = (QuestionEntity) this.sessionFactory.getCurrentSession().createCriteria(QuestionEntity.class)
                    .add(Restrictions.eq("questionNo", (currUser.getCurrquestion()) - 1)).uniqueResult();
            return preQuestion;
        }else {
            QuestionEntity preQuestion = (QuestionEntity) this.sessionFactory.getCurrentSession().createCriteria(QuestionEntity.class)
                    .add(Restrictions.eq("questionNo", currUser.getCurrquestion())).uniqueResult();
            return preQuestion;
        }
    }

    @Override
    public void adjustCurrQuestion(Integer questionNo) {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        UserEntity currUser = (UserEntity) this.sessionFactory.getCurrentSession().createCriteria(UserEntity.class)
                .add(Restrictions.eq("username",userDetails.getUsername() )).uniqueResult();
        currUser.setCurrquestion(questionNo);
    }

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }
}
