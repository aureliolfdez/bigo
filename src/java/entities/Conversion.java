package entities;

import java.io.Serializable;
import java.util.*;

public class Conversion implements Serializable {

    /*
    cGroupGenes --> Set of all genes clusters.
    dataDir --> Folder where all clusters (1 x cluster) or if the txt file with all the clusters (complete).
    csvConversion --> CSV file with structure (gene; genSynonyms) to convert.
    bConversion --> Boolean indicating whether the user wants to convert the nomenclature of their genes or not. If you want to convert the CSV file you have to do it.
    */
    private Set<Cluster> cGroupGenes;          //List of all gene clusters.
    private String dataDir, csvConversion;
    private boolean bConversion;

    public Conversion(String dataDir, Boolean bConversion, String csvConversion) {
        this.cGroupGenes = new HashSet();
        this.dataDir = dataDir;
        this.bConversion = bConversion;
        this.csvConversion = csvConversion;
    }

    public Set<Cluster> getcGroupGenes() {
        return cGroupGenes;
    }

    public void setcGroupGenes(Set<Cluster> cGroupGenes) {
        this.cGroupGenes = cGroupGenes;
    }

    public String getDataDir() {
        return dataDir;
    }

    public void setDataDir(String dataDir) {
        this.dataDir = dataDir;
    }

    public String getCsvConversion() {
        return csvConversion;
    }

    public void setCsvConversion(String csvConversion) {
        this.csvConversion = csvConversion;
    }

    public boolean isbConversion() {
        return bConversion;
    }

    public void setbConversion(boolean bConversion) {
        this.bConversion = bConversion;
    }
}
