package entities;

import java.io.Serializable;

public class Ontologizer extends Enrichment implements Serializable  {
    
    private String annoFile, oboFile, popFile, correctionTest, threshold, calculation;
    
    public Ontologizer(String dataDir,String outDir){
        super(dataDir,outDir); 
    }
    
    public Ontologizer(String dataDir, String outDir, String annoFile, String oboFile, String popFile, String correctionTest, String threshold, String calculation){
        super(dataDir,outDir);        
        this.annoFile = annoFile;
        this.oboFile = oboFile;
        this.popFile = popFile;
        this.correctionTest = correctionTest;
        this.threshold = threshold;
        this.calculation = calculation;
    }

    public String getAnnoFile() {
        return annoFile;
    }

    public void setAnnoFile(String annoFile) {
        this.annoFile = annoFile;
    }

    public String getOboFile() {
        return oboFile;
    }

    public void setOboFile(String oboFile) {
        this.oboFile = oboFile;
    }

    public String getPopFile() {
        return popFile;
    }

    public void setPopFile(String popFile) {
        this.popFile = popFile;
    }

    public String getCorrectionTest() {
        return correctionTest;
    }

    public void setCorrectionTest(String correctionTest) {
        this.correctionTest = correctionTest;
    }

    public String getThreshold() {
        return threshold;
    }

    public void setThreshold(String threshold) {
        this.threshold = threshold;
    }

    public String getCalculation() {
        return calculation;
    }

    public void setCalculation(String calculation) {
        this.calculation = calculation;
    }     
}
