package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

/**
 * Created by Yasaman on 2015-10-21.
 */
@Entity
@Table(name = "TBL_QUESTION")
public class QuestionEntity implements Serializable {
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;

    @Column(name="QUESTIONNO", unique = true)
    private Integer questionNo;

    @Column(name="QUESTION")
    private String question;

    @Column(name="ALTERNATIVE1")
    private String alternative1;

    @Column(name="ALTERNATIVE2")
    private String alternative2;

    @Column(name="ALTERNATIVE3")
    private String alternative3;

    @Column(name="ALTERNATIVE4")
    private String alternative4;

    @Column(name="RIGHTANSWER")
    private String rightAnswer;

    @Column(name="DESCRIPTION")
    private String description;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAlternative1() {
        return alternative1;
    }

    public void setAlternative1(String alternative1) {
        this.alternative1 = alternative1;
    }

    public String getAlternative2() {
        return alternative2;
    }

    public void setAlternative2(String alternative2) {
        this.alternative2 = alternative2;
    }

    public String getAlternative3() {
        return alternative3;
    }

    public void setAlternative3(String alternative3) {
        this.alternative3 = alternative3;
    }

    public String getAlternative4() {
        return alternative4;
    }

    public void setAlternative4(String alternative4) {
        this.alternative4 = alternative4;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRightAnswer() {
        return rightAnswer;
    }

    public void setRightAnswer(String rightAnswer) {
        this.rightAnswer = rightAnswer;
    }

    public Integer getQuestionNo() {
        return questionNo;
    }

    public void setQuestionNo(Integer questionNo) {
        this.questionNo = questionNo;
    }
}
