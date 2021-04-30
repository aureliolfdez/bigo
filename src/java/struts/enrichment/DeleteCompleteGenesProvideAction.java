/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

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
public class DeleteCompleteGenesProvideAction extends org.apache.struts.action.Action {

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
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId + File.separator + "dataDirProvide";
        File pathSesionDir = new File(pathSesion);
        
        if(pathSesionDir.exists()){
            String pathFileCompleteGenes = pathSesion + File.separator + "genesComplete.txt";
            File fileCompleteGenes = new File(pathFileCompleteGenes);
            if(fileCompleteGenes.exists()){
                fileCompleteGenes.delete();
            }
            pathSesionDir.delete();
        }
        
        request.getSession().setAttribute("uploadedGenesTotalProvide", null);
        
        return mapping.findForward(SUCCESS);
    }
}
