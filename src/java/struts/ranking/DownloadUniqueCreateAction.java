/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import entities.Ranking;
import entities.Row;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import processes.Bigo;

/**
 *
 * @author principalpc
 */
public class DownloadUniqueCreateAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";

    /**
     * This is the action called from the Struts framework.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     */
    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        String pathFiltrado = pathSesion + File.separator + "output.txt";

        List<String> lista = new ArrayList<String>();
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
        //int clusters = bigo.getcConjuntoTerminos().size();
        String dataFinal = "Group of genes = " + (bigo.getRanking().getcConjuntoTerminos().size()) + "\n\nID;Name;IC(x);PvalueAdjusted;NumberBiclustersView;BiclustersViewList\n";
        String dataTerms = "";
        int minLevelUser = Integer.parseInt(request.getSession().getAttribute("minLevel").toString());
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
                    String sCluster = body[4].substring(body[4].indexOf("(") + 1, body[4].length() - 2).replace(",", ".");
                    double numClusterRow = Double.parseDouble(sCluster);
                    boolean bUnique = minLevelUser >= numClusterRow;
                    if (bUnique) {
                        dataTerms += data + " \n";
                    } else {
                        lista.add(body[0]);
                    }
                }
            }
            br.close();
        }

        if (dataTerms.equals("")) {
            dataFinal = "No terms";
        } else {
            dataFinal += dataTerms;
        }

        Ranking ranking = bigo.getRanking();
        Set<Row> set = ranking.getcResultToGraph();

        //Eliminar los terminos para prepararlo para el grafo
        List<Row> listaRowsEliminar = new ArrayList<Row>();
        for (int i = 0; i < lista.size(); i++) {
            boolean bEncontrado = false;
            Iterator it = set.iterator();
            while (it.hasNext() && !bEncontrado) {
                Row r = ((Row) it.next());
                if (r.getIdGo().equals(lista.get(i))) {
                    listaRowsEliminar.add(r);
                    bEncontrado = true;
                }
            }
        }

        set.removeAll(listaRowsEliminar);

        //Guardar fichero stopwords
        FileWriter fichero = null;
        PrintWriter pw = null;
        try {
            fichero = new FileWriter(pathSesion + File.separator + "uniques.txt");
            pw = new PrintWriter(fichero);
            pw.print(dataFinal);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                // Nuevamente aprovechamos el finally para 
                // asegurarnos que se cierra el fichero.
                if (null != fichero) {
                    fichero.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }

        //Descarga fichero stopwords
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=uniques.txt");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(pathSesion + File.separator + "uniques.txt"));

            ServletOutputStream out = response.getOutputStream();

            byte[] buf = new byte[1024];
            int n = 0;
            while (-1 != (n = in.read(buf))) {
                out.write(buf, 0, n);
            }
            in.close();
            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return mapping.findForward(SUCCESS);
    }
}
