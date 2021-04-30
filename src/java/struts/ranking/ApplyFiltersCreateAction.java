/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import java.io.File;
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
public class ApplyFiltersCreateAction extends org.apache.struts.action.Action {

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
        //reeditar el output.txt (filtrado)
        //en base al IC actual eliminar aquellos terminos que tengan un IC superior y todo lo demás volverlo a cargar al fichero

        ApplyFiltersCreateActionForm applyForm = (ApplyFiltersCreateActionForm) form;
        int level = applyForm.getLevel();
        int minLevel = applyForm.getMinLevel();
        double maxIC = applyForm.getMaxIC();
        double confidenceFactor = applyForm.getConfidenceFactor();
        String enabled_maxIC = applyForm.getEnable_maxIC();
        String enabled_minLevel = applyForm.getEnable_minLevel();
        String enabled_level = applyForm.getEnable_level();
        String enabled_confidence = applyForm.getEnable_confidence();
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
        request.getSession().setAttribute("enabled_maxIC", enabled_maxIC);
        request.getSession().setAttribute("enabled_minLevel", enabled_minLevel);
        request.getSession().setAttribute("enabled_level", enabled_level);
        request.getSession().setAttribute("enabled_confidence", enabled_confidence);

        if (enabled_maxIC != null) { // No esta pulsado. Tiene en cuenta este filtrado.
            bigo.setMaxIC(maxIC);
            request.getSession().setAttribute("maxIC", level);
        } else { //Esta pulsado. No tiene en cuenta este filtrado por lo que se reinicializa.            
            bigo.setMaxIC(9999);
            if (Double.parseDouble(request.getSession().getAttribute("maxIC").toString()) != 9999) {
                request.getSession().setAttribute("prevIc", request.getSession().getAttribute("maxIC"));
            }
            request.getSession().setAttribute("maxIC", 9999);
        }

        if (enabled_minLevel != null) { // No esta pulsado. Tiene en cuenta este filtrado.
            bigo.setMinLevel(minLevel);
            request.getSession().setAttribute("minLevel", level);
        } else { //Esta pulsado. No tiene en cuenta este filtrado por lo que se reinicializa.
            bigo.setMinLevel(0);
            if (Integer.parseInt(request.getSession().getAttribute("minLevel").toString()) != 0) {
                request.getSession().setAttribute("prevMinLevel", request.getSession().getAttribute("minLevel"));
            }
            request.getSession().setAttribute("minLevel", 0);
        }

        if (enabled_level != null) { // No esta pulsado. Tiene en cuenta este filtrado.
            bigo.setLevel(level);
            request.getSession().setAttribute("level", level);
        } else { //Esta pulsado. No tiene en cuenta este filtrado por lo que se reinicializa.
            bigo.setLevel(101);
            if (Integer.parseInt(request.getSession().getAttribute("level").toString()) != 101) {
                request.getSession().setAttribute("prevLevel", request.getSession().getAttribute("level"));
            }
            request.getSession().setAttribute("level", 101);
        }

        if (enabled_confidence != null) { // No esta pulsado. Tiene en cuenta este filtrado.
            bigo.setConfidenceFactor(confidenceFactor);
            request.getSession().setAttribute("confidenceFactor", confidenceFactor);
        } else { //Esta pulsado. No tiene en cuenta este filtrado por lo que se reinicializa.
            bigo.setConfidenceFactor(1);
            if (Double.parseDouble(request.getSession().getAttribute("confidenceFactor").toString()) != 1) {
                request.getSession().setAttribute("prevConfidence", request.getSession().getAttribute("confidenceFactor"));
            }
            request.getSession().setAttribute("confidenceFactor", 1);
        }

        bigo.startCreateRanking("nobase", true);
        request.getSession().setAttribute("bigo", bigo);

        return mapping.findForward(SUCCESS);
    }
}
