/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
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
public class DownloadViewComparativeStopwordsCreateAction extends org.apache.struts.action.Action {

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

        //Capturar las stopwords del ranking en concreto
        DownloadViewComparativeStopwordsCreateActionForm applyForm = (DownloadViewComparativeStopwordsCreateActionForm) form;
        String filePath = applyForm.getFilePath();
        filePath += File.separator + "rankings";
        String fileName = applyForm.getFileName();

        String pathFiltrado = filePath + File.separator + fileName;
        int levelUser = Integer.parseInt(request.getSession().getAttribute("level").toString());
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
        //int clusters = bigo.getcConjuntoTerminos().size();
        //levelUser = ((clusters * levelUser) / 100);
        String dataFinal = "Group of genes = " + (bigo.getRanking().getcConjuntoTerminos().size()) + "\n\nID;Name;IC(x);PvalueAdjusted;NumberBiclustersView;BiclustersViewList\n";
        String dataTerms = "";
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
                    if (bStopword) {
                        dataTerms += data + " \n";
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

        //Guardar fichero stopwords
        FileWriter fichero = null;
        PrintWriter pw = null;
        try {
            fichero = new FileWriter(filePath + File.separator + "stopwords.txt");
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

        //Descargar fichero stopwords.txt     
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=stopwords.txt");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(filePath + File.separator + "stopwords.txt"));

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
