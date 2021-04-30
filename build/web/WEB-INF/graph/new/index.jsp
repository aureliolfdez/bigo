<%@page import="java.util.List"%>
<%@page import="processes.Bigo"%>
<%@page import="java.text.DecimalFormat"%>
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

        <!-- Cytoscape -->
        <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=Promise,fetch"></script>
        <script src="js/cytoscape_web/cytoscape.min.js"></script>        
        <link href="js/cytoscape_web/js-panzoom.css" rel="stylesheet" type="text/css" />
        <script src="js/cytoscape_web/cytoscape-panzoom.js"></script>

        <!-- DataTable -->        
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">        
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>        
        <script type="text/javascript" language="javascript" src="js/new_enrichment_desple.js"></script>
        <script type="text/javascript" src="js/bootstrap-filestyle.js"></script>

        <script type="text/javascript">
            $(document).ready(
                    function () {
                        $("#example2").dataTable({
                            "pageLength": 3,
                            "order": [[0, "asc"]],
                            "bLengthChange": false
                        });
                    }
            );

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

            function controlMinEdge()
            {
                if (document.getElementById("checkMinEdge").checked) {
                    document.getElementById("textMinEdge").disabled = false;
                    document.getElementById("textMinEdge").required = true;
                } else {
                    document.getElementById("textMinEdge").disabled = true;
                    document.getElementById("textMinEdge").required = false;
                }
            }

            function controlMaxEdge()
            {
                if (document.getElementById("checkMaxEdge").checked) {
                    document.getElementById("textMaxEdge").disabled = false;
                    document.getElementById("textMaxEdge").required = true;
                } else {
                    document.getElementById("textMaxEdge").disabled = true;
                    document.getElementById("textMaxEdge").required = false;
                }
            }
        </script>        

        <style>
            #alertas {width: 100%; height: 10%; border-bottom: 2px solid black;}
            #cytoscapeweb{ width:100%; height: 50%;}
            #note {width: 100%; height: 40%; background-color: #f0f0f0; overflow: auto; }
            p {padding: 0 0.5em; margin: 0; }
            p:first-child{ padding-top: 0.5em; }
        </style>
    </head>
    <body style="background-color: #f4f4f4;">
        <%
            if (session.getAttribute("bigoGraph") != null) { %>
        <script type="text/javascript">
            window.location = "#gonetwork";
        </script>
        <% }
            Bigo bigo = (Bigo) session.getAttribute("bigo");
            List<Bigo> listaBigos = (ArrayList<Bigo>) session.getAttribute("listaBigos");

            String private_files = "WEB-INF";
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = request.getSession().getId();
            String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
            String pathRankings = pathSesion + File.separator + "rankings";

            if (request.getParameter("maxEdge") != null) {
                session.setAttribute("maxEdge", request.getParameter("maxEdge"));
            } else {
                if (session.getAttribute("maxEdge") == null) {
                    session.setAttribute("maxEdge", 100);
                }
            }

            if (request.getParameter("minEdge") != null) {
                session.setAttribute("minEdge", request.getParameter("minEdge"));
            } else {
                if (session.getAttribute("minEdge") == null) {
                    session.setAttribute("minEdge", 0);
                }
            }
        %>

        <jsp:include page="../../../components/header.jsp" />
        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">Third step. Groups of genes network</a></li>
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

                        <!-- PROCESSING MODAL (APPLY FILTERS) -->
                        <div class="modal fade" id="processing" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
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
                                <h2>Third step. Groups of genes network</h2>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 0% 8%;">
                            <div class="col-md-9" style="text-align: justify">
                                A group of genes network will be generated from any of the previous saved rankings. In this network, a node represents a group of genes and an edge between two nodes implies that these two group of genes share biological terms extracted from the enrichment analysis results. The value in the edge represents the percentage of the shared biological terms.
                            </div>
                            <div class="col-md-3" style="text-align: center;">
                                <img src="images/bigo/graph/graph-icon.png" style="width: 80%;">
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12">
                                <table id="example2" class="table table-striped table-bordered table-responsive" cellspacing="0" width="100%" style="width: 100%; text-align: center;">
                                    <thead>
                                    <th style="text-align:center;">#</th>
                                    <th style="text-align:center;">Information content</th>
                                    <th style="text-align:center;">LFT CutOff</th>
                                    <th style="text-align:center;">HFT CutOff</th>
                                    <th style="text-align:center;">PValue CutOff</th>
                                    <th style="text-align:center;">LFT Terms</th>
                                    <th style="text-align:center;">HFT Terms</th>
                                    <th>&nbsp;</th>
                                    </thead>
                                    <tbody>
                                        <%
                                            int iContador = 1;
                                            //Muestro el ranking original
                                            Bigo bigo_base = (Bigo) session.getAttribute("bigo_base");
                                            out.write("<tr><td style='vertical-align:middle; font-weight: bold;'>" + iContador + "</td><td colspan=6 style='vertical-align:middle;'>Original result</td><td style='display:none'></td><td style='display:none'></td><td style='display:none'></td><td style='display:none'></td><td style='display:none'></td><td>");
                                        %>
                                        <html:form action="viewGraphCreate">
                                        <input type="hidden" name="base" value="base" />
                                        <input type="hidden" name="savedIc" value="<%=bigo_base.getMaxIC()%>" />
                                        <input type="hidden" name="savedMinLevel" value="<%=bigo_base.getMinLevel()%>" />
                                        <input type="hidden" name="savedLevel" value="<%=bigo_base.getLevel()%>" />
                                        <input type="hidden" name="savedConfidence" value="<%=bigo_base.getConfidenceFactor()%>" />
                                        <input type="hidden" name="savedStopwords" value="<%=bigo_base.getStopwords()%>" />
                                        <input type="hidden" name="savedUniques" value="<%=bigo_base.getUniques()%>" />
                                        <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" data-toggle="modal" data-target="#loading" data-backdrop="static" data-keyboard="false" value="View network" />
                                    </html:form>
                                    <%
                                        out.write("</td></tr>");
                                        iContador++;
                                        if (listaBigos != null && !listaBigos.isEmpty()) { // Si hay algun ranking guardado.
                                            for (Bigo b : listaBigos) {
                                                String sResLevel = b.getLevel() + "";
                                                String sResIc = b.getMaxIC() + "";
                                                String sResConfi = b.getConfidenceFactor() + "";
                                                String sResMinLevel = b.getMinLevel() + "";
                                                if (b.getLevel() == 101) {
                                                    sResLevel = "Not applied";
                                                }
                                                if (b.getMaxIC() == 9999) {
                                                    sResIc = "Not applied";
                                                }
                                                if (b.getConfidenceFactor() == 1) {
                                                    sResConfi = "Not applied";
                                                }
                                                if (b.getMinLevel() == 0) {
                                                    sResMinLevel = "Not applied";
                                                }
                                                out.write("<tr><td style='vertical-align:middle; font-weight: bold;'>" + iContador + "</td><td style='vertical-align:middle;'>" + sResIc + "</td><td style='vertical-align:middle;'>" + sResMinLevel + "</td><td style='vertical-align:middle;'>" + sResLevel + "</td><td style='vertical-align:middle;'>" + sResConfi + "</td><td style='vertical-align:middle;'>" + b.getUniques() + "</td><td style='vertical-align:middle;'>" + b.getStopwords() + "</td><td>");
                                    %>
                                    <html:form action="viewGraphCreate">
                                        <input type="hidden" name="base" value="nobase" />
                                        <input type="hidden" name="savedIc" value="<%=b.getMaxIC()%>" />
                                        <input type="hidden" name="savedMinLevel" value="<%=b.getMinLevel()%>" />
                                        <input type="hidden" name="savedLevel" value="<%=b.getLevel()%>" />
                                        <input type="hidden" name="savedConfidence" value="<%=b.getConfidenceFactor()%>" />
                                        <input type="hidden" name="savedStopwords" value="<%=b.getStopwords()%>" />
                                        <input type="hidden" name="savedUniques" value="<%=b.getUniques()%>" />
                                        <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" data-toggle="modal" data-target="#loading" data-backdrop="static" data-keyboard="false" value="View network" />
                                    </html:form>
                                    <% out.write("</td></tr>");
                                                iContador++;
                                            }
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div>
                        </div>


                        <p style="margin-bottom: 50px;" id="gonetwork">&nbsp;</p>

                        <%
                            if (session.getAttribute("executeGraph") != null && session.getAttribute("executeGraph").equals("true")) {
                                Bigo bigoGraph = (Bigo) session.getAttribute("bigoGraph");
                                String salidaWebGraph = (String) session.getAttribute("salidaWebGraph");
                        %>

                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12" style="text-align: justify;">
                                <h4>Group of genes network visualization</h4>
                                By clicking a node, user can access to additional information about the biological terms and genes related to this group of genes. By clicking an edge, user can access to additional information about the biological terms and genes shared by the two group of genes related.
                                <hr id="visualize" class="featurette-divider" style="margin-bottom: 30px;">
                                <div id="cy" style="height: 550px; width: 100%;"></div>
                            </div>
                        </div>

                        <script type="text/javascript">
                            <%=salidaWebGraph%>
                        </script>

                        <div id="optionsEnrichment" class="row bhoechie-tab-container" style="margin: 0% 8% 4% 8%; visibility: hidden;">
                            <div class="col-lg-2 col-md-2 col-sm-12 col-xs-12 bhoechie-tab-menu">
                                <div class="list-group">
                                    <a href="#optionsEnrichment" class="list-group-item active text-center">
                                        <h4 class="fa fa-signal"></h4><br />Terms
                                    </a>
                                    <a href="#optionsEnrichment" class="list-group-item text-center">
                                        <h4 class="fa fa-signal"></h4><br />Genes
                                    </a>
                                </div>
                            </div>                            

                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10 bhoechie-tab">
                                <!-- Terms options -->
                                <div class="bhoechie-tab-content active" style="padding: 0px 20px 20px 20px;">
                                    <h2 class="article-title" style="color: #0099cc; text-align: left; font-size: 17px; font-weight: bold;">Terms information</h2>
                                    <hr class="featurette-divider" style="margin-top: 0px;">
                                    <table class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top: 50px;">
                                        <thead>
                                            <tr>
                                                <th style='min-width: 100px;'>Property</th>
                                                <th style='min-width: 100px;'>Value</th>
                                            </tr>
                                        </thead>
                                        <tbody id="optionsNetworkTerms">                                                                              
                                        </tbody>                                    
                                    </table>
                                    <p>&nbsp;</p>
                                </div>

                                <!-- Genes options -->
                                <div class="bhoechie-tab-content" style="padding: 0px 20px 20px 20px;">
                                    <h2 class="article-title" style="color: #0099cc; text-align: left; font-size: 17px; font-weight: bold;">Genes information</h2>
                                    <hr class="featurette-divider" style="margin-top: 0px; margin-right: 20px;">
                                    <table class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top: 50px;">
                                        <thead>
                                            <tr>
                                                <th style='min-width: 100px;'>Property</th>
                                                <th style='min-width: 100px;'>Value</th>
                                            </tr>
                                        </thead>
                                        <tbody id="optionsNetworkGenes">                                                                              
                                        </tbody>                                    
                                    </table>
                                    <p>&nbsp;</p>
                                </div>
                            </div>
                        </div>


                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12" style="text-align: justify;">
                                <h4>Network filtering options</h4>
                                <hr id="filter" class="featurette-divider">
                                The network can be filtered using at least one of the following options.
                            </div>
                        </div>

                        <div class="row" style="margin: 4% 8% 4% 8%;">
                            <div class="col-md-9">
                                <html:form action="applyFiltersGraphCreate" method="post">                                
                                    <p style="font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Edges with a percentage under this value will be dropped from the network"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Min. Percentage:</p>
                                            <%
                                                if (session.getAttribute("firstGraph") != null && session.getAttribute("firstGraph").equals("true")) {
                                                    double d = Double.parseDouble(session.getAttribute("minEdge").toString());
                                                    double max = 0;
                                                    if (session.getAttribute("minEdge") != null && (double) d == max) {
                                                        if (session.getAttribute("prevMinEdge") == null) {
                                            %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMinEdge" name="minEdge" value="" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" disabled="" /></td>
                                            <td><input type="checkbox" id="checkMinEdge" name="enable_minEdge" value="true" onclick="controlMinEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>                                        
                                    </table> 
                                    <% } else {%>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMinEdge" name="minEdge" value="<%=session.getAttribute("prevMinEdge")%>" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" disabled="" /></td>
                                            <td><input type="checkbox" id="checkMinEdge" name="enable_minEdge" value="true" onclick="controlMinEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>                                        
                                    </table>                                    
                                    <% }  %>
                                    <% } else {
                                        if (session.getAttribute("enable_minEdge") == null) { //Esta desactivado
                                    %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMinEdge" name="minEdge" value="<%=session.getAttribute("minEdge")%>" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" disabled="" /></td>
                                            <td><input type="checkbox" id="checkMinEdge" name="enable_minEdge" value="true" onclick="controlMinEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>                                        
                                    </table>                                    
                                    <% } else { //Esta activo %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMinEdge" name="minEdge" value="<%=session.getAttribute("minEdge")%>" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" required /></td>
                                            <td><input type="checkbox" id="checkMinEdge" name="enable_minEdge" value="true" onclick="controlMinEdge()" checked="" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>                                        
                                    </table>                                    
                                    <% }
                                        }
                                    %>
                                    <% } else { %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMinEdge" name="minEdge" value="" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" required /></td>
                                            <td><input type="checkbox" id="checkMinEdge" name="enable_minEdge" value="true" onclick="controlMinEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>                                        
                                    </table>                                    
                                    <% }%>

                                    <p>&nbsp;</p>
                                    <p style="margin-top: 10px; font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="Edges with a percentage over this value will be dropped from the network"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Max. Percentage:</p>
                                            <%
                                                if (session.getAttribute("firstGraph") != null && session.getAttribute("firstGraph").equals("true")) {
                                                    double d = Double.parseDouble(session.getAttribute("maxEdge").toString());
                                                    double max = 100;
                                                    if (session.getAttribute("maxEdge") != null && (double) d == max) {
                                                        if (session.getAttribute("prevMaxEdge") == null) {
                                            %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMaxEdge" name="maxEdge" value="" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" disabled="" /></td>
                                            <td><input type="checkbox" id="checkMaxEdge" name="enable_maxEdge" value="true" onclick="controlMaxEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>
                                    </table>                                    
                                    <% } else {%>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMaxEdge" name="maxEdge" value="<%=session.getAttribute("prevMaxEdge")%>" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" disabled="" /></td>
                                            <td><input type="checkbox" id="checkMaxEdge" name="enable_maxEdge" value="true" onclick="controlMaxEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>
                                    </table>                                    
                                    <% } %>
                                    <% } else {
                                        if (session.getAttribute("enable_maxEdge") == null) { //Esta desactivado
                                    %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMaxEdge" name="maxEdge" value="<%=session.getAttribute("maxEdge")%>" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" disabled="" /></td>
                                            <td><input type="checkbox" id="checkMaxEdge" name="enable_maxEdge" value="true" onclick="controlMaxEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>
                                    </table>                                    
                                    <% } else { //Esta activo %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMaxEdge" name="maxEdge" value="<%=session.getAttribute("maxEdge")%>" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" required /></td>
                                            <td><input type="checkbox" id="checkMaxEdge" name="enable_maxEdge" value="true" onclick="controlMaxEdge()" checked="" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>
                                    </table>                                    
                                    <% }
                                        }
                                    %>
                                    <% } else { %>
                                    <table width="100%">
                                        <tr>
                                            <td style="padding-right: 12px;"><input type="number" id="textMaxEdge" name="maxEdge" value="" min="0" max="100" step="0.01" class="form-control" onkeypress="return numeros(event);" required /></td>
                                            <td><input type="checkbox" id="checkMaxEdge" name="enable_maxEdge" value="true" onclick="controlMaxEdge()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2);"></td>
                                        </tr>
                                    </table>                                    
                                    <% } %>                                    

                                    <p>&nbsp;</p>                                    
                                    <input type="submit" class="btn btn-success" value="Apply filters" style="font-weight:bold;" />  
                                </html:form>
                            </div>
                            <div class="col-md-3 justify-content-center align-self-center">
                                <img src="images/bigo/ranking/filter.png" style="width: 100%;">
                            </div>
                        </div>


                        <div class="row" style="margin: 4% 8% 4% 8%;">
                            <div class="col-md-12">
                                <h4>Additional options</h4>
                                <hr>
                            </div>
                        </div>


                        <div class="row" style="margin: 0% 8% 4% 8%; text-align: center;">
                            <div class="col-md-4" style="margin-top: 10px;">
                                <a href="#" id="contentPng" target="_blank"><input type="button" value="View network
                                                                    to PNG" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 80px; background:url(images/bigo/graph/png_icon.png) no-repeat top center;"/></a>
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <a href="#" id="contentJpg" target="_blank"><input type="button" value="View network
                                                                    to JPG" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 80px; background:url(images/bigo/graph/png_icon.png) no-repeat top center;"/></a>
                            </div>
                            <script type="text/javascript">
                                $('#contentPng').attr('href',contentPng);
                                $('#contentJpg').attr('href',contentJpg);
                            </script>

                            <div class="col-md-4" style="margin-top: 10px;">
                                <html:form action="downloadGraphInfoCreate" method="post">
                                    <input type="submit" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 80px; background:url(images/bigo/graph/file-info-icon.png) no-repeat top center;" value="Download network 
                                           information" />
                                </html:form>
                            </div>
                        </div>                          
                        <%
                            }
                        %>

                        <div class="row" style="margin: 0% 8% 4% 8%;">
                            <div class="col-md-12" style="text-align: left;">
                                <html:form action="backGraphCreate">
                                    <p style="text-align: left; font-size: 25px; margin-top: 38px;"><input type="submit" class="btn btn-danger btn-lg" value="&#9665; Back"></p>
                                    </html:form>
                            </div>
                        </div>


                    </div>

                </div>
        </article>      
        <jsp:include page="../../../components/footer.jsp" />



    </body>
</html>
