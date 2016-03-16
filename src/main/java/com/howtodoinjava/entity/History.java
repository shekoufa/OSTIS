package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Entity(name = "History")
@Table(name = "TBL_HISTORY")
public class History implements Serializable {
     
    @Id
    @Column(name="ID")
    @GeneratedValue
    private Integer id;
     
    @Column(name="QUERY_STR")
    private String queryString;

    @Column(name="DISEASE_TYPE")
    private String diseaseType;

    @Column(name="MIN_YEAR")
    private Integer minYear;

    @Column(name="MAX_YEAR")
    private Integer maxYear;

    @Column(name="MIN_AGE")
    private Integer minAge;

    @Column(name="MAX_AGE")
    private Integer maxAge;

    @Column(name="SEX")
    private String sex;

    @Column(name="HEALTHCARE_UTILIZATION")
    private String healthCareUtilization;

    @Column(name="MORTALITY")
    private String mortality;

    @Column(name="COMORBIDITY")
    private String comorbidity;

    @Column(name="CREATE_DATE")
    private Date createDate;

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="USER_ID")
    private UserEntity user;




    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }

    public String getQueryString() {
        return queryString;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

    public String getDiseaseType() {
        return diseaseType;
    }

    public void setDiseaseType(String diseaseType) {
        this.diseaseType = diseaseType;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getHealthCareUtilization() {
        return healthCareUtilization;
    }

    public void setHealthCareUtilization(String healthCareUtilization) {
        this.healthCareUtilization = healthCareUtilization;
    }

    public String getMortality() {
        return mortality;
    }

    public void setMortality(String mortality) {
        this.mortality = mortality;
    }

    public String getComorbidity() {
        return comorbidity;
    }

    public void setComorbidity(String comorbidity) {
        this.comorbidity = comorbidity;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }

    public Integer getMinYear() {
        return minYear;
    }

    public void setMinYear(Integer minYear) {
        this.minYear = minYear;
    }

    public Integer getMaxYear() {
        return maxYear;
    }

    public void setMaxYear(Integer maxYear) {
        this.maxYear = maxYear;
    }

    public Integer getMinAge() {
        return minAge;
    }

    public void setMinAge(Integer minAge) {
        this.minAge = minAge;
    }

    public Integer getMaxAge() {
        return maxAge;
    }

    public void setMaxAge(Integer maxAge) {
        this.maxAge = maxAge;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}