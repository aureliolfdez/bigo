package entities;

import java.io.File;
import java.io.Serializable;
import java.util.*;

public class Ranking implements Serializable {

    private Set<Cluster> cConjuntoTerminos;
    private Set<Row> cResult;
    private Set<Row> cResultToGraph;
    private String sMensaje;
    private File sOutFile;
    double maxIC, maxpValue;

    public Ranking(Set<Cluster> cConjuntoTerminos, double maxIC, File sOutFile, double maxpValue) {
        this.cConjuntoTerminos = cConjuntoTerminos;
        this.sOutFile = sOutFile;
        this.maxIC = maxIC;
        this.maxpValue = maxpValue;
        cResult = new HashSet();
        cResultToGraph = new HashSet();
    }

    public Set<Row> getcResultToGraph() {
        return cResultToGraph;
    }

    public void setcResultToGraph(Set<Row> cResultToGraph) {
        this.cResultToGraph = cResultToGraph;
    }
    
    public double getMaxpValue() {
        return maxpValue;
    }

    public void setMaxpValue(double maxpValue) {
        this.maxpValue = maxpValue;
    }

    public Set<Cluster> getcConjuntoTerminos() {
        return cConjuntoTerminos;
    }

    public void setcConjuntoTerminos(Set<Cluster> cConjuntoTerminos) {
        this.cConjuntoTerminos = cConjuntoTerminos;
    }

    public Set<Row> getcResult() {
        return cResult;
    }

    public void setcResult(Set<Row> cResult) {
        this.cResult = cResult;
    }

    public String getsMensaje() {
        return sMensaje;
    }

    public void setsMensaje(String sMensaje) {
        this.sMensaje = sMensaje;
    }

    public File getsOutFile() {
        return sOutFile;
    }

    public void setsOutFile(File sOutFile) {
        this.sOutFile = sOutFile;
    }

    public double getMaxIC() {
        return maxIC;
    }

    public void setMaxIC(double maxIC) {
        this.maxIC = maxIC;
    }
}
