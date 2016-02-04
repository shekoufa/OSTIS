package com.howtodoinjava.dao;

import com.howtodoinjava.entity.QuestionEntity;

import java.util.List;

/**
 * Created by Yasaman on 2015-10-21.
 */
public interface QuestionDAO {

    //This method will be called when a employee object is added
    void addQuestion(QuestionEntity questionEntity);

    //This method return list of employees in database
    @SuppressWarnings("unchecked")
    List<QuestionEntity> findAllQuestions();

    //Deletes a employee by it's id
    void deleteQuestion(Integer questionNo);

    QuestionEntity findNextQuestion();

    QuestionEntity findPreQuestion();

    void adjustCurrQuestion(Integer questionNo);
}
