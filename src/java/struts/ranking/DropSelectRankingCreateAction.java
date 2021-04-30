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
public class DropSelectRankingCreateAction extends org.apache.struts.action.Action {

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
        DropSelectRankingCreateActionForm dropForm = (DropSelectRankingCreateActionForm) form;
        List<String> lista = new ArrayList<String>();

        if (dropForm.getGosdelete() != null && dropForm.getGosdelete().length >= 0) {
            
            String private_files = "WEB-INF";
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = request.getSession().getId();
            String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
            String pathFiltrado = pathSesion + File.separator + "output.txt";
            String dataFinal = "";
            String sourceFile = pathSesion + File.separator + "output.txt";
            String destinationFile = pathSesion + File.separator + "copy.txt";

            //Copiar fichero para el Undo
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
            
            

            //Eliminacion de terminos            
            for (String s : dropForm.getGosdelete()) {
                lista.add(s);
            }

            Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
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
                        if (!lista.contains(body[0])) {
                            dataFinal += data + "\r\n";
                        }
                    }
                }
                br.close();
            }

            Writer output = new BufferedWriter(new FileWriter(pathFiltrado));
            try {
                output.write(dataFinal);
            } finally {
                output.close();
            }
        }

        return mapping.findForward(SUCCESS);
    }
}
