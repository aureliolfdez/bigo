<%@page import="processes.Bigo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.*"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>BIGO - Improve gene enrichment analysis in collections of genes</title>
        <meta name="keywords" content="enrichment analysis, cytoscape web plugin, bigo" />
        <meta name="description" content="BIGO. A tool to improve gene enrichment analysis in collections of genes">


        <!-- Frameworks -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

        <!-- Plugins -->
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">

        <!-- Smartphones -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->

        <!-- Own web CSS -->
        <link rel="stylesheet" href="css/style.css">
        <script src="js/cross_animated.js" type="text/javascript" charset="utf-8"></script>       


        <!-- DataTable -->        
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">        
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>        
        <script type="text/javascript" language="javascript" src="js/new_enrichment_desple.js"></script>
        <script type="text/javascript" src="js/bootstrap-filestyle.js"></script>

        <script type="text/javascript">
            $(function () {
                $('[data-toggle="tooltip"]').tooltip()
            })
        </script>

    </head>
    <body style="background-color: #f4f4f4;">
        <%
            //Esto se hace porque viene por request aunque sea session.
            Bigo bigo = (Bigo) session.getAttribute("bigo");
            session.setAttribute("bigo", bigo);

            //Preprocesamiento
            String private_files = "WEB-INF";
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = request.getSession().getId();
            String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
            String sDataDir = pathSesion + File.separator + "dataDir";
            File dirData = new File(sDataDir);
            int contFilesDataDir = dirData.listFiles().length;

            String sOutDir = pathSesion + File.separator + "outDir";
            File dirOut = new File(sOutDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
            ArrayList<String> nomFicheros = new ArrayList();
            int contFilesDataOut = 0;

            if (dirOut.exists() && dirOut.listFiles().length != 0) {
                File[] list = dirOut.listFiles();
                for (File f : list) {
                    String nomFichero = f.getName();
                    if (nomFichero.contains("table")) {
                        contFilesDataOut++;
                        nomFicheros.add(nomFichero);
                    }
                }
            }

            if (contFilesDataOut == 0) {
                response.sendRedirect("new_enrichment.jsp?bigo=error#new");
            } else {

                if (session.getAttribute("optionsEnrichment") != null) { %>
        <script type="text/javascript">
            window.location = "#options";
        </script>
        <% }

            if (request.getParameter("mtcMethod") != null) {
                session.setAttribute("mtcMethod", request.getParameter("mtcMethod"));
            }
            if (request.getParameter("calculationMethod") != null) {
                session.setAttribute("calculationMethod", request.getParameter("calculationMethod"));
            }
        %>


        <jsp:include page="../../../components/header.jsp" />
        <article style="margin-top: 30px;">
            <div class="container">
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">First step. Enrichment analysis</a></li>
                    <li style="font-weight: normal;">
                        Visualize your gene enrichment analysis
                    </li>
                </ul>
                <br>
                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">                    
                    <div>
                        <!-- LOADING MODAL -->
                        <div class="modal fade" id="loading" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-body">
                                        <div style="margin-top: 100px; margin-bottom: 100px;">
                                            <img src="images/loading.gif" style="display: block; margin-left: auto; margin-right: auto;" />
                                            <h1 style="text-align: center;">Processing...</h1>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12" style="text-align: center;">
                                <h2>First step: Enrichment analysis</h2>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 3% 8%;">

                            <div class="col-md-7">
                                <h4>Visualize your gene enrichment analysis</h4>
                                <div style="text-align: justify; padding-top: 10px;">
                                    The enrichment analysis results of every group of genes can be visualized. They also can be ordered by any of the columns. Moreover, clicking on the GO ID you can access to additional information.
                                </div>

                                <% if (contFilesDataOut < contFilesDataDir) { %>
                                <div class="alert alert-warning" role="alert" style="width: 100%; margin-bottom: 40px;"><img src='images/bigo/warning-icon.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>WARNING: </span> BIGO could not be execute properly because there area one or more gene files that are incorrect. Please, check your genes files again or you could continue in the BIGO process those genes files that have been executed correctly.</div>
                                    <% }%>

                                <% if (contFilesDataOut < contFilesDataDir) { %>
                                <div style="float: right; margin-top: -30px; margin-right: 0px;">
                                    <img src="images/bigo/enrichment_results.jpg" style="float:right; width: 22%;">
                                </div>
                                <% }%>

                                <%
                                    // Codigo para obtener el nombre del fichero de genes a traves del fichero de enrichment
                                    int contLength = 0;
                                    switch (session.getAttribute("mtcMethod").toString()) {
                                        case "Bonferroni":
                                            if (session.getAttribute("calculationMethod").equals("Term-For-Term")) {
                                                contLength = 29;
                                            } else if (session.getAttribute("calculationMethod").equals("Parent-Child-Union")) {
                                                contLength = 34;
                                            } else {
                                                contLength = 41;
                                            }
                                            break;
                                        case "Westfall-Young-Single-Step":
                                            if (session.getAttribute("calculationMethod").equals("Term-For-Term")) {
                                                contLength = 45;
                                            } else if (session.getAttribute("calculationMethod").equals("Parent-Child-Union")) {
                                                contLength = 50;
                                            } else {
                                                contLength = 57;
                                            }
                                            break;
                                        default: // None
                                            if (session.getAttribute("calculationMethod").equals("Term-For-Term")) {
                                                contLength = 23;
                                            } else if (session.getAttribute("calculationMethod").equals("Parent-Child-Union")) {
                                                contLength = 28;
                                            } else {
                                                contLength = 35;
                                            }
                                    }
                                %>
                                <div>
                                    <p style="font-weight: bold; margin-top: 40px;">Choose an gene enrichment analysis file to visualize:</p>

                                    <!-- LEER EL NOMBRE DE LOS FICHEROS -->
                                    <html:form action="enrichmentVisualizeCreate" method="post">
                                        <select name="cluster" class="form-control" style="width: 100%;">
                                            <%
                                                for (String s : nomFicheros) {
                                                    String sExtension = s.substring(s.length() - 4, s.length());
                                                    if (request.getParameter("cluster") != null && request.getParameter("cluster").equals(s)) {
                                                        out.println("<option value='" + s + "' selected>" + s.substring(6, s.length() - contLength) + sExtension + "</option>");
                                                    } else {
                                                        out.println("<option value='" + s + "'>" + s.substring(6, s.length() - contLength) + sExtension + "</option>");
                                                    }

                                                }

                                            %>
                                        </select>
                                        <input type="hidden" name="calculationMethod" value="<%=session.getAttribute("calculationMethod")%>" />
                                        <input type="hidden" name="mtcMethod" value="<%=session.getAttribute("mtcMethod")%>" />
                                        <input type="hidden" name="contLength" value="<%=contLength%>" />
                                        <input type="submit" class="btn btn-primary" value="Visualize" style="margin-top: 10px;" />
                                    </html:form>
                                </div>
                            </div> 
                            <div class="col-md-1">&nbsp;</div>
                            <div class="col-md-4">
                                <% if (contFilesDataOut == contFilesDataDir) {%>
                                <div>
                                    <div style="text-align: center;"><img src="images/bigo/enrichment_results.jpg" style="text-align: center; width: 80%;"></div>
                                    <table class="table table-striped table-bordered" cellspacing="0" width="100%">
                                        <thead>
                                            <tr>
                                                <th style='min-width: 100px;'>Method</th>
                                                <th style='min-width: 100px;'>Value</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Specifies the MTC method to use: Bonferroni, Westfall-Young-Single-Step or none."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> MTC:</span>
                                                </td>
                                                <td><%= session.getAttribute("mtcMethod")%></td>
                                            </tr>   
                                            <tr>
                                                <td>
                                                    <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Specifies the enrichment analysis method: Parent-Child-Union, Parent-Child-Intersection or Term-For-Term."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Enrichment:</span>
                                                </td>
                                                <td><%= session.getAttribute("calculationMethod")%></td>
                                            </tr>
                                        </tbody>                                    
                                    </table>
                                </div>
                                <% } %>
                            </div>
                        </div>  

                        <div class="row" style="margin: 3% 8% 0% 8%;">
                            <div class="col-md-12">
                                <hr>
                            </div>                            
                        </div>
                        <%
                            String cluster = request.getParameter("cluster");
                            String enrichmentFile = cluster, sExtension = "", pathEnrichmentFile = "", genesFile = "";

                            if (cluster != null) { //Si se ha seleccionado un fichero a visualizar
                                int clusterLength = Integer.parseInt(request.getParameter("contLength"));
                                sExtension = cluster.substring(cluster.length() - 4, cluster.length());
                                genesFile = cluster.substring(6, cluster.length() - clusterLength) + sExtension;
                                session.setAttribute("genesFile", genesFile);
                                enrichmentFile = cluster;
                                pathEnrichmentFile = pathSesion + File.separator + "outDir" + File.separator + enrichmentFile;
                            } else { //Si no se ha seleccionado ningún fichero se pondra el primero por defecto
                                enrichmentFile = nomFicheros.get(0);
                                pathEnrichmentFile = pathSesion + File.separator + "outDir" + File.separator + enrichmentFile;
                                sExtension = enrichmentFile.substring(enrichmentFile.length() - 4, enrichmentFile.length());
                                genesFile = enrichmentFile.substring(6, enrichmentFile.length() - contLength) + sExtension;
                                session.setAttribute("genesFile", genesFile);
                            }
                            session.setAttribute("enrichmentFile", enrichmentFile); //Esto es para el EnrichmentDatatableServlet
%>


                        <div class="row" style="margin: 1% 8% 3% 8%;">
                            <div class="col-md-12">
                                <h5 style="margin-bottom: 40px;">File: <%= enrichmentFile.substring(6, enrichmentFile.length() - contLength) + sExtension%></h5>
                                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th style="min-width: 100px;">GO ID</th>
                                            <th style="min-width: 300px;">Name</th>
                                            <th>P value</th>
                                            <th>P. adjusted</th>
                                            <th>P. min</th>
                                            <th>Pop. total</th>
                                            <th>Pop. term</th>
                                            <th>Study total</th>
                                            <th>Study term</th>                                        
                                        </tr>
                                    </thead>                                                               
                                </table>                            
                                <script type="text/javascript">
                                    $(document).ready(function () {
                                        $("#example").dataTable({
                                            "sScrollX": "100%",
                                            "bProcessing": false,
                                            "bServerSide": false,
                                            "sort": "position",
                                            "sAjaxSource": "./EnrichmentDatatableServlet",
                                            "aoColumns": [
                                                {"mData": "go_id"},
                                                {"mData": "name"},
                                                {"mData": "pvalue"},
                                                {"mData": "pvalueadjusted"},
                                                {"mData": "pvaluemin"},
                                                {"mData": "poptotal"},
                                                {"mData": "popterm"},
                                                {"mData": "studytotal"},
                                                {"mData": "studyterm"}
                                            ],
                                            "fnRowCallback": function (nRow, data, index) {
                                            }
                                        });
                                    });
                                </script>
                            </div>
                        </div>


                        <div class="row" style="margin: 5% 8% 2% 8%;">
                            <div class="col-md-12">
                                <h4>Additional options</h4>
                                <hr>
                            </div>
                        </div>


                        <div class="row" style="margin: 2% 8% 2% 8%; text-align: center;">
                            <div class="col-md-4" style="margin-top: 10px;">
                                <html:form action="downloadEnrichmentFileCreate" method="post">
                                    <input type="hidden" name="calculationMethod" value="<%=session.getAttribute("calculationMethod")%>" />
                                    <input type="hidden" name="mtcMethod" value="<%=session.getAttribute("mtcMethod")%>" />
                                    <% if (cluster != null) {%>
                                    <input type="hidden" name="file" value="<%=cluster%>" />
                                    <% } else {%>
                                    <input type="hidden" name="file" value="<%=nomFicheros.get(0)%>" />
                                    <% }%>                                        
                                    <input type="hidden" name="download" value="yes" />
                                    <input type="submit" value="Download this
                                           enrichment file" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/download_file.png) no-repeat top center;"/>
                                </html:form>
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <html:form action="downloadEnrichmentCreate" method="post">
                                    <input type="hidden" name="calculationMethod" value="<%=session.getAttribute("calculationMethod")%>" />
                                    <input type="hidden" name="mtcMethod" value="<%=session.getAttribute("mtcMethod")%>" />
                                    <input type="hidden" name="download" value="yes" />
                                    <input type="submit" value="Download all
                                           enrichment files" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/download.png) no-repeat top center;"/>
                                </html:form> 
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <button type="button" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/file_search.png) no-repeat top center;">View associated<br />gene file</button>
                                <!-- OPTION: FILE VIEW GENE -->
                                <!-- Modal View file gene-->
                                <div class="modal fade" id="genesFile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="text-align:left;">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">                                                
                                                <h4 class="modal-title" id="myModalLabel">View file: <%=session.getAttribute("genesFile")%></h4>
                                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                            </div>
                                            <div class="modal-body scroll">
                                                <%
                                                    String txt = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId() + File.separator + "dataDir" + File.separator + session.getAttribute("genesFile");
                                                    File fComprobacion = new File(txt);
                                                    if (fComprobacion.exists()) {
                                                        BufferedReader br = new BufferedReader(new FileReader(txt));
                                                        String data, dataFinal = "";

                                                        while ((data = br.readLine()) != null) {
                                                            dataFinal += data + "<br>";
                                                        }

                                                        if (dataFinal.equals("")) {
                                                            out.println("This file is empty.");
                                                        } else {
                                                            out.println(dataFinal);
                                                        }
                                                        br.close();
                                                    }
                                                %>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="pull-right" style="margin: 40px 8% 0% 0%;">
                            <html:form action="executeRankingCreate">
                                <p>
                                    <input type="submit" class="btn btn-success btn-lg" data-toggle="modal" data-target="#loading" data-backdrop="static" data-keyboard="false" value="Next &#9655;">
                                </p>
                            </html:form>                                
                        </div>

                        <div class="row">
                            <div class="col-md-6" style="margin: 40px 0% 4% 10%;">
                                <html:form action="backEnrichmentCreate">
                                    <input type="hidden" name="backEnrichment" value="yes" />
                                    <p>
                                        <input type="submit" class="btn btn-danger btn-lg" value="&#9665; Back" />
                                    </p>
                                </html:form>
                            </div>
                        </div>
                    </div>
                </div>
        </article>
        <jsp:include page="../../../components/footer.jsp" />

        <%
            }
        %>


    </body>
</html>