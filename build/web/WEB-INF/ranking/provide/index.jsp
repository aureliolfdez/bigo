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
        <!-- <meta name="robots" content="index, follow" /> -->
        <meta name="keywords" content="enrichment analysis, cytoscape web plugin, bigo" />
        <meta name="description" content="BIGO. A tool to improve gene enrichment analysis in collections of genes">


        <!-- Frameworks -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <script src="js/jquery.js"></script>
        <script src="js/bootstrap.min.js"></script>

        <!-- Plugins -->
        <link rel="stylesheet" href="css/line-icons.css">
        <link rel="stylesheet" href="css/font-awesome.min.css">

        <!-- Smartphones -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Own web CSS -->
        <link rel="stylesheet" href="css/style.css">
        <script src="js/cross_animated.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript" language="javascript" src="js/new_enrichment_desple.js"></script>
        <script type="text/javascript" src="js/bootstrap-filestyle.js"></script>

        <!-- DataTable -->        
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/plug-ins/1.10.7/integration/bootstrap/3/dataTables.bootstrap.css">        
        <script type="text/javascript" language="javascript" src="js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/dataTables.bootstrap.js"></script>

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

            function controlMaxIC()
            {
                if (document.getElementById("checkMaxIC").checked) {
                    document.getElementById("textMaxIC").disabled = false;
                    document.getElementById("textMaxIC").required = true;
                } else {
                    document.getElementById("textMaxIC").disabled = true;
                    document.getElementById("textMaxIC").required = false;
                }
            }

            function controlMinLevel()
            {
                if (document.getElementById("checkMinLevel").checked) {
                    document.getElementById("textMinLevel").disabled = false;
                    document.getElementById("textMinLevel").required = true;
                } else {
                    document.getElementById("textMinLevel").disabled = true;
                    document.getElementById("textMinLevel").required = false;
                }
            }

            function controlLevel()
            {
                if (document.getElementById("checkLevel").checked) {
                    document.getElementById("textLevel").disabled = false;
                    document.getElementById("textLevel").required = true;
                } else {
                    document.getElementById("textLevel").disabled = true;
                    document.getElementById("textLevel").required = false;
                }
            }

            function controlConfidence()
            {
                if (document.getElementById("checkConfidenceFactor").checked) {
                    document.getElementById("textConfidenceFactor").disabled = false;
                    document.getElementById("textConfidenceFactor").required = true;
                } else {
                    document.getElementById("textConfidenceFactor").disabled = true;
                    document.getElementById("textConfidenceFactor").required = false;
                }
            }
        </script>

    </head>
    <body style="background-color: #f4f4f4;">
        <%
            Bigo bigo = (Bigo) session.getAttribute("bigo");
            //List<Bigo> listaBigos = (ArrayList<Bigo>) session.getAttribute("listaBigos");

            int clusters = bigo.getcConjuntoTerminos().size();
            System.out.println(clusters+"kkkkkkk");

            int numGoTermsInicial = bigo.getoOutput_base().getRank().getcResult().size();

            String private_files = "WEB-INF";
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = request.getSession().getId();
            String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
            String pathFiltrado = pathSesion + File.separator + "output.txt";
            int numGoTermsFiltrado = 0, stopwords = 0, unique = 0;

            //Apply filters
            if (request.getParameter("confidenceFactor") != null) {
                session.setAttribute("confidenceFactor", request.getParameter("confidenceFactor"));
            } else {
                if (session.getAttribute("confidenceFactor") == null) {
                    session.setAttribute("confidenceFactor", 1);
                }
            }
            bigo.setConfidenceFactor(Double.parseDouble(session.getAttribute("confidenceFactor").toString()));
            session.setAttribute("bigo", bigo);

            if (request.getParameter("level") != null) {
                session.setAttribute("level", request.getParameter("level"));
            } else {
                if (session.getAttribute("level") == null) {
                    session.setAttribute("level", 101);
                }
            }

            if (request.getParameter("minLevel") != null) {
                session.setAttribute("minLevel", request.getParameter("minLevel"));
            } else {
                if (session.getAttribute("minLevel") == null) {
                    session.setAttribute("minLevel", 0);
                }
            }

            if (request.getParameter("maxIC") != null) {
                session.setAttribute("maxIC", request.getParameter("maxIC"));
            } else {
                if (session.getAttribute("maxIC") == null) {
                    session.setAttribute("maxIC", 9999);
                }
            }

            int levelUser = Integer.parseInt(session.getAttribute("level").toString());
            //levelUser = ((clusters * levelUser) / 100);
            int minLevelUser = Integer.parseInt(session.getAttribute("minLevel").toString());
            //minLevelUser = ((clusters * minLevelUser) / 100);

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
                        String sCluster = body[4].substring(body[4].indexOf("(") + 1, body[4].length() - 2).replace(",",".");
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
            session.setAttribute("stopwordsRanking", stopwords);
            session.setAttribute("uniquesRanking", unique);

        %>
        <jsp:include page="../../../components/header.jsp" />
        <article class="article article-contributors" style="margin-top: -80px; margin-bottom: -80px; ">
            <div class="container">
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">Second phase. Ranking of biological terms</a></li>
                </ul>
                <br>

                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; text-align: left; background-color: #ffffff; margin-top: 5px;">
                    <div class="about-container" style="margin: 50px 100px 50px 100px; text-align: justify;">
                        <div>

                            <!-- VIEW SAVED RANKING -->
                            <div class="modal fade" id="viewranking" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                            <h4 class="modal-title" id="myModalLabel">View a saved ranking</h4>

                                        </div>
                                        <div class="modal-body scroll">
                                            <div style="margin-top: 30px; margin-bottom: 50px;">
                                                <%                                                            if (session.getAttribute("listaBigos") != null) {
                                                %>
                                                <table id="example2" class="table table-striped table-bordered" cellspacing="0" width="100%" style="text-align: center;">
                                                    <thead>
                                                    <th style="width: 50px; vertical-align:middle; text-align: center;">#</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">Information content</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">LFT CutOff</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">HFT CutOff</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">PValue CutOff</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">HFT terms</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">LFT terms</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 100px;">&nbsp;</th>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            int iContador = 1;
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
                                                                out.write("<tr><td style='vertical-align:middle; font-weight: bold;'>" + iContador + "</td><td style='vertical-align:middle;'>" + sResIc + "</td><td style='vertical-align:middle;'>" + sResMinLevel + "</td><td style='vertical-align:middle;'>" + sResLevel + "</td><td style='vertical-align:middle;'>" + sResConfi + "</td><td style='vertical-align:middle;'>" + b.getStopwords() + "</td><td style='vertical-align:middle;'>" + b.getUniques() + "</td><td>");

                                                        %>
                                                        <html:form action="viewSavedRanking">
                                                        <input type="hidden" name="savedIc" value="<%=b.getMaxIC()%>" />
                                                        <input type="hidden" name="savedMinLevel" value="<%=b.getMinLevel()%>" />
                                                        <input type="hidden" name="savedLevel" value="<%=b.getLevel()%>" />
                                                        <input type="hidden" name="savedConfidence" value="<%=b.getConfidenceFactor()%>" />
                                                        <input type="hidden" name="savedStopwords" value="<%=b.getStopwords()%>" />
                                                        <input type="hidden" name="savedUniques" value="<%=b.getUniques()%>" />
                                                        <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" value="View ranking" />
                                                    </html:form>
                                                    <% out.write("</td></tr>");
                                                            iContador++;
                                                        }
                                                    %>
                                                    </tbody>
                                                </table>
                                                <%
                                                    }
                                                %>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- DOWNLOAD SAVED RANKING -->
                            <div class="modal fade" id="downloadranking" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                            <h4 class="modal-title" id="myModalLabel">Download a saved ranking</h4>

                                        </div>
                                        <div class="modal-body scroll">
                                            <div style="margin-top: 30px; margin-bottom: 50px;">
                                                <table id="example2" class="table table-striped table-bordered" cellspacing="0" width="100%" style="text-align: center;">
                                                    <thead>
                                                    <th style="width: 50px; vertical-align:middle; text-align: center;">#</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">Information content</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">LFT CutOff</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">HFT CutOff</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">PValue CutOff</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">HFT terms</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 72px;">LFT terms</th>
                                                    <th style="vertical-align:middle; text-align: center; min-width: 100px;">&nbsp;</th>
                                                    </thead>
                                                    <tbody>
                                                        <%
                                                            int iContador = 1;
                                                            Bigo bigo_base = (Bigo) session.getAttribute("bigo_base");
                                                            out.write("<tr><td style='vertical-align:middle; font-weight: bold;'>" + iContador + "</td><td colspan=6 style='vertical-align:middle;'>Original result</td><td style='display:none'></td><td style='display:none'></td><td style='display:none'></td><td style='display:none'></td><td style='display:none'></td><td>");
                                                            iContador++;

                                                            String fileFiltrado = "output_base.txt";
                                                        %>
                                                        <html:form action="downloadAnyRankingCreate">
                                                        <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                                        <input type="hidden" name="filePath" value="<%=pathSesion + File.separator + fileFiltrado%>" />
                                                        <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" value="Download" />
                                                    </html:form>
                                                    <%
                                                        if (session.getAttribute("listaBigos") != null) {
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
                                                                if (b.getLevel() == 101 && b.getMaxIC() == 9999 && b.getConfidenceFactor() == 1 && b.getMinLevel() == 0 && b.getStopwords() == 0 && b.getUniques() == 0) {
                                                                } else {
                                                                    out.write("<tr><td style='vertical-align:middle; font-weight: bold;'>" + iContador + "</td><td style='vertical-align:middle;'>" + sResIc + "</td><td style='vertical-align:middle;'>" + sResMinLevel + "</td><td style='vertical-align:middle;'>" + sResLevel + "</td><td style='vertical-align:middle;'>" + sResConfi + "</td><td style='vertical-align:middle;'>" + b.getStopwords() + "</td><td style='vertical-align:middle;'>" + b.getUniques() + "</td><td>");
                                                                    java.text.DecimalFormat formatoSalidaDecimal = new java.text.DecimalFormat("#.###");//para dos decimales
                                                                    sResLevel = formatoSalidaDecimal.format(b.getLevel()).replace(".", "_").replace(",", "_");
                                                                    if (b.getLevel() == 101) {
                                                                        sResLevel = "no";
                                                                    }

                                                                    sResIc = formatoSalidaDecimal.format(b.getMaxIC()).replace(".", "_").replace(",", "_");
                                                                    if (b.getMaxIC() == 9999) {
                                                                        sResIc = "no";
                                                                    }

                                                                    sResConfi = formatoSalidaDecimal.format(b.getConfidenceFactor()).replace(".", "_").replace(",", "_");
                                                                    if (b.getConfidenceFactor() == 1) {
                                                                        sResConfi = "no";
                                                                    }

                                                                    sResMinLevel = formatoSalidaDecimal.format(b.getMinLevel()).replace(".", "_").replace(",", "_");
                                                                    if (b.getMinLevel() == 0) {
                                                                        sResMinLevel = "no";
                                                                    }

                                                                    fileFiltrado = "output-" + sResIc.replace(",", "_").replace(".", "_") + "-" + sResMinLevel.replace(",", "_").replace(".", "_") + "-" + sResLevel.replace(",", "_").replace(".", "_") + "-" + sResConfi.replace(",", "_").replace(".", "_") + "-" + b.getStopwords() + "-" + b.getUniques() + ".txt";
                                                    %>
                                                    <html:form action="downloadAnyRankingCreate">
                                                        <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                                        <input type="hidden" name="filePath" value="<%=pathSesion + File.separator + "rankings" + File.separator + fileFiltrado%>" />
                                                        <input type="submit" class="btn btn-success" style="font-weight: bold; display: inline; margin-left: auto; margin-right: auto;" value="Download" />
                                                    </html:form>
                                                    <% out.write("</td></tr>");
                                                                    iContador++;
                                                                }
                                                            }
                                                        }
                                                    %>
                                                    </tbody>
                                                </table>

                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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

                            <!-- RANKING SAVED -->
                            <div class="modal fade" id="rankingsaved" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-body">
                                            <div style="margin-top: 50px; margin-bottom: 50px;">
                                                <img src="images/bigo/ranking/ranking_saved.png" style="width: 40%; display: block; margin-left: auto; margin-right: auto;" />
                                                <br />
                                                <h2 style="text-align: center;">Your ranking has been saved.</h2>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <h2 class="article-title" style="text-align: center; font-size: 30px; margin-top: 35px; margin-bottom: 50px;
                                ">Second phase. Ranking of biological terms</h2>
                            <%                                    if (session.getAttribute(
                                        "saveRank") != null) {
                                    session.setAttribute("saveRank", null);
                            %>
                            <script type="text/javascript">
                                $('#rankingsaved').modal('show');
                                window.setTimeout(function () {
                                    $('#rankingsaved').modal('hide');
                                }, 3000);
                            </script>
                            <% }%>

                            <div style="width: 65%; text-align: justify; margin-bottom: 150px;">
                                The enrichment results from all the groups of genes are processed together to generate a ranking of biological terms. This ranking is based on the frequency of appearance of every biological term in the enrichment analysis results of the groups of genes. The standard output is ordered by the aforementioned frequency in increasing order (see ‘Frequency’ column). The column ‘Group of genes’ shows the list of groups of genes in whose enrichment results a biological term appears.
                            </div>
                            <div style="float: right; margin-top: -290px; margin-right: 30px; margin-bottom: 50px;">
                                <img src="images/bigo/ranking/visualize.png" style="float:right; width: 60%;"><br />
                                <html:form action="saveRankingCreate" method="post">
                                    <input type="submit" class="btn btn-success" style="float: right; font-weight:bold; font-size: 16px; margin-top: 0%; margin-right: 0%" value="Save current ranking" />           
                                </html:form>
                            </div>

                            <div>
                                <html:form action="dropSelectRankingCreate" method="post">
                                    <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="width: 100%;">
                                        <thead>
                                            <tr>
                                                <th>&nbsp;</th>
                                                <th style="min-width: 100px;">ID</th>
                                                <th style="min-width: 300px;">Name</th>
                                                <th>Information content (IC)</th>
                                                <th>P value adjusted</th>
                                                <th>Frequency</th>
                                                <th>No visible</th>
                                                <th>No visible</th>
                                                <th>Group of genes</th>
                                            </tr>
                                        </thead>                                      
                                    </table>         

                                    <script type="text/javascript">
                                        $(document).ready(
                                                function () {
                                                    var levelUser = <%=levelUser%>;
                                                    var minLevelUser = <%=minLevelUser%>;
                                                    var firstRanking = <%=session.getAttribute("firstRanking")%>;
                                                    var checkStopwords = <%=session.getAttribute("checkedStopwords")%>;

                                                    $("#example").dataTable({
                                                        "sScrollX": "100%",
                                                        "pageLength": 25,
                                                        "order": [[6, "asc"], [7, "asc"], [4, "asc"]],
                                                        "bProcessing": false,
                                                        "bServerSide": false,
                                                        "sort": "position",
                                                        "sAjaxSource": "./RankingDatatableServlet",
                                                        "aoColumns": [
                                                            {"mData": "input"},
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
                                                            if (firstRanking != true) {
                                                                var numClusterRow = data["num_biclusters"].substring(data["num_biclusters"].indexOf("(") + 1, data["num_biclusters"].length - 2).replace(",",".");
                                                                //alert(numClusterRow);
                                                                //alert(levelUser);
                                                                //alert(levelUser > numClusterRow);
                                                                if (levelUser > numClusterRow) // Si cumple el filtro de stopword
                                                                {
                                                                    if (minLevelUser >= numClusterRow) { //Si cumple el filtro minLevel
                                                                        $('td', nRow).css('background-color', '#a1de9b');
                                                                    }
                                                                }
                                                                else // Si no cumple el stopword
                                                                {
                                                                    $('td', nRow).css('background-color', '#ffb5b5'); //Red
                                                                    if (checkStopwords == true) {
                                                                        $('input', nRow).prop("checked", true);
                                                                    }
                                                                }
                                                            }

                                                        }
                                                    });
                                                }

                                        );
                                    </script>
                                    <input type="submit" class="btn btn-danger" style="font-size: 14px; float: left;" value="Drop selected" data-toggle="tooltip" data-placement="left" title="Drop all the biological terms selected by the user" />           
                                </html:form>

                                <div style="margin-left: 15px; margin-top: -5px;">
                                    
                                    <html:form action="dropUniques" method="post">
                                        <% if (unique == 0) { %>
                                        <input type="submit" class="btn btn-danger" style=" float: left; font-size: 14px; margin-left: 15px; margin-right: 10px; font-weight: bold; " value="Drop LFT" disabled="" />           
                                        <% } else { %>
                                        <input type="submit" class="btn btn-danger" style=" float: left; font-size: 14px; margin-left: 15px; margin-right: 10px; font-weight: bold; " value="Drop LFT" data-toggle="tooltip" data-placement="bottom" title="Drop all low frequency terms (LFT) discovered" />           
                                        <% } %>                                        
                                    </html:form>
                                    <html:form action="dropStopwords" method="post">
                                        <% if (stopwords == 0) { %>
                                        <input type="submit" class="btn btn-danger" style=" float: left; font-size: 14px; margin-left: 5px; margin-right: 10px; font-weight: bold; " value="Drop HFT" disabled="" />           
                                        <% } else { %>
                                        <input type="submit" class="btn btn-danger" style=" float: left; font-size: 14px; margin-left: 5px; margin-right: 10px; font-weight: bold; " value="Drop HFT" data-toggle="tooltip" data-placement="bottom" title="Drop all high frequency terms  (HFT) discovered" />           
                                        <% } %>         
                                    </html:form>
                                        <html:form action="undoAction" method="post">
                                            <% if (session.getAttribute("undo") != null && session.getAttribute("undo").equals("true")) { %>
                                        <input type="submit" class="btn btn-danger" style=" float: left; font-size: 14px; margin-left: 5px; margin-right: 10px; " value="Undo" data-toggle="tooltip" data-placement="bottom" title="Undo last action" />       
                                        <% } else { %>
                                        <input type="submit" class="btn btn-danger" style=" float: left; font-size: 14px; margin-left: 5px; margin-right: 10px; " value="Undo" disabled="" />           
                                        <% }%>                                        
                                    </html:form>
                                    <html:form action="checkStopwords" method="post">
                                        <% if (session.getAttribute("checkedStopwords") != null) {
                                                session.setAttribute("checkedStopwords", null);
                                            }
                                        %>
                                        <input type="hidden" name="check" value="yes" />
                                        <% if (stopwords == 0) { %>
                                        <input type="submit" class="btn btn-default" style=" float: left; font-size: 14px; margin-left: 5px; margin-right: 10px; " value="Check HFT" disabled="" />           
                                        <% } else { %>
                                        <input type="submit" class="btn btn-default" style=" float: left; font-size: 14px; margin-left: 5px; margin-right: 10px; " value="Check HFT" data-toggle="tooltip" data-placement="bottom" />       
                                        <% }%>                                        
                                    </html:form>
                                        
                                </div>
                            </div>

                            <p style="margin-top: 50px;">&nbsp;</p>                            

                            <div style="width: 25%; float: right; margin-top: 50px; margin-right: -30px; margin-bottom: 20px;">
                                <img src="../../../images/bigo/ranking/ranking.png" style="width: 65%;">
                            </div>

                            <h4>Review your ranking of biological terms</h4>
                            <hr id="visualize" class="featurette-divider" style="margin-bottom: 30px;">

                            <div style="margin-top: 40px; width: 55%; text-align: justify; ">The next table shows all the properties related to the biological terms ranking.</div>

                            <table class="table table-striped table-bordered" cellspacing="0" width="100%" style="margin-top: 50px;">
                                <thead>
                                    <tr>
                                        <th style='min-width: 100px;'>Property</th>
                                        <th style='min-width: 100px;'>Value</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of groups of genes being analyzed"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Group of genes:</span>
                                        </td>
                                        <td>
                                            <%=clusters%>
                                        </td>
                                    </tr>  
                                    <tr>
                                        <td>
                                            <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of biological terms being analyzed"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Biological terms:</span>
                                        </td>
                                        <td><%=numGoTermsInicial%></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of biological terms obtained by the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Filtered biological terms:</span>
                                        </td>
                                        <td><%=numGoTermsFiltrado%></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of high frequency terms obtained by the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Total HFT:</span>
                                        </td>
                                        <td><%=stopwords%></td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Number of the low frequency terms obtained by the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Total LFT:</span>
                                        </td>
                                        <td><%=unique%></td>
                                    </tr> 
                                    <tr>   
                                        <td style="border-top: 2px solid #cccccc;">
                                            <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Significance cutoff used in the last filtering action."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Pvalue cutoff:</span>
                                        </td>
                                        <td style="border-top: 2px solid #cccccc;">
                                            <%
                                                if (session.getAttribute("confidenceFactor") != null && Double.parseDouble(session.getAttribute("confidenceFactor").toString()) == 1) {
                                                    out.print("Not applied");
                                                } else {
                                                    out.print("p < " + session.getAttribute("confidenceFactor"));
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Information content value used in the last filtering action"><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Information Content:</span>
                                        </td>
                                        <td>
                                            <%
                                                if (session.getAttribute("maxIC") != null && Double.parseDouble(session.getAttribute("maxIC").toString()) == 9999) {
                                                    out.print("Not applied");
                                                } else {
                                                    out.print(session.getAttribute("maxIC"));
                                                }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="High Frequency terms cutoff used in the last filtering action."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> HFT cutoff:</span>
                                        </td>
                                        <td><%
                                            if (session.getAttribute("level") != null && Integer.parseInt(session.getAttribute("level").toString()) == 101) {
                                                out.print("Not applied");
                                            } else {
                                                out.print(session.getAttribute("level") + " %");
                                            }
                                            %></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Low Frequency terms cutoff used in the last filtering action."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> LFT cutoff:</span>
                                        </td>
                                        <td><%
                                            if (session.getAttribute("minLevel") != null && Integer.parseInt(session.getAttribute("minLevel").toString()) == 0) {
                                                out.print("Not applied");
                                            } else {
                                                out.print(session.getAttribute("minLevel") + " %");
                                            }
                                            %></td>
                                    </tr>
                                </tbody>                                    
                            </table>

                            <p style="margin-top: 50px;">&nbsp;</p>
                            <h4>Ranking filtering options</h4>
                            <hr id="filter" class="featurette-divider" style="margin-bottom: 30px;">

                            <div style="width: 55%; text-align: justify;">
                                <html:form action="applyFiltersCreate" method="post">
                                    The ranking can be filtered using at least one of the following options. In the filtered ranking, the low frequency biological terms (LFT) will be colored in green while the high frequency biological terms (HFT) will be colored in red.
                                    <p style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="The biological terms with a IC value above this value will be dropped from the ranking."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Information content (IC):</p>
                                            <%
                                                if (session.getAttribute("firstRanking") != null && session.getAttribute("firstRanking").equals("false")) {
                                                    double d = Double.parseDouble(session.getAttribute("maxIC").toString());
                                                    double max = 9999;
                                                    if (session.getAttribute("maxIC") != null && (double) d == max) {
                                                        if (session.getAttribute("prevIc") == null) {
                                            %>
                                    <input type="number" id="textMaxIC" name="maxIC" value="" min="0.001" max="10" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkMaxIC" name="enable_maxIC" value="true" onclick="controlMaxIC()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else {%>
                                    <input type="number" id="textMaxIC" name="maxIC" value="<%=session.getAttribute("prevIc")%>" min="0.001" max="10" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkMaxIC" name="enable_maxIC" value="true" onclick="controlMaxIC()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }  %>
                                    <% } else {
                                        if (session.getAttribute("enabled_maxIC") == null) { //Esta desactivado
%>
                                    <input type="number" id="textMaxIC" name="maxIC" value="<%=session.getAttribute("maxIC")%>" min="0.001" max="10" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;"  />
                                    <input type="checkbox" id="checkMaxIC" name="enable_maxIC" value="true" onclick="controlMaxIC()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else { //Esta activo %>
                                    <input type="number" id="textMaxIC" name="maxIC" value="<%=session.getAttribute("maxIC")%>" min="0.001" max="10" step="0.001" class="form-control" onkeypress="return numeros(event);" required style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkMaxIC" name="enable_maxIC" value="true" onclick="controlMaxIC()" checked="" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }
                                        }
                                    %>
                                    <% } else { %>
                                    <input type="number" id="textMaxIC" name="maxIC" value="" min="0.001" max="10" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkMaxIC" name="enable_maxIC" value="true" onclick="controlMaxIC()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }%>

                                    <p style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="The biological terms that appear in a percentage of groups of genes under o equal to this value will be labeled as Low Frequency Terms (LFT) and colored in green."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> Low Frequency percentage:</p>
                                            <%
                                                if (session.getAttribute("firstRanking") != null && session.getAttribute("firstRanking").equals("false")) {
                                                    int d = Integer.parseInt(session.getAttribute("minLevel").toString());
                                                    int max = 0;
                                                    if (session.getAttribute("minLevel") != null && (double) d == max) {
                                                        if (session.getAttribute("prevLevel") == null) {
                                            %>
                                    <input type="number" id="textMinLevel" name="minLevel" value="" min="1" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkMinLevel" name="enable_minLevel" value="true" onclick="controlMinLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else {%>                                    
                                    <input type="number" id="textMinLevel" name="minLevel" value="<%=session.getAttribute("prevMinLevel")%>" min="1" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkMinLevel" name="enable_minLevel" value="true" onclick="controlMinLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }  %>   
                                    <% } else {
                                        if (session.getAttribute("enabled_minLevel") == null) { //Esta desactivado
%>
                                    <input type="number" id="textMinLevel" name="minLevel" value="<%=session.getAttribute("minLevel")%>" min="1" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkMinLevel" name="enable_minLevel" value="true" onclick="controlMinLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else { //Esta activo %>
                                    <input type="number" id="textMinLevel" name="minLevel" value="<%=session.getAttribute("minLevel")%>" min="1" max="100" step="1" class="form-control" onkeypress="return numeros(event);" required style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkMinLevel" name="enable_minLevel" value="true" onclick="controlMinLevel()" checked="" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }
                                        }
                                    %>
                                    <% } else { %>
                                    <input type="number" id="textMinLevel" name="minLevel" value="" min="1" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkMinLevel" name="enable_minLevel" value="true" onclick="controlMinLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }%>

                                    <p style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="The biological terms that appear in a percentage of groups of genes above o equal to this value will be labeled as High Frequency Terms (HFT) and colored in red."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> High Frequency percentage:</p>
                                            <%
                                                if (session.getAttribute("firstRanking") != null && session.getAttribute("firstRanking").equals("false")) {
                                                    int d = Integer.parseInt(session.getAttribute("level").toString());
                                                    int max = 101;
                                                    if (session.getAttribute("level") != null && (double) d == max) {
                                                        if (session.getAttribute("prevLevel") == null) {
                                            %>
                                    <input type="number" id="textLevel" name="level" value="" min="0" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkLevel" name="enable_level" value="true" onclick="controlLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else {%>
                                    <input type="number" id="textLevel" name="level" value="<%=session.getAttribute("prevLevel")%>" min="0" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkLevel" name="enable_level" value="true" onclick="controlLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }  %>
                                    <% } else {
                                        if (session.getAttribute("enabled_level") == null) { //Esta desactivado
%>
                                    <input type="number" id="textLevel" name="level" value="<%=session.getAttribute("level")%>" min="0" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkLevel" name="enable_level" value="true" onclick="controlLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else { //Esta activo %>
                                    <input type="number" id="textLevel" name="level" value="<%=session.getAttribute("level")%>" min="0" max="100" step="1" class="form-control" onkeypress="return numeros(event);" required style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkLevel" name="enable_level" value="true" onclick="controlLevel()" checked="" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }

                                        }
                                    %>
                                    <% } else { %>
                                    <input type="number" id="textLevel" name="level" value="" min="0" max="100" step="1" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                        
                                    <input type="checkbox" id="checkLevel" name="enable_level" value="true" onclick="controlLevel()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }%>

                                    <p style="margin-top: 20px; font-size: 14px; font-weight: bold;"><a href="#new" data-toggle="tooltip" data-placement="right" title="The biological terms that appear in a percentage of groups of genes above o equal to this value will be labeled as High Frequency Terms (HFT) and colored in red."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> PValue CutOff:</p>
                                            <%
                                                if (session.getAttribute("firstRanking") != null && session.getAttribute("firstRanking").equals("false")) {
                                                    double d = Double.parseDouble(session.getAttribute("confidenceFactor").toString());
                                                    double max = 1;
                                                    if (session.getAttribute("confidenceFactor") != null && (double) d == max) {
                                                        if (session.getAttribute("prevConfidence") == null) {
                                            %>
                                    <input type="number" id="textConfidenceFactor" name="confidenceFactor" value="" min="0" max="0.999" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkConfidenceFactor" name="enable_confidence" value="true" onclick="controlConfidence()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else {%>
                                    <input type="number" id="textConfidenceFactor" name="confidenceFactor" value="<%=session.getAttribute("prevConfidence")%>" min="0" max="0.999" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkConfidenceFactor" name="enable_confidence" value="true" onclick="controlConfidence()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }  %>
                                    <% } else {
                                        if (session.getAttribute("enabled_confidence") == null) { //Esta desactivado
%>
                                    <input type="number" id="textConfidenceFactor" name="confidenceFactor" value="<%=session.getAttribute("confidenceFactor")%>" min="0" max="0.999" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkConfidenceFactor" name="enable_confidence" value="true" onclick="controlConfidence()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% } else { //Esta activo %>
                                    <input type="number" id="textConfidenceFactor" name="confidenceFactor" value="<%=session.getAttribute("confidenceFactor")%>" min="0" max="0.999" step="0.001" class="form-control" onkeypress="return numeros(event);" required style="width: 90%; display: inline-block;" />
                                    <input type="checkbox" id="checkConfidenceFactor" name="enable_confidence" value="true" onclick="controlConfidence()" checked="" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }

                                        }
                                    %>
                                    <% } else {%>
                                    <input type="number" id="textConfidenceFactor" name="confidenceFactor" value="" min="0" max="0.999" step="0.001" class="form-control" onkeypress="return numeros(event);" disabled="" style="width: 90%; display: inline-block;" />                                    
                                    <input type="checkbox" id="checkConfidenceFactor" name="enable_confidence" value="true" onclick="controlConfidence()" style="-ms-transform: scale(2); -moz-transform: scale(2); -webkit-transform: scale(2); -o-transform: scale(2); margin-left: 10px;">
                                    <% }%>
                                    <p>&nbsp;</p>
                                    <input type="submit" class="btn btn-success" value="Apply filters" style="font-weight:bold;" />           
                                </html:form>

                            </div>

                            <div style="float: right; margin-top: -350px; margin-right: 30px;">
                                <img src="images/bigo/ranking/filter.png" style="float:right; width: 22%;">
                            </div>



                            <p style="margin-top: 30px;">&nbsp;</p>
                            <h4>Additional options</h4>
                            <hr class="featurette-divider" style="margin-bottom: 50px;">
                            <div class="row" style="text-align: center; width: 100%; margin-top: 75px;">
                                <div class="col-md-4">
                                    <html:form action="saveRankingCreate" method="post">
                                        <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/save_file.png) no-repeat top center;" value="Save current 
                                               ranking" />
                                    </html:form>
                                </div>
                                <div class="col-md-4">
                                    <button class="btn btn-link" data-toggle="modal" data-target="#downloadranking" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/download_file.png) no-repeat top center;">Download any<br />ranking</button>
                                </div>
                                <div class="col-md-4">
                                    <% if (unique == 0) { %>
                                    <html:form action="downloadUniqueCreate" method="post">
                                        <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/uniques_file.png) no-repeat top center;" value="Download
                                               Low Frequency Terms" disabled />
                                    </html:form>
                                    <% } else { %>
                                    <html:form action="downloadUniqueCreate" method="post">
                                        <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/uniques_file.png) no-repeat top center;" value="Download
                                               Low Frequency Terms" />
                                    </html:form>
                                    <% } %>
                                </div>
                            </div>

                            <div class="row" style="text-align: center; width: 100%; margin-top: 25px;">
                                <div class="col-md-4">
                                    <% if (stopwords == 0) { %>
                                    <html:form action="downloadStopwordsCreate" method="post">
                                        <input type="submit" value="Download High
                                               Frequency Terms" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/stopwords_file.png) no-repeat top center;" disabled />
                                    </html:form>
                                    <% } else { %>
                                    <html:form action="downloadStopwordsCreate" method="post">
                                        <input type="submit" value="Download High
                                               Frequency Terms" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/stopwords_file.png) no-repeat top center;"/>
                                    </html:form>
                                    <% } %>
                                </div>
                                <div class="col-md-4">
                                    <%
                                        String sRankingDir = pathSesion + File.separator + "rankings";
                                        //Comprueba si la carpeta rankings existe
                                        File rankingFolder = new File(sRankingDir);

                                        if (!rankingFolder.exists()) {
                                    %>
                                    <html:form action="downloadRankingCreate" method="post">
                                        <input type="submit" value="Download all
                                               saved rankings" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/download.png) no-repeat top center;" disabled />
                                    </html:form>
                                    <% } else { %>
                                    <html:form action="downloadRankingCreate" method="post">
                                        <input type="submit" value="Download all
                                               saved rankings" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/download.png) no-repeat top center;"/>
                                    </html:form>
                                    <% }%>
                                </div>
                                <div class="col-md-4">
                                    <%
                                        sRankingDir = pathSesion + File.separator + "rankings";
                                        //Comprueba si la carpeta rankings existe
                                        rankingFolder = new File(sRankingDir);

                                        if (!rankingFolder.exists()) {
                                    %>
                                    <button class="btn btn-link" data-toggle="modal" data-target="#viewranking" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/file_search.png) no-repeat top center;" disabled>View a saved<br />ranking</button>    
                                        <% } else { %>
                                    <button class="btn btn-link" data-toggle="modal" data-target="#viewranking" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/file_search.png) no-repeat top center;">View a saved<br />ranking</button>
                                        <% }%>   
                                </div>
                            </div>
                            <div class="row" style="text-align: center; width: 100%; margin-top: 25px; margin-bottom: 75px;">
                                <div class="col-md-4">
                                    <%
                                        sRankingDir = pathSesion + File.separator + "rankings";
                                        //Comprueba si la carpeta rankings existe
                                        rankingFolder = new File(sRankingDir);

                                        if (!rankingFolder.exists()) {
                                    %>
                                    <html:form action="comparativeRankingCreate" method="post">
                                        <input type="submit" value="Rankings
                                               comparative" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/comparative.png) no-repeat top center;" disabled/>
                                    </html:form>
                                    <% } else { %>
                                    <html:form action="comparativeRankingCreate" method="post">
                                        <input type="submit" value="Rankings
                                               comparative" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/comparative.png) no-repeat top center;"/>
                                    </html:form>
                                    <% }%>                              
                                </div>
                            </div>

                            <html:form action="executeGraphCreate">
                                <input type="hidden" name="comparative" value="yes" />
                                <p class="pull-right" style="margin-top: 5px;"><input type="submit" class="btn btn-success btn-lg" value="Next &#9658;" /></p>
                                </html:form>

                            <html:form action="backRankingCreate">
                                <p style="text-align: left; font-size: 25px; margin-top: 38px;"><input type="submit" class="btn btn-danger btn-lg" value="&#9664 Back"></p>
                                </html:form>

                            <% session.setAttribute("firstRanking", "false");%>
                        </div>
                    </div>
                </div>
        </article>      
        <jsp:include page="../../../components/footer.jsp" />
    </body>
</html>
