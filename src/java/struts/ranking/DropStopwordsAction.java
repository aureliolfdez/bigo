/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import entities.Ranking;
import entities.Row;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import processes.Bigo;

/**
 *
 * @author aureliolfdez
 */
public class DropStopwordsAction extends org.apache.struts.action.Action {

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
        int levelUser = Integer.parseInt(request.getSession().getAttribute("level").toString());
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
        List<String> lista = new ArrayList<String>();

        //Copiar fichero para el Undo
        String sourceFile = pathSesion + File.separator + "output.txt";
        String destinationFile = pathSesion + File.separator + "copy.txt";
        try {
            File inFile = new File(sourceFile);
            File outFile = new File(destinationFile);

            FileInputStream in = new FileInputStream(inFile);
            FileOutputStream out = new FileOutputStream(outFile);

            int c;
            while ((c = in.read()) != -1) {
                out.write(c);
            }

            in.close();
            out.close();
            request.getSession().setAttribute("undo", "true");
        } catch (IOException e) {
            System.err.println("Hubo un error de entrada/salida!!!");
        }

        String dataFinal = "";
        File fComprobacionFiltrado = new File(pathFiltrado);
        if (fComprobacionFiltrado.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(pathFiltrado));
            String data;
            dataFinal += br.readLine() + "\r\n";
            dataFinal += br.readLine() + "\r\n";
            dataFinal += br.readLine() + "\r\n";
            //Body file
            while ((data = br.readLine()) != null) {
                String[] body = data.split(";");
                if (body.length == 6) {
                    //int numClusterRow = Integer.parseInt(body[4].substring(0, body[4].indexOf("/")));
                    String sCluster = body[4].substring(body[4].indexOf("(") + 1, body[4].length() - 2).replace(",", ".");
                    double numClusterRow = Double.parseDouble(sCluster);
                    boolean bStopword = levelUser <= numClusterRow;
                    if (!bStopword) {
                        dataFinal += data + "\r\n";
                    } else {
                        lista.add(body[0]);
                    }
                }
            }
            br.close();
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
        

        Writer output = new BufferedWriter(new FileWriter(pathFiltrado));
        try {
            output.write(dataFinal);
        } finally {
            output.close();
        }

        return mapping.findForward(SUCCESS);
    }
}
