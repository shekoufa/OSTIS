package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;
import java.util.Set;

@Entity(name = "User")
@Table(name = "TBL_USER")
public class UserEntity implements Serializable {
     
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;
     
    @Column(name="FIRSTNAME")
    private String firstname;
 
    @Column(name="LASTNAME")
    private String lastname;

    @Column(name="USERNAME", unique = true)
    private String username;

    @Column(name="PASSWORD")
    private String password;

    @Column(name="EMAIL")
    private String email;

    @Column(name="CURRQUESTION")
    private Integer currquestion;

    @Column(name="ENABLED")
    private Boolean enabled;

    @OneToMany(mappedBy="user")
    private List<UserRoleEntity> userroles;
     
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getFirstname() {
        return firstname;
    }
    public String getLastname() {
        return lastname;
    }
    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }
    public void setLastname(String lastname) {
        this.lastname = lastname;
    }
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

     public List<UserRoleEntity> getUserroles() {
        return userroles;
    }

    public void setUserroles(List<UserRoleEntity> userroles) {
        this.userroles = userroles;
    }

    public Integer getCurrquestion() {
        return currquestion;
    }

    public void setCurrquestion(Integer currquestion) {
        this.currquestion = currquestion;
    }
}