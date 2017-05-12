package com.howtodoinjava.controller;

import com.howtodoinjava.entity.*;
import com.howtodoinjava.service.UserManager;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.Preparable;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.FacetField;
import org.apache.solr.client.solrj.response.FieldStatsInfo;
import org.apache.solr.client.solrj.response.PivotField;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.util.NamedList;
import org.apache.struts2.ServletActionContext;
import org.hibernate.Hibernate;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import java.awt.*;
import java.sql.Timestamp;
import java.util.*;
import java.util.List;
import java.util.logging.Logger;

/**
 * Created by Yasaman on 2015-10-21.
 */
public class MapAction extends ActionSupport implements Preparable {
    private static final String CARDIOVASCULARDISEASE = "cardiacarrest";
    private static final String DIABETES = "diabetes";
    private static final String OBSTRUCTIVE_PULMONARY_DISEASE = "cancer";
    private static final String HYPERTENSION = "hypertension";
    private static final String MENTALILLNESS = "mentalillness";
    private static final String MOOD_ANXIETY_DISORDERS = "anxiety";
    private static final String ASTHMA = "asthma";
    private static final String ISCHEMIC_HEART_DISEASE = "ischemic-heartdisease";
    private static final String ACUTE_MYOCARDIAL_INFARCTION = "myocardial";
    private static final String HEART_FAILURE = "heart-failure";
    public static final String SOLR_SERVER = "http://ostis.med.mun.ca:8983/solr/newostis";
    private String facetfieldStr;
    private String facetfieldStr1;
    private String facetfieldStr2;
    private Long total;
    private Long total1;
    private Long total2;
    @Autowired
    private UserManager userManager;
    List<History> historyList = new ArrayList<History>();
    private History history1;
    private History history2;
    private TreeMap<String, HashMap<String, Integer>> finalChartResult;
    private String statsObjectStr;
    private Settings settings;




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
    private String log="fsa"; //cs,da,hr,la

    public String getLog() {
        return log;
    }

    public void setLog(String log) {
        this.log = log;
    }
    private String hospitalizationStatus = "*";
    private String noOfHospFrom = "*";
    private String noOfHospTo = "*";
    private String lengthOfStayFrom = "*";
    private String lengthOfStayTo = "*";
    private String comorbidity="*";
    private String disease="*";
    private Integer maximumCount = 0;
    private Integer minimumCount = 0;
    private Integer distance = 0;
    private String response;
    private Integer historyId1 = 0;
    private Integer historyId2 = 0;
    private Map<String, String> postalCodeToCCSUID;
//    @Autowired
//    private QuestionManager questionManager;

    public String showMap(){
        if(postalCodeToCCSUID == null){
            postalCodeToCCSUID = new HashMap<String, String>();
        }
        logger.info("Showing main page with map and stuffs");
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        historyList = userManager.findHistoryByUserId(user.getId());
        List<PostalCodeLookup> postalCodeLookups = userManager.selectAllPostalCodeMappings();
        if(postalCodeToCCSUID.size() == 0){
            for (PostalCodeLookup postalCodeLookup : postalCodeLookups) {
                postalCodeToCCSUID.put(postalCodeLookup.getPostalCode(), postalCodeLookup.getCcsuid());
            }
        }

//        questionEntity = questionManager.findNextQuestion();
        return SUCCESS;
    }
    public String showSettings(){
        logger.info("Showing main page with map and stuffs");
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        settings = user.getSettings();
        return SUCCESS;
    }

    public String history1Details(){
        history1 = userManager.findHistoryById(historyId1);
        return SUCCESS;
    }
    public String history2Details(){
        history2 = userManager.findHistoryById(historyId2);
        return SUCCESS;
    }
    public String addToHistory(){
        System.out.println("Start addToHistory");
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        History history = new History();
        history.setMinAge(minAge);
        history.setMaxAge(maxAge);
        history.setMaxYear(maxYear);
        history.setMinYear(minYear);
        history.setDiseaseType(disease);
        history.setComorbidity(comorbidity);
        history.setHealthCareUtilization(healthcare);
        history.setSex(sex);
        history.setMortality(mortality);
        history.setUser(user);
        history.setCreateDate(new Date());
        userManager.addToHistory(history);
        historyId1 = history.getId();
        System.out.println("End addToHistory");
        return SUCCESS;
    }
    public String compare() throws SolrServerException {
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        History firstHistory = userManager.findHistoryById(historyId1);
        History secondHistory = userManager.findHistoryById(historyId2);
        String[] colorsGradient = new String[6];
        String[] colorsDescription = new String[6];
        colorsGradient[0]="FF0000";
        colorsGradient[1]="FF6A00";
        colorsGradient[2]="FFD400";
        colorsGradient[3]="BFFF00";
        colorsGradient[4]="55FF00";
        colorsGradient[5]="00FF15";
//        HttpSolrServer solr = new HttpSolrServer("http://134.153.89.205:8983/solr/ostis");
        HttpSolrServer solr = new HttpSolrServer(SOLR_SERVER);
        SolrQuery query = new SolrQuery();
        if(firstHistory.getComorbidity().length()==0){
            comorbidity="*";
        }else {
            comorbidity = firstHistory.getComorbidity().replaceAll(",", " OR ");
        }
        if(firstHistory.getDiseaseType().length()==0){
            disease="*";
        }else {
            disease = firstHistory.getDiseaseType().replaceAll(",", " OR ");
        }
        if(firstHistory.getMinAge()==null){
            minAge=10;
        }else{
            minAge = firstHistory.getMinAge();
        }
        if(firstHistory.getMaxAge()==null){
            maxAge=200;
        }else{
            maxAge = firstHistory.getMaxAge();
        }
        if(firstHistory.getMinYear()==null){
            minYear=1995;
        }else{
            minYear = firstHistory.getMinYear();
        }
        if(firstHistory.getMaxYear()==null){
            maxYear=2015;
        }else{
            maxYear = firstHistory.getMaxYear();
        }
        if(firstHistory.getSex() == null){
            sex = "*";
        }else{
            sex = firstHistory.getSex();
        }
        /*query.set("q","complications:("+comorbidity+") AND disease_type:("+disease+") AND "+ SolrFieldNames.AGE+":["+minAge+" TO "+maxAge+"] " +
                "AND year:["+minYear+" TO "+maxYear+"] AND sex:"+sex+" AND healthcare:"+healthcare+" AND mortality:"+mortality);*/
        SolrFieldNames fieldNames = new SolrFieldNames();
        StringBuffer diseaseComponents = new StringBuffer("(");
        if(disease.contains(OBSTRUCTIVE_PULMONARY_DISEASE) || disease.contains("*")){
            String diagYearField = fieldNames.getOPD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOPD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(DIABETES) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                //TODO: should this be OR or AND or USER_SPECIFIED?
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getDIABETES_DIAGNOSIS_YEAR();
            String diagAgeField = fieldNames.getDIABETES_DIAGNOSIS_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HYPERTENSION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHYP_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHYP_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MENTALILLNESS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getOMNI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOMNI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MOOD_ANXIETY_DISORDERS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getANXIETY_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getANXIETY_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ASTHMA) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getASTHMA_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getASTHMA_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ISCHEMIC_HEART_DISEASE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getIHD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getIHD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ACUTE_MYOCARDIAL_INFARCTION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getAMI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getAMI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HEART_FAILURE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHF_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHF_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }

        diseaseComponents.append(")");
        String theQueryString = (diseaseComponents.toString().length()>0? diseaseComponents.toString()+" AND " :"")+ SolrFieldNames.AGE + ":[" + minAge + " TO " + maxAge + "] " +
                "AND " + SolrFieldNames.SEX + ":" + sex;
        query.set("q",theQueryString);
        query.setFacet(true);
        query.addFacetField("fsa");
        query.setFacetLimit(-1);
        query.setFacetMinCount(1);
        query.setFacetSort("count");
        query.setStart(0);
        query.set("defType", "edismax");
        query.setGetFieldStatistics(true);
        query.setGetFieldStatistics(SolrFieldNames.AGE);


        QueryResponse response = solr.query(query);
        FacetField ff = response.getFacetField(SolrFieldNames.FSA_POSTAL_CODE);
        JSONArray facetfield = new JSONArray();
        System.out.println(query.toString());
        System.out.println("After running the query: "+new Timestamp(System.currentTimeMillis()));
        //TODO: We have some results without a FSA value in the response. They will be bucketed under empty string.
        FieldStatsInfo statsInfo = response.getFieldStatsInfo().get(SolrFieldNames.AGE);
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
                    colorsDescription[cntDesc] = "From "+(i-distance)+" to "+(i);
                }
                cntDesc++;
            }

            if (ff.getValues() != null) {
                total1 = 0l;
                total2 = 0l;
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
                            System.out.println();
                        }
                        total1 += fcount.getCount();
                        facetfield.put(attr);
                    }
                }
            }
            facetfieldStr1 = facetfield.toString();
        }
        query = new SolrQuery();
        if(secondHistory.getComorbidity().length()==0){
            comorbidity="*";
        }else {
            comorbidity = secondHistory.getComorbidity().replaceAll(",", " OR ");
        }
        if(secondHistory.getDiseaseType().length()==0){
            disease="*";
        }else {
            disease = secondHistory.getDiseaseType().replaceAll(",", " OR ");
        }
        if(secondHistory.getMinAge()==null){
            minAge=10;
        }else{
            minAge = secondHistory.getMinAge();
        }
        if(secondHistory.getMaxAge()==null){
            maxAge=200;
        }else{
            maxAge = secondHistory.getMaxAge();
        }
        if(secondHistory.getMinYear()==null){
            minYear=1995;
        }else{
            minYear = secondHistory.getMinYear();
        }
        if(secondHistory.getMaxYear()==null){
            maxYear=2015;
        }else{
            maxYear = secondHistory.getMaxYear();
        }
        if(secondHistory.getSex() == null){
            sex = "*";
        }else{
            sex = secondHistory.getSex();
        }
        /*query.set("q","complications:("+comorbidity+") AND disease_type:("+disease+") AND "+ SolrFieldNames.AGE+":["+minAge+" TO "+maxAge+"] " +
                "AND year:["+minYear+" TO "+maxYear+"] AND sex:"+sex+" AND healthcare:"+healthcare+" AND mortality:"+mortality);*/
        diseaseComponents = new StringBuffer("(");
        if(disease.contains(OBSTRUCTIVE_PULMONARY_DISEASE) || disease.contains("*")){
            String diagYearField = fieldNames.getOPD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOPD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(DIABETES) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                //TODO: should this be OR or AND or USER_SPECIFIED?
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getDIABETES_DIAGNOSIS_YEAR();
            String diagAgeField = fieldNames.getDIABETES_DIAGNOSIS_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HYPERTENSION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHYP_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHYP_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MENTALILLNESS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getOMNI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOMNI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MOOD_ANXIETY_DISORDERS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getANXIETY_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getANXIETY_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ASTHMA) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getASTHMA_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getASTHMA_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ISCHEMIC_HEART_DISEASE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getIHD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getIHD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ACUTE_MYOCARDIAL_INFARCTION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getAMI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getAMI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HEART_FAILURE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHF_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHF_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }

        diseaseComponents.append(")");
        theQueryString = (diseaseComponents.toString().length()>0? diseaseComponents.toString()+" AND " :"")+ SolrFieldNames.AGE + ":[" + minAge + " TO " + maxAge + "] " +
                "AND " + SolrFieldNames.SEX + ":" + sex;
        query.set("q",theQueryString);
        query.setFacet(true);
        query.addFacetField("fsa");
        query.setFacetLimit(-1);
        query.setFacetMinCount(1);
        query.setFacetSort("count");
        query.setStart(0);
        query.set("defType", "edismax");
        query.setGetFieldStatistics(true);
        query.setGetFieldStatistics(SolrFieldNames.AGE);


        response = solr.query(query);
        ff = response.getFacetField(SolrFieldNames.FSA_POSTAL_CODE);
        facetfield = new JSONArray();
        System.out.println(query.toString());
        System.out.println("After running the query: "+new Timestamp(System.currentTimeMillis()));
        //TODO: We have some results without a FSA value in the response. They will be bucketed under empty string.
        statsInfo = response.getFieldStatsInfo().get(SolrFieldNames.AGE);
        facetEntries = ff.getValues();
        if(facetEntries.size()>=3) {
            long highestCount = facetEntries.get(0).getCount();
            long lowestCount = facetEntries.get(facetEntries.size() - 1).getCount();
            Double distanceDouble = Math.ceil((highestCount - lowestCount+1) / 6);
            int distance = distanceDouble.intValue();
            int cntDesc = 0;
            for(long i = highestCount; i>=lowestCount; i = i - distance){
                if(cntDesc==5){
                    colorsDescription[cntDesc] = "Below "+(i);
                    break;
                }else {
                    colorsDescription[cntDesc] = "From "+(i-distance)+" to "+(i);
                }
                cntDesc++;
            }

            if (ff.getValues() != null) {
                total2 = 0l;
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
                            System.out.println();
                        }
                        total2 += fcount.getCount();
                        facetfield.put(attr);
                    }
                }
            }
            facetfieldStr2 = facetfield.toString();
        }
        return SUCCESS;
    }
    public Color hex2Rgb(String colorStr) {
        return new Color(
                Integer.valueOf( colorStr.substring( 1, 3 ), 16 ),
                Integer.valueOf( colorStr.substring( 3, 5 ), 16 ),
                Integer.valueOf( colorStr.substring( 5, 7 ), 16 ) );
    }
    public Color bleach(Color color, float amount)
    {
        int red = (int) ((color.getRed() * (1 - amount) / 255 + amount) * 255);
        int green = (int) ((color.getGreen() * (1 - amount) / 255 + amount) * 255);
        int blue = (int) ((color.getBlue() * (1 - amount) / 255 + amount) * 255);
        return new Color(red, green, blue);
    }
    public String sendMyRequest() throws SolrServerException {
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        SolrFieldNames fieldNames = new SolrFieldNames();
        String[] colorsGradient = new String[6];
        String[] colorsDescription = new String[6];
        Hibernate.initialize(user.getUserroles());
        Hibernate.initialize(user.getSettings());
        String prevalenceColor = user.getSettings().getPrevalenceColor();
        if(prevalenceColor.equalsIgnoreCase("default")){
            colorsGradient[0]="FF0000";
            colorsGradient[1]="FF6A00";
            colorsGradient[2]="FFD400";
            colorsGradient[3]="BFFF00";
            colorsGradient[4]="55FF00";
            colorsGradient[5]="00FF15";
        }else if(prevalenceColor.equalsIgnoreCase("reverse")){
            colorsGradient[5]="FF0000";
            colorsGradient[4]="FF6A00";
            colorsGradient[3]="FFD400";
            colorsGradient[2]="BFFF00";
            colorsGradient[1]="55FF00";
            colorsGradient[0]="00FF15";
        }else{
            Color color = hex2Rgb(prevalenceColor);
            String hex = String.format("%02x%02x%02x", color.getRed(), color.getGreen(), color.getBlue());
            colorsGradient[0]=hex;
            Color color1 = bleach(color, 0.17f);
            hex = String.format("%02x%02x%02x", color1.getRed(), color1.getGreen(), color1.getBlue());
            colorsGradient[1]=hex;
            Color color2 = bleach(color, .38f);
            hex = String.format("%02x%02x%02x", color2.getRed(), color2.getGreen(), color2.getBlue());
            colorsGradient[2]=hex;
            Color color3 = bleach(color, .59f);
            hex = String.format("%02x%02x%02x", color3.getRed(), color3.getGreen(), color3.getBlue());
            colorsGradient[3]=hex;
            Color color4 = bleach(color, .80f);
            hex = String.format("%02x%02x%02x", color4.getRed(), color4.getGreen(), color4.getBlue());
            colorsGradient[4]=hex;
            Color color5 = bleach(color, .97f);
            hex = String.format("%02x%02x%02x", color5.getRed(), color5.getGreen(), color5.getBlue());
            colorsGradient[5]=hex;
        }


        System.out.println("********---------********");
        System.out.println("Before running the query: "+new Timestamp(System.currentTimeMillis()));
        HttpSolrServer solr = new HttpSolrServer(SOLR_SERVER);
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
            minYear=1995;
        }
        if(maxYear==null){
            maxYear=2014;
        }
        /*query.set("q","complications:("+comorbidity+") AND disease_type:("+disease+") AND "+ SolrFieldNames.AGE+":["+minAge+" TO "+maxAge+"] " +
                "AND year:["+minYear+" TO "+maxYear+"] AND sex:"+sex+" AND healthcare:"+healthcare+" AND mortality:"+mortality);*/
        StringBuffer diseaseComponents = new StringBuffer("(");
        if(disease.contains(OBSTRUCTIVE_PULMONARY_DISEASE) || disease.contains("*")){
            String diagYearField = fieldNames.getOPD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOPD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(DIABETES) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                //TODO: should this be OR or AND or USER_SPECIFIED?
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getDIABETES_DIAGNOSIS_YEAR();
            String diagAgeField = fieldNames.getDIABETES_DIAGNOSIS_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HYPERTENSION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHYP_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHYP_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MENTALILLNESS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getOMNI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOMNI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MOOD_ANXIETY_DISORDERS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getANXIETY_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getANXIETY_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ASTHMA) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getASTHMA_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getASTHMA_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ISCHEMIC_HEART_DISEASE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getIHD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getIHD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ACUTE_MYOCARDIAL_INFARCTION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getAMI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getAMI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HEART_FAILURE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHF_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHF_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }

        diseaseComponents.append(")");

        String theQueryString = (diseaseComponents.toString().length()>0? diseaseComponents.toString() :"")+
                " AND " + SolrFieldNames.SEX + ":" + sex;;
        if(hospitalizationStatus.equalsIgnoreCase("yes")){
            theQueryString += " AND HS_Separations: ["+noOfHospFrom+" TO "+noOfHospTo+"] AND HS_DaysStay: ["+lengthOfStayFrom+" TO "+lengthOfStayTo+"] AND Year: ["+minYear+" TO "+maxYear+" ]";
        }else if(hospitalizationStatus.equalsIgnoreCase("no")){
            theQueryString += " AND -HS_Separations: [* TO *]";
        }
        /*String theQueryString = (diseaseComponents.toString().length()>0? diseaseComponents.toString()+" AND " :"")+ SolrFieldNames.AGE + ":[" + minAge + " TO " + maxAge + "] " +
                "AND " + SolrFieldNames.SEX + ":" + sex;*/
        query.set("q", theQueryString);
        query.setFacet(true);
        query.addFacetField(log);
        query.setFacetLimit(-1);
        query.setFacetMinCount(1);
        query.setFacetSort("count");
        query.setStart(0);
//        query.set("defType", "edismax");
        query.setGetFieldStatistics(true);
//        query.setGetFieldStatistics(SolrFieldNames.AGE);
        query.setGetFieldStatistics("DM_Diagnosis_MidYear_Age");

        QueryResponse response = solr.query(query);
        FacetField ff = response.getFacetField(log);
        JSONArray facetfield = new JSONArray();
        System.out.println(query.toString());
        System.out.println("After running the query: "+new Timestamp(System.currentTimeMillis()));
        //TODO: We have some results without a FSA value in the response. They will be bucketed under empty string.
//        FieldStatsInfo statsInfo = response.getFieldStatsInfo().get(SolrFieldNames.AGE);
        FieldStatsInfo statsInfo = response.getFieldStatsInfo().get("DM_Diagnosis_MidYear_Age");
        List<FacetField.Count> facetEntries = ff.getValues();
        if(facetEntries.size()>=3) {
            long highestCount = facetEntries.get(0).getCount();
            long lowestCount = facetEntries.get(facetEntries.size() - 1).getCount();
            Double distanceDouble = Math.ceil((highestCount - lowestCount+1) / 6);
            int distance = distanceDouble.intValue();
            int cntDesc = 0;
            for(long i = highestCount; i>=lowestCount; i = i - distance){
                if(cntDesc==5){
                    colorsDescription[cntDesc] = "Below "+(i);
                    break;
                }else {
                    colorsDescription[cntDesc] = (i-distance)+" to "+(i);
                }
                cntDesc++;
            }

            if (ff.getValues() != null) {
                total = 0l;
                int rank = 1;
                for (FacetField.Count fcount : facetEntries) {
                    JSONObject attr = new JSONObject();
                    if (fcount.getName().toLowerCase().startsWith("a")
                            || fcount.getName().toLowerCase().startsWith("100")
                            || log.equalsIgnoreCase("LA_ID")) {
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
                            System.out.println();
                        }
                        total += fcount.getCount();
                        facetfield.put(attr);
                    }
                }
            }
            statsObjectStr = new String();
            JSONObject statsObject =new JSONObject();
            JSONObject ageStats = new JSONObject();
            ageStats.put("count",statsInfo.getCount());
            ageStats.put("coundDistinct", statsInfo.getCountDistinct());
            ageStats.put("min", statsInfo.getMin());
            ageStats.put("max", statsInfo.getMax());
            ageStats.put("average", statsInfo.getMean());
            ageStats.put("stddev",statsInfo.getStddev());
            statsObject.put("ageStatistics",ageStats);
            statsObjectStr = statsObject.toString();
            facetfieldStr = facetfield.toString();

        }else{
            statsObjectStr = new String();
            JSONObject statsObject =new JSONObject();
            JSONObject ageStats = new JSONObject();
            statsObject.put("ageStatistics",ageStats);
            statsObjectStr = statsObject.toString();
            facetfieldStr = facetfield.toString();
        }
        System.out.println("After preparing the json: "+new Timestamp(System.currentTimeMillis()));
        System.out.println();
        return SUCCESS;
    }
    public String sendBubbleChartReuqest() throws SolrServerException {
        HttpSolrServer solr = new HttpSolrServer(SOLR_SERVER);
        SolrQuery query = new SolrQuery();
        HashMap<Integer, HashMap<String, Integer>> chartResult = new HashMap<Integer, HashMap<String, Integer>>();
        finalChartResult = new TreeMap<String, HashMap<String, Integer>>();
        query.set("q","year:*");
        query.setFacet(true);
        query.addFacetPivotField("postal_code_5,disease_type");
        query.setFacetSort("postal_code_5 asc");
        query.setFacetSort("disease_type asc");
        query.setStart(0);
        query.set("defType", "edismax");
        QueryResponse response = solr.query(query);
        NamedList<List<PivotField>> pivot = response.getFacetPivot();

        return SUCCESS;
    }
    public String sendDifferentDiseasesRequest() throws SolrServerException {
        HttpSolrServer solr = new HttpSolrServer(SOLR_SERVER);
        SolrQuery query = new SolrQuery();
        HashMap<Integer, HashMap<String, Integer>> chartResult = new HashMap<Integer, HashMap<String, Integer>>();
        finalChartResult = new TreeMap<String, HashMap<String, Integer>>();
        query.set("q","year:["+minYear+" TO "+maxYear+"]");
        query.setFacet(true);
        query.addFacetPivotField("year,disease_type");
        query.setFacetSort("year desc");
        query.setFacetSort("disease_type asc");
        query.setStart(0);
        query.set("defType", "edismax");
        QueryResponse response = solr.query(query);
        NamedList<List<PivotField>> pivot = response.getFacetPivot();
        for (Map.Entry<String, List<PivotField>> pivotList : pivot) {
            String key = pivotList.getKey();
            List<PivotField> values = pivotList.getValue();
            for (PivotField value : values) {
                PivotField yearDiseasePivotField = value;
                Integer yearValue = (Integer)yearDiseasePivotField.getValue();
                HashMap<String, Integer> diseaseIntensity = new HashMap<String, Integer>();
                for (int i = 0;i<4; i++){
                    String diseaseName = (String) yearDiseasePivotField.getPivot().get(i).getValue();
                    Integer diseaseCount = (Integer) yearDiseasePivotField.getPivot().get(i).getCount();
                    diseaseIntensity.put(diseaseName,diseaseCount);
                }
                finalChartResult.put(yearValue+"",diseaseIntensity);
            }
        }
        return SUCCESS;
    }
    public String sendAgeGroupRequest() throws SolrServerException {
        HttpSolrServer solr = new HttpSolrServer(SOLR_SERVER);
        String key1= "20-40";
        String key2= "41-60";
        String key3= "61-80";
        String key4= "81+";
        SolrQuery query = new SolrQuery();
        HashMap<Integer, HashMap<String, Integer>> chartResult = new HashMap<Integer, HashMap<String, Integer>>();
        finalChartResult = new TreeMap<String, HashMap<String, Integer>>();
        SolrFieldNames fieldNames = new SolrFieldNames();
        StringBuffer diseaseComponents = new StringBuffer("(");
        if(disease.contains(OBSTRUCTIVE_PULMONARY_DISEASE) || disease.contains("*")){
            String diagYearField = fieldNames.getOPD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOPD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(DIABETES) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                //TODO: should this be OR or AND or USER_SPECIFIED?
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getDIABETES_DIAGNOSIS_YEAR();
            String diagAgeField = fieldNames.getDIABETES_DIAGNOSIS_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HYPERTENSION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHYP_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHYP_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MENTALILLNESS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getOMNI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getOMNI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(MOOD_ANXIETY_DISORDERS) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getANXIETY_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getANXIETY_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ASTHMA) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getASTHMA_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getASTHMA_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ISCHEMIC_HEART_DISEASE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getIHD_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getIHD_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(ACUTE_MYOCARDIAL_INFARCTION) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getAMI_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getAMI_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }
        if(disease.contains(HEART_FAILURE) || disease.contains("*")){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHF_DIAGNOSTIC_YEAR();
            String diagAgeField = fieldNames.getHF_DIAGNOSTIC_AGE();
            diseaseComponents.append("(").append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]").append(" AND ").append(diagAgeField).append(":[").append(minAge)
                    .append(" TO ").append(maxAge).append("]").append(")");
        }

        diseaseComponents.append(")");
        String theQueryString = (diseaseComponents.toString().length()>0? diseaseComponents.toString()+" " :"");
        query.set("q", theQueryString);
        query.setFacet(true);
        query.addFacetPivotField("Age_MidYear,sex");
        query.setFacetSort("Age_MidYear desc");
//        query.setFacetSort("count");
        query.setStart(0);
        query.set("defType", "edismax");
        QueryResponse response = solr.query(query);
        NamedList<List<PivotField>> pivot = response.getFacetPivot();
        for (Map.Entry<String, List<PivotField>> pivotList : pivot) {
            String key = pivotList.getKey();
            List<PivotField> values = pivotList.getValue();
            for (PivotField value : values) {
                PivotField ageSexPivotField = value;
                Integer ageValue = (Integer)ageSexPivotField.getValue();
                Integer maleValue = 0;
                Integer femaleValue = 0;
                if(ageSexPivotField.getPivot().size() > 0){
                    String sexDecider = (String) ageSexPivotField.getPivot().get(0).getValue();
                    if(sexDecider.equalsIgnoreCase("m")){
                        maleValue = ageSexPivotField.getPivot().get(0).getCount();
                    }else{
                        if(ageSexPivotField.getPivot().size()>1){
                            femaleValue = ageSexPivotField.getPivot().get(1).getCount();
                        }else{
                            femaleValue = 0;
                        }
                    }
                    if(ageSexPivotField.getPivot().size()>1){
                        sexDecider = (String) ageSexPivotField.getPivot().get(1).getValue();
                        if(sexDecider.equalsIgnoreCase("m")){
                            maleValue = ageSexPivotField.getPivot().get(0).getCount();
                        }else{
                            if(ageSexPivotField.getPivot().size()>1){
                                femaleValue = ageSexPivotField.getPivot().get(1).getCount();
                            }else{
                                femaleValue = 0;
                            }
                        }
                    }else{
                        femaleValue = 0;
                    }
                }else{
                    maleValue = 0;
                    femaleValue = 0;
                }


                HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                femaleMaleMap.put("m",maleValue);
                femaleMaleMap.put("f",femaleValue);
                chartResult.put(ageValue,femaleMaleMap);
            }
        }
        for (Integer integer : chartResult.keySet()) {
            if(20<=integer && integer<=40){
                if(finalChartResult.containsKey(key1)){
                    int newMaleValue = getFinalChartResult().get(key1).get("m").intValue() + chartResult.get(integer).get("m").intValue();
                    int newFemaleValue = getFinalChartResult().get(key1).get("f").intValue() + chartResult.get(integer).get("f").intValue();
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",newMaleValue);
                    femaleMaleMap.put("f",newFemaleValue);
                    finalChartResult.put(key1,femaleMaleMap);
                }else{
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",chartResult.get(integer).get("m").intValue());
                    femaleMaleMap.put("f",chartResult.get(integer).get("f").intValue());
                    finalChartResult.put(key1,femaleMaleMap);
                }
            }else if(41<=integer && integer<=60){
                if(finalChartResult.containsKey(key2)){
                    int newMaleValue = getFinalChartResult().get(key2).get("m").intValue() + chartResult.get(integer).get("m").intValue();
                    int newFemaleValue = getFinalChartResult().get(key2).get("f").intValue() + chartResult.get(integer).get("f").intValue();
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",newMaleValue);
                    femaleMaleMap.put("f",newFemaleValue);
                    finalChartResult.put(key2,femaleMaleMap);
                }else{
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",chartResult.get(integer).get("m").intValue());
                    femaleMaleMap.put("f",chartResult.get(integer).get("f").intValue());
                    finalChartResult.put(key2,femaleMaleMap);
                }
            }else if(61<= integer && integer <=80){
                if(finalChartResult.containsKey(key3)){
                    int newMaleValue = getFinalChartResult().get(key3).get("m").intValue() + chartResult.get(integer).get("m").intValue();
                    int newFemaleValue = getFinalChartResult().get(key3).get("f").intValue() + chartResult.get(integer).get("f").intValue();
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",newMaleValue);
                    femaleMaleMap.put("f",newFemaleValue);
                    finalChartResult.put(key3,femaleMaleMap);
                }else{
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",chartResult.get(integer).get("m").intValue());
                    femaleMaleMap.put("f",chartResult.get(integer).get("f").intValue());
                    finalChartResult.put(key3,femaleMaleMap);
                }
            }else if(81<= integer && integer <=120){
                if(finalChartResult.containsKey(key4)){
                    int newMaleValue = getFinalChartResult().get(key4).get("m").intValue() + chartResult.get(integer).get("m").intValue();
                    int newFemaleValue = getFinalChartResult().get(key4).get("f").intValue() + chartResult.get(integer).get("f").intValue();
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",newMaleValue);
                    femaleMaleMap.put("f",newFemaleValue);
                    finalChartResult.put(key4,femaleMaleMap);
                }else{
                    HashMap<String, Integer> femaleMaleMap = new HashMap<String, Integer>();
                    femaleMaleMap.put("m",chartResult.get(integer).get("m").intValue());
                    femaleMaleMap.put("f",chartResult.get(integer).get("f").intValue());
                    finalChartResult.put(key4,femaleMaleMap);
                }

            }
        }
        return SUCCESS;
    }

    public String saveSettings() throws SolrServerException {
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        String theColor = settings.getPrevalenceColor();
        user.getSettings().setPrevalenceColor(theColor);
        userManager.updateUser(user);
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

    public UserManager getUserManager() {
        return userManager;
    }

    public void setUserManager(UserManager userManager) {
        this.userManager = userManager;
    }

    public List<History> getHistoryList() {
        return historyList;
    }

    public void setHistoryList(List<History> historyList) {
        this.historyList = historyList;
    }

    public Integer getHistoryId1() {
        return historyId1;
    }

    public void setHistoryId1(Integer historyId1) {
        this.historyId1 = historyId1;
    }

    public Integer getHistoryId2() {
        return historyId2;
    }

    public void setHistoryId2(Integer historyId2) {
        this.historyId2 = historyId2;
    }

    public String getFacetfieldStr1() {
        return facetfieldStr1;
    }

    public void setFacetfieldStr1(String facetfieldStr1) {
        this.facetfieldStr1 = facetfieldStr1;
    }

    public String getFacetfieldStr2() {
        return facetfieldStr2;
    }

    public void setFacetfieldStr2(String facetfieldStr2) {
        this.facetfieldStr2 = facetfieldStr2;
    }

    public History getHistory1() {
        return history1;
    }

    public void setHistory1(History history1) {
        this.history1 = history1;
    }

    public History getHistory2() {
        return history2;
    }

    public void setHistory2(History history2) {
        this.history2 = history2;
    }

    public Long getTotal1() {
        return total1;
    }

    public void setTotal1(Long total1) {
        this.total1 = total1;
    }

    public Long getTotal2() {
        return total2;
    }

    public void setTotal2(Long total2) {
        this.total2 = total2;
    }

    public TreeMap<String, HashMap<String, Integer>> getFinalChartResult() {
        return finalChartResult;
    }

    public void setFinalChartResult(TreeMap<String, HashMap<String, Integer>> finalChartResult) {
        this.finalChartResult = finalChartResult;
    }

    public String getStatsObjectStr() {
        return statsObjectStr;
    }

    public void setStatsObjectStr(String statsObjectStr) {
        this.statsObjectStr = statsObjectStr;
    }

    public Settings getSettings() {
        return settings;
    }

    public void setSettings(Settings settings) {
        this.settings = settings;
    }

    public String getHospitalizationStatus() {
        return hospitalizationStatus;
    }

    public void setHospitalizationStatus(String hospitalizationStatus) {
        this.hospitalizationStatus = hospitalizationStatus;
    }

    public String getNoOfHospFrom() {
        return noOfHospFrom;
    }

    public void setNoOfHospFrom(String noOfHospFrom) {
        this.noOfHospFrom = noOfHospFrom;
    }

    public String getNoOfHospTo() {
        return noOfHospTo;
    }

    public void setNoOfHospTo(String noOfHospTo) {
        this.noOfHospTo = noOfHospTo;
    }

    public String getLengthOfStayFrom() {
        return lengthOfStayFrom;
    }

    public void setLengthOfStayFrom(String lengthOfStayFrom) {
        this.lengthOfStayFrom = lengthOfStayFrom;
    }

    public String getLengthOfStayTo() {
        return lengthOfStayTo;
    }

    public void setLengthOfStayTo(String lengthOfStayTo) {
        this.lengthOfStayTo = lengthOfStayTo;
    }
}
