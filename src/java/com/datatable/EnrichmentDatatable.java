/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.datatable;

/**
 *
 * @author principalpc
 */
public class EnrichmentDatatable {
    
    private String go_id, name, pvalue, pvalueadjusted, pvaluemin, poptotal, popterm, studytotal, studyterm;

    public EnrichmentDatatable(String go_id, String name, String pvalue, String pvalueadjusted, String pvaluemin, String poptotal, String popterm, String studytotal, String studyterm){
        this.go_id = go_id;
        this.name = name;
        this.pvalue = pvalue;
        this.pvalueadjusted = pvalueadjusted;
        this.pvaluemin = pvaluemin;
        this.poptotal = poptotal;
        this.popterm = popterm;
        this.studytotal = studytotal;
        this.studyterm = studyterm;
    }

    public String getId() {
        return go_id;
    }

    public void setId(String go_id) {
        this.go_id = go_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPvalue() {
        return pvalue;
    }

    public void setPvalue(String pvalue) {
        this.pvalue = pvalue;
    }

    public String getPvalueadjusted() {
        return pvalueadjusted;
    }

    public void setPvalueadjusted(String pvalueadjusted) {
        this.pvalueadjusted = pvalueadjusted;
    }

    public String getPvaluemin() {
        return pvaluemin;
    }

    public void setPvaluemin(String pvaluemin) {
        this.pvaluemin = pvaluemin;
    }

    public String getPoptotal() {
        return poptotal;
    }

    public void setPoptotal(String poptotal) {
        this.poptotal = poptotal;
    }

    public String getPopterm() {
        return popterm;
    }

    public void setPopterm(String popterm) {
        this.popterm = popterm;
    }

    public String getStudytotal() {
        return studytotal;
    }

    public void setStudytotal(String studytotal) {
        this.studytotal = studytotal;
    }

    public String getStudyterm() {
        return studyterm;
    }

    public void setStudyterm(String studyterm) {
        this.studyterm = studyterm;
    }  
}
