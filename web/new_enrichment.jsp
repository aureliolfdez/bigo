<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.nio.file.*"%>
<%@page import="java.io.*"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page session="true" %>
<%@page isErrorPage="true" %>
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
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">        
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
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
            <% if (request.getParameter("sConversion") != null && request.getParameter("sConversion").equals("y")) { %>
                document.getElementById("divConversion").style.display = "initial";
            <% } else { %>
                document.getElementById("divConversion").style.display = "none";
            <% } %>
            <% if (request.getParameter("type_character") != null && request.getParameter("type_character").equals("other")) { %>
                document.getElementById("character").style.display = "inline";
            <% } %>
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
                if (options === "own_file") {
                    document.getElementById("divanno").style.display = "inline";
                } else {
                    document.getElementById("divanno").style.display = "none";

                }
            }

            function select_ontology() {
                var select = document.getElementById("oboFile");
                var options = select[select.selectedIndex].value;
                if (options === "own_file") {
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
        <%
            System.out.println("CACA: " + session.getAttribute("demo"));
            if ((request.getParameter("backEnrichment") != null && request.getParameter("backEnrichment").equals("yes"))) {
        %>
        <script type="text/javascript">
            window.location : "#new";</script>
            <%
                }
                if (session.getAttribute("clickBack") != null && session.getAttribute("clickBack").equals("true")) { %>
        <script type="text/javascript">
            window.location : "#new";
        </script>   
        <%
            }
            session.setAttribute("active", "bigo");
            session.setAttribute("startbigo", "yes");
            String applicationPath = request.getServletContext().getRealPath("");
            String origenDemo = applicationPath + File.separator + "test";
            String sessionDemo = applicationPath + "WEB-INF" + File.separator + session.getId();
            Path pathSessionDemo = Paths.get(sessionDemo);
            String dataDirDemo = sessionDemo + File.separator + "dataDir";
            Path pathDataDirDemo = Paths.get(dataDirDemo);

            //Creacion de carpetas
            File dirSesion = new File(sessionDemo);
            File dirDataDir = new File(dataDirDemo);

            if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { //Version demo
                if (!dirSesion.exists()) {
                    try {
                        Files.createDirectory(pathDataDirDemo);
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                } else {
                    FileUtils.deleteDirectory(dirDataDir);
                    FileUtils.deleteDirectory(dirSesion);
                }

                if (!dirDataDir.exists()) {
                    dirDataDir.mkdirs();
                } else {
                    FileUtils.deleteDirectory(dirDataDir);
                }

                //Copiar ficheros
                File dirOrigenDemo = new File(origenDemo);
                for (File f : dirOrigenDemo.listFiles()) {
                    String sNombre = f.getName();
                    if (sNombre.equals("Population_DUP.txt")) { // Population file
                        Files.copy(Paths.get(origenDemo + File.separator + sNombre), Paths.get(sessionDemo + File.separator + sNombre));
                    } else { // Genes file
                        Files.copy(Paths.get(origenDemo + File.separator + sNombre), Paths.get(dataDirDemo + File.separator + sNombre));
                    }
                }

                session.setAttribute("demo", "yes");
            } else { //Version no-demo
                if (session.getAttribute("demo") != null && session.getAttribute("demo").equals("yes")) {
                    if (!dirSesion.exists()) {
                        dirSesion.mkdirs();
                        dirDataDir.mkdirs();
                    } else {
                        FileUtils.deleteDirectory(dirDataDir);
                        FileUtils.deleteDirectory(dirSesion);
                    }

                    if (!dirDataDir.exists()) {
                        dirDataDir.mkdirs();
                    } else {
                        FileUtils.deleteDirectory(dirDataDir);
                    }
                }
                session.setAttribute("demo", null);
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
                        Use a gene enrichment analysis tool
                    </li>
                </ul>
                <br>
                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div class="row" style="margin: 4% 8% 4% 8%;">                        
                        <div class="col-md-12" style="text-align: center;">
                            <h2>First step: Enrichment analysis</h2>
                            <!-- STEP 1. SELECT A SOURCE FOR THE GENE ENRICHMENT ANALYSIS -->
                        </div>
                    </div>

                    <div class="row" style="margin: 4% 8% 4% 8%;"> 
                        <div class="col-md-12" style="text-align: center; ">
                            <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                            <jsp:include page="bigo/source_gene.jsp?enrichment=yes&demo=yes" />
                            <% } else { %>
                            <jsp:include page="bigo/source_gene.jsp?enrichment=yes&demo=no" />
                            <% } %>                            

                            <!-- LOADING MODAL -->
                            <div class="modal fade" id="loading" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div style="margin-top: 100px; margin-bottom: 100px;">
                                                <img src="images/loading.gif" style="display: block; margin-left: auto; margin-right: auto;" /><br />
                                                <h1 style="text-align: center;">Processing...</h1>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- OPTION: FILE DELETE -->
                            <%
                                String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId();

                                if (request.getParameter("filename_delete") != null) {
                                    String dataDir = pathSesion + File.separator + "dataDir";
                                    String file_delete_path = dataDir + File.separator + request.getParameter("filename_delete");
                                    File f = new File(file_delete_path); // Elimina el fichero seleccionado
                                    f.delete();
                                    File dirData = new File(dataDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                                    if (dirData.exists() && dirData.listFiles().length == 0) {
                                        dirData.delete();
                                        dirSesion = new File(pathSesion);
                                        dirSesion.delete();
                                    }
                                }%>

                            <!-- OPTION: FILE VIEW -->
                            <!-- Modal View file-->                   
                            <div class="modal fade bd-example-modal-sm" id="viewFile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header" style="vertical-align: middle;">
                                            <% String file_view = request.getParameter("filename_view");%>                                            
                                            <h5 id="myModalLabel" style="font-size: 16px; text-align: left;"><span style="font-weight: bold;">File:</span>
                                                <%
                                                    if (file_view == null) {
                                                        out.print("Loading file...");
                                                    } else {
                                                        out.print(file_view);
                                                    }
                                                %>
                                            </h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body scroll">
                                            <%
                                                String txt = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId() + File.separator + "dataDir" + File.separator + file_view;
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

                            <hr style="margin: 4% 0% 4% 0%;"> 
                        </div>
                    </div>

                    <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) {
                            //Version demo - Creo directorios y archivos                      

                            //Copiar ficheros
                            /*File dirOrigenDemo = new File(origenDemo);
                            for (File f : dirOrigenDemo.listFiles()) {
                                String sNombre = f.getName();
                                if (sNombre.equals("Population_DUP.txt")) { // Population file
                                    Files.copy(Paths.get(origenDemo + File.separator + sNombre), Paths.get(sessionDemo + File.separator + sNombre));
                                } else { // Genes file
                                    Files.copy(Paths.get(origenDemo + File.separator + sNombre), Paths.get(dataDirDemo + File.separator + sNombre));
                                }
                            }*/
                    %>

                    <% } else {
                        // Version no-demo
                    %>
                    <div class="row" style="margin: 4% 8% 4% 8%;"> 
                        <div class="col-md-6" style="text-align: left; ">
                            <h2>Upload gene files</h2>
                            <p style="color: #999999;">Single-column file - Max. 50MB per file - Only *.txt files</p>
                        </div> 
                        <div class="col-md-6" style="text-align: right; ">
                            <!-- SELECT FILES... -->
                            <div class="pull-right">
                                <form action="FilesServlet" method="post" enctype="multipart/form-data" id="filesuploader">
                                    <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                                    <input type="hidden" name="enrichment" value="yes" />
                                    <span class="pull-left file-input btn btn-primary btn-file" style="font-size: 20px;">Select files...
                                        <input type="file" name="dataDir" multiple="multiple" accept="text/plain" onchange="document.getElementById('filesuploader').submit();">
                                    </span>
                                    <br>
                                </form>
                            </div>
                        </div> 
                    </div>
                    <% } %>


                    <!-- ERRORS -->
                    <%
                        String sesionId = request.getParameter("sessionId");
                        String dataDir = pathSesion + File.separator + "dataDir";
                        dirSesion = new File(dataDir);
                    %>

                    <logic:messagesPresent>
                        <div class="alert alert-danger" role="alert" style="margin: 50px 8% -15px 8%;">
                            <img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> 
                            <span style='font-weight: bold;'>ERROR:</span><br /><br /><html:errors />
                        </div>
                    </logic:messagesPresent>

                    <% if (session.getAttribute("error_extension") != null && (int) session.getAttribute("error_extension") == 1) {
                    %>
                    <div class="alert alert-danger" role="alert" style="margin: 50px 8% -15px 8%;">
                        <img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'>
                        <span style='font-weight: bold;'>ERROR:</span> Only files with .txt or .csv extension allowed.
                    </div>
                    <%
                            session.setAttribute("error_extension", null);
                        }
                        if (session.getAttribute("error_exists") != null && (int) session.getAttribute("error_exists") == 1) {
                    %>
                    <div class="alert alert-warning" role="alert" style="margin: 50px 8% -15px 8%;">
                        <img src='images/bigo/warning-icon.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'>
                        <span style='font-weight: bold;'>WARNING:</span> There is a file with the same name, it has been replaced.
                    </div>
                    <%
                            session.setAttribute("error_exists", null);
                        }
                        if (session.getAttribute("error_size") != null && (int) session.getAttribute("error_size") == 1) {
                    %>
                    <div class="alert alert-danger" role="alert" style="margin: 50px 8% -15px 8%;">
                        <img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'>
                        <span style='font-weight: bold;'>ERROR: </span> There is a file empty. This file will be not uploaded.
                    </div>
                    <%
                            session.setAttribute("error_size", null);
                        }
                        if (request.getParameter("bigo") != null && request.getParameter("bigo").equals("error")) {
                    %>
                    <div class="alert alert-danger" role="alert" style="margin: 50px 8% -15px 8%;">
                        <img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'>
                        <span style='font-weight: bold;'>ERROR: </span> BIGO was not executed correctly. Please, review your gene files and the different options.
                    </div>
                    <%
                        }
                        if (session.getAttribute("error_max_size") != null && (int) session.getAttribute("error_max_size") == 1) {
                    %>
                    <div class="alert alert-warning" role="alert" style="margin: 50px 8% -15px 8%;">
                        <img src='images/bigo/warning-icon.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'>
                        <span style='font-weight: bold;'>ERROR: </span> One or more files exceed the 50 MB/file limit, these file are not available.
                    </div>
                    <%
                            session.setAttribute("error_max_size", null);
                        }
                        if (session.getAttribute("error_max_size_folder") != null && (int) session.getAttribute("error_max_size_folder") == 1) {
                    %>
                    <div class="alert alert-danger" role="alert" style="margin: 50px 8% -15px 8%;">
                        <img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'>
                        <span style='font-weight: bold;'>ERROR: </span> You have exceeded the 1 GB limit intended for your groups of genes. Please, contact us if you want to study at a higher load.
                    </div>
                    <%
                            session.setAttribute("error_max_size_folder", null);
                        }

                        if (dirSesion.exists() && dirSesion.listFiles().length > 0) { %>


                    <p style="margin-top: 30px;">&nbsp;</p>

                    <div class="row" style="margin: 4% 8% 4% 8%;"> 
                        <div class="col-md-12">
                            <table class="table table-striped table-bordered table-responsive">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Filename</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        File[] list = dirSesion.listFiles();
                                        int iContFile = 0;
                                        for (File f : list) {
                                            String nomFichero = f.getName();
                                    %>
                                    <tr>
                                        <td style="width: 5%; vertical-align: middle; font-weight: bold;"><% out.println(iContFile + 1); %></td>
                                        <td style="width: 60%; vertical-align: middle;"><% out.println(f.getName());%></td>
                                        <td>
                                            <div class="row">
                                                <div class="col-xs-6 col-md-6">
                                                    <!-- VIEW FILE BUTTON -->
                                                    <form id="view_file" action="#new" method="post" style="margin-top: -38px;">
                                                        <button id="view_file_dialog" type="button" class="btn btn-info" data-toggle="modal" data-target="#viewFile" style="visibility: hidden; font-weight: bold;"><img src="images/bigo/view.png"> View file</button>
                                                        <input type="hidden" name="filename_view" value="<%=nomFichero%>" />
                                                        <input onclick="document.getElementById('view_file').submit();" type="submit" class="btn btn-info" data-toggle="modal" data-target="#viewFile" style="padding-left: 28px; padding-top: -3px; font-weight: bold; background: url(images/bigo/view.png) #46b8da no-repeat; background-position: left;" value="View file">
                                                        <% if (request.getParameter("filename_view") != null) { %>
                                                        <script language="JavaScript">
                                                            document.getElementById('view_file_dialog').click();
                                                        </script>
                                                        <% }%>
                                                    </form>
                                                </div>
                                                <div class="col-xs-6 col-md-6">
                                                    <!-- DROP FILE BUTTON -->
                                                    <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                                    &nbsp;
                                                    &nbsp;
                                                    &nbsp;
                                                    &nbsp;
                                                    &nbsp;
                                                    <% } else {%>
                                                    <form id="drop_file" class="form-inline" action="new_enrichment.jsp#new" method="post">
                                                        <input type="hidden" name="filename_delete" value="<%=nomFichero%>" />
                                                        <input type="submit" class="btn btn-danger" style="padding-left: 28px; padding-top: -3px; font-weight: bold; background: url(images/bigo/drop_file.gif) #d9534f no-repeat; background-position: left; border: 1px solid #d9534f;" value="Drop file">
                                                    </form>
                                                    <% } %>                                                    
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                            iContFile++;
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>


                    <html:form action="executeNewEnrichment" method="post" enctype="multipart/form-data">
                        <div id="optionsEnrichment" class="row bhoechie-tab-container" style="margin: 4% 8% 4% 8%;">
                            <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12 bhoechie-tab-menu">
                                <div class="list-group">
                                    <a href="#optionsEnrichment" class="list-group-item active text-center">
                                        <h4 class="fa fa-user"></h4><br />Basic
                                    </a>
                                    <a href="#optionsEnrichment" class="list-group-item text-center">
                                        <h4 class="fa fa-wrench"></h4><br />Advanced
                                    </a>
                                </div>
                            </div>
                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10 bhoechie-tab">
                                <!-- Basic options -->
                                <div class="bhoechie-tab-content active" style="padding: 0px 20px 20px 20px;">
                                    <h2 class="article-title" style="color: #0099cc; text-align: left; font-size: 17px; font-weight: bold;">Basic options (required)</h2>
                                    <hr class="featurette-divider" style="margin-top: 0px;">
                                    <div class="row" style="padding-left: 25px;">
                                        <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Select from a list of available organism’s annotations or provide your own annotations file." ><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Select annotations file:</p>
                                        <br>
                                        <select onchange="select_annotations()" class="form-control" id="annoFile" name="annoFile" required style="width: 100%;">
                                            %> 
                                            <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                            <% } else { %>
                                            <option value="own_file" selected>Own file</option>
                                            <% } %>
                                            <%
                                                StringBuffer sb = new StringBuffer();
                                                try {
                                                    String fichero = request.getRealPath("/annotations/annotations.txt");
                                                    File file = new File(fichero);
                                                    String linea = null;
                                                    BufferedReader br = new BufferedReader(new FileReader(file));
                                                    while ((linea = br.readLine()) != null) {
                                                        sb.append(linea);
                                                        String textoOption = linea.substring(linea.indexOf(";") + 1, linea.length());
                                            %>
                                            <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                            <% if (textoOption.equals("Saccharomyces cerevisiae")) {%>
                                            <option value="gene_association.<%=linea.substring(0, linea.indexOf(";"))%>"><%=textoOption%></option>
                                            <% } %>
                                            <% } else {%>
                                            <option value="gene_association.<%=linea.substring(0, linea.indexOf(";"))%>"><%=textoOption%></option>
                                            <% } %>
                                            %>
                                            <%
                                                    }
                                                    br.close();
                                                } catch (FileNotFoundException fnfe) {
                                                    System.out.println("No ha sido posible encontrar el archivo ");
                                                } catch (IOException ioe) {
                                                    System.out.println("Se ha producido un error durante la lectura del archivo ");
                                                }

                                            %>
                                        </select>

                                        <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                        <% } else { %>
                                        <div id="divanno" style="padding-top: 10px; width: 100%;">
                                            <input type="file" id="annoFile_file" name="annoFile_file" class="filestyle" data-buttonBefore="true">
                                        </div>
                                        <% } %>

                                    </div>
                                    <div class="row" style="margin-top: 30px; padding-left: 25px;">
                                        <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Select the latest version of .OBO file available or provide your own .OBO file." ><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Select ontology file (.OBO):</p>
                                        <br>
                                        <select onchange="select_ontology()" class="form-control" name="oboFile" id="oboFile" required style="width: 100%;">
                                            <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                            <option value="auto" selected>Latest version available</option>
                                            <% } else { %>
                                            <option value="own_file" selected>Own file</option>
                                            <option value="auto">Latest version available</option>
                                            <% } %>
                                        </select>

                                        <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                        <% } else { %>
                                        <div id="divobo" style="padding-top: 10px; width: 100%;">
                                            <input type="file" id="oboFile_file" name="oboFile_file" class="filestyle" data-buttonBefore="true">
                                        </div>
                                        <% } %>

                                    </div>

                                    <div class="row" style="margin-top: 30px; padding-left: 25px;">
                                        <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="TXT Format: This file contains all gene names (one per line) of the population set, e.g. the names of the genes of your microarray." ><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Select population file:</p>
                                                <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                        <select class="form-control" name="populationFile" id="populationFile" required style="width: 100%;">
                                            <option value="population_file_demo" selected>Population_file_demo.txt</option>
                                        </select>
                                        <% } else { %>
                                        <input type="file" id="popFile" name="popFile" class="filestyle" required data-buttonBefore="true">
                                        <% } %>                                        
                                    </div>
                                    <p>&nbsp;</p>
                                </div>

                                <!-- Advanced options -->
                                <div class="bhoechie-tab-content" style="padding: 0px 20px 20px 20px;">
                                    <h2 class="article-title" style="color: #0099cc; text-align: left; font-size: 17px; font-weight: bold;">Statistical Measures</h2>
                                    <hr class="featurette-divider" style="margin-top: 0px; margin-right: 20px;">

                                    <p style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Specifies the enrichment analysis method: Parent-Child-Union, Parent-Child-Intersection or Term-For-Term."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Enrichment analysis method:</p>
                                    <select name="calculationMethod" class="form-control">
                                        <% if (request.getParameter("calculationMethod") != null) {
                                                if (request.getParameter("calculationMethod").equals("Term-For-Term")) {
                                        %>
                                        <option value="Term-For-Term" selected="">Term for Term</option>
                                        <option value="Parent-Child-Union">Parent Child Union</option>
                                        <option value="Parent-Child-Intersection">Parent Child Intersection</option>
                                        <% } else if (request.getParameter("calculationMethod").equals("Parent-Child-Union")) {%>
                                        <option value="Term-For-Term">Term for Term</option>
                                        <option value="Parent-Child-Union" selected="">Parent Child Union</option>
                                        <option value="Parent-Child-Intersection">Parent Child Intersection</option>
                                        <% } else { %>
                                        <option value="Term-For-Term">Term for Term</option>
                                        <option value="Parent-Child-Union">Parent Child Union</option>
                                        <option value="Parent-Child-Intersection" selected="">Parent Child Intersection</option>
                                        <% } %>
                                        <% } else { %>
                                        <option value="Term-For-Term" selected="">Term for Term</option>
                                        <option value="Parent-Child-Union">Parent Child Union</option>
                                        <option value="Parent-Child-Intersection">Parent Child Intersection</option>
                                        <% } %> 
                                    </select>
                                    <br>
                                    <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Specifies the MTC method to use: Bonferroni, Westfall-Young-Single-Step or none."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Multiple-Testing Correction method:</p>
                                    <select name="mtcMethod" class="form-control">
                                        <% if (request.getParameter("mtcMethod") != null) {
                                                if (request.getParameter("mtcMethod").equals("Bonferroni")) {
                                        %>
                                        <option value="Bonferroni" selected="">Bonferroni</option>
                                        <option value="None">None</option>
                                        <option value="Westfall-Young-Single-Step">Westfall Young Single Step</option>
                                        <% } else if (request.getParameter("mtcMethod").equals("Westfall-Young-Single-Step")) {%>
                                        <option value="Bonferroni">Bonferroni</option>
                                        <option value="None">None</option>
                                        <option value="Westfall-Young-Single-Step" selected="">Westfall Young Single Step</option>
                                        <% } else { %>
                                        <option value="Bonferroni">Bonferroni</option>
                                        <option value="None" selected="">None</option>
                                        <option value="Westfall-Young-Single-Step">Westfall Young Single Step</option>
                                        <% } %>
                                        <% } else { %>
                                        <option value="Bonferroni" selected="">Bonferroni</option>
                                        <option value="None">None</option>
                                        <option value="Westfall-Young-Single-Step">Westfall Young Single Step</option>
                                        <% } %>                                                
                                    </select>
                                    <br>
                                    <h2 class="article-title" style="color: #0099cc; text-align: left; font-size: 17px; font-weight: bold; ">Genes ID conversion</h2>
                                    <hr class="featurette-divider" style="margin-top: 0px; margin-right: 20px;">
                                    <div style="margin-top: -10px; text-align: justify;">BIGO uses the associated gene names. However, it offers the possibility of gene id conversion. Users provide a gene id conversion file. This file contains two columns: the first one corresponds to the original gene id and the second column corresponds to the new gene id.</div>

                                    <p style="margin-top: 20px; font-size: 14px; font-weight: bold;"> Do you need gene id conversion?</p>


                                    <select id="sConversion" name="sConversion" onchange="select_conversion()" class="form-control">
                                        <% if (request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
                                        <option value="n" selected="">No</option>
                                        <% } else { %>
                                        <% if (request.getParameter("sConversion") != null) {
                                                if (request.getParameter("sConversion").equals("n")) {
                                        %>
                                        <option value="n" selected="">No</option>
                                        <option value="y">Yes</option>
                                        <% } else {%>
                                        <option value="n">No</option>
                                        <option value="y" selected="">Yes</option>
                                        <% } %>
                                        <% } else { %>
                                        <option value="n" selected="">No</option>
                                        <option value="y">Yes</option>
                                        <% } %>
                                        <% } %>                                        
                                    </select>
                                    <br>
                                    <div id="divConversion">
                                        <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Minimum number of terms that should share two independent groups of genes."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Gene Id conversion file (CSV):</p>
                                        <input type="file" id="sGenesCsv" name="sGenesCsv" class="filestyle" data-buttonBefore="true">                                                
                                        <br>
                                        <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Minimum number of terms that should share two independent groups of genes."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Separator character:</p>
                                        <select onchange="select_type()" class="form-control" name="type_character" id="type_character" required style="width: 150px; display: inline; margin-bottom: 20px;">
                                            <% if (request.getParameter("type_character") != null) {
                                                    if (request.getParameter("type_character").equals("tab")) {
                                            %>
                                            <option value="tab" selected="">Tab key</option>
                                            <option value="space">Space bar</option>
                                            <option value="other">Other character</option>
                                            <% } else if (request.getParameter("type_character").equals("space")) {%>
                                            <option value="tab">Tab key</option>
                                            <option value="space" selected="">Space bar</option>
                                            <option value="other">Other character</option>
                                            <% } else { %>
                                            <option value="tab">Tab key</option>
                                            <option value="space">Space bar</option>
                                            <option value="other" selected="">Other character</option>
                                            <% } %>
                                            <% } else { %>
                                            <option value="tab" selected="">Tab key</option>
                                            <option value="space">Space bar</option>
                                            <option value="other">Other character</option>
                                            <% } %>
                                        </select>
                                        <% if (request.getParameter("sSeparator") != null) {
                                        %>
                                        <input id="character" name="sSeparator" type="text" class="form-control" placeholder="Input your character" style="width: 180px;" maxlength="1" value="<%=request.getParameter("sSeparator")%>">
                                        <% } else { %>
                                        <input id="character" name="sSeparator" type="text" class="form-control" placeholder="Input your character" style="width: 180px;" maxlength="1">
                                        <% } %>                                                
                                        <br>
                                    </div>
                                    <p>&nbsp;</p>
                                </div>
                            </div>
                        </div>

                        <input type="hidden" name="calculate_enrichment" value="yes" />
                        <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                        <p class="pull-right" style="margin: 40px 8% 0% 0%;"><input type="submit" class="btn btn-success btn-lg" data-toggle="modal" data-target="#loading" data-backdrop="static" data-keyboard="false" value="Execute &#9655;"></p>
                        </html:form>


                    <div class="row">
                        <div class="col-md-6" style="margin: 40px 0% 4% 10%; ">
                            <html:form action="quitProvide">
                                <input type="hidden" name="contfile" value="<%=iContFile%>" />
                                <input type="hidden" name="sessionId" value="<%=session.getId()%>" />
                                <p style="text-align: left; font-size: 25px;"><input type="submit" class="btn btn-danger btn-lg" value="&#9665; Quit"></p>
                                </html:form>
                        </div>
                    </div>

                    <% } else { %>
                    <div style="text-align: center; margin-top: 50px; margin-bottom: 50px;">
                        <img src="images/bigo/empty_box.jpg" style="width: 20%;">
                        <p style="font-size: 16px; font-weight: bold;">No files uploaded yet.</p>
                        <p>To upload a file click the "Select files..." button</p>
                    </div>
                    <%
                        }
                    %>

                </div>
            </div>
        </article>
        <jsp:include page="components/footer.jsp" />
    </body>
</html>
