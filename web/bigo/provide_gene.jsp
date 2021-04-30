<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<!-- OPTION: FILE DELETE -->
<%
    String applicationPath = request.getServletContext().getRealPath("");
    String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId();

    if (request.getParameter("filename_delete") != null) {
        out.println("");
        String dataDir = pathSesion + File.separator + "outDirProvide";
        String file_delete_path = dataDir + File.separator + request.getParameter("filename_delete");
        System.out.println(file_delete_path);
        System.out.println(file_delete_path);
        System.out.println(file_delete_path);

        File f = new File(file_delete_path); // Elimina el fichero seleccionado
        f.delete();
        File dirData = new File(dataDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
        if (dirData.exists() && dirData.listFiles().length == 0) {
            dirData.delete();
            File dirSesion = new File(pathSesion);
            dirSesion.delete();
        }
    }%> 

<!-- OPTION: FILE VIEW -->
<!-- Modal View file-->
<div class="modal fade" id="viewFile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <% String file_view = request.getParameter("filename_view");%>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel"><span style="font-weight: bold;">View file:</span> 
                    <%
                        if (file_view == null) {
                            out.print("Loading file...");
                        } else {
                            out.print(file_view);
                        }
                    %></h4>
            </div>
            <div class="modal-body scroll">
                <%
                    String txt = applicationPath + File.separator + "WEB-INF" + File.separator + session.getId() + File.separator + "outDirProvide" + File.separator + file_view;
                    
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

<hr id="own" class="featurette-divider" style=" margin-top: 50px; margin-bottom: 50px;">

<!-- SELECT FILES... -->
<div class="pull-right">
    <form action="FilesServlet" method="post" enctype="multipart/form-data" id="filesuploader">
        <span class="pull-left file-input btn btn-primary btn-file" style="font-size: 20px;">Select files...
            <input type="file" name="dataDir" multiple="multiple" accept=".csv,text/plain" onchange="document.getElementById('filesuploader').submit();">
        </span>
        <br>
        <span class="pull-left" style="padding-top: 8px; font-size: 13px; color: #959595; font-style: italic;"> (only *.txt and *.csv files)</span>
        <input type="hidden" name="sessionId" value="<%out.print(session.getId());%>" />
        <input type="hidden" name="enrichment" value="no" />
    </form>

</div>

<h2 class="article-title" style="text-align: left; font-size: 25px; margin-top: 35px; ">Step 2. Provide a gene enrichment analysis result</h2> 
<p style="color: #999999;">Select your gene enrichment analysis files to upload into the application (Max. 50MB per file).</p>

<!-- ERRORS -->
<%
    String sesionId = request.getParameter("sessionId");
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
<p style="margin-top: 30px;">&nbsp;</p>



<table id="example" class="table table-striped table-bordered" cellspacing="0" width="100%">
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
            <td style="width: 65%; vertical-align: middle;"><% out.println(f.getName());%></td>
            <td style="text-align: right; vertical-align: middle;">
                <!-- VIEW FILE BUTTON -->
                <form id="view_file" action="bigo.jsp?enrichment=no#own" method="post" style="margin-right: 52%; margin-top: -33px;">
                    <button id="view_file_dialog" type="button" class="btn btn-info" data-toggle="modal" data-target="#viewFile" style="visibility: hidden; font-weight: bold;"><img src="images/bigo/view.png"> View file</button>
                    <input type="hidden" name="filename_view" value="<%=nomFichero%>" />
                    <input onclick="document.getElementById('view_file').submit();" type="submit" class="btn btn-info" data-toggle="modal" data-target="#viewFile" style="padding-left: 28px; padding-top: -3px; font-weight: bold; background: url(images/bigo/view.png) #46b8da no-repeat; background-position: left;" value="View file">
                    <% if (request.getParameter("filename_view") != null) { %>
                    <script language="JavaScript">
                        document.getElementById('view_file_dialog').click();
                    </script>
                    <% }%>

                </form>

                <!-- DROP FILE BUTTON -->
                <form id="drop_file" action="bigo.jsp?enrichment=no#own" method="post" style="margin-top: -34px; margin-right: 15px; ">
                    <input type="hidden" name="filename_delete" value="<%=nomFichero%>" />
                    <input type="submit" class="btn btn-danger" style="padding-left: 28px; padding-top: -3px; font-weight: bold; background: url(images/bigo/drop_file.gif) #d9534f no-repeat; background-position: left; border: 1px solid d9534f;" value="Drop file">
                </form>
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
        <p style="font-size: 14px;">Select your column separator character</p>
        <html:form action="viewClustersProvide">
            <select onchange="select_type()" class="form-control" name="type_character" id="type_character" required style="width: 150px; display: inline; margin-bottom: 20px;">
                <option value="tab">Tab key</option>
                <option value="space">Space bar</option>
                <option value="other">Other character</option>
            </select>
            <input id="character" name="character" type="text" class="form-control" maxlength="1" placeholder="Input your character" style="width: 180px;">
        </div>

        <div class="col-xs-6 col-sm-4">
            <p style="font-size: 14px;">Select your biological resource</p>
            <select class="form-control" name="type_resource" id="type_resource" required style="width: 150px; display: inline; margin-bottom: 50px;">
                <option value="go">Gene Ontology</option>
                <option value="other">Other resource</option>
            </select>
        </div>

        <div class="col-xs-6 col-sm-4">
            <p style="font-size: 14px;">Do the files include header?</p>
            <select class="form-control" name="include_header" id="type_resource" required style="width: 150px; display: inline; margin-bottom: 50px;">
                <option value="yes">Yes</option>
                <option value="no">No</option>
            </select>
        </div>
        <p style="margin-top: 50px;">&nbsp;</p>

        <input type="hidden" name="calculate_enrichment" value="yes" />
        <p class="pull-right"><input type="submit" class="btn btn-success btn-lg" value="Next step &#9658;"></p>
        </html:form>
        <html:form action="quitProvide">
        <input type="hidden" name="contfile" value="<%=iContFile%>" />
        <input type="hidden" name="sessionId" value="<%=session.getId()%>" />
        <p style="text-align: left; font-size: 25px;"><input type="submit" class="btn btn-danger btn-lg" value="&#9664 Quit"></p> 
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