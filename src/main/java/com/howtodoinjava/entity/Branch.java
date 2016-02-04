package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;

@Entity(name = "Branch")
@Table(name = "TBL_Branch")
public class Branch implements Serializable {
     
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;
     
    @Column(name="NAME")
    private String name;
 

    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}