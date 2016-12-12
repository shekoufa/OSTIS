package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity(name = "Settings")
@Table(name = "TBL_SETTINGS")
public class Settings implements Serializable {
     
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;
     
    @Column(name="PREVELANCE_COLOR")
    private String prevalenceColor;

    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public String getPrevalenceColor() {
        return prevalenceColor;
    }

    public void setPrevalenceColor(String prevalenceColor) {
        this.prevalenceColor = prevalenceColor;
    }

}