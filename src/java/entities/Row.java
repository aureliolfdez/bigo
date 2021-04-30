package entities;

import java.io.Serializable;
import java.util.*;

public class Row implements Comparable, Serializable {
    private String idGo, attrib_name;
    private int popTotal, popTerm, iNumBiclusters;
    private double pValue, pValueAdjusted, pValueMin;
    private List<String> lBiclusters;

    public Row(String idGo, int popTotal, int popTerm, double pValue, double pValueAdjusted, double pValueMin, String attrib_name) {
        this.idGo = idGo;
        this.popTotal = popTotal;
        this.popTerm = popTerm;
        this.attrib_name = attrib_name;
        this.pValue = pValue;
        this.pValueAdjusted = pValueAdjusted;
        this.pValueMin = pValueMin;
        iNumBiclusters = 0; //iNumBiclusters counts the number of clusters found this row.
        lBiclusters = new LinkedList();
    }

    public void setiNumBiclusters(int iNumBiclusters) {
        this.iNumBiclusters = iNumBiclusters;
    }

    public List<String> getlBiclusters() {
        return lBiclusters;
    }

    public void setlBiclusters(List<String> lBiclusters) {
        this.lBiclusters = lBiclusters;
    }

    public void addNameBicluster(String sName) {
        lBiclusters.add(sName);
    }

    public String getIdGo() {
        return idGo;
    }

    public void setIdGo(String idGo) {
        this.idGo = idGo;
    }

    public String getAttrib_name() {
        return attrib_name;
    }

    public void setAttrib_name(String attrib_name) {
        this.attrib_name = attrib_name;
    }

    public int getPopTotal() {
        return popTotal;
    }

    public void setPopTotal(int popTotal) {
        this.popTotal = popTotal;
    }

    public int getPopTerm() {
        return popTerm;
    }

    public void setPopTerm(int popTerm) {
        this.popTerm = popTerm;
    }

    public void upOutBicluster() {
        this.iNumBiclusters += 1;
    }
    
    public int getiNumBiclusters() {
        return iNumBiclusters;
    }

    public double getpValue() {
        return pValue;
    }

    public void setpValue(double pValue) {
        this.pValue = pValue;
    }

    public double getpValueAdjusted() {
        return pValueAdjusted;
    }

    public void setpValueAdjusted(double pValueAdjusted) {
        this.pValueAdjusted = pValueAdjusted;
    }

    public double getpValueMin() {
        return pValueMin;
    }

    public void setpValueMin(double pValueMin) {
        this.pValueMin = pValueMin;
    }
    
    // IC: Occurrence probability (- ln(Pop.Term / Pop.Total))
    // We round to three decimal places
    public double getIC(){
        return Math.rint(-Math.log((double)this.getPopTerm()/(double)this.getPopTotal())*1000)/1000;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 89 * hash + Objects.hashCode(this.attrib_name);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Row other = (Row) obj;
        if (!Objects.equals(this.attrib_name, other.attrib_name)) {
            return false;
        }
        return true;
    }
    
    

    @Override
    public String toString() {
        return "ID=" + this.getIdGo() + ", PopTotal=" + this.getPopTotal() + ", PopTerm=" + this.getPopTerm() + ", attrib_name=" + this.getAttrib_name() + ", biclusterOut=" + iNumBiclusters;
    }

    @Override
    public int compareTo(Object o) {
        Row ob = (Row)o;
        int res;
        if(this.getiNumBiclusters()<ob.getiNumBiclusters()){
            res = -1;
        }else if(this.getiNumBiclusters()>ob.getiNumBiclusters()){
            res = 1;
        }else{
            res = 0;
        }
        return res;
    }
}
