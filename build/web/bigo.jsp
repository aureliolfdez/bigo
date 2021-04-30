<%@page import="processes.Bigo"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page session="true" %>
<%@page import="java.io.*"%>
<!DOCTYPE html>
<html>
    <head>  
        <title>BIGO - Improve gene enrichment analysis in collections of genes</title>
        <meta name="keywords" content="enrichment analysis, cytoscape web plugin, bigo" />
        <meta name="description" content="BIGO. A tool to improve gene enrichment analysis in collections of genes">

        <!-- Frameworks -->
        <!--<link rel="stylesheet" href="css/bootstrap.min.css">-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

        <!-- Smartphones -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->

        <!-- Own web CSS -->
        <link rel="stylesheet" href="css/style.css">        
        <script src="js/cross_animated.js" type="text/javascript" charset="utf-8"></script>


        <!-- DataTable -->
        <link rel="stylesheet" href="css/dataTables.bootstrap.css">
        <script type="text/javascript" language="javascript" src="js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/dataTables.bootstrap.js"></script>
        <script type="text/javascript" language="javascript" src="js/new_enrichment_desple.js"></script>
        <script type="text/javascript" src="js/bootstrap-filestyle.js"></script>

        <script language="JavaScript">
            $(document).ready(function () {
                $('#example').dataTable();
            });

            function select_all() {
                document.getElementById("drop_files_button").disabled = false;
                $(':checkbox').each(function () {
                    this.checked = true;
                });
            }

            function deselect_all() {
                document.getElementById("drop_files_button").disabled = true;
                $(':checkbox').each(function () {
                    this.checked = false;
                });
            }

            function checkbox_files() {
                chk = document.getElementsByName("filedrop");
                var contSelect = 0;
                for (var i = 0; i < chk.length; i++) {
                    if (chk[i].checked) {
                        contSelect++;
                    }
                }
                if (contSelect > 0) {
                    document.getElementById("drop_files_button").disabled = false;
                } else {
                    document.getElementById("drop_files_button").disabled = true;
                }
            }

            function disabled_drop() {
                document.getElementById("character").style.display = "none";
                document.getElementById("divConversion").style.display = "none";
            }

            function select_type() {
                var select = document.getElementById("type_character");
                var options = select[select.selectedIndex].value;
                if (options == "other") {
                    document.getElementById("character").style.display = "inline";
                } else {
                    document.getElementById("character").style.display = "none";
                }
            }

            function select_annotations() {
                var select = document.getElementById("annoFile");
                var options = select[select.selectedIndex].value;
                if (options == "own_file") {
                    document.getElementById("divanno").style.display = "inline";
                } else {
                    document.getElementById("divanno").style.display = "none";

                }
            }

            function select_ontology() {
                var select = document.getElementById("oboFile");
                var options = select[select.selectedIndex].value;
                if (options == "own_file") {
                    document.getElementById("divobo").style.display = "inline";
                } else {
                    document.getElementById("divobo").style.display = "none";
                }
            }

            function select_conversion() {
                var select = document.getElementById("sConversion");
                var options = select[select.selectedIndex].value;
                if (options == "n") {
                    document.getElementById("divConversion").style.display = "none";
                } else {
                    document.getElementById("divConversion").style.display = "initial";
                }
            }

            $(function () {
                $('[data-toggle="tooltip"]').tooltip()
            })

            function numeros(e)
            {
                var keynum = window.event ? window.event.keyCode : e.which;
                if ((keynum == 8) || (keynum == 46))
                    return true;
                return /\d/.test(String.fromCharCode(keynum));
            }

        </script>        

    </head>
    <body style="background-color: #f4f4f4;" onload="disabled_drop()">
        <% session.setAttribute("active", "bigo");%>
        <%
            if (request.getParameter("q") != null && request.getParameter("q").equals("y")) {
                request.getSession().setAttribute("executeEnrichment", null);
                String applicationPath = request.getServletContext().getRealPath("");
                String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId();
                String sessionId = request.getParameter("sessionId");

                //INICIO GRAFOS
                String sesionId = request.getSession().getId();
                String filePath = applicationPath + File.separator + "WEB-INF" + File.separator + sesionId + File.separator + "rankings";

                // Eliminar output ranking
                File ranking_base = new File(filePath + File.separator + "output_base.txt");
                if (ranking_base.exists()) {
                    ranking_base.delete();
                }

                //Eliminar carpeta rankings si esta vacia
                File dirRanking = new File(filePath);
                File[] list = dirRanking.listFiles();
                if (dirRanking.exists() && dirRanking.listFiles().length == 0) {
                    dirRanking.delete();
                }

                //Eliminar carpeta graphs
                String graphPath = applicationPath + File.separator + "WEB-INF" + File.separator + sesionId + File.separator + "graphs";
                File dirGraphs = new File(graphPath);
                File[] listGraphs = dirGraphs.listFiles();
                if (dirGraphs.exists() && dirGraphs.listFiles().length != 0) {
                    for (File f : listGraphs) {
                        String nomFichero = f.getName();
                        File fil = new File(graphPath + File.separator + nomFichero); // Elimina el fichero seleccionado
                        fil.delete();
                        File dirData = new File(graphPath); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                        if (dirData.exists() && dirData.listFiles().length == 0) {
                            dirData.delete();
                        }
                    }
                }

                String[] listGra = dirGraphs.list();
                if (listGra != null) {
                    for (String s : listGra) {
                        File f = new File(applicationPath + File.separator + "WEB-INF" + File.separator + sesionId + File.separator + "graphs" + File.separator + s);
                        File[] listf = f.listFiles();
                        if (f.listFiles().length != 0) {
                            for (File f3 : listf) {
                                f3.delete();
                                if (f.exists() && f.listFiles().length == 0) {
                                    f.delete();
                                }
                            }
                        } else {
                            f.delete();
                        }

                    }
                }

                if (dirGraphs.exists() && dirGraphs.listFiles().length == 0) {
                    dirGraphs.delete();
                }

                request.getSession().setAttribute("executeGraph", null);
                request.getSession().setAttribute("bigoGraphBase", null);
                request.getSession().setAttribute("bigoGraph", null);
                request.getSession().setAttribute("salidaWebGraph", null);
                request.getSession().setAttribute("sIcGraph", null);
                request.getSession().setAttribute("sMinGraph", null);
                request.getSession().setAttribute("sLevelGraph", null);
                request.getSession().setAttribute("sConfiGraph", null);
                request.getSession().setAttribute("bigoGraphBase", null);
                request.getSession().setAttribute("maxEdge", null);
                request.getSession().setAttribute("minEdge", null);
                request.getSession().setAttribute("enable_minEdge", null);
                request.getSession().setAttribute("firstGraph", null);
                request.getSession().setAttribute("prevMinEdge", null);
                request.getSession().setAttribute("minEdge", 0);
                request.getSession().setAttribute("prevMaxEdge", null);
                request.getSession().setAttribute("maxEdge", 100);

                Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
                if (bigo != null) {
                    bigo.setMinEdge(0);
                    bigo.setMaxEdge(100);
                    request.getSession().setAttribute("bigo", bigo);
                }

                //FIN DE GRAFOS
                //INICIO DE RANKINGS
                // Eliminar output.txt
                filePath = applicationPath + File.separator + "WEB-INF" + File.separator + sesionId;
                File nobase = new File(filePath + File.separator + "output.txt");
                if (nobase.exists()) {
                    nobase.delete();
                }

                File origen = new File(filePath + File.separator + "output_base.txt");
                File destino = new File(filePath + File.separator + "output.txt");
                //Copiar output_base.txt - output.txt
                try {
                    InputStream in = new FileInputStream(origen);
                    OutputStream out2 = new FileOutputStream(destino);

                    byte[] buf = new byte[1024];
                    int len;

                    while ((len = in.read(buf)) > 0) {
                        out2.write(buf, 0, len);
                    }
                    in.close();
                    out2.close();
                } catch (IOException ioe) {
                    ioe.printStackTrace();
                }

                // Eliminar output_base.txt        
                File base = new File(filePath + File.separator + "output_base.txt");
                if (base.exists()) {
                    base.delete();
                }

                // Eliminar stopwords.txt        
                File stopwords = new File(filePath + File.separator + "stopwords.txt");
                if (stopwords.exists()) {
                    stopwords.delete();
                }

                // Eliminar uniques.txt        
                File uniques = new File(filePath + File.separator + "uniques.txt");
                if (uniques.exists()) {
                    uniques.delete();
                }

                // Eliminar carpeta rankings
                //DATADIR
                String pathRankingDir = filePath + File.separator + "rankings";
                File dirSesion = new File(pathRankingDir);
                list = dirSesion.listFiles();
                //Comprueba si la carpeta dataDir existe
                if (dirSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                    if (dirSesion.listFiles().length == 0) {
                        dirSesion.delete();
                    } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                        for (File f : list) {
                            String nomFichero = f.getName();
                            File fil = new File(pathRankingDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                            fil.delete();
                            File dirData = new File(pathRankingDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                            if (dirData.exists() && dirData.listFiles().length == 0) {
                                dirData.delete();
                            }
                        }
                    }
                }

                // Aqui indico que la actualizacion del ranking del navegador se anula porque ya no se encuentra en esa ventana.
                request.getSession().setAttribute("listaBigos", null);
                request.getSession().setAttribute("confidenceFactor", null);
                request.getSession().setAttribute("level", null);
                request.getSession().setAttribute("minLevel", null);
                request.getSession().setAttribute("maxIC", null);
                request.getSession().setAttribute("firstRanking", null);
                request.getSession().setAttribute("optionsEnrichment", null);
                request.getSession().setAttribute("enabled_maxIC", null);
                request.getSession().setAttribute("enabled_minLevel", null);
                request.getSession().setAttribute("enabled_level", null);
                request.getSession().setAttribute("enabled_confidence", null);
                request.getSession().setAttribute("prevLevel", null);
                request.getSession().setAttribute("prevIc", null);
                request.getSession().setAttribute("prevConfidence", null);
                request.getSession().setAttribute("prevMinLevel", null);
                request.getSession().setAttribute("stopwordsRanking", null);
                request.getSession().setAttribute("uniquesRanking", null);
                request.getSession().setAttribute("undo", null);

                bigo = (Bigo) request.getSession().getAttribute("bigo");
                if (bigo != null) {
                    int clusters = bigo.getcConjuntoTerminos().size();
                    bigo.setLevel(clusters);
                    bigo.setMinLevel(0);
                    bigo.setMaxIC(9999);
                    bigo.setConfidenceFactor(1);
                    request.getSession().setAttribute("bigo", bigo);
                }

                //FIN DE RANKINGS
                //INICIO DE ENRICHMENT
                //OUTDIR
                String pathoutDir = pathSesion + File.separator + "outDir";
                File outSesion = new File(pathoutDir);
                File[] listOut = outSesion.listFiles();
                //Comprueba si la carpeta outDir existe
                if (outSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                    if (outSesion.listFiles().length == 0) {
                        outSesion.delete();
                    } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                        for (File f : listOut) {
                            String nomFichero = f.getName();
                            File fil = new File(pathoutDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                            fil.delete();
                            File dirData = new File(pathoutDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                            if (dirData.exists() && dirData.listFiles().length == 0) {
                                dirData.delete();
                            }
                        }
                    }
                }

                //Elimina el resto de ficheros y elimina carpeta de sesion
                File filepathSesion = new File(pathSesion);
                File[] listSesion = filepathSesion.listFiles();
                //Comprueba si la carpeta de sesion existe
                if (filepathSesion.exists()) {
                    if (filepathSesion.listFiles().length == 0) {
                        filepathSesion.delete();
                    } else {
                        for (File f : listSesion) {
                            String nomFichero = f.getName();
                            if (!nomFichero.equals("output.txt")) {
                                File fil = new File(pathSesion + File.separator + nomFichero); // Elimina el fichero seleccionado
                                fil.delete();
                            }

                        }
                    }
                }

                //Elimina el objeto BIGO
                if (request.getSession().getAttribute("bigo") != null) {
                    bigo = (Bigo) request.getSession().getAttribute("bigo");
                    bigo = null;
                    request.getSession().setAttribute("bigo", null);
                    request.getSession().setAttribute("executeRanking", null);
                }

                request.getSession().setAttribute("clickBack", "true");
                //FIN DE ENRICHMENT

                //INICIO DE QUIT
                String dataDir = pathSesion + File.separator + "dataDir";
                dirSesion = new File(dataDir);
                list = dirSesion.listFiles();
                int iContFile = 0;
                if (list != null) {
                    for (File f : list) {
                        iContFile++;
                    }
                }

                if (iContFile > 0) {
                    //DATADIR
                    String pathDataDir = pathSesion + File.separator + "dataDir";

                    //Comprueba si la carpeta dataDir existe
                    if (dirSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                        if (dirSesion.listFiles().length == 0) {
                            dirSesion.delete();
                        } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                            for (File f : list) {
                                String nomFichero = f.getName();
                                File fil = new File(pathDataDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                                fil.delete();
                                File dirData = new File(pathDataDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                                if (dirData.exists() && dirData.listFiles().length == 0) {
                                    dirData.delete();
                                }
                            }
                        }
                    }

                    //DATADIRPROVIDE
                    String pathDataDirProvide = pathSesion + File.separator + "outDirProvide";
                    File dirSesionProvide = new File(pathDataDirProvide);
                    File[] listProvide = dirSesionProvide.listFiles();
                    //Comprueba si la carpeta dataDir existe
                    if (dirSesionProvide.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                        if (dirSesionProvide.listFiles().length == 0) {
                            dirSesionProvide.delete();
                        } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                            for (File f : listProvide) {
                                String nomFichero = f.getName();
                                File fil = new File(pathDataDirProvide + File.separator + nomFichero); // Elimina el fichero seleccionado
                                fil.delete();
                                File dirData = new File(pathDataDirProvide); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                                if (dirData.exists() && dirData.listFiles().length == 0) {
                                    dirData.delete();
                                }
                            }
                        }
                    }

                    //OUTDIR
                    pathoutDir = pathSesion + File.separator + "outDir";
                    outSesion = new File(pathoutDir);
                    listOut = outSesion.listFiles();
                    //Comprueba si la carpeta outDir existe
                    if (outSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                        if (outSesion.listFiles().length == 0) {
                            outSesion.delete();
                        } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                            for (File f : listOut) {
                                String nomFichero = f.getName();
                                File fil = new File(pathoutDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                                fil.delete();
                                File dirData = new File(pathoutDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                                if (dirData.exists() && dirData.listFiles().length == 0) {
                                    dirData.delete();
                                }
                            }
                        }
                    }

                    //Elimina el resto de ficheros y elimina carpeta de sesion
                    filepathSesion = new File(pathSesion);
                    listSesion = filepathSesion.listFiles();
                    //Comprueba si la carpeta de sesion existe
                    if (filepathSesion.exists()) {
                        if (filepathSesion.listFiles().length == 0) {
                            filepathSesion.delete();
                        } else {
                            for (File f : listSesion) {
                                String nomFichero = f.getName();
                                File fil = new File(pathSesion + File.separator + nomFichero); // Elimina el fichero seleccionado
                                fil.delete();
                                File dirData = new File(pathSesion); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                                if (dirData.exists() && dirData.listFiles().length == 0) {
                                    dirData.delete();
                                }
                            }
                        }
                    }
                }
                //FIN DE QUIT
            }

        %>
        <jsp:include page="components/header.jsp" />


        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">First step. Enrichment analysis</a></li>
                    <li style="font-weight: normal;">
                        <% if (request.getParameter("enrichment") == null) { %>
                        Select a source for the gene enrichment analysis
                        <% } else { %>
                        Use a gene enrichment analysis tool
                        <% } %>
                    </li>
                </ul>
                <br>

                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div class="row" style="margin: 4% 8% 4% 8%;">
                        <div class="col-md-12" style="text-align: center;">              
                            <h2>First phase: Enrichment analysis</h2> 
                            <!-- STEP 1. SELECT A SOURCE FOR THE GENE ENRICHMENT ANALYSIS -->
                            <!--<h2 class="article-title" style="text-align: left; font-size: 25px; margin-top: 35px; ">Step 1. Select a source for the gene enrichment analysis</h2> -->
                            <% if (request.getParameter("calculate_enrichment") != null && request.getParameter("calculate_enrichment").equals("yes")) {
                                    //response.sendRedirect("bigo.jsp?enrichment=no&separator=no#own");
                                }
                            %>
                        </div>
                    </div>

                    <div class="row" style="margin: 4% 8% 30% 8%;"> 
                        <div class="col-md-12" style="text-align: center; ">
                            <jsp:include page="bigo/source_gene.jsp" />
                        </div>

                        <!-- STEP 2. PROVIDE A GENE ENRICHMENT ANALYSIS RESULT -->
                        <% if (request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("no")) {  %> 
                        <jsp:include page="bigo/provide_gene.jsp" />
                        <!-- STEP 2. CREATE A NEW GENE ENRICHMENT ANALYSIS -->                        
                        <% } else if (request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("yes")) { %>
                        <jsp:include page="bigo/new_enrichment.jsp" />                    
                        <% }%>
                    </div>

                </div>
            </div>
        </div>              
    </article>
    <jsp:include page="components/footer.jsp" /> 
</body>
</html>
