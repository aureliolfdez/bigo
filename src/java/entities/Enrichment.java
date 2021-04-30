package entities;

import java.io.Serializable;

public class Enrichment implements Serializable {
    private String dataDir, outDir;
    
    public Enrichment(String dataDir, String outDir){
        this.dataDir = dataDir;
        this.outDir = outDir;
    }

    public String getDataDir() {
        return dataDir;
    }

    public void setDataDir(String dataDir) {
        this.dataDir = dataDir;
    }

    public String getOutDir() {
        return outDir;
    }

    public void setOutDir(String outDir) {
        this.outDir = outDir;
    }        
}
