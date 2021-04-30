/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.graph;

import java.io.File;
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
public class BackGraphCreateAction extends org.apache.struts.action.Action {

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

        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String filePath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "rankings";

        // Eliminar output ranking
        File ranking_base = new File(filePath + File.separator + "output_base.txt");
        if (ranking_base.exists()) {
            ranking_base.delete();
        }

        //Eliminar carpeta rankings si esta vacia
        File dirRanking = new File(filePath);
        File[] list = dirRanking.listFiles();
        if (dirRanking.exists() && dirRanking.listFiles().length == 0) {
            dirRanking.delete();
        }

        //Eliminar carpeta graphs
        String graphPath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "graphs";
        File dirGraphs = new File(graphPath);
        File[] listGraphs = dirGraphs.listFiles();
        if (dirGraphs.exists() && dirGraphs.listFiles().length != 0) {
            for (File f : listGraphs) {
                String nomFichero = f.getName();
                File fil = new File(graphPath + File.separator + nomFichero); // Elimina el fichero seleccionado
                fil.delete();
                File dirData = new File(graphPath); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                if (dirData.exists() && dirData.listFiles().length == 0) {
                    dirData.delete();
                }
            }
        }

        String[] listGra = dirGraphs.list();
        if (listGra != null) {
            for (String s : listGra) {
                File f = new File(applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "graphs" + File.separator + s);
                File[] listf = f.listFiles();
                if (f.listFiles().length != 0) {
                    for (File f3 : listf) {
                        f3.delete();
                        if (f.exists() && f.listFiles().length == 0) {
                            f.delete();
                        }
                    }
                } else {
                    f.delete();
                }

            }
        }

        if (dirGraphs.exists() && dirGraphs.listFiles().length == 0) {
            dirGraphs.delete();
        }

        request.getSession().setAttribute("executeGraph", null);
        request.getSession().setAttribute("bigoGraphBase", null);
        request.getSession().setAttribute("bigoGraph", null);
        request.getSession().setAttribute("salidaWebGraph", null);
        request.getSession().setAttribute("sIcGraph", null);
        request.getSession().setAttribute("sMinGraph", null);
        request.getSession().setAttribute("sLevelGraph", null);
        request.getSession().setAttribute("sConfiGraph", null);
        request.getSession().setAttribute("bigoGraphBase", null);
        request.getSession().setAttribute("maxEdge", null);
        request.getSession().setAttribute("minEdge", null);
        request.getSession().setAttribute("enable_minEdge", null);
        request.getSession().setAttribute("firstGraph", null);
        request.getSession().setAttribute("prevMinEdge", null);
        request.getSession().setAttribute("minEdge", 0);
        request.getSession().setAttribute("prevMaxEdge", null);
        request.getSession().setAttribute("maxEdge", 100);
        
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
        bigo.setMinEdge(0);
        bigo.setMaxEdge(100);
        request.getSession().setAttribute("bigo", bigo);
        return mapping.findForward(SUCCESS);
    }
}
