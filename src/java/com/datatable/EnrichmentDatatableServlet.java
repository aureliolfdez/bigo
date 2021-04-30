package com.datatable;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

/**
 *
 * @author principalpc
 */
@WebServlet("/EnrichmentDatatableServlet")
public class EnrichmentDatatableServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public EnrichmentDatatableServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        
        

        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        String pathEnrichmentFile = pathSesion + File.separator + "outDir" + File.separator + request.getSession().getAttribute("enrichmentFile");

        response.setContentType("application/json");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        List<EnrichmentDatatable> enrichmentList = new ArrayList<EnrichmentDatatable>();

        File fComprobacionInicial = new File(pathEnrichmentFile);

        if (fComprobacionInicial.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(pathEnrichmentFile));
            String data, dataFinal = "", sTerm = "";
            br.readLine();
            //Body file  
            while ((data = br.readLine()) != null) {
                String[] body = data.split("\t");
                if (body[0].contains("GO:")) {
                    sTerm = body[0].replace(":", "%3A");
                    sTerm = "<a href='http://amigo.geneontology.org/amigo/medial_search?q=" + sTerm + "' target='_blank'><img src='images/bigo/zoom_in.png'> " + body[0] + "</a>";
                } else {
                    sTerm = body[0];
                }
                enrichmentList.add(new EnrichmentDatatable(sTerm, body[8], body[5], body[6], body[7], body[1], body[2], body[3], body[4]));
            }
            br.close();
        }

        EnrichmentJsonObject enrichmentJsonObject = new EnrichmentJsonObject();
        enrichmentJsonObject.setiTotalDisplayRecords(enrichmentList.size());
        enrichmentJsonObject.setiTotalRecords(enrichmentList.size());
        enrichmentJsonObject.setAaData(enrichmentList);

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json2 = gson.toJson(enrichmentJsonObject);
        out.print(json2);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // TODO Auto-generated method stub
    }
}
