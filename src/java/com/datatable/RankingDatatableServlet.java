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
@WebServlet("/RankingDatatableServlet")
public class RankingDatatableServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public RankingDatatableServlet() {
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

        /*String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        String pathFiltrado = pathSesion + File.separator + "output.txt";

        response.setContentType("application/json");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        List<RankingDatatable> rankingList = new ArrayList<RankingDatatable>();

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
                    rankingList.add(new RankingDatatable(sTerm, body[1], Double.parseDouble(body[2]), Double.parseDouble(body[3]), body[4], body[5]));
                }
            }
            br.close();
        }

        RankingJsonObject rankingJsonObject = new RankingJsonObject();
        rankingJsonObject.setiTotalDisplayRecords(rankingList.size());
        rankingJsonObject.setiTotalRecords(rankingList.size());
        rankingJsonObject.setAaData(rankingList);
        rankingJsonObject.setLength(25);

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json2 = gson.toJson(rankingJsonObject);
        out.print(json2);*/
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // TODO Auto-generated method stub
        
        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        String pathFiltrado = pathSesion + File.separator + "output.txt";

        response.setContentType("application/json");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        List<RankingDatatable> rankingList = new ArrayList<RankingDatatable>();

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
                    rankingList.add(new RankingDatatable(sTerm, body[1], Double.parseDouble(body[2]), Double.parseDouble(body[3]), body[4], body[5]));
                }
            }
            br.close();
        }

        RankingJsonObject rankingJsonObject = new RankingJsonObject();
        rankingJsonObject.setiTotalDisplayRecords(rankingList.size());
        rankingJsonObject.setiTotalRecords(rankingList.size());
        rankingJsonObject.setAaData(rankingList);
        rankingJsonObject.setLength(25);

        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String json2 = gson.toJson(rankingJsonObject);
        out.print(json2);
    }

}
