package com.howtodoinjava.service;

import com.howtodoinjava.dao.QuestionDAO;
import com.howtodoinjava.entity.QuestionEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by Yasaman on 2015-10-21.
 */
@Service(value = "questionManager")
public class QuestionManagerImpl implements QuestionManager{

    @Autowired
    private QuestionDAO questionDAO;

    public QuestionDAO getQuestionDAO() {
        return questionDAO;
    }

    public void setQuestionDAO(QuestionDAO questionDAO) {
        this.questionDAO = questionDAO;
    }

    @Override
    @Transactional
    public QuestionEntity findPreQuestion()  {
        return questionDAO.findPreQuestion();
    }

    @Override
    @Transactional
    public QuestionEntity findNextQuestion()  {
        return questionDAO.findNextQuestion();
    }

    @Override
    @Transactional
    public void addQuestion(QuestionEntity questionEntity)  {
        questionDAO.addQuestion(questionEntity);
    }

    @Override
    @Transactional
    public List<QuestionEntity> findAllQuestions()  {
        return questionDAO.findAllQuestions();
    }

    @Override
    @Transactional
    public void deleteQuestion(Integer questionNo)  {
        questionDAO.deleteQuestion(questionNo);
    }

    @Override
    @Transactional
    public void adjustCurrQuestion(Integer questionNo)  {
        questionDAO.adjustCurrQuestion(questionNo);
    }


}
