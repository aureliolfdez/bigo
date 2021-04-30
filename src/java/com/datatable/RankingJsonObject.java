package com.datatable;

import java.util.List;

public class RankingJsonObject {

    int iTotalRecords;

    int iTotalDisplayRecords;
    
    int length;

    String sEcho;

    String sColumns;

    List<RankingDatatable> aaData;

    public int getLength() {
        return length;
    }

    public void setLength(int length) {
        this.length = length;
    }
    
    

    public int getiTotalRecords() {
	return iTotalRecords;
    }

    public void setiTotalRecords(int iTotalRecords) {
	this.iTotalRecords = iTotalRecords;
    }

    public int getiTotalDisplayRecords() {
	return iTotalDisplayRecords;
    }

    public void setiTotalDisplayRecords(int iTotalDisplayRecords) {
	this.iTotalDisplayRecords = iTotalDisplayRecords;
    }

    public String getsEcho() {
	return sEcho;
    }

    public void setsEcho(String sEcho) {
	this.sEcho = sEcho;
    }

    public String getsColumns() {
	return sColumns;
    }

    public void setsColumns(String sColumns) {
	this.sColumns = sColumns;
    }

    public List<RankingDatatable> getAaData() {
        return aaData;
    }

    public void setAaData(List<RankingDatatable> aaData) {
        this.aaData = aaData;
    }

    
}
