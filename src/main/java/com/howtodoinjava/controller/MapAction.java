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
    private Integer minYear=1900;
    private Integer maxYear=2200;
    private Integer minAge=10;
    private Integer maxAge=100;
    private String healthcare="*";
    private String mortality="*";
    private String sex="*";
    private String comorbidity="*";
    private String disease="*";
    private Integer maximumCount = 0;
    private Integer minimumCount = 0;
    private Integer distance = 0;
    private String response;
//    @Autowired
//    private QuestionManager questionManager;

    public String showMap(){
        logger.info("Showing main page with map and stuffs");
//        questionEntity = questionManager.findNextQuestion();
        return SUCCESS;
    }
    public String sendRequest() throws SolrServerException {
        String[] colorsGradient = new String[6];
        String[] colorsDescription = new String[6];
        colorsGradient[0]="FF0000";
        colorsGradient[1]="FF6A00";
        colorsGradient[2]="FFD400";
        colorsGradient[3]="BFFF00";
        colorsGradient[4]="55FF00";
        colorsGradient[5]="00FF15";
        System.out.println("********---------********");
        System.out.println("Before running the query: "+new Timestamp(System.currentTimeMillis()));
        HttpSolrServer solr = new HttpSolrServer("http://localhost:8983/solr/ostis");
        SolrQuery query = new SolrQuery();
        if(comorbidity.length()==0){
            comorbidity="*";
        }else {
            comorbidity = comorbidity.replaceAll(",", " OR ");
        }
        if(disease.length()==0){
            disease="*";
        }else {
            disease = disease.replaceAll(",", " OR ");
        }
        if(minAge==null){
            minAge=10;
        }
        if(maxAge==null){
            maxAge=200;
        }
        if(minYear==null){
            minYear=1000;
        }
        if(maxYear==null){
            maxYear=4000;
        }
        query.set("q","complications:("+comorbidity+") AND disease_type:("+disease+") AND age:["+minAge+" TO "+maxAge+"] " +
                "AND year:["+minYear+" TO "+maxYear+"] AND sex:"+sex+" AND healthcare:"+healthcare+" AND mortality:"+mortality);
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
        if(facetEntries.size()>=3) {
            long highestCount = facetEntries.get(1).getCount();
            long lowestCount = facetEntries.get(facetEntries.size() - 1).getCount();
            Double distanceDouble = Math.ceil((highestCount - lowestCount+1) / 6);
            int distance = distanceDouble.intValue();
            int cntDesc = 0;
            for(long i = highestCount; i>=lowestCount; i = i - distance){
                if(cntDesc==5){
                    colorsDescription[cntDesc] = "Below "+(i);
                    break;
                }else {
                    colorsDescription[cntDesc] = "From "+i+" to "+(i-distance);
                }
                cntDesc++;
            }

            if (ff.getValues() != null) {
                total = 0l;
                int rank = 1;
                for (FacetField.Count fcount : facetEntries) {
                    JSONObject attr = new JSONObject();
                    if (fcount.getName().toLowerCase().startsWith("a")) {
                        if (fcount.getCount() >= (highestCount-distance)) {
                            attr.put("value", fcount.getName().toUpperCase());
                            attr.put("count", fcount.getCount());
                            attr.put("rank", rank);
                            attr.put("color", colorsGradient[rank-1]);
                            attr.put("description", colorsDescription[rank-1]);
                        }else{
                            highestCount = highestCount - distance;
                            rank++;
                            if(rank>6)rank=6;
                            attr.put("value", fcount.getName().toUpperCase());
                            attr.put("count", fcount.getCount());
                            attr.put("rank", rank);
                            attr.put("color", colorsGradient[rank-1]);
                            attr.put("description", colorsDescription[rank-1]);
                        }
                        total += fcount.getCount();
                        facetfield.put(attr);
                    }
                }
            }
            facetfieldStr = facetfield.toString();
        }
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

    public String getComorbidity() {
        return comorbidity;
    }

    public void setComorbidity(String comorbidity) {
        this.comorbidity = comorbidity;
    }

    public String getDisease() {
        return disease;
    }

    public void setDisease(String disease) {
        this.disease = disease;
    }

    public String getHealthcare() {
        return healthcare;
    }

    public void setHealthcare(String healthcare) {
        this.healthcare = healthcare;
    }

    public String getMortality() {
        return mortality;
    }

    public void setMortality(String mortality) {
        this.mortality = mortality;
    }

    public Integer getMaximumCount() {
        return maximumCount;
    }

    public void setMaximumCount(Integer maximumCount) {
        this.maximumCount = maximumCount;
    }

    public Integer getMinimumCount() {
        return minimumCount;
    }

    public void setMinimumCount(Integer minimumCount) {
        this.minimumCount = minimumCount;
    }

    public Integer getDistance() {
        return distance;
    }

    public void setDistance(Integer distance) {
        this.distance = distance;
    }
}
