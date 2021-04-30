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
        </script>


    </head>

    <body style="background-color: #f4f4f4;">

        <% session.setAttribute("active", "bigo");%>
        <jsp:include page="../../../components/header.jsp" />
        <article class="article article-contributors" style="margin-top: -80px; margin-bottom: -80px; ">
            <div class="container">
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li><a href="bigo.jsp">First phase. Enrichment analysis</a></li>
                    <li style="font-weight: normal;">
                        Step 3. Customize your collections of genes
                    </li>
                </ul>
                <br>
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; text-align: left; background-color: #ffffff; margin-top: 5px;">
                    <div class="about-container" style="margin: 50px 100px 50px 100px; text-align: justify;">
                        <div>

                            <h2 class="article-title" style="text-align: center; font-size: 30px; margin-top: 35px; ">First phase: Enrichment analysis</h2>
                            <div style="float: right; margin-top: 30px; margin-right: -50px;">
                                <img src="../../../images/bigo/customize.png" style="width: 65%;">
                            </div>
                            <h2 class="article-title" style="text-align: left; font-size: 25px; margin-top: 35px; margin-bottom: 30px; ">Step 3. Customize your collections of genes</h2>
                            <div style="width: 55%; text-align: justify;">Aqui se deberia explicar que los ficheros deben ser homogeneos en cuanto al formato, que debe establecer el significado de las columnas de su enriquecimiento, etc. Explicar que mostrará siempre los 300 primeros términos del fichero.</div>
                            <!-- LEER EL NOMBRE DE LOS FICHEROS -->
                            <%
                                String applicationPath = request.getServletContext().getRealPath("");
                                String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId();
                                String dataDir = pathSesion + File.separator + "outDirProvide";
                                File dirData = new File(dataDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                                ArrayList<String> nomFicheros = new ArrayList();
                                if (dirData.exists() && dirData.listFiles().length != 0) {
                                    File[] list = dirData.listFiles();
                                    for (File f : list) {
                                        String nomFichero = f.getName();
                                        nomFicheros.add(nomFichero);
                                    }
                                }
                                String pathFile = dataDir + File.separator + nomFicheros.get(0);
                            %>
                            <p style="margin-top: 50px;">&nbsp;</p>
                            <h4>Preview view: <%=nomFicheros.get(0)%></h4>
                            <hr id="new" class="featurette-divider" style="margin-bottom: 50px;">

                            <logic:messagesPresent>
                                <div class="alert alert-danger" role="alert" style="margin-top: 50px; margin-bottom: 30px;"><img src='images/bigo/upload_files_error.png' style='width: 25px; margin-top: -2px; padding-right: 5px;'> <span style='font-weight: bold;'>ERROR:</span><br /><br /><html:errors /></div>
                                </logic:messagesPresent>

                            <html:form action="selectGenesProvide">
                                <table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%" style="width: 100%;">
                                    <%
                                        String character = "";
                                        if (session.getAttribute("type_character_provide") != null && session.getAttribute("type_character_provide").equals("tab")) {
                                            character = "\t";
                                        } else if (session.getAttribute("type_character_provide") != null && session.getAttribute("type_character_provide").equals("space")) {
                                            character = " ";
                                        } else if (session.getAttribute("type_character_provide") != null && session.getAttribute("type_character_provide").equals("other") && session.getAttribute("character_provide") != null) {
                                            character = (String) session.getAttribute("character_provide");
                                        } else {
                                            out.println("Excepcion gorda.");
                                        }
                                        session.setAttribute("separador", character);

                                        String txt = pathFile;
                                        File fComprobacion = new File(txt);
                                        int numColumns = 0;
                                        if (fComprobacion.exists()) {
                                            BufferedReader br = new BufferedReader(new FileReader(txt));
                                            String data, dataFinal = "";
                                    %>

                                    <thead>
                                        <tr>
                                            <%
                                                // Header file
                                                if ((data = br.readLine()) != null) {
                                                    String[] header = data.split(character);
                                                    numColumns = header.length;

                                                    if (session.getAttribute("include_header_provide") != null && session.getAttribute("include_header_provide").equals("yes")) {

                                                        int iCont = 0;
                                                        for (String sHead : header) {
                                                            out.println("<th style='min-width: 100px; text-align: left; '>" + sHead + "<br />");
                                            %>
                                    <select name="cluster_columns_<%=iCont%>" class="form-control" style="text-align: center; margin-top: 10px; background-color: #b4cdff;">
                                        <option value="default" selected="">Select an option...</option>
                                        <option value="term_id">Term ID</option>
                                        <option value="term_name">Term name</option>
                                        <option value="pvalue">Pvalue</option>
                                        <option value="popterm">Population term</option>
                                        <option value="poptotal">Population total</option>
                                        <option value="genesList">List of genes</option>
                                        <option value="other">Other info</option>
                                    </select>
                                    <%
                                            out.println("</th>");
                                            iCont++;
                                        }
                                    } else {
                                        for (int i = 0; i < numColumns; i++) {
                                            out.println("<th style='min-width: 100px; text-align: left; '> Column" + (i + 1) + "<br />");
                                    %>
                                    <select name="cluster_columns_<%=i%>" class="form-control" style="text-align: center; margin-top: 10px; background-color: #b4cdff;">
                                        <option value="default" selected="">Select an option...</option>
                                        <option value="term_id">Term ID</option>
                                        <option value="term_name">Term name</option>
                                        <option value="pvalue">P value</option>
                                        <option value="popterm">Population term</option>
                                        <option value="poptotal">Population total</option>
                                        <option value="genesList">List of genes</option>
                                        <option value="other">Other info</option>
                                    </select>
                                    <%
                                                out.println("</th>");
                                            }
                                        }
                                    %>
                                    </tr>
                                    </thead>

                                    <tbody>
                                        <%
                                            if (session.getAttribute("include_header_provide") != null && session.getAttribute("include_header_provide").equals("no")) {
                                                out.println("</tr>");
                                                for (String sHead : header) {
                                                    out.println("<td style='min-width: 100px;'>" + sHead + "</td>");
                                                }
                                                out.println("</tr>");
                                            }
                                            //Body file
                                            int iCont = 0;
                                            while ((data = br.readLine()) != null) {
                                                if (iCont < 300) {
                                                    out.println("<tr>");
                                                    String[] body = data.split(character);
                                                    for (String sBody : body) {
                                        %>
                                    <td style="min-width: 100px;"><%=sBody%></td>
                                    <%
                                                }
                                                out.println("</tr>");
                                                iCont++;
                                            }
                                        }
                                    %>

                                    </tbody>
                                </table>
                                <%
                                        } else { //No reconoce fichero
                                            out.println("Excepcion gorda.");
                                        }

                                        br.close();
                                    }
                                %>
                                <p>&nbsp;</p>
                                <div>

                                    <input type="hidden" name="numColumns" value="<%=numColumns%>" />
                                    <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
                                    <p class="pull-right">
                                        <input type="submit" class="btn btn-success btn-lg" value="Next &#9658;">
                                    </p>
                                </html:form>
                                <a href="bigo.jsp?enrichment=no#own" class="btn btn-danger btn-lg">&#9664 Back</a>
                            </div>
                        </div>
                    </div>
                </div>
        </article>
        <jsp:include page="../../../components/footer.jsp" />
    </body>
</html>
