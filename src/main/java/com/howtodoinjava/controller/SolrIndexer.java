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
        String zipRegions = "A0A,A0A,A0B,A0C,A0E,A0G,A0H,A0J,A0K,A0L,A0M,A0N,A0P,A0R,A1A,A1B,A1C,A1E,A1G,A1H,A1K,A1L,A1M,A1N,A1S,A1V,A1W,A1X,A1Y,A2A,A2B,A2H,A2N,A2V,A5A,A8A";
        String sexStr = "F,M";
        String[] zipRegionsArray = zipRegions.split(",");
        String[] sexArray = sexStr.split(",");
        HttpSolrServer server = new HttpSolrServer("http://localhost:8983/solr/ostis");
        for (int i=430001; i<6000000; i++) {
            String postalCode = zipRegionsArray[randomGenerator.nextInt(zipRegionsArray.length)] + " 3K8";
            Integer age =  randomGenerator.nextInt((99 - 18) + 1) + 18;
            Integer instanceId = randomGenerator.nextInt((9999 - 900)+1)+900;
            Integer year = randomGenerator.nextInt((2008 - 1998)+1)+1998;
            String sex = sexArray[randomGenerator.nextInt(sexArray.length)];
//            System.out.println(postalCode+","+age+","+instanceId+","+year+","+sex+","+i);
            SolrInputDocument doc = new SolrInputDocument();
            doc.addField("id", i+"");
            doc.addField("instance_id", instanceId);
            doc.addField("sex", sex);
            doc.addField("age", age);
            doc.addField("postal_code_1", postalCode);
            doc.addField("postal_code_2", postalCode);
            doc.addField("postal_code_3", postalCode);
            doc.addField("postal_code_4", postalCode);
            doc.addField("postal_code_5", postalCode);
            doc.addField("year", year);
            server.add(doc);
            if(i%100000==0) {
                System.out.println("So far: "+i);
                server.commit();  // periodically flush
            }
        }
        server.commit();

//        for(int i=0;i<100000;++i) {
//            SolrInputDocument doc = new SolrInputDocument();
//            doc.addField("cat", "book");
//            doc.addField("id", "book-" + i);
//            doc.addField("name", "The Legend of the Hobbit part " + i);
//            server.add(doc);
//            if(i%1000==0) server.commit();  // periodically flush
//        }
//        server.commit();
    }
}
