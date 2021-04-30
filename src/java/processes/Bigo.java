package processes;

import entities.*;
import java.io.*;
import java.util.*;

public class Bigo implements Serializable, Cloneable {

    private String sDataDir, sFolder, sAnnoFile, sOboFile, sPopFile, sCorrection, sThreshold, sCalculation, sOutFile, sOutFileGraph, csvConversion, sConversion, sGenesCsv, sSeparator;
    private double maxIC, confidenceFactor, maxEdge, minEdge;
    private int level, minLevel, levelGraph;
    private boolean bConversion;
    private char separator;
    private Set<Cluster> cConjuntoTerminos; // Conjunto que almacenara los distintos clusters. Cada conjunto esta relacionado con un cluster. 
    private Input input;
    private Set<Cluster> cGroupGenes;
    private Enrichment enrich;
    private Processing oPre;
    private Analysis oAnalysis;
    private Ranking ranking_base, ranking;
    private GraphGO oGrafo;
    private Output oOutput_base, oOutput;
    // Para el guardado de los rankings diferenciando las stopwords y las uniques
    private int stopwords, uniques;

    public Bigo(String sDataDir, String sFolder, String sAnnoFile, String sOboFile, String sPopFile, String sCorrection, String sThreshold, String sCalculation, String sOutFile, String sOutFileGraph, double maxIC, int level, double maxEdge, double minEdge, String sConversion, String sGenesCsv, String sSeparator, double confidenceFactor, int minLevel) {
        this.sDataDir = sDataDir;
        this.sFolder = sFolder;
        this.sAnnoFile = sAnnoFile;
        this.sOboFile = sOboFile;
        this.sPopFile = sPopFile;
        this.sCorrection = sCorrection;
        this.sThreshold = sThreshold;
        this.sCalculation = sCalculation;
        this.sOutFile = sOutFile;
        this.sOutFileGraph = sOutFileGraph;
        this.maxIC = maxIC;
        this.level = level;
        this.maxEdge = maxEdge;
        this.minEdge = minEdge;
        bConversion = false;
        csvConversion = "";
        this.sConversion = sConversion;
        this.sGenesCsv = sGenesCsv;
        this.sSeparator = sSeparator;
        this.cConjuntoTerminos = new HashSet();
        this.input = null;
        this.cGroupGenes = null;
        this.enrich = null;
        this.oPre = null;
        this.oAnalysis = null;
        this.ranking_base = null;
        this.ranking = null;
        this.oGrafo = null;
        this.oOutput_base = null;
        this.oOutput = null;
        this.confidenceFactor = confidenceFactor;
        this.minLevel = minLevel;
        this.levelGraph = 100;
        this.stopwords = 0;
        this.uniques = 0;
    }

    //Ver ExecuteNewEnrichmentAction.java --> executeBigo()
    //sDataDir --> dataDirProvide
    //sFolder --> outDirProvide
    //outFile --> generacion del ranking
    //sOutFileGraph --> generacion grafo
    //maxIC --> 9999
    //level --> 101
    //maxEdge --> 100
    //minEdge --> 0
    //confidenceFactor --> Filtrado de pvalue (1)
    //minLevel --> Filtado level (0)    
    public Bigo(String sDataDir, String sFolder, String sOutFile, String sOutFileGraph, double maxIC, int level, double maxEdge, double minEdge, double confidenceFactor, int minLevel) {
        this.sDataDir = sDataDir;
        this.sFolder = sFolder;
        this.sOutFile = sOutFile;
        this.sOutFileGraph = sOutFileGraph;
        this.maxIC = maxIC;
        this.level = level;
        this.maxEdge = maxEdge;
        this.minEdge = minEdge;
        this.cConjuntoTerminos = new HashSet();
        this.input = null;
        this.cGroupGenes = null;
        this.enrich = null;
        this.oPre = null;
        this.oAnalysis = null;
        this.ranking_base = null;
        this.ranking = null;
        this.oGrafo = null;
        this.oOutput_base = null;
        this.oOutput = null;
        this.confidenceFactor = confidenceFactor;
        this.minLevel = minLevel;
        this.levelGraph = 100;
        this.stopwords = 0;
        this.uniques = 0;
        this.bConversion = false;
        this.sConversion = "n";
        this.csvConversion = "";
        this.sGenesCsv = "";
        this.sSeparator = "";        
        
    }
    
    public int getStopwords() {
        return stopwords;
    }

    public void setStopwords(int stopwords) {
        this.stopwords = stopwords;
    }

    public int getUniques() {
        return uniques;
    }

    public void setUniques(int uniques) {
        this.uniques = uniques;
    }

    public double getMinEdge() {
        return minEdge;
    }

    public void setMinEdge(double minEdge) {
        this.minEdge = minEdge;
    }
    
    public int getLevelGraph() {
        return levelGraph;
    }

    public void setLevelGraph(int levelGraph) {
        this.levelGraph = levelGraph;
    }

    public int getMinLevel() {
        return minLevel;
    }

    public void setMinLevel(int minLevel) {
        this.minLevel = minLevel;
    }

    public double getConfidenceFactor() {
        return confidenceFactor;
    }

    public void setConfidenceFactor(double confidenceFactor) {
        this.confidenceFactor = confidenceFactor;
    }

    public String getsDataDir() {
        return sDataDir;
    }

    public void setsDataDir(String sDataDir) {
        this.sDataDir = sDataDir;
    }

    public String getsFolder() {
        return sFolder;
    }

    public void setsFolder(String sFolder) {
        this.sFolder = sFolder;
    }

    public String getsAnnoFile() {
        return sAnnoFile;
    }

    public void setsAnnoFile(String sAnnoFile) {
        this.sAnnoFile = sAnnoFile;
    }

    public String getsOboFile() {
        return sOboFile;
    }

    public void setsOboFile(String sOboFile) {
        this.sOboFile = sOboFile;
    }

    public String getsPopFile() {
        return sPopFile;
    }

    public void setsPopFile(String sPopFile) {
        this.sPopFile = sPopFile;
    }

    public String getsCorrection() {
        return sCorrection;
    }

    public void setsCorrection(String sCorrection) {
        this.sCorrection = sCorrection;
    }

    public String getsThreshold() {
        return sThreshold;
    }

    public void setsThreshold(String sThreshold) {
        this.sThreshold = sThreshold;
    }

    public String getsCalculation() {
        return sCalculation;
    }

    public void setsCalculation(String sCalculation) {
        this.sCalculation = sCalculation;
    }

    public String getsOutFile() {
        return sOutFile;
    }

    public void setsOutFile(String sOutFile) {
        this.sOutFile = sOutFile;
    }

    public String getsOutFileGraph() {
        return sOutFileGraph;
    }

    public void setsOutFileGraph(String sOutFileGraph) {
        this.sOutFileGraph = sOutFileGraph;
    }

    public String getCsvConversion() {
        return csvConversion;
    }

    public void setCsvConversion(String csvConversion) {
        this.csvConversion = csvConversion;
    }

    public String getsConversion() {
        return sConversion;
    }

    public void setsConversion(String sConversion) {
        this.sConversion = sConversion;
    }

    public String getsGenesCsv() {
        return sGenesCsv;
    }

    public void setsGenesCsv(String sGenesCsv) {
        this.sGenesCsv = sGenesCsv;
    }

    public String getsSeparator() {
        return sSeparator;
    }

    public void setsSeparator(String sSeparator) {
        this.sSeparator = sSeparator;
    }

    public double getMaxIC() {
        return maxIC;
    }

    public void setMaxIC(double maxIC) {
        this.maxIC = maxIC;
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

    public boolean isbConversion() {
        return bConversion;
    }

    public void setbConversion(boolean bConversion) {
        this.bConversion = bConversion;
    }

    public char getSeparator() {
        return separator;
    }

    public void setSeparator(char separator) {
        this.separator = separator;
    }

    public Set<Cluster> getcConjuntoTerminos() {
        return cConjuntoTerminos;
    }

    public void setcConjuntoTerminos(Set<Cluster> cConjuntoTerminos) {
        this.cConjuntoTerminos = cConjuntoTerminos;
    }

    public Input getInput() {
        return input;
    }

    public void setInput(Input input) {
        this.input = input;
    }

    public Set<Cluster> getcGroupGenes() {
        return cGroupGenes;
    }

    public void setcGroupGenes(Set<Cluster> cGroupGenes) {
        this.cGroupGenes = cGroupGenes;
    }

    public Enrichment getEnrich() {
        return enrich;
    }

    public void setEnrich(Enrichment enrich) {
        this.enrich = enrich;
    }

    public Processing getoPre() {
        return oPre;
    }

    public void setoPre(Processing oPre) {
        this.oPre = oPre;
    }

    public Analysis getoAnalysis() {
        return oAnalysis;
    }

    public void setoAnalysis(Analysis oAnalysis) {
        this.oAnalysis = oAnalysis;
    }

    public Ranking getRanking_base() {
        return ranking_base;
    }

    public void setRanking_base(Ranking ranking_base) {
        this.ranking_base = ranking_base;
    }

    public Ranking getRanking() {
        return ranking;
    }

    public void setRanking(Ranking ranking) {
        this.ranking = ranking;
    }

    public GraphGO getoGrafo() {
        return oGrafo;
    }

    public void setoGrafo(GraphGO oGrafo) {
        this.oGrafo = oGrafo;
    }

    public Output getoOutput_base() {
        return oOutput_base;
    }

    public void setoOutput_base(Output oOutput_base) {
        this.oOutput_base = oOutput_base;
    }

    public Output getoOutput() {
        return oOutput;
    }

    public void setoOutput(Output oOutput) {
        this.oOutput = oOutput;
    }

    public void startCreateEnrichment(String pathSesion) throws IOException {
        if (sConversion.equals("y")) {
            bConversion = true;
            csvConversion = sGenesCsv;
            separator = sSeparator.charAt(0);
        } else {
            separator = sSeparator.charAt(0);
        }

        /*
         ####################################
         # CONVERSIÓN DE GENES GENERALIZADA #
         ####################################
         Permite modificar las anotaciones de los genes a cualquier tipo de anotacio que el usuario desee.
         Si el usuario no desea modificar dichas anotaciones no se modificarán.
         Hay un archivo "genes.csv" que incluira en la primera columna las anotaciones de los genes originales y en la segunda su sinonimo.
         Este archivo se usara como base para la conversion y si desea convertirlo el usuario debera de realizar este fichero.
         */
        input = new Input(new Conversion(sDataDir, bConversion, csvConversion), separator);
        input.start();       //En funcion de si el usuario quiere convertirlo o no.        
        cGroupGenes = input.getoConversion().getcGroupGenes();

        /*
         #######################
         # EXECUTE ONTOLOGIZER #
         #######################
         Con los nuevos genes con notacion FlyBase, ejecutamos Ontologizer para proseguir en materia como la construccion del ranking y grafos, en funcion de todos los parametros
         necesarios para la ejecucion del mismo.        
         */
        enrich = new Ontologizer(sDataDir, sFolder, sAnnoFile, sOboFile, sPopFile, sCorrection, sThreshold, sCalculation);
        oPre = new Processing(cConjuntoTerminos, sFolder, input.getoConversion());
        oAnalysis = new Analysis(enrich, oPre);

        if (oAnalysis.start()) { // Si existen biclusters generados por Ontologizer en la carpeta sFolder los procesamos.
            try {
                if (cConjuntoTerminos.isEmpty()) { //Si existen biclusters.
                    System.out.println("No data biclusters found.");
                }
            } catch (Exception e) {
                System.out.println("No data biclusters found.");
                System.out.println(e.getMessage());
            }
        }
    }
    
    public void startCreateEnrichmentProvide(String pathSesion) throws IOException {
        separator = '\0';
        /*
         ####################################
         # CONVERSIÓN DE GENES GENERALIZADA #
         ####################################
         Permite modificar las anotaciones de los genes a cualquier tipo de anotacio que el usuario desee.
         Si el usuario no desea modificar dichas anotaciones no se modificarán.
         Hay un archivo "genes.csv" que incluira en la primera columna las anotaciones de los genes originales y en la segunda su sinonimo.
         Este archivo se usara como base para la conversion y si desea convertirlo el usuario debera de realizar este fichero.
         */
        input = new Input(new Conversion(sDataDir, bConversion, csvConversion), separator);
        input.start();       //En funcion de si el usuario quiere convertirlo o no.        
        cGroupGenes = input.getoConversion().getcGroupGenes();

        /*
         #######################
         # EXECUTE ONTOLOGIZER #
         #######################
         Con los nuevos genes con notacion FlyBase, ejecutamos Ontologizer para proseguir en materia como la construccion del ranking y grafos, en funcion de todos los parametros
         necesarios para la ejecucion del mismo.        
         */
        enrich = new Ontologizer(sDataDir, sFolder, sAnnoFile, sOboFile, sPopFile, sCorrection, sThreshold, sCalculation);
        oPre = new Processing(cConjuntoTerminos, sFolder, input.getoConversion());
        oAnalysis = new Analysis(enrich, oPre);

        if (oAnalysis.startProvide()) { // Si existen biclusters generados por Ontologizer en la carpeta sFolder los procesamos.
            try {
                if (cConjuntoTerminos.isEmpty()) { //Si existen biclusters.
                    System.out.println("No data biclusters found.");
                }
            } catch (Exception e) {
                System.out.println("No data biclusters found.");
                System.out.println(e.getMessage());
            }
        }
    }

    public void startCreateRanking(String base, Boolean bExecute) throws Exception {
        try {
            /*
             - Nobase: UN Ranking filtrado y un grafo filtrado.
             - El base no lo creamos porque ya se ha creado anteriormente.
             */

            if (base.equals("base") && !bExecute) {
                //Creamos el ranking sin filtrado
                ranking_base = new Ranking(cConjuntoTerminos, maxIC, new File(sOutFile), confidenceFactor);
                oOutput_base = new Output(null, ranking_base);
                oOutput_base.startRanking(base);
                
                ranking = new Ranking(cConjuntoTerminos, maxIC, new File(sOutFile), confidenceFactor);
                this.oOutput = new Output(null, ranking);
                oOutput.startRanking("nobase");
                
            } else if (base.equals("nobase")) {
                //Creamos el ranking filtrado
                ranking = new Ranking(cConjuntoTerminos, maxIC, new File(sOutFile), confidenceFactor);
                this.oOutput = new Output(null, ranking);
                oOutput.startRanking(base);
            }
        } catch (Exception e) {
            System.out.println("No data biclusters found.");
            System.out.println(e.getMessage());
        }
    }

    public String startCreateGraph(String base, String savedIc, String savedMinLevel, String savedLevel, String savedConfidence, String savedStopwords, String savedUniques) throws Exception {
        String salida = "";
       
        try {
            if (base.equals("base")) {
                System.out.println("Crea grafo");
                this.oGrafo = new GraphGO(new File(sOutFileGraph), cConjuntoTerminos.size(), ranking_base.getcResultToGraph(), minEdge, maxEdge, cGroupGenes, input.getoConversion());
                oOutput_base.setGrafo(oGrafo);
                salida = oOutput_base.startGraphWeb(base, savedIc, savedMinLevel, savedLevel, savedConfidence, savedStopwords, savedUniques);
            } else { 
                this.oGrafo = new GraphGO(new File(sOutFileGraph), cConjuntoTerminos.size(), ranking.getcResultToGraph(), minEdge, maxEdge, cGroupGenes, input.getoConversion());
                oOutput.setGrafo(oGrafo);     
                salida = oOutput.startGraphWeb(base, savedIc, savedMinLevel, savedLevel, savedConfidence, savedStopwords, savedUniques);
            }
        } catch (Exception e) {
            System.out.println("No data biclusters found.");
            System.out.println(e.getMessage());
        }
        return salida;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 37 * hash + (int) (Double.doubleToLongBits(this.maxIC) ^ (Double.doubleToLongBits(this.maxIC) >>> 32));
        hash = 37 * hash + (int) (Double.doubleToLongBits(this.confidenceFactor) ^ (Double.doubleToLongBits(this.confidenceFactor) >>> 32));
        hash = 37 * hash + this.level;
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        boolean resultado = false;
        if (obj instanceof Bigo) {
            Bigo b = (Bigo) obj;
            if (this.getMaxIC() == b.getMaxIC() && this.getLevel() == b.getLevel() && this.getConfidenceFactor() == b.getConfidenceFactor()) {
                resultado = true;
            }
        }
        return resultado;
    }

    public Bigo clone() {
        Bigo clon = new Bigo(this.sDataDir, this.sFolder, this.sAnnoFile, this.sOboFile, this.sPopFile, this.sCorrection, this.sThreshold, this.sCalculation, this.sOutFile, this.sOutFileGraph, this.maxIC, this.level, this.maxEdge, this.minEdge, this.sConversion, this.sGenesCsv, this.sSeparator, this.confidenceFactor, this.minLevel);
        clon.setCsvConversion(this.getCsvConversion());
        clon.setbConversion(this.isbConversion());
        clon.setSeparator(this.getSeparator());
        clon.setConfidenceFactor(this.getConfidenceFactor());
        clon.setcConjuntoTerminos(this.getcConjuntoTerminos());
        clon.setInput(this.getInput());
        clon.setcGroupGenes(this.getcGroupGenes());
        clon.setEnrich(this.getEnrich());
        clon.setoPre(this.getoPre());
        clon.setoAnalysis(this.getoAnalysis());
        clon.setRanking_base(this.getRanking_base());
        clon.setRanking(this.getRanking());
        clon.setoGrafo(this.getoGrafo());
        clon.setoOutput_base(this.getoOutput_base());
        clon.setoOutput(this.getoOutput());
        return clon;
    }
}
