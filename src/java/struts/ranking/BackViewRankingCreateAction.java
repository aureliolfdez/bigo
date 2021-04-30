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

/**
 *
 * @author aureliolfdez
 */
public class BackViewRankingCreateAction extends org.apache.struts.action.Action {

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

        // Eliminar stopwords.txt
        File stopwords = new File(filePath + File.separator + "stopwords.txt");
        if (stopwords.exists()) {
            stopwords.delete();
        }

        // Eliminar uniques.txt        
        File uniques = new File(filePath + File.separator + "uniques.txt");
        if (uniques.exists()) {
            uniques.delete();
        }
        
        request.getSession().setAttribute("savedIc",null);
        request.getSession().setAttribute("savedConfidence",null);
        request.getSession().setAttribute("savedLevel",null);
        request.getSession().setAttribute("savedMinLevel",null);
        
        return mapping.findForward(SUCCESS);
    }
}
