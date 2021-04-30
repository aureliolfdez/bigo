/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.graph;

import java.io.File;
import java.util.ArrayList;
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
public class ApplyFiltersGraphCreateAction extends org.apache.struts.action.Action {

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

        ApplyFiltersGraphCreateActionForm applyForm = (ApplyFiltersGraphCreateActionForm) form;
        double maxEdge = applyForm.getMaxEdge();
        System.out.println("kkk: "+maxEdge);
        double minEdge = applyForm.getMinEdge();

        String base = (String) request.getSession().getAttribute("bigoGraphBase");
        String graphOwnPath = (String) request.getSession().getAttribute("bigoGraphPath");
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigoGraph");
        String sIc = (String) request.getSession().getAttribute("sIcGraph");
        String sMin = (String) request.getSession().getAttribute("sMinGraph");
        String sLevel = (String) request.getSession().getAttribute("sLevelGraph");
        String sConfi = (String) request.getSession().getAttribute("sConfiGraph");
        String sStop = (String) request.getSession().getAttribute("sStopGraph");
        String sUniq = (String) request.getSession().getAttribute("sUniqGraph");
        String enabled_minEdge = applyForm.getEnable_minEdge();
        String enabled_maxEdge = applyForm.getEnable_maxEdge();
        request.getSession().setAttribute("enable_minEdge", enabled_minEdge);
        request.getSession().setAttribute("enable_maxEdge", enabled_maxEdge);
        
        if (enabled_minEdge != null) { // No esta pulsado. Tiene en cuenta este filtrado.
            bigo.setMinEdge(minEdge);
            bigo.getoGrafo().setMinEdge(minEdge);
            request.getSession().setAttribute("minEdge", minEdge);
        } else { //Esta pulsado. No tiene en cuenta este filtrado por lo que se reinicializa.
            bigo.setMinEdge(0);
            bigo.getoGrafo().setMinEdge(0);
            if(Double.parseDouble(request.getSession().getAttribute("minEdge").toString()) != 0){
                request.getSession().setAttribute("prevMinEdge", request.getSession().getAttribute("minEdge"));
            }
            request.getSession().setAttribute("minEdge", 0);
        }
        
        if (enabled_maxEdge != null) { // No esta pulsado. Tiene en cuenta este filtrado.
            bigo.setMaxEdge(maxEdge);
            bigo.getoGrafo().setMaxEdge(maxEdge);
            request.getSession().setAttribute("maxEdge", maxEdge);
        } else { //Esta pulsado. No tiene en cuenta este filtrado por lo que se reinicializa.
            bigo.setMaxEdge(100);
            bigo.getoGrafo().setMaxEdge(100);
            if(Double.parseDouble(request.getSession().getAttribute("maxEdge").toString()) != 100){
                request.getSession().setAttribute("prevMaxEdge", request.getSession().getAttribute("maxEdge"));
            }
            request.getSession().setAttribute("maxEdge", 100);
        }

        //Ejecuto el grafo
        String salida = bigo.startCreateGraph(base, sIc, sMin, sLevel, sConfi, sStop, sUniq);

        request.getSession().setAttribute("bigoGraphBase", base);
        request.getSession().setAttribute("bigoGraph", bigo);
        request.getSession().setAttribute("salidaWebGraph", salida);
        //request.getSession().setAttribute("firstGraph", "false");

        return mapping.findForward(SUCCESS);
    }
}
