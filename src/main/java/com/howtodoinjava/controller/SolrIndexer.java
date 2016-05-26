package com.howtodoinjava.controller;

import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.common.SolrInputDocument;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Created by ns265 on 1/28/2016.
 */
public class SolrIndexer {

    public static void main(String[] args) throws IOException, SolrServerException {
        Random randomGenerator = new Random();
        String zipRegions = "A0A,A0B,A0C,A0E,A0G,A0H,A0J,A0K,A0L,A0M,A0N,A0P,A0R,A1A,A1B,A1C,A1E,A1G,A1H,A1K,A1L,A1M,A1N,A1S,A1V,A1W,A1X,A1Y,A2A,A2B,A2H,A2N,A2V,A5A,A8A";
        String sexStr = "M,F";
        String healthcareUtilizationStr = "1,0";
        String mortalityStr = "1,0";
//        String diseaseTypeStr = "diabetes,cardiacarrest,cancer,hypertension";
        String diseaseTypeStr = "cardiacarrest";
        String complicationsStr = "bloodpressure,nausia,dizziness,seizure";
        String[] zipRegionsArray = zipRegions.split(",");
        String[] sexArray = sexStr.split(",");
        String[] diseaseTypeArray = diseaseTypeStr.split(",");
        String[] complicationArray = complicationsStr.split(",");
        String[] healthcareUtilizationArray = healthcareUtilizationStr.split(",");
        String[] mortalityArray = mortalityStr.split(",");
        HttpSolrServer server = new HttpSolrServer("http://localhost:8983/solr/ostis");
        for (int i = 1914351; i < 1944304; i++) {
            String postalCode = zipRegionsArray[randomGenerator.nextInt(zipRegionsArray.length)] + " 3K8";
            Integer age = randomGenerator.nextInt((99 - 20) + 1) + 20;
            Integer instanceId = randomGenerator.nextInt((9999 - 900) + 1) + 900;
//            Integer year = randomGenerator.nextInt((2008 - 1998) + 1) + 1998;
            Integer year = 2005;
            String sex = sexArray[randomGenerator.nextInt(sexArray.length)];
            String diseaseType = diseaseTypeArray[randomGenerator.nextInt(diseaseTypeArray.length)];
            String complication = complicationArray[randomGenerator.nextInt(complicationArray.length)];
            Integer healthcareUtilization = Integer.parseInt(healthcareUtilizationArray[randomGenerator.nextInt(healthcareUtilizationArray.length)]);
            Integer mortality = Integer.parseInt(mortalityArray[randomGenerator.nextInt(mortalityArray.length)]);
//            System.out.println(postalCode+","+age+","+instanceId+","+year+","+sex+","+i);
            SolrInputDocument doc = new SolrInputDocument();
            doc.addField("id", i + "");
            doc.addField("instance_id", instanceId);
            doc.addField("sex", sex);
            doc.addField("age", age);
            doc.addField("postal_code_1", postalCode);
            doc.addField("postal_code_2", postalCode);
            doc.addField("postal_code_3", postalCode);
            doc.addField("postal_code_4", postalCode);
            doc.addField("postal_code_5", postalCode);
            doc.addField("year", year);
            doc.addField("disease_type", diseaseType);
            doc.addField("complications", complication);
            doc.addField("healthcare", healthcareUtilization);
            doc.addField("mortality", mortality);
            server.add(doc);
            if (i % 10000 == 0) {
                System.out.println("So far: " + i);
                server.commit();  // periodically flush
            }
        }
        server.commit();
    }
//    public static int random(int low, int high, int bias)
//    {
//        float r = rand01();    // random between 0 and 1
//        r = pow(r, bias);
//        return low + (high - low) * r;
//    }
}
