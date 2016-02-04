package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity(name = "Translation")
@Table(name = "TBL_TRANSLATION")
public class Translation implements Serializable {
     
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;
     
    @Column(name="ENWORD")
    private String enWord;
 
    @Column(name="FAWORD")
    private String faWord;

    @Column(name="STATUS")
    private String status;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEnWord() {
        return enWord;
    }

    public void setEnWord(String enWord) {
        this.enWord = enWord;
    }

    public String getFaWord() {
        return faWord;
    }

    public void setFaWord(String faWord) {
        this.faWord = faWord;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}