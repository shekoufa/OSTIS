package com.howtodoinjava.controller;

import com.howtodoinjava.entity.QuestionEntity;
import com.howtodoinjava.service.QuestionManager;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocumentList;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by Yasaman on 2015-10-21.
 */
public class MapAction extends ActionSupport implements Preparable {

    private String facetfieldStr;
    private Long total;

    @Override
    public void prepare() throws Exception {
    }

    private static final long serialVersionUID = 1L;

    //Logger configured using log4j
    private static final Logger logger = Logger.getLogger(String.valueOf(EditEmployeeAction.class));
    private Integer minYear;
    private Integer maxYear;
    private Integer minAge;
    private Integer maxAge;
    private String sex;
    private String response;
//    @Autowired
//    private QuestionManager questionManager;

    public String showMap(){
        logger.info("Showing main page with map and stuffs");
//        questionEntity = questionManager.findNextQuestion();
        return SUCCESS;
    }
    public String sendRequest() throws SolrServerException {
        System.out.println("********---------********");
        System.out.println("Before running the query: "+new Timestamp(System.currentTimeMillis()));
        HttpSolrServer solr = new HttpSolrServer("http://localhost:8983/solr/ostis");
        SolrQuery query = new SolrQuery();
//        query.setFQuery("age:["+minAge+" TO "+maxAge+"] year:["+minYear+" TO "+maxYear+"] sex:"+sex);
        query.set("q","age:["+minAge+" TO "+maxAge+"] AND year:["+minYear+" TO "+maxYear+"] AND sex:"+sex);
        query.setFacet(true);
        query.addFacetField("postal_code_5");
        query.setFacetLimit(-1);
        query.setFacetMinCount(1);
        query.setFacetSort("count");
        query.setStart(0);
        query.set("defType", "edismax");


        QueryResponse response = solr.query(query);
        FacetField ff = response.getFacetField("postal_code_5");
        JSONArray facetfield = new JSONArray();

        System.out.println("After running the query: "+new Timestamp(System.currentTimeMillis()));

        List<FacetField.Count> facetEntries = ff.getValues();
        if (ff.getValues() != null) {
            total = 0l;
            for (FacetField.Count fcount : facetEntries) {
                JSONObject attr = new JSONObject();
                if(fcount.getName().toLowerCase().startsWith("a")) {
                    attr.put("value", fcount.getName().toUpperCase());
                    attr.put("count", fcount.getCount());
                    total+=fcount.getCount();
                    facetfield.put(attr);
                }
            }
        }
        facetfieldStr = facetfield.toString();
        System.out.println("After preparing the json: "+new Timestamp(System.currentTimeMillis()));
        System.out.println();
        return SUCCESS;
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

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public String getFacetfieldStr() {
        return facetfieldStr;
    }

    public void setFacetfieldStr(String facetfieldStr) {
        this.facetfieldStr = facetfieldStr;
    }

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }
}