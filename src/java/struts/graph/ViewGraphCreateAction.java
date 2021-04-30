/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.graph;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.tomcat.util.codec.binary.Base64;
import processes.Bigo;

/**
 *
 * @author aureliolfdez
 */
public class ViewGraphCreateAction extends org.apache.struts.action.Action {

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
               

        ViewGraphCreateActionForm applyForm = (ViewGraphCreateActionForm) form;
        double savedIc = applyForm.getSavedIc();
        double savedConfidence = applyForm.getSavedConfidence();
        int savedLevel = applyForm.getSavedLevel();
        int savedMinLevel = applyForm.getSavedMinLevel();
        int savedStopwords = applyForm.getSavedStopwords();
        int savedUniques = applyForm.getSavedUniques();
        String base = applyForm.getBase();
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String graphsPath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "graphs";

        String graphOwnPath, sIc = "", sMin = "", sLevel = "", sConfi = "", sStop = "", sUniq = "";
        if (base.equals("base")) {
            graphOwnPath = graphsPath + File.separator + "base";
        } else {
            java.text.DecimalFormat formatoSalidaDecimal = new java.text.DecimalFormat("#.###");//para dos decimales
            sIc = formatoSalidaDecimal.format(savedIc).replace(".", "_").replace(",", "_");
            sMin = formatoSalidaDecimal.format(savedMinLevel).replace(".", "_").replace(",", "_");
            sLevel = formatoSalidaDecimal.format(savedLevel).replace(".", "_").replace(",", "_");
            sConfi = formatoSalidaDecimal.format(savedConfidence).replace(".", "_").replace(",", "_");
            sStop = formatoSalidaDecimal.format(savedStopwords).replace(".", "_").replace(",", "_");
            sUniq = formatoSalidaDecimal.format(savedUniques).replace(".", "_").replace(",", "_");
            graphOwnPath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "graphs" + File.separator + sIc + "-" + sMin + "-" + sLevel + "-" + sConfi + "-" + sStop + "-" + sUniq;
        }
        

        //Obtengo el objeto Bigo
        Bigo bigo = null;
        if (base.equals("base")) {
            bigo = (Bigo) request.getSession().getAttribute("bigo_base");
        } else {
            int pos = -1;
            ArrayList<Bigo> listaBigo = (ArrayList<Bigo>) request.getSession().getAttribute("listaBigos");
            if (!listaBigo.isEmpty()) {
                for (int i = 0; i < listaBigo.size() && pos == -1; i++) {
                    if (listaBigo.get(i).getMaxIC() == savedIc && listaBigo.get(i).getMinLevel() == savedMinLevel && listaBigo.get(i).getLevel() == savedLevel && listaBigo.get(i).getConfidenceFactor() == savedConfidence && listaBigo.get(i).getStopwords() == savedStopwords && listaBigo.get(i).getUniques() == savedUniques) {
                        pos = i;
                        
                    }
                }
                
                if (pos != -1) {
                    bigo = listaBigo.get(pos);
                } else {
                    bigo = (Bigo) request.getSession().getAttribute("bigo_base");
                }
            }
        }
                
        //Preparo la carpeta graphs para la ejecucion de BIGO
        File graphsFile = new File(graphsPath);
        if (!graphsFile.exists()) {
            graphsFile.mkdir();
        }

        //Preparo la carpeta del ranking en concreto
        File graphOwnFile = new File(graphOwnPath);
        if (!graphOwnFile.exists()) {
            graphOwnFile.mkdir();
        }

        //Ejecuto el grafo
        String salida = "";
        if (bigo != null) {
            salida = bigo.startCreateGraph(base, sIc, sMin, sLevel, sConfi, sStop, sUniq);
        }
        
        request.getSession().setAttribute("sIcGraph", sIc);
        request.getSession().setAttribute("sMinGraph", sMin);
        request.getSession().setAttribute("sLevelGraph", sLevel);
        request.getSession().setAttribute("sConfiGraph", sConfi);
        request.getSession().setAttribute("sStopGraph", sStop);
        request.getSession().setAttribute("sUniqGraph", sUniq);
        request.getSession().setAttribute("bigoGraphBase", base);
        request.getSession().setAttribute("bigoGraph", bigo);
        request.getSession().setAttribute("salidaWebGraph", salida);
        request.getSession().setAttribute("executeGraph", "true");
        request.getSession().setAttribute("bigoGraphPath", graphOwnPath);
        
        //Checks
        request.getSession().setAttribute("firstGraph", "true");
        
       
        return mapping.findForward(SUCCESS);
    }
}
