package processes;

/*
 The "output" process involves the generation of ranking, graphs and .CSV files
 with plus information.
 */
import entities.Cluster;
import entities.GraphGO;
import entities.Ranking;
import entities.GraphNodeRelation;
import entities.Row;
import java.io.*;
import java.text.DecimalFormat;
import java.util.*;

public class Output implements Serializable {

    private GraphGO grafo;
    private Ranking rank;
    private boolean bCargaImagenGrafo;

    public Output(GraphGO grafo, Ranking rank) {
        this.grafo = grafo;
        this.rank = rank;
        this.bCargaImagenGrafo = false;
    }

    public boolean isbCargaImagenGrafo() {
        return bCargaImagenGrafo;
    }

    public void setbCargaImagenGrafo(boolean bCargaImagenGrafo) {
        this.bCargaImagenGrafo = bCargaImagenGrafo;
    }

    public GraphGO getGrafo() {
        return grafo;
    }

    public void setGrafo(GraphGO grafo) {
        this.grafo = grafo;
    }

    public Ranking getRank() {
        return rank;
    }

    public void setRank(Ranking rank) {
        this.rank = rank;
    }

    /*
     ###########
     # RANKING #
     ###########
     */
 /* 
     * 1. I have a result set (cResult) where we stored all rows clusters with:
     *      - Number of clusters in wich they find themselves.
     *      - Total number of clusters in which the find themselves.
     * 
     * 2. I do loop around the set clusters (cConjuntoTerminos). For each row in a cluster, I check if that row exists in the result set (cResult).
     *      - If there isn't:
     *              - Increase by one the number of cluster where the row is located.
     *              - I add the name cluster that this looping to the list of names that each row clusters.
     *      - If there is:
     *              - I need to get the row to modify the result set directly in the set.
     *              - Increase by one the number of cluster where the row is located.
     *              - I add the name cluster that this looping to the list of names that each row clusters.
     * 
     * 3. Finally, I add all the already modified, the result set (cResult).
     * This is what would cause the common rows of the two sets aren't changed and which have been modified by the cResult.
     * The opposite, if they aren't common, and modified rows will be added to the set cResult.
     */
    // Main method for creating ranking.
    public void startRanking(String base) throws IOException {
        /* RANKING */
        this.getRank().setsMensaje("Group of genes = " + (this.getRank().getcConjuntoTerminos().size()) + "\n\nID;Name;IC(x);PvalueAdjusted;NumberBiclustersView;BiclustersViewList\n");
        gestionFilas(base);
        this.getRank().setsMensaje(printSet(this.getRank().getcResult(), this.getRank().getsMensaje(), this.getRank().getcConjuntoTerminos().size(), this.getRank().getMaxIC(), this.getRank().getMaxpValue()));
        imprimeSalida(this.getRank().getsOutFile(), this.getRank().getsMensaje());
    }

    public void gestionFilas(String base) {
        Iterator it = this.getRank().getcConjuntoTerminos().iterator();
        while (it.hasNext()) {
            Cluster cBic = ((Cluster) it.next());
            Set<Row> cConjuntoFilas = cBic.getcBicluster();
            for (Row cFila : cConjuntoFilas) {
                if (this.getRank().getcResult().contains(cFila)) {                    
                    Row rRecuperacion = recuperarFilaResult(this.getRank().getcResult(), cFila);
                    //2018-04-23 Max pValue
                    /*if(cFila.getpValueAdjusted()>rRecuperacion.getpValueAdjusted()){
                        rRecuperacion.setpValueAdjusted(cFila.getpValueAdjusted());
                        rRecuperacion.setpValue(cFila.getpValue());
                        rRecuperacion.setpValueMin(cFila.getpValueMin());
                    }*/
                    
                    if (base.equals("base")) {
                        rRecuperacion.upOutBicluster();
                        rRecuperacion.getlBiclusters().add(cBic.getsNameBicluster());
                    }
                } else {
                    if (base.equals("base")) {
                        cFila.upOutBicluster();
                        cFila.getlBiclusters().add(cBic.getsNameBicluster());
                    }
                }
            }
            this.getRank().getcResult().addAll(cConjuntoFilas);
        }
    }

    // It's a simply function that returns a row cResult set, if it finds a row that is identical to it (by attrib_name attribute).
    private Row recuperarFilaResult(Set<Row> cResult, Row cFila) {
        Row rDevolver = null;
        Iterator it = cResult.iterator();
        while (it.hasNext() && rDevolver == null) {
            Row r = (Row) it.next();
            if (r.equals(cFila)) {
                rDevolver = r;
            }
        }
        return rDevolver;
    }

    // Save and return a String with what will contain the rank.
    public String printSet(Set<Row> cResult, String sMensaje, int totalBiclusters, double maxIC, double maxpValue) {
        double percentageClusters;
        List<Row> list = new ArrayList(cResult);
        Collections.sort(list);
        for (Row oGo : list) {
            if (oGo.getIC() <= maxIC && oGo.getpValueAdjusted() <= maxpValue) {
                percentageClusters = (oGo.getiNumBiclusters() * 100) / (totalBiclusters + 0.00); // Calculate te percentage of clusters for NumberBiclustersView Rank attribute.
                DecimalFormat formatPer = new DecimalFormat("#.##");
                sMensaje += oGo.getIdGo() + ";" + oGo.getAttrib_name() + ";" + oGo.getIC() + ";" + oGo.getpValueAdjusted() + ";" + (oGo.getiNumBiclusters()) + "/" + totalBiclusters + "(" + formatPer.format(percentageClusters) + "%)" + ";" + oGo.getlBiclusters() + "\n";
                this.getRank().getcResultToGraph().add(oGo);
            }
        }
        sMensaje += "\n\n";
        return sMensaje;
    }

    /*
     ###############
     # END RANKING #
     ###############
     */
 /*
     ##########
     # GRAPHS #
     ##########
     */
    // Main method for creating graphs.
    public String startGraphWeb(String base, String savedIc, String savedMinLevel, String savedLevel, String savedConfidence, String savedStopwords, String savedUniques) throws IOException {

        /* GRAPHS */
        //1. I create the list of possible matches between the number of clusters that we have.
        //The resultGraph variable is the list that we have all the data relating to create of the graph.
        List<String> listaNombres = new ArrayList();
        for (Cluster clust : this.getGrafo().getoConversion().getcGroupGenes()) {
            listaNombres.add(clust.getsNameBicluster());
        }

        List<GraphNodeRelation> resultGraph = createGraph(this.getGrafo().getcResult(), listaNombres);

        //2. The cResult variable, I get the biclusters list per row.
        List<GraphNodeRelation> posibilities = createPosibilities(this.getGrafo().getcResult(), this.getGrafo().getLevel());

        //3. Calculate the edges graph.
        calcularAristas(resultGraph, posibilities);
        Collections.sort(resultGraph);

        String salida = crearEstructuraGrafoWeb(resultGraph, this.getGrafo().getSize(), this.getGrafo().getMinEdge(), this.getGrafo().getMaxEdge(), this.getGrafo().getcGroupGenes());

        if (base.equals("base")) {
            imprimeSalida(new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + "base" + File.separator + "webgraph-" + this.getGrafo().getMaxEdge() + ".js"), salida);
        } else {
            String dirRank = savedIc + "-" + savedMinLevel + "-" + savedLevel + "-" + savedConfidence + "-" + savedStopwords + "-" + savedUniques;
            imprimeSalida(new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + dirRank + File.separator + "webgraph-" + this.getGrafo().getMaxEdge() + ".js"), salida);
        }

        return salida;
    }

    public void downloadGraphComplete() throws IOException {
        List<String> listaNombres = new ArrayList();
        for (Cluster clust : this.getGrafo().getoConversion().getcGroupGenes()) {
            listaNombres.add(clust.getsNameBicluster());
        }

        List<GraphNodeRelation> resultGraph = createGraph(this.getGrafo().getcResult(), listaNombres);

        List<GraphNodeRelation> posibilities = createPosibilities(this.getGrafo().getcResult(), this.getGrafo().getLevel());

        calcularAristas(resultGraph, posibilities);
        Collections.sort(resultGraph);

        String salida = crearEstructuraFichero(resultGraph, this.getGrafo().getSize(), 0, 100);
        File completedot = new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + "all.dot");
        imprimeSalida(completedot, salida);
    }

    public void downloadGraphFiltered() throws IOException {
        List<String> listaNombres = new ArrayList();
        for (Cluster clust : this.getGrafo().getoConversion().getcGroupGenes()) {
            listaNombres.add(clust.getsNameBicluster());
        }

        List<GraphNodeRelation> resultGraph = createGraph(this.getGrafo().getcResult(), listaNombres);

        List<GraphNodeRelation> posibilities = createPosibilities(this.getGrafo().getcResult(), this.getGrafo().getLevel());

        calcularAristas(resultGraph, posibilities);
        Collections.sort(resultGraph);

        //4. Create the graph files.
        String salida = crearEstructuraFichero(resultGraph, this.getGrafo().getSize(), this.getGrafo().getMinEdge(), this.getGrafo().getMaxEdge());
        File graphdot = new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + "graph-" + this.getGrafo().getMaxEdge() + ".dot");
        imprimeSalida(graphdot, salida);
    }

    public void downloadInfoGraph() throws IOException {
        List<String> listaNombres = new ArrayList();
        for (Cluster clust : this.getGrafo().getoConversion().getcGroupGenes()) {
            listaNombres.add(clust.getsNameBicluster());
        }

        List<GraphNodeRelation> resultGraph = createGraph(this.getGrafo().getcResult(), listaNombres);

        //2. The cResult variable, I get the biclusters list per row.
        List<GraphNodeRelation> posibilities = createPosibilities(this.getGrafo().getcResult(), this.getGrafo().getLevel());

        //3. Calculate the edges graph.
        calcularAristas(resultGraph, posibilities);
        Collections.sort(resultGraph);

        String salida = crearEstructuraCsv(resultGraph, this.getGrafo().getSize(), this.getGrafo().getMinEdge(), this.getGrafo().getMaxEdge(), this.getGrafo().getcGroupGenes());
        imprimeSalida(new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + "general.csv"), salida);
        salida = crearEstructuraGenesCsv(resultGraph, this.getGrafo().getSize(), this.getGrafo().getMinEdge(), this.getGrafo().getMaxEdge(), this.getGrafo().getcGroupGenes());
        imprimeSalida(new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + "genes.csv"), salida);
        salida = crearEstructuraTermsCsv(resultGraph, this.getGrafo().getSize(), this.getGrafo().getMinEdge(), this.getGrafo().getMaxEdge(), this.getGrafo().getcGroupGenes());
        imprimeSalida(new File(this.getGrafo().getsOutFile().getParent() + File.separator + "graphs" + File.separator + "terms.csv"), salida);

    }

    //Method for creating a list of possible matches between the number of clusters that we have.
    // This list is the one that will modify our list because it's "result".
    private static List<GraphNodeRelation> createGraph(Set<Row> cResult, List<String> listaNombres) {
        List<GraphNodeRelation> resultGraph = new ArrayList();
        for (int i = 0; i < listaNombres.size(); i++) {
            for (int j = 0; j < listaNombres.size(); j++) {
                if (i != j) {
                    String[] pareja = {listaNombres.get(i), listaNombres.get(j)};
                    GraphNodeRelation oVert = new GraphNodeRelation(pareja);
                    for (Row oGo : cResult) {
                        if (oGo.getlBiclusters().contains(listaNombres.get(i))) {
                            oVert.añadirGoNodoA(oGo);
                        }
                        if (oGo.getlBiclusters().contains(listaNombres.get(j))) {
                            oVert.añadirGoNodoB(oGo);
                        }
                    }
                    resultGraph.add(oVert);
                }
            }
        }
        return resultGraph;
    }

    // Method for building clusters pairs existing in the set cResult.
    private static List<GraphNodeRelation> createPosibilities(Set<Row> cResult, int level) {
        List<GraphNodeRelation> posibilities = new ArrayList();
        for (Row oGo : cResult) {
            /*
             oGo.getiNumBiclusters --- 100%
             x             --- level (percentage)
             level * oGo.getiNumBiclusters / 100
             */
            int levelPercentage = ((oGo.getiNumBiclusters() * level)) / 100;
            if (oGo.getiNumBiclusters() > 1 && oGo.getiNumBiclusters() <= levelPercentage) { // I check that we will only take into account the genes are among a number of clusters provided by the user.
                List<String> lBiclusters = oGo.getlBiclusters();
                for (int i = 0; i < lBiclusters.size(); i++) {
                    for (int j = lBiclusters.size() - 1; j > i; j--) {
                        String[] par = {lBiclusters.get(i), lBiclusters.get(j)};
                        posibilities.add(new GraphNodeRelation(par, oGo));
                    }
                }
            }
        }
        return posibilities;
    }

    // In the wake of the "possibilities" list obtained by the set cResult,
    // we increase the number of times the pair of clusters apperars in the resulting list (resultGraph).
    private static void calcularAristas(List<GraphNodeRelation> resultGraph, List<GraphNodeRelation> posibilities) {
        for (GraphNodeRelation oVert : posibilities) {
            int iPos = resultGraph.indexOf(oVert);
            if (iPos != -1) {
                resultGraph.get(resultGraph.indexOf(oVert)).aumentarVeces(); // Increase the number of times a gene apperars in a couple in particular.
                resultGraph.get(resultGraph.indexOf(oVert)).añadirGo(oVert.getListaGo().get(0)); // To this couple, I add the specific GO term.
            }
        }

        // Clean couples who aren't associated GO terms.
        cleanGraph(resultGraph);
    }

    // Method to clear the resulting list (resultGraph) those pairs of clusters that aren't listed among the
    // various possibilities (posibilities).
    private static void cleanGraph(List<GraphNodeRelation> resultGraph) {
        List<GraphNodeRelation> aux0 = new ArrayList();
        for (GraphNodeRelation oVert : resultGraph) {
            if (oVert.getiNumVeces() == 0) {
                aux0.add(oVert);
            }
        }
        resultGraph.removeAll(aux0);
    }

    // Create the file. Referring to dot Graph where there is a restriction according to the number of edge (maxEdge).
    private static String crearEstructuraFichero(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge) {
        String salida = "graph G {\n";
        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            //int maxEdgePercentage = (maxEdge * oVert.getiNumVeces()) / 100;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                salida += oVert.getPareja()[0] + " -- " + oVert.getPareja()[1] + " [label=\"" + oVert.getiNumVeces() + " (" + oVert.getPareja()[0] + " = " + Math.round(oVert.getPorcentajeNodoA() * 100.0) / 100.0 + "% - " + oVert.getPareja()[1] + " = " + Math.round(oVert.getPorcentajeNodoB() * 100.0) / 100.0 + "%) \"]\n";
            }
        }
        salida += "}";
        return salida;
    }

    /*
     Relacion entre clusters ; Nº Terminos GO Comunes ; GO IDs comunes entre clusters ; Nº Terminos GO Cluster A ; Porcentaje de terminos del cluster A que se encuentran en cluster B ; Nº Terminos GO Cluster B ; Porcentaje de terminos del cluster B que se encuentran en cluster A
     {B13, B3} ; 2 ; GO:___, GO:___,... ; 488 ; 60% ; 333 ; 100%
     */
    private static String crearEstructuraCsv(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge, Set<Cluster> cGroupGenes) {
        //String salida = "Relacion entre clusters ; Nº Terminos GO Comunes ; GO IDs comunes entre clusters ; Numero de genes del cluster A ; Lista de genes del cluster A ; Numero de genes del cluster B ; Lista de genes del cluster B ; Nº Terminos GO Cluster A ; Porcentaje de terminos del cluster A que se encuentran en cluster B ; Nº Terminos GO Cluster B ; Porcentaje de terminos del cluster B que se encuentran en cluster A \n";
        String salida = "Node A ; Node B ; Num. Terms A ; Num. Terms B ; % Common terms ; Num. Common terms ; % Common terms in A ; Num. Common terms in A ; % Common terms in B ; Num. Common terms in B ; Num. Genes A ; Num. Genes B ; % Common Genes ; Num. Common Genes ; % Common Genes in A ; Num. Common Genes in A ; % Common Genes in B ; Num. Common Genes in B \n";

        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                int iGenesNodeA = 0, iGenesNodeB = 0;
                String sGenesNodeA = "", sGenesNodeB = "";
                Set<String> genesNodeA = new HashSet<String>();
                Set<String> genesNodeB = new HashSet<String>();
                for (Cluster bi : cGroupGenes) {
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[0])) {
                        iGenesNodeA = bi.getcGenes().size();
                        sGenesNodeA = bi.getcGenes().toString();
                        genesNodeA.addAll(bi.getcGenes());
                    }
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[1])) {
                        iGenesNodeB = bi.getcGenes().size();
                        sGenesNodeB = bi.getcGenes().toString();
                        genesNodeB.addAll(bi.getcGenes());
                    }
                }

                Set<String> commonGenes = new HashSet<String>();
                int iCommonGenesNodeA = 0, iCommonGenesNodeB = 0;
                //Optimizar calculando los genes comunes con el grupo de genes mas pequeño
                if (genesNodeA.size() < genesNodeB.size()) {
                    for (String gen : genesNodeA) {
                        if (genesNodeB.contains(gen)) {
                            commonGenes.add(gen);
                            iCommonGenesNodeA++;
                        }
                    }
                } else {
                    for (String gen : genesNodeB) {
                        if (genesNodeA.contains(gen)) {
                            commonGenes.add(gen);
                            iCommonGenesNodeB++;
                        }
                    }
                }

                for (String gen : genesNodeA) {
                    if (genesNodeB.contains(gen)) {
                        iCommonGenesNodeA++;
                    }
                }
                for (String gen : genesNodeB) {
                    if (genesNodeA.contains(gen)) {
                        iCommonGenesNodeB++;
                    }
                }

                double statisticalMeasurementGenes = ((((((iCommonGenesNodeA + 0.0) * 100.0) / (genesNodeA.size() + 0.0)) * 100.0) / 100.0) + (((((iCommonGenesNodeB + 0.0) * 100.0) / (genesNodeB.size() + 0.0)) * 100.0) / 100.0)) / 2.0;

                double commonGenesinA = ((iCommonGenesNodeA + 0.0) * 100.0) / (genesNodeA.size() + 0.0);
                double commonGenesinB = ((iCommonGenesNodeB + 0.0) * 100.0) / (genesNodeB.size() + 0.0);
                salida += oVert.getPareja()[0] + " ; " + oVert.getPareja()[1] + " ; " + oVert.getListaGoNodoA().size() + " ; " + oVert.getListaGoNodoB().size() + " ; " + Math.round(statisticalMeasurement) + " ; " + oVert.getiNumVeces() + " ; " + Math.round(oVert.getPorcentajeNodoA() * 100.0) / 100.0 + " ; " + oVert.getCommonTermsNodoA() + " ; " + Math.round(oVert.getPorcentajeNodoB() * 100.0) / 100.0 + " ; " + oVert.getCommonTermsNodoB() + " ; " + iGenesNodeA + " ; " + iGenesNodeB + " ; " + Math.round(statisticalMeasurementGenes) + " ; " + commonGenes.size() + " ; " + Math.round(commonGenesinA * 100.0) / 100.0 + " ; " + iCommonGenesNodeA + " ; " + Math.round(commonGenesinB * 100.0) / 100.0 + " ; " + iCommonGenesNodeB + "\n";
            }
        }
        salida += "}";
        return salida;
    }

    private static String crearEstructuraGenesCsv(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge, Set<Cluster> cGroupGenes) {
        //String salida = "Relacion entre clusters ; Nº Terminos GO Comunes ; GO IDs comunes entre clusters ; Numero de genes del cluster A ; Lista de genes del cluster A ; Numero de genes del cluster B ; Lista de genes del cluster B ; Nº Terminos GO Cluster A ; Porcentaje de terminos del cluster A que se encuentran en cluster B ; Nº Terminos GO Cluster B ; Porcentaje de terminos del cluster B que se encuentran en cluster A \n";
        String salida = "Node A ; Node B ; List common genes \n";

        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                Set<String> genesNodeA = new HashSet<String>();
                Set<String> genesNodeB = new HashSet<String>();
                for (Cluster bi : cGroupGenes) {
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[0])) {
                        genesNodeA.addAll(bi.getcGenes());
                    }
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[1])) {
                        genesNodeB.addAll(bi.getcGenes());
                    }
                }

                Set<String> commonGenes = new HashSet<String>();
                //Optimizar calculando los genes comunes con el grupo de genes mas pequeño
                if (genesNodeA.size() < genesNodeB.size()) {
                    for (String gen : genesNodeA) {
                        if (genesNodeB.contains(gen)) {
                            commonGenes.add(gen);
                        }
                    }
                } else {
                    for (String gen : genesNodeB) {
                        if (genesNodeA.contains(gen)) {
                            commonGenes.add(gen);
                        }
                    }
                }

                salida += oVert.getPareja()[0] + " ; " + oVert.getPareja()[1] + " ; " + commonGenes.toString() + "\n";
            }
        }
        salida += "}";
        return salida;
    }

    private static String crearEstructuraTermsCsv(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge, Set<Cluster> cGroupGenes) {
        //String salida = "Relacion entre clusters ; Nº Terminos GO Comunes ; GO IDs comunes entre clusters ; Numero de genes del cluster A ; Lista de genes del cluster A ; Numero de genes del cluster B ; Lista de genes del cluster B ; Nº Terminos GO Cluster A ; Porcentaje de terminos del cluster A que se encuentran en cluster B ; Nº Terminos GO Cluster B ; Porcentaje de terminos del cluster B que se encuentran en cluster A \n";
        String salida = "Node A ; Node B ; List common ID terms ; List common Name terms \n";

        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                String goIdTerms = "[", goNameTerms = "[";
                for (Row oGo : oVert.getListaGo()) {
                    goIdTerms += oGo.getIdGo() + ",";
                    goNameTerms += oGo.getAttrib_name() + ",";
                }
                goIdTerms = goIdTerms.substring(0, goIdTerms.length() - 1);
                goNameTerms = goNameTerms.substring(0, goNameTerms.length() - 1);
                goIdTerms += "]";
                goNameTerms += "]";

                salida += oVert.getPareja()[0] + " ; " + oVert.getPareja()[1] + " ; " + goIdTerms + " ; " + goNameTerms + "\n";
            }
        }
        salida += "}";
        return salida;
    }

    // Save the ranking with nomFich name.
    static void imprimeSalida(File nomFich, String mensaje) throws IOException {
        PrintWriter salida = new PrintWriter(new BufferedWriter(new FileWriter(nomFich, false)));
        try {
            salida.print(mensaje);
            salida.close();
        } catch (Exception e) {
            salida.close();
            System.out.println("Error"+e.getMessage());
        }

    }

    /*
     ##############
     # END GRAPHS #
     ##############
     */
    private String crearEstructuraGrafoWeb(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge, Set<Cluster> cGroupGenes) {
        String salida = "var contentPng, contentJpg; var cy = cytoscape({\n";
        salida += "container: document.getElementById('cy'),\n";
        salida += "ready: function () {\n";
        salida += "window.cy = this;\n";
        salida += "contentPng = cy.png();\n";
        salida += "contentJpg = cy.jpg();\n";
        
        //salida += "$('input[name=contentpng]').val('hola');\n";
        //salida += "var aContentPng = document.getElementsByClassName('contentpng');\n";
        //salida += "console.log($('input[name=contentpng]'));\n";
        //salida += "$(\"#export_form[name=contentpng]\").val(base64);\n";
        salida += "},\n\n";
        salida += "boxSelectionEnabled: true,\n";
        salida += "autounselectify: true,\n\n";
        salida += "style: cytoscape.stylesheet()\n";
        salida += ".selector('node')\n";
        salida += ".css({\n";
        salida += "'border-width': '2',\n";
        salida += "'border-color': '#cccccc',\n";
        salida += "'content': 'data(name)',\n";
        salida += "'text-valign': 'center',\n";
        salida += "'color': '#000000',\n";
        salida += "'background-color': '#b9d0ff',\n";
        salida += "'font-weight': 'bold',\n";
        salida += "'font-size': '12',\n";
        salida += "'width': 'data(widthNode)',\n";
        salida += "'height': 'data(widthNode)'\n";
        salida += "})\n";
        salida += ".selector(\":active\")\n";
        salida += ".css({\n";
        salida += "'overlay-color': 'black',\n";
        salida += "'overlay-padding': 10,\n";
        salida += "'overlay-opacity': 0.25\n";
        salida += "})\n";
        salida += ".selector(':selected')\n";
        salida += ".css({\n";
        salida += "'font-size': '80',\n";
        salida += "'background-color': 'black',\n";
        salida += "'line-color': 'black',\n";
        salida += "'target-arrow-color': 'black',\n";
        salida += "'source-arrow-color': 'black',\n";
        salida += "'text-outline-color': 'black'\n";
        salida += "})\n";
        salida += ".selector('edge')\n";
        salida += ".style({\n";
        salida += "'label': 'data(label)'\n";
        salida += "})\n";
        salida += ".css({\n";
        salida += "'width': 'data(edgeStatistic)',\n";
        salida += "'background-color': '#ffd68e',\n";
        salida += "'line-color': '#ffd68e',\n";
        salida += "'font-weight': 'bold',\n";
        salida += "'font-size': '12'\n";
        salida += "}),\n\n";
        salida += "elements: {\n";
        salida += "nodes: [\n";
        salida += consNodesData(resultGraph, size, minEdge, maxEdge, cGroupGenes);
        salida += "\n ],\n";
        salida += "edges: [ ";
        salida += consEdgesData(resultGraph, size, minEdge, maxEdge, cGroupGenes);
        salida += "\n ] \n";
        salida += "},\n";
        salida += "layout: {\n";
        salida += "name: 'circle',\n";
        salida += "padding: 10\n";
        salida += "}\n";
        salida += "});\n";
        salida += "cy.panzoom({\n";
        salida += "});\n\n";
        salida += "";
        salida += "function printNode(oObjeto) {\n";
        salida += "var genes = '';\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Name of the group of genes'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Node name:</span></td><td>\" + oObjeto.data('clusterName') + \"</td></tr>\";\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Number of the genes included in the node'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Number of genes:</span></td><td>\" + oObjeto.data('numGenes') + \"</td></tr>\";\n";
        salida += "let aGenes = oObjeto.data('listGenes').replace('[', '').replace(']', '');\n";
        salida += "if (aGenes !== '') {\n";
        salida += "aGenes = aGenes.split(',');\n";
        salida += "}\n";
        salida += "let select = \"<select class='form-control'>\";\n";
        salida += "for (let i = 0; i < aGenes.length; i++) {\n";
        salida += "select += '<option value=' + aGenes[i] + '>' + aGenes[i] + '</option>';\n";
        salida += "}\n";
        salida += "select += '</select>';\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='List of the genes included in the node'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> List of genes:</span></td><td>\" + select + \"</td></tr>\";\n";
        salida += "document.getElementById('optionsNetworkGenes').innerHTML += genes;\n";
        salida += "var terminos = '';\n";
        salida += "let aTerms = oObjeto.data('listTerms').replace('[', '').replace(']', '');\n";
        salida += "if (aTerms !== '') {\n";
        salida += "aTerms = aTerms.split(',');\n";
        salida += "}\n";
        salida += "select = \"<select class='form-control'>\";\n";
        salida += "for (let i = 0; i < aTerms.length; i++) {\n";
        salida += "select += '<option value=' + aTerms[i] + '>' + aTerms[i] + '</option>';\n";
        salida += "}\n";
        salida += "select += '</select>';\n";
        salida += "terminos += \"<tr><td><span style=\\\"margin-top: 20px; font-size: 14px; font-weight: bold;\\\"><a href=\\\"#\\\" data-toggle=\\\"tooltip\\\" data-placement=\\\"right\\\" title=\\\"List of the biological terms related with the node\\\"><img src=\\\"images/bigo/info.gif\\\" style=\\\"margin-top: -4px;\\\"></a> List of terms:</span></td><td>\" + select + \"</td></tr>\";\n";
        salida += "terminos += \"<tr><td><span style=\\\"margin-top: 20px; font-size: 14px; font-weight: bold;\\\"><a href=\\\"#\\\" data-toggle=\\\"tooltip\\\" data-placement=\\\"right\\\" title=\\\"Number of the biological terms related with the node\\\"><img src=\\\"images/bigo/info.gif\\\" style=\\\"margin-top: -4px;\\\"></a> Number of terms:</span></td><td>\" + oObjeto.data('numTerms') + \"</td></tr>\";\n";
        salida += "terminos += \"<tr><td><span style=\\\"margin-top: 20px; font-size: 14px; font-weight: bold;\\\"><a href=\\\"#\\\" data-toggle=\\\"tooltip\\\" data-placement=\\\"right\\\" title=\\\"Name of the group of genes\\\"><img src=\\\"images/bigo/info.gif\\\" style=\\\"margin-top: -4px;\\\"></a> Node name:</span></td><td>\" + oObjeto.data('clusterName') + \"</td></tr>\";\n";
        salida += "document.getElementById('optionsNetworkTerms').innerHTML += terminos;\n";
        salida += "}\n\n";
        salida += "";
        salida += "function printEdge(oObjeto) {\n";
        salida += "var genes = '';\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Name of the edge'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Edge name:</span></td><td>\" + oObjeto.data('edgeName') + \"</td></tr>\";\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Number of the genes shared by the nodes connected by the edge'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Number of common genes:</span></td><td>\" + oObjeto.data('numCommonGenes') + \"</td></tr>\";\n";
        salida += "let aCommonGenes = oObjeto.data('listcommonGenes').replace('[', '').replace(']', '');\n";
        salida += "if (aCommonGenes !== '') {\n";
        salida += "aCommonGenes = aCommonGenes.split(',');\n";
        salida += "}\n";
        salida += "let select = \"<select class='form-control'>\";\n";
        salida += "for (let i = 0; i < aCommonGenes.length; i++) {\n";
        salida += "select += '<option value=' + aCommonGenes[i] + '>' + aCommonGenes[i] + '</option>';\n";
        salida += "}\n";
        salida += "select += '</select>';\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='List of the genes shared by the nodes connected by the edge'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> List of common genes:</span></td><td>\" + select + \"</td></tr>\";\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Percentage of genes from node A that are shared with the node B'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Genes from A:</span></td><td>\" + Math.round(oObjeto.data('genesPercentageAB') * 100) / 100 + \" %</td></tr>\";\n";
        salida += "genes += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Percentage of genes from node B that are shared with the node A'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Genes from B:</span></td><td>\" + Math.round(oObjeto.data('genesPercentageBA') * 100) / 100 + \" %</td></tr>\";\n";
        salida += "document.getElementById('optionsNetworkGenes').innerHTML += genes;\n";
        salida += "var terminos = '';\n";
        salida += "terminos += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Name of the edge'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Edge name:</span></td><td>\" + oObjeto.data('edgeName') + \"</td></tr>\";\n";
        salida += "terminos += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='Number of the terms shared by the nodes connected by the edge'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> Number of common terms:</span></td><td>\" + oObjeto.data('numCommonTerms') + \"</td></tr>\";\n";
        salida += "let aCommonTerms = oObjeto.data('listCommonTerms').replace('[', '').replace(']', '');\n";
        salida += "if (aCommonTerms !== '') {\n";
        salida += "aCommonTerms = aCommonTerms.split(',');\n";
        salida += "}\n";
        salida += "select = \"<select class='form-control'>\";\n";
        salida += "for (var i = 0; i < aCommonTerms.length; i++) {\n";
        salida += "select += '<option value=' + aCommonTerms[i] + '>' + aCommonTerms[i] + '</option>';\n";
        salida += "}\n";
        salida += "select += '</select>';\n";
        salida += "terminos += \"<tr><td><span style='margin-top: 20px; font-size: 14px; font-weight: bold;'><a href='#' data-toggle='tooltip' data-placement='right' title='List of the terms shared by the nodes connected by the edge'><img src='images/bigo/info.gif' style='margin-top: -4px;'></a> List of common terms:</span></td><td>\" + select + \"</td></tr>\";\n";
        salida += "terminos += \"<tr><td><span style=\\\"margin-top: 20px; font-size: 14px; font-weight: bold;\\\"><a href=\\\"#\\\" data-toggle=\\\"tooltip\\\" data-placement=\\\"right\\\" title=\\\"Percentage of terms from node A that are shared with the node B\\\"><img src=\\\"images/bigo/info.gif\\\" style=\\\"margin-top: -4px;\\\"></a> Terms from A:</span></td><td>\" + Math.round(oObjeto.data('termsPercentageAB') * 100) / 100 + \" %</td></tr>\";\n";
        salida += "terminos += \"<tr><td><span style=\\\"margin-top: 20px; font-size: 14px; font-weight: bold;\\\"><a href=\\\"#\\\" data-toggle=\\\"tooltip\\\" data-placement=\\\"right\\\" title=\\\"’Percentage of terms from node B that are shared with the node A\\\"><img src=\\\"images/bigo/info.gif\\\" style=\\\"margin-top: -4px;\\\"></a> Terms from B:</span></td><td>\" + Math.round(oObjeto.data('termsPercentageBA') * 100) / 100 + \" %</td></tr>\";\n";
        salida += "document.getElementById('optionsNetworkTerms').innerHTML += terminos;\n";
        salida += "}\n\n";
        salida += "";
        salida += "function clear() {\n";
        salida += "document.getElementById('optionsNetworkGenes').innerHTML = '';\n";
        salida += "document.getElementById('optionsNetworkTerms').innerHTML = '';\n";
        salida += "}\n\n";
        salida += "";
        salida += "cy.on('tap', 'edge', function () {\n";
        salida += "clear();\n";
        salida += "printEdge(this);\n";
        salida += "document.getElementById('optionsEnrichment').style.visibility = 'visible';\n";
        salida += "document.getElementById('optionsEnrichment').style.position = 'static';\n";
        salida += "});\n\n";
        salida += "";
        salida += "cy.on('tap', 'node', function () {\n";
        salida += "clear();\n";
        salida += "printNode(this);\n";
        salida += "document.getElementById('optionsEnrichment').style.visibility = 'visible';\n";
        salida += "document.getElementById('optionsEnrichment').style.position = 'static';\n";
        salida += "});\n";
        return salida;
    }

    static String consNodesData(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge, Set<Cluster> cGroupGenes) {
        String nodesData = "";
        int iMaxGenes = -1, iMinGenes = 147000;
        Set<String> listaClustersRepetidos = new HashSet<String>();
        //Calculo de minimo y maximo del grafo
        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                for (Cluster bi : cGroupGenes) {
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[0])) {
                        if (iMaxGenes < bi.getcGenes().size()) {
                            iMaxGenes = bi.getcGenes().size();
                        }
                        if (iMinGenes > bi.getcGenes().size()) {
                            iMinGenes = bi.getcGenes().size();
                        }
                    }
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[1])) {
                        if (iMaxGenes < bi.getcGenes().size()) {
                            iMaxGenes = bi.getcGenes().size();
                        }
                        if (iMinGenes > bi.getcGenes().size()) {
                            iMinGenes = bi.getcGenes().size();
                        }
                    }
                }
            }
        }

        int iDiferenciaGenes = iMaxGenes - iMinGenes;
        if (iDiferenciaGenes == 0) {
            iDiferenciaGenes = 1;
        }
        int iDiferenciaNodeWidth = 51; // 24 - 75
        //Elabora datos del nodo
        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            //int maxEdgePercentage = (maxEdge * oVert.getiNumVeces()) / 100;

            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                int iGenesNodeA = 0, iGenesNodeB = 0;
                String sGenesNodeA = "", sGenesNodeB = "", sTermsNodeA = "[", sTermsNodeB = "[";
                for (Cluster bi : cGroupGenes) {
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[0])) {
                        iGenesNodeA = bi.getcGenes().size();
                        sGenesNodeA = bi.getcGenes().toString();
                    }
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[1])) {
                        iGenesNodeB = bi.getcGenes().size();
                        sGenesNodeB = bi.getcGenes().toString();
                    }
                }

                if (!listaClustersRepetidos.contains(oVert.getPareja()[0])) {
                    for (Row r : oVert.getListaGoNodoA()) {
                        sTermsNodeA += r.getIdGo() + ",";
                    }
                    sTermsNodeA = sTermsNodeA.substring(0, sTermsNodeA.length() - 1);
                    sTermsNodeA += "]";

                    int widthNodeA;
                    try {
                        widthNodeA = (((iGenesNodeA - iMinGenes) * iDiferenciaNodeWidth) / iDiferenciaGenes) + 24;
                    } catch (Exception e) {
                        widthNodeA = 1;
                        System.out.println("Divison por cero en widthNodeA Output.java");
                    }

                    nodesData += " { data: { id: \"" + oVert.getPareja()[0] + "\", name: \"" + oVert.getPareja()[0] + "\", clusterName: \"" + oVert.getPareja()[0] + "\", numGenes: " + iGenesNodeA + ", listGenes: \"" + sGenesNodeA + "\", numTerms: " + oVert.getListaGoNodoA().size() + ", widthNode: " + widthNodeA + ", listTerms: \"" + sTermsNodeA + "\" } },\n";
                    listaClustersRepetidos.add(oVert.getPareja()[0]);
                }

                if (!listaClustersRepetidos.contains(oVert.getPareja()[1])) {
                    for (Row r : oVert.getListaGoNodoB()) {
                        sTermsNodeB += r.getIdGo() + ",";
                    }
                    sTermsNodeB = sTermsNodeB.substring(0, sTermsNodeB.length() - 1);
                    sTermsNodeB += "]";
                    int widthNodeB = (((iGenesNodeB - iMinGenes) * iDiferenciaNodeWidth) / iDiferenciaGenes) + 24;
                    nodesData += " { data: { id: \"" + oVert.getPareja()[1] + "\", name: \"" + oVert.getPareja()[1] + "\", clusterName: \"" + oVert.getPareja()[1] + "\", numGenes: " + iGenesNodeB + ", listGenes: \"" + sGenesNodeB + "\", numTerms: " + oVert.getListaGoNodoB().size() + ", widthNode: " + widthNodeB + ", listTerms: \"" + sTermsNodeB + "\" } },\n";
                    listaClustersRepetidos.add(oVert.getPareja()[1]);
                }
            }
        }

        return nodesData;
    }

    static String consEdgesData(List<GraphNodeRelation> resultGraph, int size, double minEdge, double maxEdge, Set<Cluster> cGroupGenes) {
        String edgesData = "";
        //Calculo de minimo y maximo del grafo
        double iMaxMeasurement = -1, iMinMeasurement = 147000;
        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                if (iMaxMeasurement < Math.round(statisticalMeasurement)) {
                    iMaxMeasurement = statisticalMeasurement;
                }
                if (iMinMeasurement > Math.round(statisticalMeasurement)) {
                    iMinMeasurement = statisticalMeasurement;
                }
            }
        }

        double iDiferenciaMeasurement = iMaxMeasurement - iMinMeasurement;
        if(iDiferenciaMeasurement <= 0){
            iDiferenciaMeasurement = 1;
        }
        double iDiferenciaEdgeWidth = 3; // 5 - 2
        //Elabora datos del nodo
        for (GraphNodeRelation oVert : resultGraph) {
            double statisticalMeasurement = (((oVert.getPorcentajeNodoA() * 100.0) / 100.0) + ((oVert.getPorcentajeNodoB() * 100.0) / 100.0)) / 2.0;
            //double maxEdgePercentage = (Double)(maxEdge * oVert.getiNumVeces()) / 100.00;
            if (statisticalMeasurement <= maxEdge && statisticalMeasurement >= minEdge) {
                String goTerms = "[";
                for (Row oGo : oVert.getListaGo()) {
                    goTerms += oGo.getIdGo() + ",";
                }
                goTerms = goTerms.substring(0, goTerms.length() - 1);
                goTerms += "]";
                Set<String> genesNodeA = new HashSet<String>();
                Set<String> genesNodeB = new HashSet<String>();
                for (Cluster bi : cGroupGenes) {
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[0])) {
                        genesNodeA.addAll(bi.getcGenes());
                    }
                    if (bi.getsNameBicluster().equals(oVert.getPareja()[1])) {
                        genesNodeB.addAll(bi.getcGenes());
                    }
                }
                Set<String> commonGenes = new HashSet<String>();
                //Optimizar calculando los genes comunes con el grupo de genes mas pequeño
                if (genesNodeA.size() < genesNodeB.size()) {
                    for (String gen : genesNodeA) {
                        if (genesNodeB.contains(gen)) {
                            commonGenes.add(gen);
                        }
                    }
                } else {
                    for (String gen : genesNodeB) {
                        if (genesNodeA.contains(gen)) {
                            commonGenes.add(gen);
                        }
                    }
                }

                /* termsPercentageAB = Porcentaje de terminos del cluster A que se encuentran en cluster B
                 termsPercentajeBA = Porcentaje de terminos del cluster B que se encuentran en el cluster A
                 */
                int iGenesNodeA = 0, iGenesNodeB = 0;
                for (String sGen : genesNodeA) {
                    if (genesNodeB.contains(sGen)) {
                        iGenesNodeA++;
                    }
                }
                for (String sGen : genesNodeB) {
                    if (genesNodeA.contains(sGen)) {
                        iGenesNodeB++;
                    }
                }

                DecimalFormat df = new DecimalFormat("#.00");
                String smRedondeado = df.format(statisticalMeasurement);
                String sCommonGenes = "-";
                if (!commonGenes.isEmpty()) {
                    sCommonGenes = commonGenes.toString();
                }
                if (goTerms.equals("[]")) {
                    goTerms = "-";
                }
                int edgeStatistic = (int) (((Math.round(statisticalMeasurement) - iMinMeasurement) * iDiferenciaEdgeWidth) / iDiferenciaMeasurement) + 2;
                edgesData += " { data: { label: \"" + smRedondeado + " %\", edgeStatistic: " + edgeStatistic + ", statistic: " + Math.round(statisticalMeasurement) + ", id: \"" + oVert.getPareja()[0] + " to " + oVert.getPareja()[1] + "\", target: \"" + oVert.getPareja()[0] + "\", source: \"" + oVert.getPareja()[1] + "\", edgeName: \"" + oVert.getPareja()[0] + " (A) to " + oVert.getPareja()[1] + " (B)\", numCommonGenes: \"" + commonGenes.size() + "\", listcommonGenes: \"" + sCommonGenes + "\", genesPercentageAB: \"" + ((iGenesNodeA + 0.0) * 100) / (genesNodeA.size() + 0.0) + "\", genesPercentageBA: \"" + ((iGenesNodeB + 0.0) * 100) / (genesNodeB.size() + 0.0) + "\", numCommonTerms: \"" + oVert.getiNumVeces() + "\", listCommonTerms: \"" + goTerms + "\", termsPercentageAB: \"" + Math.round(oVert.getPorcentajeNodoA() * 100.0) / 100.0 + "\", termsPercentageBA: \"" + Math.round(oVert.getPorcentajeNodoB() * 100.0) / 100.0 + "\" } },\n";
            }
        }
        return edgesData;
    }
}
