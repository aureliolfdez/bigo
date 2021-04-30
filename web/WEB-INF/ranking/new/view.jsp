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
            //SESIONES            
            if (request.getParameter("savedConfidence") != null) {
                session.setAttribute("savedConfidence", request.getParameter("savedConfidence"));
            }

            if (request.getParameter("savedMinLevel") != null) {
                session.setAttribute("savedMinLevel", request.getParameter("savedMinLevel"));
            }

            if (request.getParameter("savedLevel") != null) {
                session.setAttribute("savedLevel", request.getParameter("savedLevel"));
            }

            if (request.getParameter("savedIc") != null) {
                session.setAttribute("savedIc", request.getParameter("savedIc"));
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

            List<Bigo> listaBigos = (ArrayList<Bigo>) session.getAttribute("listaBigos");
            Bigo bigo = null;
            for (int i = 0; i < listaBigos.size() && bigo == null; i++) {
                if (listaBigos.get(i).getMaxIC() == Double.parseDouble(request.getParameter("savedIc")) && listaBigos.get(i).getConfidenceFactor() == Double.parseDouble(request.getParameter("savedConfidence")) && listaBigos.get(i).getMinLevel() == Integer.parseInt(request.getParameter("savedMinLevel")) && listaBigos.get(i).getLevel() == Integer.parseInt(request.getParameter("savedLevel")) && listaBigos.get(i).getStopwords() == Integer.parseInt(request.getParameter("savedStopwords")) && listaBigos.get(i).getUniques() == Integer.parseInt(request.getParameter("savedUniques"))) {
                    bigo = listaBigos.get(i);
                }
            }

            int clusters = bigo.getcConjuntoTerminos().size();
            int levelUser = Integer.parseInt(savedLevel);
            //levelUser = ((clusters * levelUser) / 100);
            int minLevelUser = Integer.parseInt(savedMinLevel);
            //minLevelUser = ((clusters * minLevelUser) / 100);
            int numGoTermsInicial = bigo.getoOutput_base().getRank().getcResult().size();
            String private_files = "WEB-INF";
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = request.getSession().getId();
            String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
            String sResLevel = savedLevel;
            if (savedLevel.equals("101")) {
                sResLevel = "no";
            }
            String sResIc = savedIc;
            if (savedIc.equals("9999")) {
                sResIc = "no";
            }

            String sResConfidence = savedConfidence;
            if (savedConfidence.equals("1")) {
                sResConfidence = "no";
            }

            String sResMinLevel = savedMinLevel;
            if (savedMinLevel.equals("0")) {
                sResMinLevel = "no";
            }

            String fileFiltrado = "output-" + sResIc.replace(",", "_").replace(".", "_") + "-" + sResMinLevel.replace(",", "_").replace(".", "_") + "-" + sResLevel.replace(",", "_").replace(".", "_") + "-" + sResConfidence.replace(",", "_").replace(".", "_") + "-" + savedStopwords + "-" + savedUniques + ".txt";
            String pathFiltrado = pathSesion + File.separator + "rankings" + File.separator + fileFiltrado;
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
        <jsp:include page="../../../components/header.jsp" />
        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">Second step. Ranking of biological terms</a></li>
                    <li style="font-weight: normal;">
                        View a saved ranking
                    </li>
                </ul>
                <br>

                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div>

                        <div class="row" style="margin: 3% 8% 4% 8%;">
                            <div class="col-md-12" style="text-align: center;">
                                <h2>Second step. Ranking of biological terms</h2>
                                <h4 style="font-weight: normal;">Additional option: View a saved ranking</h4>
                            </div>
                        </div>

                        <div class="row" style="margin: 4% 8% 3% 8%;">
                            <div class="col-md-12">
                                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                                    <thead>
                                        <tr>
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

                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12">
                                <h4>Review your ranking of biological term</h4>
                                <hr id="visualize">
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12">
                                <table class="table table-striped table-bordered" cellspacing="0" width="100%" >
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
                                                    if (session.getAttribute("savedConfidence") != null && Double.parseDouble(session.getAttribute("savedConfidence").toString()) == 1) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(" p < " + session.getAttribute("savedConfidence"));
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
                                                    if (session.getAttribute("savedIc") != null && Double.parseDouble(session.getAttribute("savedIc").toString()) == 9999) {
                                                        out.print("Not applied");
                                                    } else {
                                                        out.print(" < " + session.getAttribute("savedIc"));
                                                    }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="High Frequency terms cutoff used in the last filtering action."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> HFT cutoff:</span>
                                            </td>
                                            <td><% if (session.getAttribute("savedLevel") != null && Integer.parseInt(session.getAttribute("savedLevel").toString()) == 101) {
                                                    out.print("Not applied");
                                                } else {
                                                    out.print(session.getAttribute("savedLevel") + " %");
                                                }
                                                %></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size: 14px; font-weight: bold;"><a href="#" data-toggle="tooltip" data-placement="right" title="Low Frequency terms cutoff used in the last filtering action."><img src="images/bigo/info.gif" style="margin-top: -4px;"></a> LFT cutoff:</span>
                                            </td>
                                            <td><% if (session.getAttribute("savedMinLevel") != null && Integer.parseInt(session.getAttribute("savedMinLevel").toString()) == 0) {
                                                    out.print("Not applied");
                                                } else {
                                                    out.print(session.getAttribute("savedMinLevel") + " %");
                                                }
                                                %></td>
                                        </tr>
                                    </tbody>                                    
                                </table>
                            </div>
                        </div>

                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12">
                                <h4>Additional options</h4>
                                <hr>
                            </div>
                        </div>


                        <div class="row" style="text-align: center; margin: 3% 8% 3% 8%;">
                            <div class="col-md-4" style="margin-top: 10px;">
                                <html:form action="downloadViewRankingCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathFiltrado%>" />
                                    <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/download_filter.png) no-repeat top center;" value="Download this
                                           ranking" />
                                </html:form>
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <% if (unique == 0) {%>
                                <html:form action="downloadViewUniqueCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/uniques_file.png) no-repeat top center;" value="Download
                                           Low Frequency Terms" disabled />
                                </html:form>
                                <% } else {%>
                                <html:form action="downloadViewUniqueCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" class="btn btn-link" data-toggle="modal" data-target="#genesFile" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/uniques_file.png) no-repeat top center;" value="Download
                                           Low Frequency Terms" />
                                </html:form>
                                <% } %>
                            </div>
                            <div class="col-md-4" style="margin-top: 10px;">
                                <% if (stopwords == 0) {%>
                                <html:form action="downloadViewStopwordsCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" value="Download High
                                           Frequency Terms" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #cccccc; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/stopwords_file.png) no-repeat top center;" disabled />
                                </html:form>
                                <% } else {%>
                                <html:form action="downloadViewStopwordsCreate" method="post">
                                    <input type="hidden" name="fileName" value="<%=fileFiltrado%>" />
                                    <input type="hidden" name="filePath" value="<%=pathSesion%>" />
                                    <input type="submit" value="Download High
                                           Frequency Terms" class="btn btn-link" style="white-space: normal; font-weight: bold; font-size: 15px; border: 2px solid #0e8ad3; border-radius: 5px; height: 150px; width: 170px; padding-top: 75px; background:url(images/bigo/ranking/stopwords_file.png) no-repeat top center;"/>
                                </html:form>
                                <% }%>
                            </div>
                        </div>


                        <div class="row" style="margin: 3% 8% 3% 8%;">
                            <div class="col-md-12">
                                <html:form action="backViewRankingCreate">
                                    <p><input type="submit" class="btn btn-danger btn-lg" value="Back" style="width: 100%;"></p>
                                    </html:form>
                            </div>
                        </div>

                    </div>
                </div>
        </article>
        <jsp:include page="../../../components/footer.jsp" />
    </body>
</html>
