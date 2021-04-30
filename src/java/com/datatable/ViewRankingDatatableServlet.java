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
 * Servlet implementation class RankingDatatableServlet
 */
@WebServlet("/ViewRankingDatatableServlet")
public class ViewRankingDatatableServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewRankingDatatableServlet() {
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

        java.text.DecimalFormat formatoSalidaDecimal = new java.text.DecimalFormat("#.###");//para dos decimales
        String savedIc = formatoSalidaDecimal.format(Double.parseDouble(request.getSession().getAttribute("savedIc").toString()));
        String savedConfidence = formatoSalidaDecimal.format(Double.parseDouble(request.getSession().getAttribute("savedConfidence").toString()));
        String savedLevel = request.getSession().getAttribute("savedLevel").toString();
        String savedMinLevel = request.getSession().getAttribute("savedMinLevel").toString();
        String savedStopwords = request.getSession().getAttribute("savedStopwords").toString();
        String savedUniques = request.getSession().getAttribute("savedUniques").toString();
        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        
        String sResMinLevel = savedMinLevel;
        if (savedMinLevel.equals("0")) {
            sResMinLevel = "no";
        }
        
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

        String pathFiltrado = pathSesion + File.separator + "rankings" + File.separator + "output-" + sResIc.replace(",", "_") + "-" + sResMinLevel.replace(",", "_") + "-" + sResLevel.replace(",", "_") + "-" + sResConfidence.replace(",", "_") + "-" + savedStopwords + "-" + savedUniques + ".txt";
        response.setContentType("application/json");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        List<ViewRankingDatatable> rankingList = new ArrayList<ViewRankingDatatable>();

        File fComprobacionInicial = new File(pathFiltrado);

        if (fComprobacionInicial.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(pathFiltrado));
            String data, dataFinal = "", sTerm = "";
            br.readLine();
            br.readLine();
            br.readLine();

            while ((data = br.readLine()) != null) {
                String[] body = data.split(";");
                if (body.length == 6) {
                    if (body[0].contains("GO:")) {
                        sTerm = body[0].replace(":", "%3A");
                        sTerm = "<a href='http://amigo.geneontology.org/amigo/medial_search?q=" + sTerm + "' target='_blank'><img src='images/bigo/zoom_in.png'> " + body[0] + "</a>";
                    } else {
                        sTerm = body[0];
                    }
                    rankingList.add(new ViewRankingDatatable(sTerm, body[1], Double.parseDouble(body[2]), Double.parseDouble(body[3]), body[4], body[5]));
                }
            }
            br.close();
        }

        ViewRankingJsonObject rankingJsonObject = new ViewRankingJsonObject();
        rankingJsonObject.setiTotalDisplayRecords(rankingList.size());
        rankingJsonObject.setiTotalRecords(rankingList.size());
        rankingJsonObject.setAaData(rankingList);

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json2 = gson.toJson(rankingJsonObject);
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
