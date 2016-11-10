package com.howtodoinjava.controller;

import com.howtodoinjava.entity.History;
import com.howtodoinjava.entity.SolrFieldNames;
import com.howtodoinjava.entity.UserEntity;
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
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Timestamp;
import java.util.*;
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
    private Integer historyId1 = 0;
    private Integer historyId2 = 0;
//    @Autowired
//    private QuestionManager questionManager;

    public String showMap(){
        logger.info("Showing main page with map and stuffs");
        UserEntity user = userManager.findUserByUsername(ServletActionContext.getRequest().getRemoteUser());
        historyList = userManager.findHistoryByUserId(user.getId());
//        questionEntity = questionManager.findNextQuestion();
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
            minYear=1000;
        }else{
            minYear = firstHistory.getMinYear();
        }
        if(firstHistory.getMaxYear()==null){
            maxYear=4000;
        }else{
            maxYear = firstHistory.getMaxYear();
        }
        if(firstHistory.getHealthCareUtilization().equals("0")){
            healthcare = "0";
        }else if(firstHistory.getHealthCareUtilization().equals("1")){
            healthcare = "1";
        }
        if(firstHistory.getMortality().equals("0")){
            mortality = "0";
        }else if(firstHistory.getMortality().equals("1")){
            mortality = "1";
        }
        if(firstHistory.getSex().equals("M")){
            sex = "M";
        }else if(firstHistory.getSex().equals("F")){
            sex = "F";
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
            minYear=1000;
        }else{
            minYear = secondHistory.getMinYear();
        }
        if(secondHistory.getMaxYear()==null){
            maxYear=4000;
        }else{
            maxYear = secondHistory.getMaxYear();
        }
        if(secondHistory.getHealthCareUtilization().equals("0")){
            healthcare = "0";
        }else if(secondHistory.getHealthCareUtilization().equals("1")){
            healthcare = "1";
        }
        if(secondHistory.getMortality().equals("0")){
            mortality = "0";
        }else if(secondHistory.getMortality().equals("1")){
            mortality = "1";
        }
        if(secondHistory.getSex().equals("M")){
            sex = "M";
        }else if(secondHistory.getSex().equals("F")){
            sex = "F";
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


        response = solr.query(query);
        ff = response.getFacetField("postal_code_5");
        facetfield = new JSONArray();

        facetEntries = ff.getValues();
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
    public String sendRequest() throws SolrServerException {
        SolrFieldNames fieldNames = new SolrFieldNames();
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
        if(disease.contains(OBSTRUCTIVE_PULMONARY_DISEASE)){
            String diagYearField = fieldNames.getOPD_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(DIABETES)){
            if(diseaseComponents.toString().length() > 1) {
                //TODO: should this be OR or AND or USER_SPECIFIED?
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getDIABETES_DIAGNOSIS_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(HYPERTENSION)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHYP_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(MENTALILLNESS)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getOMNI_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(MOOD_ANXIETY_DISORDERS)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getANXIETY_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(ASTHMA)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getASTHMA_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(ISCHEMIC_HEART_DISEASE)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getIHD_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(ACUTE_MYOCARDIAL_INFARCTION)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getAMI_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains(HEART_FAILURE)){
            if(diseaseComponents.toString().length() > 1) {
                diseaseComponents.append(" OR ");
            }
            String diagYearField = fieldNames.getHF_DIAGNOSTIC_YEAR();
            diseaseComponents.append(diagYearField).append(":[ ").append(minYear).append(" TO ")
                    .append(maxYear).append(" ]");
        }
        if(disease.contains("*")){
            diseaseComponents.append("*");
        }
        diseaseComponents.append(")");
        String theQueryString = (diseaseComponents.toString().length()>0? diseaseComponents.toString()+" AND " :"")+ SolrFieldNames.AGE + ":[" + minAge + " TO " + maxAge + "] " +
                "AND " + SolrFieldNames.SEX + ":" + sex;
        query.set("q", theQueryString);
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
//        for (Map.Entry<String, List<PivotField>> pivotList : pivot) {
//            String key = pivotList.getKey();
//            List<PivotField> values = pivotList.getValue();
//            for (PivotField value : values) {
//                PivotField yearDiseasePivotField = value;
//                Integer yearValue = (Integer)yearDiseasePivotField.getValue();
//                HashMap<String, Integer> diseaseIntensity = new HashMap<String, Integer>();
//                for (int i = 0;i<4; i++){
//                    String diseaseName = (String) yearDiseasePivotField.getPivot().get(i).getValue();
//                    Integer diseaseCount = (Integer) yearDiseasePivotField.getPivot().get(i).getCount();
//                    diseaseIntensity.put(diseaseName,diseaseCount);
//                }
//                finalChartResult.put(yearValue+"",diseaseIntensity);
//            }
//        }
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
        query.set("q","disease_type:"+disease);
        query.setFacet(true);
        query.addFacetPivotField("age,sex");
        query.setFacetSort("age desc");
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
                String sexDecider = (String) ageSexPivotField.getPivot().get(0).getValue();
                Integer maleValue = 0;
                Integer femaleValue = 0;
                if(sexDecider.equalsIgnoreCase("m")){
                    maleValue = ageSexPivotField.getPivot().get(0).getCount();
                }else{
                    femaleValue = ageSexPivotField.getPivot().get(1).getCount();
                }
                sexDecider = (String) ageSexPivotField.getPivot().get(1).getValue();
                if(sexDecider.equalsIgnoreCase("m")){
                    maleValue = ageSexPivotField.getPivot().get(0).getCount();
                }else{
                    femaleValue = ageSexPivotField.getPivot().get(1).getCount();
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
}
