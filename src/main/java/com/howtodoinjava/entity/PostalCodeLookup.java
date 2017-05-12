package com.howtodoinjava.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity(name = "PostalCodeLookup")
@Table(name = "tbl_postalcode_lookup")
public class PostalCodeLookup implements Serializable {

    @Id
    @Column(name = "POSTALCODE")
    private String postalCode;
    @Column(name = "COMM_NAME")
    private String commName;
    @Column(name = "MUNICIPAL")
    private String municipal;
    @Column(name = "RHA")
    private String rha;
    @Column(name = "FSA")
    private String fsa;
    @Column(name = "CCSUID")
    private String ccsuid;
    @Column(name = "CCSNAME")
    private String ccsname;
    @Column(name = "CDUID")
    private String cduid;
    @Column(name = "CDNAME")
    private String cdname;
    @Column(name = "CSDUID")
    private String csduid;
    @Column(name = "CSDNAME")
    private String csdname;
    @Column(name = "DAUID")
    private String dauid;
    @Column(name = "ERUID")
    private String eruid;
    @Column(name = "ERNAME")
    private String ername;
    @Column(name = "LOCAL_AREA")
    private String localArea;
    @Column(name = "Remote_Cla")
    private String remoteCla;
    @Column(name = "RemoteIdx")
    private String remoteIdx;
    @Column(name = "RemoteFuzz")
    private String remoteFuzz;
    @Column(name = "Local_Ar_1")
    private String localAr1;
    @Column(name = "RHA_Pop_13")
    private String rhaPop13;
    @Column(name = "CD_Pop_11")
    private String cdPop11;
    @Column(name = "CSD_Pop_11")
    private String csdPop11;
    @Column(name = "ER_Pop_11")
    private String erPop11;
    @Column(name = "FSA_Pop_11")
    private String fsaPop11;
    @Column(name = "DA_Pop_11")
    private String daPop11;

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getCommName() {
        return commName;
    }

    public void setCommName(String commName) {
        this.commName = commName;
    }

    public String getMunicipal() {
        return municipal;
    }

    public void setMunicipal(String municipal) {
        this.municipal = municipal;
    }

    public String getRha() {
        return rha;
    }

    public void setRha(String rha) {
        this.rha = rha;
    }

    public String getFsa() {
        return fsa;
    }

    public void setFsa(String fsa) {
        this.fsa = fsa;
    }

    public String getCcsuid() {
        return ccsuid;
    }

    public void setCcsuid(String ccsuid) {
        this.ccsuid = ccsuid;
    }

    public String getCcsname() {
        return ccsname;
    }

    public void setCcsname(String ccsname) {
        this.ccsname = ccsname;
    }

    public String getCduid() {
        return cduid;
    }

    public void setCduid(String cduid) {
        this.cduid = cduid;
    }

    public String getCdname() {
        return cdname;
    }

    public void setCdname(String cdname) {
        this.cdname = cdname;
    }

    public String getCsduid() {
        return csduid;
    }

    public void setCsduid(String csduid) {
        this.csduid = csduid;
    }

    public String getCsdname() {
        return csdname;
    }

    public void setCsdname(String csdname) {
        this.csdname = csdname;
    }

    public String getDauid() {
        return dauid;
    }

    public void setDauid(String dauid) {
        this.dauid = dauid;
    }

    public String getEruid() {
        return eruid;
    }

    public void setEruid(String eruid) {
        this.eruid = eruid;
    }

    public String getErname() {
        return ername;
    }

    public void setErname(String ername) {
        this.ername = ername;
    }

    public String getLocalArea() {
        return localArea;
    }

    public void setLocalArea(String localArea) {
        this.localArea = localArea;
    }

    public String getRemoteCla() {
        return remoteCla;
    }

    public void setRemoteCla(String remoteCla) {
        this.remoteCla = remoteCla;
    }

    public String getRemoteIdx() {
        return remoteIdx;
    }

    public void setRemoteIdx(String remoteIdx) {
        this.remoteIdx = remoteIdx;
    }

    public String getRemoteFuzz() {
        return remoteFuzz;
    }

    public void setRemoteFuzz(String remoteFuzz) {
        this.remoteFuzz = remoteFuzz;
    }

    public String getLocalAr1() {
        return localAr1;
    }

    public void setLocalAr1(String localAr1) {
        this.localAr1 = localAr1;
    }

    public String getRhaPop13() {
        return rhaPop13;
    }

    public void setRhaPop13(String rhaPop13) {
        this.rhaPop13 = rhaPop13;
    }

    public String getCdPop11() {
        return cdPop11;
    }

    public void setCdPop11(String cdPop11) {
        this.cdPop11 = cdPop11;
    }

    public String getCsdPop11() {
        return csdPop11;
    }

    public void setCsdPop11(String csdPop11) {
        this.csdPop11 = csdPop11;
    }

    public String getErPop11() {
        return erPop11;
    }

    public void setErPop11(String erPop11) {
        this.erPop11 = erPop11;
    }

    public String getFsaPop11() {
        return fsaPop11;
    }

    public void setFsaPop11(String fsaPop11) {
        this.fsaPop11 = fsaPop11;
    }

    public String getDaPop11() {
        return daPop11;
    }

    public void setDaPop11(String daPop11) {
        this.daPop11 = daPop11;
    }
}