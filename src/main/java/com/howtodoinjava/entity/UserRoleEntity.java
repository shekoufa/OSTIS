package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Created by yasi on 6/15/15.
 */
@Entity
@Table(name="TBL_USERROLE")
public class UserRoleEntity implements Serializable {
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;

    @Column(name="ROLE")
    private String role;

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="USER_ID")
    private UserEntity user;

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
}
