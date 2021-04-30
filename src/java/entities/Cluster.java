package entities;

import java.io.Serializable;
import java.util.*;

public class Cluster implements Serializable {
    // For a group of GO Terms.
    Set<Row> cBicluster;
    String sNameBicluster;
    
    // For a group of genes.
    Set<String> cGenes;
        
    //CONSTRUCTOR: For a group of GO Terms.
    public Cluster(Set<Row> cBicluster, String sNameBicluster){
        this.cBicluster=cBicluster;
        this.sNameBicluster=sNameBicluster;
    }
    
    //CONSTRUCTOR: For a group of genes.
    public Cluster(String sNameBicluster){
        this.cGenes = new HashSet();
        this.sNameBicluster=sNameBicluster;
    }

    public String getsNameBicluster() {
        return sNameBicluster;
    }

    public void setsNameBicluster(String sNameBicluster) {
        this.sNameBicluster = sNameBicluster;
    }

    public Set<Row> getcBicluster() {
        return cBicluster;
    }

    public void anadirGen(String gen){
        this.cGenes.add(gen);
    }

    public Set<String> getcGenes() {
        return cGenes;
    }

    public void setcGenes(Set<String> cGenes) {
        this.cGenes = cGenes;
    }    
    
}
