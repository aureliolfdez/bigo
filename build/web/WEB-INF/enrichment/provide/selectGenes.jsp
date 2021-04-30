<%@page import="java.util.ArrayList"%>
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
        <!-- <meta name="robots" content="index, follow" /> -->
        <meta name="keywords" content="enrichment analysis, cytoscape web plugin, bigo" />
        <meta name="description" content="BIGO. A tool to improve gene enrichment analysis in collections of genes">

        <!-- Frameworks -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <script type="text/javascript" language="javascript" src="js/jquery.js"></script>
        <script type="text/javascript" language="javascript" src="js/bootstrap.min.js"></script>


        <link rel="stylesheet" href="css/line-icons.css">
        <link rel="stylesheet" href="css/font-awesome.min.css">

        <link rel="stylesheet" href="css/dataTables.bootstrap.css">
        <script type="text/javascript" language="javascript" src="js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/dataTables.bootstrap.js"></script>

        <!-- Smartphones -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Own web CSS -->
        <link rel="stylesheet" href="css/style.css">
        <script src="js/cross_animated.js" type="text/javascript" charset="utf-8"></script>

        <script type="text/javascript">
            $(document).ready(function () {
                $('#example').dataTable({
                    "scrollX": true,
                    "ordering": false
                });
            });

            function select_type() {
                var select = document.getElementById("type_character_gene");
                var options = select[select.selectedIndex].value;
                if (options == "other") {
                    document.getElementById("character_gene").style.display = "inline";
                } else {
                    document.getElementById("character_gene").style.display = "none";
                }

                var select = document.getElementById("type_character_completegene");
                var options = select[select.selectedIndex].value;
                if (options == "other") {
                    document.getElementById("character_completegene").style.display = "inline";
                } else {
                    document.getElementById("character_completegene").style.display = "none";
                }
            }

            function disabled_drop() {
                document.getElementById("character_gene").style.display = "none";
                document.getElementById("character_completegene").style.display = "none";
            }
        </script>


    </head>
    <body style="background-color: #f4f4f4;" onload="disabled_drop()">
        <% session.setAttribute("active", "bigo");%>
        <jsp:include page="../../../components/header.jsp" />
        <article class="article article-contributors" style="margin-top: -80px; margin-bottom: -80px; ">
            <div class="container">
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">First phase. Enrichment analysis</a></li>
                    <li style="font-weight: normal;">Step 4. Select gene files for the gene enrichment analysis</li>
                </ul>
                <br>
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; text-align: left; background-color: #ffffff; margin-top: 5px;">
                    <div class="about-container" style="margin: 50px 100px 50px 100px; text-align: justify;">                       
                        <div>
                            <h2 class="article-title" style="text-align: center; font-size: 30px; margin-top: 35px; ">First phase: Enrichment analysis</h2> 
                            <h2 class="article-title" style="text-align: left; font-size: 25px; margin-top: 35px; ">Step 4. Select gene files for the gene enrichment analysis</h2> 
                            <p style="color: #999999;">Select your gene enrichment analysis files to upload into the application (Max. 50MB per file).</p>
                        </div>
                        <p>&nbsp;</p>

                        <!-- SELECT FILES... -->
                        <%
                            if (session.getAttribute("uploadedGenesTotalProvide") != null && session.getAttribute("uploadedGenesTotalProvide").equals("yes")) {
                        %>
                        <div class="pull-right">
                            <html:form action="deleteCompleteGenesProvide">
                                <input type="submit" class="pull-left file-input btn btn-danger btn-file" style="font-size: 20px;" value="Delete complete gene file..." />
                            </html:form>
                            <span class="center-block" style="margin-top: 50px; text-align: center; font-size: 13px; color: #959595; font-style: italic;"> (only *.txt and *.csv files)</span>
                        </div>
                        <% } else { %>
                        <div class="pull-right">
                            <form action="FilesServlet" method="post" enctype="multipart/form-data" id="filesuploader">
                                <span class="pull-left file-input btn btn-primary btn-file" style="font-size: 20px;">Upload complete gene file...
                                    <input type="file" name="dataDir" multiple="multiple" accept=".csv,text/plain" onchange="document.getElementById('filesuploader').submit();">
                                </span>
                                <br>
                                <span class="center-block" style="margin-top: 30px; text-align: center; font-size: 13px; color: #959595; font-style: italic;"> (only *.txt and *.csv files)</span>
                                <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                                <input type="hidden" name="genesProvide" value="yes" />
                                <input type="hidden" name="enrichment" value="genesProvide" />
                            </form>
                        </div>
                        <%
                            }
                        %>


                        <!-- ERRORS -->
                        <%
                            String applicationPath = request.getServletContext().getRealPath("");
                            String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId();
                            String dataDir = pathSesion + File.separator + "outDirProvide";
                            File dirSesion = new File(dataDir);
                        %>

                        <logic:messagesPresent>
                            <div class="alert alert-danger" role="alert" style="margin-top: 50px; margin-bottom: -15px;"><img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>ERROR:</span><br /><br /><html:errors /></div>
                            </logic:messagesPresent>

                        <% if (request.getParameter("separator") != null && request.getParameter("separator").equals("no") && request.getParameter("character") == null && session.getAttribute("failure_columns_provide") == null) { %>
                        <div class="alert alert-danger" role="alert" style="margin-top: 50px; margin-bottom: -15px;"><img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>ERROR:</span> Column separator character is required.</div>
                            <%
                                }
                            %>

                        <% if (session.getAttribute("error_extension") != null && (int) session.getAttribute("error_extension") == 1) {
                        %>
                        <div class="alert alert-danger" role="alert" style="margin-top: 50px; margin-bottom: -15px;"><img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>ERROR:</span> Only files with .txt or .csv extension allowed.</div>
                            <%
                                    session.setAttribute("error_extension", null);
                                }
                                if (session.getAttribute("error_exists") != null && (int) session.getAttribute("error_exists") == 1) {
                            %>
                        <div class="alert alert-warning" role="alert" style="margin-top: 50px; margin-bottom: -15px;"><img src='images/bigo/warning-icon.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>WARNING:</span> There is a file with the same name, it has been replaced.</div>
                            <%
                                    session.setAttribute("error_exists", null);
                                }
                                if (session.getAttribute("error_size") != null && (int) session.getAttribute("error_size") == 1) {
                            %>
                        <div class="alert alert-warning" role="alert" style="margin-top: 50px; margin-bottom: -15px;"><img src='images/bigo/warning-icon.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>WARNING:</span> There is a file empty. This file will be not uploaded.</div>
                            <%
                                    session.setAttribute("error_size", null);
                                }

                                if (session.getAttribute("failure_columns_provide") != null && (int) session.getAttribute("failure_columns_provide") == 1) {
                            %>
                        <div class="alert alert-danger" role="alert" style="margin-top: 50px; margin-bottom: -15px;"><img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>ERROR</span> The enrichment files contains more 30 columns.</div>
                            <%
                                    session.setAttribute("failure_columns_provide", null);
                                }

                                if (dirSesion.exists() && dirSesion.listFiles().length > 0) { %>
                        <p style="margin-top: 80px;">&nbsp;</p>

                        <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Uploaded</th>
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
                                        String idForm = "genesuploader_"+iContFile;
                                %>
                                <tr>
                                    <td style="width: 5%; vertical-align: middle; font-weight: bold;"><% out.println(iContFile + 1); %></td>
                                    <td style="width: 5%; vertical-align: middle; font-weight: bold; text-align: center;">
                                        <%     
                                    System.out.println("kkk1: "+session.getAttribute(nomFichero));
                                            if ((session.getAttribute("uploadedGenesTotalProvide") != null && session.getAttribute("uploadedGenesTotalProvide").equals("yes")) || (session.getAttribute(nomFichero) != null && session.getAttribute(nomFichero).equals(nomFichero))) {
                                        %>
                                        <img src="images/bigo/enrichment_provide/uploaded-icon.png" style="width: 25%;">
                                        <% } else { %>
                                        <img src="images/bigo/enrichment_provide/nouploaded-icon.png" style="width: 25%;">
                                        <% }
                                        %>
                                    </td>
                                    <td style="vertical-align: middle;"><% out.println(f.getName());%></td>
                                    <td style="width: 23%;">
                                        <%
                                            if (session.getAttribute("uploadedGenesTotalProvide") != null && session.getAttribute("uploadedGenesTotalProvide").equals("yes")) {
                                        
                                        %>
                                        <form action="FilesServlet" method="post" enctype="multipart/form-data" id="<%=idForm%>">
                                            <span class="pull-left file-input btn btn-file" style="padding-left: 34px; padding-top: -3px; font-weight: bold; background: url(images/bigo/enrichment_provide/upload_button-icon.png) #fafafa no-repeat; color: #d68b00; border: 1px solid #e8b10b; background-position: left;">Already uploaded!
                                                <input type="file" name="dataDir" accept=".csv,text/plain" onchange="document.getElementById('<%=idForm%>').submit();" disabled="">
                                            </span>
                                            <br>
                                            <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                                            <input type="hidden" name="nameFileProvide" value="<%=nomFichero%>" />
                                            <input type="hidden" name="genesProvide" value="no" />
                                            <input type="hidden" name="enrichment" value="genesProvide" />
                                            
                                        </form>
                                        <% } else { %>
                                        <form action="FilesServlet" method="post" enctype="multipart/form-data" id="<%=idForm%>">
                                            <span class="pull-left file-input btn btn-file" style="padding-left: 34px; padding-top: -3px; font-weight: bold; background: url(images/bigo/enrichment_provide/upload_button-icon.png) #fafafa no-repeat; color: #d68b00; border: 1px solid #e8b10b; background-position: left;">Upload gene file
                                                <input type="file" name="dataDir" accept=".csv,text/plain" onchange="document.getElementById('<%=idForm%>').submit();">
                                            </span>
                                            <br>
                                            <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                                            <input type="hidden" name="nameFileProvide" value="<%=nomFichero%>" />
                                            <input type="hidden" name="genesProvide" value="no" />
                                            <input type="hidden" name="enrichment" value="genesProvide" />
                                        </form>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                        iContFile++;
                                    }
                                %>
                            </tbody>
                        </table>

                        <h2 class="article-title" style="color: #0099cc; text-align: left; font-size: 17px; font-weight: bold; margin-top: 35px; ">Advanced options (required)</h2> 
                        <hr class="featurette-divider" style="margin-top: 0px;">

                        <div class="row" style="text-align: center;">
                            <div class="col-xs-6 col-sm-4">
                                <p style="font-size: 14px;">Select your gene column separator character</p>
                                <html:form action="executeEnrichmentProvide">
                                    <select onchange="select_type()" class="form-control" name="type_character_gene" id="type_character_gene" required style="width: 150px; display: inline; margin-bottom: 20px;">
                                        <option value="tab">Tab key</option>
                                        <option value="enter">Enter key</option>
                                        <option value="space">Space bar</option>
                                        <option value="other">Other character</option>
                                    </select>
                                    <input id="character_gene" name="character_gene" type="text" class="form-control" maxlength="1" placeholder="Input your character" style="width: 180px;">
                                </div>

                                <div class="col-xs-6 col-sm-4">
                                    <p style="font-size: 14px;">Do the files include header?</p>
                                    <select class="form-control" name="include_header_gene" id="include_header_gene" required style="width: 150px; display: inline; margin-bottom: 50px;">
                                        <option value="yes">Yes</option>
                                        <option value="no">No</option>
                                    </select>
                                </div>

                                <%
                                    if (session.getAttribute("uploadedGenesTotalProvide") != null && session.getAttribute("uploadedGenesTotalProvide").equals("yes")) {
                                %>

                                <div class="col-xs-6 col-sm-4">
                                    <p style="font-size: 14px;">Select your group column separator character</p>
                                    <select onchange="select_type()" class="form-control" name="type_character_completegene" id="type_character_completegene" required style="width: 150px; display: inline; margin-bottom: 20px;">
                                        <option value="tab">Tab key</option>
                                        <option value="space">Space bar</option>
                                        <option value="other">Other character</option>
                                    </select>
                                    <input id="character_completegene" name="character_completegene" type="text" class="form-control" maxlength="1" placeholder="Input your character" style="width: 180px;">
                                </div>
                                <%
                                    }
                                %>

                                <p style="margin-top: 130px;">&nbsp;</p>
                                <input type="hidden" name="calculate_enrichment" value="yes" />
                                <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />

                                <p class="pull-right">
                                    <% 
                                    boolean bUploadedManual = true;
                                    for (File f : list) {
                                        String nomFichero = f.getName();
                                        if((session.getAttribute(nomFichero) == null) || (session.getAttribute(nomFichero) != null && !session.getAttribute(nomFichero).equals(nomFichero))){
                                            bUploadedManual = false;
                                        }
                                    }
                                    if ((session.getAttribute("uploadedGenesTotalProvide") != null && session.getAttribute("uploadedGenesTotalProvide").equals("yes")) || (bUploadedManual)) {
                                    %>
                                    <input type="submit" class="btn btn-success btn-lg" value="Next &#9658;">
                                    <% } else { %>
                                    <input type="submit" class="btn btn-success btn-lg" value="Next &#9658;" disabled="">
                                    <%}%>


                                </p>
                            </html:form>
                            <html:form action="backSelectGenesProvide">
                                <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                                <p style="text-align: left; font-size: 25px;"><input type="submit" class="btn btn-danger btn-lg" value="&#9664 Back"></p> 
                                </html:form>
                        </div>
                        <% } else { %>
                        <div style="text-align: center; margin-top: 50px;">
                            <img src="images/bigo/empty_box.jpg" style="width: 20%;">
                            <p style="font-size: 16px; font-weight: bold;">You haven't uploaded any gene enrichment analysis file.</p>
                            <p>To upload a file click the "Select files..." button</p>
                        </div>
                        <%
                            }
                        %>





                    </div>
                </div>
            </div>              
        </article>
        <jsp:include page="../../../components/footer.jsp" />

    </body>
</html>
