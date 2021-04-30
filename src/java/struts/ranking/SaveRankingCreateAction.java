/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
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
public class SaveRankingCreateAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";
    private static final String PRIVATE_FILES = "WEB-INF";

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

        String level = request.getSession().getAttribute("level").toString().replace(".", "_");
        String minLevel = request.getSession().getAttribute("minLevel").toString().replace(".", "_");
        String maxIC = request.getSession().getAttribute("maxIC").toString().replace(".", "_");
        String confidenceFactor = request.getSession().getAttribute("confidenceFactor").toString().replace(".", "_");

        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String filePath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId;
        String rankingPath = filePath + File.separator + "rankings";
        
        int stopwords = Integer.parseInt(request.getSession().getAttribute("stopwordsRanking").toString());
        int uniques = Integer.parseInt(request.getSession().getAttribute("uniquesRanking").toString());
                

        //Comprueba si la carpeta rankings existe
        File rankingFolder = new File(rankingPath);
        if (!rankingFolder.exists()) {
            rankingFolder.mkdir();
        }

        // Copiar ranking a carpeta rankings
        File origen = new File(filePath + File.separator + "output.txt");
        if(level.equals("101")){
            level = "no";
        }  
        if(maxIC.equals("9999")){
            maxIC = "no";
        } 
        if(confidenceFactor.equals("1")){
            confidenceFactor = "no";
        }         
        if(minLevel.equals("0")){
            minLevel = "no";
        } 
        File destino = new File(rankingPath + File.separator + "output-" + maxIC + "-" + minLevel + "-" + level + "-" + confidenceFactor + "-" + stopwords + "-" + uniques + ".txt");

        try {
            InputStream in = new FileInputStream(origen);
            OutputStream out = new FileOutputStream(destino);

            byte[] buf = new byte[1024];
            int n = 0;
            while (-1 != (n = in.read(buf))) {
                out.write(buf, 0, n);
            }

            in.close();
            out.close();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }

        //Lista BIGO guardara los objetos BIGO de todos los rankings guardados.
        List<Bigo> listaBigo;
        if (request.getSession().getAttribute("listaBigos") == null) {
            listaBigo = new ArrayList<Bigo>();
        } else {
            listaBigo = (ArrayList<Bigo>) request.getSession().getAttribute("listaBigos");
        }

        int pos = -1;
        Bigo bOriginal = (Bigo)request.getSession().getAttribute("bigo");
        bOriginal.setStopwords(stopwords);
        bOriginal.setUniques(uniques);
        request.getSession().setAttribute("bigo", bOriginal);
        Bigo b = ((Bigo) request.getSession().getAttribute("bigo")).clone();
        b.setStopwords(stopwords);
        b.setUniques(uniques);
        if (!listaBigo.isEmpty()) {
            for (int i = 0; i < listaBigo.size() && pos == -1; i++) {
                if(listaBigo.get(i).getMaxIC() == b.getMaxIC() && listaBigo.get(i).getMinLevel() == b.getMinLevel() && listaBigo.get(i).getLevel() == b.getLevel() && listaBigo.get(i).getConfidenceFactor() == b.getConfidenceFactor() && listaBigo.get(i).getStopwords() == b.getStopwords() && listaBigo.get(i).getUniques() == b.getUniques()){
                    pos = i;
                }
            }
        }
        
        if (pos == -1) {
            listaBigo.add(b);
            request.getSession().setAttribute("listaBigos", listaBigo);
        } else {
            listaBigo.remove(pos);
            listaBigo.add(b);
            request.getSession().setAttribute("listaBigos", listaBigo);
        }

        request.getSession().setAttribute("saveRank", "yes");

        return mapping.findForward(SUCCESS);
    }
}
