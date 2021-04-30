package entities;

import java.io.File;
import java.io.Serializable;
import java.util.*;

public class GraphGO implements Serializable {

    private File sOutFile;
    private int size, level;
    private double maxEdge, minEdge;
    private Set<Row> cResult;
    private Set<Cluster> cGroupGenes;
    private Conversion oConversion;

    public GraphGO(File sOutFile, int size, Set<Row> cResult, double minEdge, double maxEdge, Set<Cluster> cGroupGenes, Conversion oConversion) {
        this.sOutFile = sOutFile;
        this.size = size;
        this.level = 100;
        this.minEdge = minEdge;
        this.maxEdge = maxEdge;
        this.cResult = cResult;
        this.cGroupGenes = cGroupGenes;
        this.oConversion = oConversion;
    }

    public double getMinEdge() {
        return minEdge;
    }

    public void setMinEdge(double minEdge) {
        this.minEdge = minEdge;
    }

    public File getsOutFile() {
        return sOutFile;
    }

    public void setsOutFile(File sOutFile) {
        this.sOutFile = sOutFile;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public double getMaxEdge() {
        return maxEdge;
    }

    public void setMaxEdge(double maxEdge) {
        this.maxEdge = maxEdge;
    }

    public Set<Row> getcResult() {
        return cResult;
    }

    public void setcResult(Set<Row> cResult) {
        this.cResult = cResult;
    }

    public Set<Cluster> getcGroupGenes() {
        return cGroupGenes;
    }

    public void setcGroupGenes(Set<Cluster> cGroupGenes) {
        this.cGroupGenes = cGroupGenes;
    }

    public Conversion getoConversion() {
        return oConversion;
    }

    public void setoConversion(Conversion oConversion) {
        this.oConversion = oConversion;
    }
}
