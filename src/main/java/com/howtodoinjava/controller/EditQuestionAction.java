package com.howtodoinjava.controller;

import com.howtodoinjava.entity.QuestionEntity;
import com.howtodoinjava.service.QuestionManager;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;
import org.omg.CORBA.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.Object;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by Yasaman on 2015-10-21.
 */
public class EditQuestionAction extends ActionSupport implements Preparable {
    private QuestionEntity questionEntity;
    private List<QuestionEntity> questions;
    private Integer questionNo;
    private Integer questionsArr[] ;

    @Override
    public void prepare() throws Exception {
        questionEntity = null;
    }

    private static final long serialVersionUID = 1L;

    //Logger configured using log4j
    private static final Logger logger = Logger.getLogger(String.valueOf(EditEmployeeAction.class));

    @Autowired
    private QuestionManager questionManager;

    public String findNextQuestion(){
        logger.info("findNextQuestion method called");
//        questionEntity = questionManager.findNextQuestion();
        return SUCCESS;
    }

    public String findPreQuestion(){
        logger.info("findPreQuestion method called");
        questionEntity = questionManager.findPreQuestion();
        return SUCCESS;
    }

    public String addQuestion(){
        logger.info("addQuestion method called");
        questionManager.addQuestion(questionEntity);
        return SUCCESS;
    }

    public String deleteQuestion(){
        logger.info("deleteQuestion method called");
        for (Integer questionArr : questionsArr) {
            questionManager.deleteQuestion(questionArr);
        }
        return SUCCESS;
    }

    public String findAllQuestions(){
        logger.info("findAllQuestions method called");
        questions = questionManager.findAllQuestions();
        return SUCCESS;
    }

    public String adjustCurrQuestion(){
        logger.info("adjustCurrQuestion method called");
        questionManager.adjustCurrQuestion(questionNo);
        return SUCCESS;
    }

    public QuestionEntity getQuestionEntity() {
        return questionEntity;
    }

    public void setQuestionEntity(QuestionEntity questionEntity) {
        this.questionEntity = questionEntity;
    }

    public List<QuestionEntity> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuestionEntity> questions) {
        this.questions = questions;
    }

    public Integer getQuestionNo() {
        return questionNo;
    }

    public void setQuestionNo(Integer questionNo) {
        this.questionNo = questionNo;
    }

    public Integer[] getQuestionsArr() {
        return questionsArr;
    }

    public void setQuestionsArr(Integer[] questionsArr) {
        this.questionsArr = questionsArr;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public static Logger getLogger() {
        return logger;
    }

    public QuestionManager getQuestionManager() {
        return questionManager;
    }

    public void setQuestionManager(QuestionManager questionManager) {
        this.questionManager = questionManager;
    }
}
