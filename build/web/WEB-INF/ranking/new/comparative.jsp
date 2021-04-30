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


        <!-- DataTable -->
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/new_enrichment_desple.js"></script>
        <script type="text/javascript" src="js/bootstrap-filestyle.js"></script>

        <script type="text/javascript">

            function cluster1() {

                var nomFichero = document.getElementById("select_cluster1").value;
                var limit_ic = nomFichero.indexOf("-", 7);
                var limit_minlevel = nomFichero.indexOf("-", limit_ic + 1);
                var limit_maxlevel = nomFichero.indexOf("-", limit_minlevel + 1);
                var limit_confidence = nomFichero.indexOf("-", limit_maxlevel + 1);
                var limit_stopwords = nomFichero.indexOf("-", limit_confidence + 1);
                var ic = nomFichero.substring(7, limit_ic);
                var minlevel = nomFichero.substring(limit_ic + 1, limit_minlevel);
                var maxlevel = nomFichero.substring(limit_minlevel + 1, limit_maxlevel);
                var confidence = nomFichero.substring(limit_maxlevel + 1, limit_confidence).replace("_", ".");
                var stopwords = nomFichero.substring(limit_confidence + 1, limit_stopwords);
                var uniques = nomFichero.substring(limit_stopwords + 1, nomFichero.length - 4);

                if (minlevel == "no") {
                    document.getElementById("lft_cluster1").innerHTML = "Not applied";
                } else {
                    document.getElementById("lft_cluster1").innerHTML = "< " + minlevel + " %";
                }
                if (maxlevel == "no") {
                    document.getElementById("commons_cluster1").innerHTML = "Not applied";
                } else {
                    document.getElementById("commons_cluster1").innerHTML = "> " + maxlevel + " %";
                }
                if (ic == "no") {
                    document.getElementById("ic_cluster1").innerHTML = "Not applied";
                } else {
                    document.getElementById("ic_cluster1").innerHTML = "< " + ic;
                }
                if (confidence == "no") {
                    document.getElementById("confidence_cluster1").innerHTML = "Not applied";
                } else {
                    document.getElementById("confidence_cluster1").innerHTML = "p < " + confidence;
                }
                document.getElementById("stopwords_cluster1").innerHTML = stopwords;
                document.getElementById("uniques_cluster1").innerHTML = uniques;
            }

            function cluster2() {
                var nomFichero = document.getElementById("select_cluster2").value;
                var limit_ic = nomFichero.indexOf("-", 7);
                var limit_minlevel = nomFichero.indexOf("-", limit_ic + 1);
                var limit_maxlevel = nomFichero.indexOf("-", limit_minlevel + 1);
                var limit_confidence = nomFichero.indexOf("-", limit_maxlevel + 1);
                var limit_stopwords = nomFichero.indexOf("-", limit_confidence + 1);
                var ic = nomFichero.substring(7, limit_ic);
                var minlevel = nomFichero.substring(limit_ic + 1, limit_minlevel);
                var maxlevel = nomFichero.substring(limit_minlevel + 1, limit_maxlevel);
                var confidence = nomFichero.substring(limit_maxlevel + 1, limit_confidence).replace("_", ".");
                var stopwords = nomFichero.substring(limit_confidence + 1, limit_stopwords);
                var uniques = nomFichero.substring(limit_stopwords + 1, nomFichero.length - 4);
                if (minlevel == "no") {
                    document.getElementById("lft_cluster2").innerHTML = "Not applied";
                } else {
                    document.getElementById("lft_cluster2").innerHTML = "< " + minlevel + " %";
                }
                if (maxlevel == "no") {
                    document.getElementById("commons_cluster2").innerHTML = "Not applied";
                } else {
                    document.getElementById("commons_cluster2").innerHTML = " > " + maxlevel + " %";
                }
                if (ic == "no") {
                    document.getElementById("ic_cluster2").innerHTML = "Not applied";
                } else {
                    document.getElementById("ic_cluster2").innerHTML = "< " + ic;
                }
                if (confidence == "no") {
                    document.getElementById("confidence_cluster2").innerHTML = "Not applied";
                } else {
                    document.getElementById("confidence_cluster2").innerHTML = "p < " + confidence;
                }
                document.getElementById("stopwords_cluster2").innerHTML = stopwords;
                document.getElementById("uniques_cluster2").innerHTML = uniques;
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
    <body style="background-color: #f4f4f4;">
        <%
            if (session.getAttribute("executeComparative") != null) {
                if (session.getAttribute("executeComparativeRanking") != null) { %>
        <script type="text/javascript">
            window.location = "#rankingDatatableComparative";
        </script>
        <% } else { %>
        <script type="text/javascript">
            window.location = "#reviewRankingsComparative";
        </script>
        <% }
            } %>

        <%
            Bigo bigo = (Bigo) session.getAttribute("bigo");
            List<Bigo> listaBigos = (ArrayList<Bigo>) session.getAttribute("listaBigos");
            int clusters = bigo.getcConjuntoTerminos().size();
            int numGoTermsInicial = bigo.getoOutput_base().getRank().getcResult().size();
            String private_files = "WEB-INF";
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = request.getSession().getId();
            String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
            String pathRankings = pathSesion + File.separator + "rankings";
        %>
        <jsp:include page="../../../components/header.jsp" />
        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a name="up" href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">Second step. Ranking of biological terms</a></li>
                    <li style="font-weight: normal;">
                        Comparative rankings
                    </li>
                </ul>
                <br>

                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div>
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

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12" style="text-align: center;">
                                <h2>Second step. Ranking of biological terms</h2>
                                <h4 style="font-weight: normal;">Additional option: Rankings comparative</h4>
                            </div>
                        </div>

                        <html:form action="executeComparativeRankingCreate">
                            <div class="row" style="margin: 3% 8% 4% 8%;">
                                <div class="col-xs-7 col-md-5" style="width: 42%;">
                                    <select id="select_cluster1" name="select_cluster1" class="form-control" style="width: 85%; display: inline-block;" onchange="cluster1()">
                                        <option value="output-no-no-no-no-0-0.txt" selected>Original ranking</option>
                                        <%                                                File dirPathRankings = new File(pathRankings);
                                            File[] listRankings = dirPathRankings.listFiles();

                                            if (dirPathRankings.exists() && dirPathRankings.listFiles().length > 0) {
                                                for (File f : listRankings) {
                                                    String nomFichero = f.getName();
                                                    if (!nomFichero.equals("output-no-no-no-no-0-0.txt") && !nomFichero.equals("rankingFiles.zip") && !nomFichero.equals("stopwords.txt") && !nomFichero.equals("uniques.txt")) {
                                                        out.write("<option value='" + nomFichero + "'>" + nomFichero + "</option>");
                                                    }
                                                }
                                            }
                                        %>
                                    </select>
                                    <div style="background-color: #fde1e1; border-right: 1px solid #cccccc; border-bottom: 1px solid #cccccc; border-left: 1px solid #cccccc; margin-left: 10px; padding: 10px 10px 10px 10px; width: 78%;">
                                        <span style="font-weight: bold;">Information content:</span> <span id="ic_cluster1">Not applied</span><br/>
                                        <span style="font-weight: bold;">LFT CutOff:</span> <span id="lft_cluster1">Not applied</span><br />
                                        <span style="font-weight: bold;">HFT CutOff:</span> <span id="commons_cluster1">Not applied</span><br />
                                        <span style="font-weight: bold;">PValue CutOff:</span> <span id="confidence_cluster1">Not applied</span><br/>
                                        <span style="font-weight: bold;">Hight Frequency Terms:</span> <span id="stopwords_cluster1">0</span><br/>
                                        <span style="font-weight: bold;">Low Frequency Terms:</span> <span id="uniques_cluster1">0</span><br/>
                                    </div>
                                </div>
                                <div class="col-xs-4 col-md-2 justify-content-center align-self-center" style="text-align: left;">
                                    <img src="images/bigo/ranking/compare.png" style="width: 100%;" />
                                </div>
                                <div class="col-xs-7 col-md-5" style="width: 42%;">
                                    <select id="select_cluster2" name="select_cluster2" class="form-control" style="width: 85%;display: inline-block;" onchange="cluster2()">
                                        <option value="output-no-no-no-no-0-0.txt" selected >Original ranking</option>
                                        <%
                                            if (dirPathRankings.exists() && dirPathRankings.listFiles().length > 0) {
                                                for (File f : listRankings) {
                                                    String nomFichero = f.getName();
                                                    if (!nomFichero.equals("output-no-no-no-no-0-0.txt") && !nomFichero.equals("rankingFiles.zip") && !nomFichero.equals("stopwords.txt") && !nomFichero.equals("uniques.txt")) {
                                                        out.write("<option value='" + nomFichero + "'>" + nomFichero + "</option>");
                                                    }
                                                }
                                            }
                                        %>
                                    </select>
                                    <div style="background-color: #fde1e1; border-right: 1px solid #cccccc; border-bottom: 1px solid #cccccc; border-left: 1px solid #cccccc; margin-left: 10px; padding: 10px 10px 10px 10px; width: 78%;">
                                        <span style="font-weight: bold;">Information content:</span> <span id="ic_cluster2">Not applied</span><br/>
                                        <span style="font-weight: bold;">LFT CutOff:</span> <span id="lft_cluster2">Not applied</span><br />
                                        <span style="font-weight: bold;">HFT CutOff:</span> <span id="commons_cluster2">Not applied</span><br />
                                        <span style="font-weight: bold;">PValue CutOff:</span> <span id="confidence_cluster2">Not applied</span><br/>
                                        <span style="font-weight: bold;">High Frequency Terms:</span> <span id="stopwords_cluster2">0</span><br/>
                                        <span style="font-weight: bold;">Low Frequency Terms:</span> <span id="uniques_cluster2">0</span><br/>
                                    </div>
                                </div>
                            </div>
                            <div class="row" style="margin: 3% 8% 4% 8%;">
                                <div class="col-md-12" style="text-align: center;">
                                    <input type="hidden" name="clusters" value="<%=clusters%>" />
                                    <input type="submit" class="btn btn-warning btn-lg center-block" style="margin-top: 50px; margin-bottom: 80px; font-weight: bold; color: white;" value=" &Implies;  COMPARE RANKINGS &DoubleLeftArrow; "/>
                                </div>
                            </div>
                        </html:form>

                        <%
                            if (session.getAttribute("executeComparative") != null && session.getAttribute("executeComparative").equals("true")) {
                        %>
                        <div id="reviewRankingsComparative" ></div>

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12">
                                <h4>Ranking comparative review</h4>
                                <hr>
                                <table class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top: 50px;">
                                    <thead>
                                        <tr>
                                            <th style='min-width: 100px;'>Property</th>
                                            <th style='min-width: 100px; text-align: center;'><%
                                                if (session.getAttribute("cluster1").equals("output-no-no-no-no-0-0.txt")) {
                                                    out.write("Original Ranking");
                                                } else {
                                                    out.write(session.getAttribute("cluster1").toString());
                                                }
                                                %></th>
                                            <th style='min-width: 100px; text-align: center;'><%
                                                if (session.getAttribute("cluster2").equals("output-no-no-no-no-0-0.txt")) {
                                                    out.write("Original Ranking");
                                                } else {
                                                    out.write(session.getAttribute("cluster2").toString());
                                                }
                                                %></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of groups of genes being analyzed"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Group of genes:</span>
                                            </td>
                                            <td style="text-align: center;">
                                                <%=clusters%>
                                            </td>
                                            <td style="text-align: center;">
                                                <%=clusters%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of biological terms being analyzed"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Biological terms:</span>
                                            </td>
                                            <td style="text-align: center;"><%=numGoTermsInicial%></td>
                                            <td style="text-align: center;"><%=numGoTermsInicial%></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of biological terms obtained by the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Filtered biological terms:</span>
                                            </td>
                                            <td style="text-align: center;"><%=session.getAttribute("numGoTermsFiltrado_cluster1")%></td>
                                            <td style="text-align: center;"><%=session.getAttribute("numGoTermsFiltrado_cluster2")%></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of high frequency terms obtained by the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Total HFT</span>
                                            </td>
                                            <td style="text-align: center;"><%=session.getAttribute("stopwords_cluster1")%></td>
                                            <td style="text-align: center;"><%=session.getAttribute("stopwords_cluster2")%></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of the low frequency terms obtained by the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Total LFT</span>
                                            </td>
                                            <td style="text-align: center;"><%=session.getAttribute("unique_cluster1")%></td>
                                            <td style="text-align: center;"><%=session.getAttribute("unique_cluster2")%></td>
                                        </tr>
                                        <tr>
                                            <td style="border-top: 2px solid #cccccc;">
                                                <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Significance cutoff used in the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Pvalue cutoff:</span>
                                            </td>
                                            <td style="border-top: 2px solid #cccccc; text-align: center;">
                                                <%
                                                    if (session.getAttribute("confidence_cluster1") != null && session.getAttribute("confidence_cluster1").toString().equals("no")) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print("p < " + session.getAttribute("confidence_cluster1"));
                                                    }
                                                %>
                                            </td>
                                            <td style="border-top: 2px solid #cccccc; text-align: center;">
                                                <%
                                                    if (session.getAttribute("confidence_cluster2") != null && session.getAttribute("confidence_cluster2").toString().equals("no")) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print("p < " + session.getAttribute("confidence_cluster2"));
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Information content value used in the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Information content:</span>
                                            </td>
                                            <td style="text-align: center;">
                                                <%
                                                    if (session.getAttribute("ic_cluster1") != null && session.getAttribute("ic_cluster1").toString().equals("no")) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(session.getAttribute("ic_cluster1") + " %");
                                                    }
                                                %>
                                            </td>
                                            <td style="text-align: center;">
                                                <%
                                                    if (session.getAttribute("ic_cluster2") != null && session.getAttribute("ic_cluster2").toString().equals("no")) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(session.getAttribute("ic_cluster2") + " %");
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Low Frequency terms cutoff used in the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> HFT cutoff:</span>
                                            </td>
                                            <td style="text-align: center;">
                                                <%
                                                    if (session.getAttribute("levelUser_cluster1") != null && Integer.parseInt(session.getAttribute("levelUser_cluster1").toString()) == 101) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(session.getAttribute("levelUser_cluster1") + " %");
                                                    }
                                                %>
                                            </td>
                                            <td style="text-align: center;">
                                                <%
                                                    if (session.getAttribute("levelUser_cluster2") != null && Integer.parseInt(session.getAttribute("levelUser_cluster2").toString()) == 101) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(session.getAttribute("levelUser_cluster2") + " %");
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="High Frequency terms cutoff used in the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> LFT cutoff:</span>
                                            </td>
                                            <td style="text-align: center;">
                                                <%
                                                    if (session.getAttribute("minLevelUser_cluster1") != null && Integer.parseInt(session.getAttribute("minLevelUser_cluster1").toString()) == 0) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(session.getAttribute("minLevelUser_cluster1") + " %");
                                                    }
                                                %>
                                            </td>
                                            <td style="text-align: center;">
                                                <%
                                                    if (session.getAttribute("minLevelUser_cluster2") != null && Integer.parseInt(session.getAttribute("minLevelUser_cluster2").toString()) == 0) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(session.getAttribute("minLevelUser_cluster2") + " %");
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td style="text-align: center;">
                                                <html:form action="viewComparativeRanking">
                                                    <input type="hidden" name="savedIc" value="<%
                                                        if (session.getAttribute("ic_cluster1") != null && session.getAttribute("ic_cluster1").equals("no")) {
                                                            out.print("9999");
                                                        } else {
                                                            out.print(session.getAttribute("ic_cluster1"));
                                                        }
                                                           %>" />
                                                    <input type="hidden" name="savedMinLevel" value="<%=session.getAttribute("minLevelUser_cluster1")%>" />
                                                    <input type="hidden" name="savedLevel" value="<%=session.getAttribute("levelUser_cluster1")%>" />
                                                    <input type="hidden" name="savedConfidence" value="<%
                                                        if (session.getAttribute("confidence_cluster1") != null && session.getAttribute("confidence_cluster1").equals("no")) {
                                                            out.print("1");
                                                        } else {
                                                            out.print(session.getAttribute("confidence_cluster1"));
                                                        }
                                                           %>" />
                                                    <input type="hidden" name="savedStopwords" value="<%=session.getAttribute("stopwords_cluster1")%>" />
                                                    <input type="hidden" name="savedUniques" value="<%=session.getAttribute("unique_cluster1")%>" />
                                                    <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" value="View ranking" />
                                                </html:form>
                                            </td>
                                            <td style="text-align: center;">
                                                <html:form action="viewComparativeRanking">
                                                    <input type="hidden" name="savedIc" value="<%
                                                        if (session.getAttribute("ic_cluster2") != null && session.getAttribute("ic_cluster2").equals("no")) {
                                                            out.print("9999");
                                                        } else {
                                                            out.print(session.getAttribute("ic_cluster2"));
                                                        }
                                                           %>" />
                                                    <input type="hidden" name="savedMinLevel" value="<%=session.getAttribute("minLevelUser_cluster2")%>" />
                                                    <input type="hidden" name="savedLevel" value="<%=session.getAttribute("levelUser_cluster2")%>" />
                                                    <input type="hidden" name="savedConfidence" value="<%
                                                        if (session.getAttribute("confidence_cluster2") != null && session.getAttribute("confidence_cluster2").equals("no")) {
                                                            out.print("1");
                                                        } else {
                                                            out.print(session.getAttribute("confidence_cluster2"));
                                                        }
                                                           %>" />
                                                    <input type="hidden" name="savedStopwords" value="<%=session.getAttribute("stopwords_cluster2")%>" />
                                                    <input type="hidden" name="savedUniques" value="<%=session.getAttribute("unique_cluster2")%>" />
                                                    <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" value="View ranking" />
                                                </html:form>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12" style="text-align: right;">
                                <img src="images/bigo/ranking/go_up.png" />&nbsp;<a href="#up">Go up</a>
                            </div>
                        </div>

                        <% } %>

                        <%
                            if (session.getAttribute("executeComparativeRanking") != null) {
                        %>

                        <%
                            //SESIONES
                            if (request.getParameter("savedConfidence") != null) {
                                session.setAttribute("savedConfidence", request.getParameter("savedConfidence").replace("_", "."));
                            }

                            if (request.getParameter("savedMinLevel") != null) {
                                session.setAttribute("savedMinLevel", request.getParameter("savedMinLevel"));
                            }

                            if (request.getParameter("savedLevel") != null) {
                                session.setAttribute("savedLevel", request.getParameter("savedLevel"));
                            }

                            if (request.getParameter("savedIc") != null) {
                                session.setAttribute("savedIc", request.getParameter("savedIc").replace("_", "."));
                            }

                            if (request.getParameter("savedStopwords") != null) {
                                session.setAttribute("savedStopwords", request.getParameter("savedStopwords"));
                            }

                            if (request.getParameter("savedUniques") != null) {
                                session.setAttribute("savedUniques", request.getParameter("savedUniques"));
                            }

                            java.text.DecimalFormat formatoSalidaDecimal = new java.text.DecimalFormat("#.###");//para dos decimales
                            String savedIc = formatoSalidaDecimal.format(Double.parseDouble(session.getAttribute("savedIc").toString()));
                            String savedConfidence = formatoSalidaDecimal.format(Double.parseDouble(session.getAttribute("savedConfidence").toString()));
                            String savedLevel = session.getAttribute("savedLevel").toString();
                            String savedMinLevel = session.getAttribute("savedMinLevel").toString();
                            String savedStopwords = session.getAttribute("savedStopwords").toString();
                            String savedUniques = session.getAttribute("savedUniques").toString();
                            int levelUser = Integer.parseInt(savedLevel);
                            //levelUser = ((clusters * levelUser) / 100);
                            int minLevelUser = Integer.parseInt(savedMinLevel);
                            //minLevelUser = ((clusters * minLevelUser) / 100);

                            for (int i = 0; i < listaBigos.size() && bigo == null; i++) {
                                if (listaBigos.get(i).getMaxIC() == Double.parseDouble(savedIc) && listaBigos.get(i).getConfidenceFactor() == Double.parseDouble(savedConfidence) && listaBigos.get(i).getMinLevel() == Integer.parseInt(savedMinLevel) && listaBigos.get(i).getLevel() == Integer.parseInt(savedLevel) && listaBigos.get(i).getStopwords() == Integer.parseInt(savedStopwords) && listaBigos.get(i).getUniques() == Integer.parseInt(savedUniques)) {
                                    bigo = listaBigos.get(i);
                                }
                            }

                            if (savedLevel.equals("101")) {
                                savedLevel = "no";
                            }

                            if (savedIc.equals("9999")) {
                                savedIc = "no";
                            }

                            if (savedConfidence.equals("1")) {
                                savedConfidence = "no";
                            }

                            if (savedMinLevel.equals("0")) {
                                savedMinLevel = "no";
                            }

                            String fileFiltrado = "output-" + savedIc.replace(",", "_").replace(".", "_") + "-" + savedMinLevel.replace(",", "_").replace(".", "_") + "-" + savedLevel.replace(",", "_").replace(".", "_") + "-" + savedConfidence.replace(",", "_").replace(".", "_") + "-" + savedStopwords + "-" + savedUniques + ".txt";
                            String pathFiltrado = pathRankings + File.separator + fileFiltrado;
                            int numGoTermsFiltrado = 0, stopwords = 0, unique = 0;

                            File fComprobacionFiltrado = new File(pathFiltrado);
                            if (fComprobacionFiltrado.exists()) {
                                BufferedReader br = new BufferedReader(new FileReader(pathFiltrado));
                                String data;
                                br.readLine();
                                br.readLine();
                                br.readLine();
                                //Body file
                                while ((data = br.readLine()) != null) {
                                    String[] body = data.split(";");
                                    if (body.length == 6) {
                                        //int numClusterRow = Integer.parseInt(body[4].substring(0, body[4].indexOf("/")));
                                        String sCluster = body[4].substring(body[4].indexOf("(") + 1, body[4].length() - 2).replace(",", ".");
                                        double numClusterRow = Double.parseDouble(sCluster);
                                        boolean bStopword = levelUser <= numClusterRow;
                                        boolean bUnique = minLevelUser >= numClusterRow;
                                        if (bStopword) {
                                            stopwords++;
                                        }
                                        if (bUnique) {
                                            unique++;
                                        }
                                        numGoTermsFiltrado++;
                                    }
                                }
                                br.close();
                            }
                        %>
                        <div id="rankingDatatableComparative"></div>

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12">
                                <h4>View ranking file: <%
                                    if (fileFiltrado.equals("output-no-no-no-no-0-0.txt")) {
                                        out.write("Original Ranking");
                                    } else {
                                        out.write(fileFiltrado);
                                    }
                                    %></h4>
                                <hr>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 4% 8%;">                                
                            <div class="col-md-12">
                                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="width: 100%;">
                                    <thead>
                                        <tr>
                                            <th style="min-width: 100px;">ID</th>
                                            <th style="min-width: 300px;">Name</th>
                                            <th>Information content (IC)</th>
                                            <th>P value adjusted</th>
                                            <th>Total group of genes view</th>
                                            <th>No visible</th>
                                            <th>No visible</th>
                                            <th>List group of genes view</th>
                                        </tr>
                                    </thead>
                                </table>
                                <script type="text/javascript">
                                    $(document).ready(
                                            function () {
                                                var levelUser = <%=levelUser%>;
                                                var confidenceFactor = <%=Double.parseDouble(session.getAttribute("savedConfidence").toString())%>;
                                                var minLevelUser = <%=minLevelUser%>;
                                                $("#example").dataTable({
                                                    "sScrollX": "100%",
                                                    "pageLength": 25,
                                                    "order": [[5, "asc"], [6, "asc"], [3, "asc"]],
                                                    "bProcessing": false,
                                                    "bServerSide": false,
                                                    "sort": "position",
                                                    "sAjaxSource": "./ViewRankingDatatableServlet",
                                                    "aoColumns": [
                                                        {"mData": "id"},
                                                        {"mData": "name"},
                                                        {"mData": "ic"},
                                                        {"mData": "pvalue"},
                                                        {"mData": "num_biclusters"},
                                                        {bVisible: false, "mData": "num_bicluster"},
                                                        {bVisible: false, "mData": "list_biclusters"},
                                                        {"mData": "select"}
                                                    ],
                                                    "fnRowCallback": function (nRow, data, index) {
                                                        //var numClusterRow = data["num_biclusters"].substring(0, data["num_biclusters"].indexOf("/"));
                                                        var numClusterRow = data["num_biclusters"].substring(data["num_biclusters"].indexOf("(") + 1, data["num_biclusters"].length - 2).replace(",", ".");

                                                        if (levelUser > numClusterRow) // Si cumple el filtro de stopword
                                                        {
                                                            if (minLevelUser >= numClusterRow) { //Si cumple el filtro minLevel
                                                                $('td', nRow).css('background-color', '#a1de9b');
                                                            }
                                                        } else // Si no cumple el stopword
                                                        {
                                                            $('td', nRow).css('background-color', '#ffb5b5'); //Red
                                                            $('input', nRow).prop("checked", true);
                                                        }
                                                    }
                                                });
                                            }

                                    );
                                </script>
                            </div>
                        </div>

                        <div class="row" style="margin: 0% 8% 4% 8%;">
                            <div class="col-md-12" style="text-align: right;">
                                <img src="images/bigo/ranking/go_up.png" />&nbsp;<a href="#up">Go up</a>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12">
                                <h4>Additional options</h4>
                                <hr>
                            </div>
                        </div>
                        
                        <div class="row" style="text-align: center; margin: 3% 8% 4% 8%;">
                            <div class="col-md-4" style="margin-top: 10px;">
                                <html:form action="downloadViewComparativeRankingCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/download_filter.png) no-repeat top center;" value="Download this
                                           ranking" />
                                </html:form>
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <% if (unique == 0) {%>
                                <html:form action="downloadViewComparativeUniqueCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/uniques_file.png) no-repeat top center;" value="Download
                                           Low Frequency Terms" disabled />
                                </html:form>
                                <% } else {%>
                                <html:form action="downloadViewComparativeUniqueCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/uniques_file.png) no-repeat top center;" value="Download
                                           Low Frequency Terms" />
                                </html:form>
                                <% } %>
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <% if (stopwords == 0) {%>
                                <html:form action="downloadViewComparativeStopwordsCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" value="Download High
                                           Frequency Terms" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/stopwords_file.png) no-repeat top center;" disabled />
                                </html:form>
                                <% } else {%>
                                <html:form action="downloadViewComparativeStopwordsCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" value="Download High
                                           Frequency Terms" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/stopwords_file.png) no-repeat top center;"/>
                                </html:form>
                                <% }%>
                            </div>
                        </div>

                        <% }%>

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12">
                                <html:form action="backComparativeRankingCreate">
                                    <p><input type="submit" class="btn btn-danger btn-lg" value="&#9665 Back"></p>
                                    </html:form>
                            </div>
                        </div>
                    </div>
                </div>
        </article>
        <jsp:include page="../../../components/footer.jsp" />

    </body>
</html>
