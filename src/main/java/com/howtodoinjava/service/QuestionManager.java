package com.howtodoinjava.service;

import com.howtodoinjava.entity.QuestionEntity;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by Yasaman on 2015-10-21.
 */
public interface QuestionManager {
    @Transactional
    QuestionEntity findPreQuestion();

    public QuestionEntity findNextQuestion();

    @Transactional
    void addQuestion(QuestionEntity questionEntity);

    @Transactional
    List<QuestionEntity> findAllQuestions();

    @Transactional
    void deleteQuestion(Integer questionNo);

    @Transactional
    void adjustCurrQuestion(Integer questionNo);
}
