package com.datatable;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public class RankingDatatable {

    private String id;
    private String name;
    private double ic;
    private double pvalue;
    private String num_biclusters;
    private String list_biclusters;
    private String input;
    private int num_bicluster;
    private String select;

    public RankingDatatable(String id, String name, double ic, double pvalue, String num_biclusters, String list_biclusters) {
        String idAcortado;
        if(id.contains("</a>")){
            idAcortado = id.substring(id.indexOf("GO:"),id.length()-4);
        }else{
            idAcortado = id.substring(id.indexOf("GO:"),id.length());
        }
        this.input = "<td style='background-color: #ffb5b5; width: 10px; white-space: nowrap;'><input class='form-control center-block' style='text-align: center;' type='checkbox' name='gosdelete' value='" + idAcortado + "' /></td>";
        this.id = id;
        this.name = name;
        this.ic = ic;
        this.pvalue = pvalue;
        this.num_biclusters = num_biclusters;
        this.num_bicluster = Integer.parseInt(num_biclusters.substring(0,num_biclusters.indexOf("/")));
        this.list_biclusters = list_biclusters;
        String [] body = this.list_biclusters.replace("[","").replace("]", "").split(",");
        
        List<String> lista = new LinkedList();
        lista.addAll(Arrays.asList(body));
        Collections.sort(lista);
        this.select = "<select name='listaClusters' class='form-control'>";
        for(String s: lista){
            this.select += "<option value='"+s+"'>"+s+"</option>";
        }
        this.select += "</select>";
        
    }

    public String getSelect() {
        return select;
    }

    public void setSelect(String select) {
        this.select = select;
    }

    public int getNum_bicluster() {
        return num_bicluster;
    }

    public void setNum_bicluster(int num_bicluster) {
        this.num_bicluster = num_bicluster;
    }

    
    public String getInput() {
        return input;
    }

    public void setInput(String input) {
        this.input = input;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getIc() {
        return ic;
    }

    public void setIc(double ic) {
        this.ic = ic;
    }

    public double getPvalue() {
        return pvalue;
    }

    public void setPvalue(double pvalue) {
        this.pvalue = pvalue;
    }

    public String getNum_biclusters() {
        return num_biclusters;
    }

    public void setNum_biclusters(String num_biclusters) {
        this.num_biclusters = num_biclusters;
    }

    public String getList_biclusters() {
        return list_biclusters;
    }

    public void setList_biclusters(String list_biclusters) {
        this.list_biclusters = list_biclusters;
    }
}
