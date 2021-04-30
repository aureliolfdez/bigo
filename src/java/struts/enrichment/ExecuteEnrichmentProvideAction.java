/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
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
public class ExecuteEnrichmentProvideAction extends org.apache.struts.action.Action {

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
        
        ExecuteEnrichmentProvideActionForm fileUploadForm = (ExecuteEnrichmentProvideActionForm) form;
        
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = fileUploadForm.getSessionId();
        String filePath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId;
        List<String> datosSelect = (List<String>)request.getSession().getAttribute("datosSelect"); //Paso a sesion la variable bigo para obtener datos
        
        Bigo bigo = executeBigo(filePath, request, fileUploadForm);        
        
        request.getSession().setAttribute("datosSelect", null); //Paso a sesion la variable bigo para obtener datos
        
        
        return mapping.findForward(SUCCESS);
    }

    private Bigo executeBigo(String pathSesion, HttpServletRequest request, ExecuteEnrichmentProvideActionForm fileUploadForm) {
        String applicationPath = request.getServletContext().getRealPath(""); //Para ficheros no subidos
        String contentDisp = "";

        //dataDIR
        String sDataDir = pathSesion + File.separator + "dataDirProvide";

        //outDir
        String sFolder = pathSesion + File.separator + "outDirProvide";

        //Ranking TXT
        String sOutFile = pathSesion + File.separator + "output.txt";

        //Graph DOT
        String sOutFileGraph = pathSesion + File.separator + "output.dot";
        Bigo bigo = new Bigo(sDataDir, sFolder, sOutFile, sOutFileGraph, 9999, 101, 100, 0, 1, 0);
        
        try {
            bigo.startCreateEnrichmentProvide(pathSesion);
        } catch (FileNotFoundException io) {
            System.out.println("Usuario intenta realizar una inyeccion metiendo codigo fuente en ficheros clusters");
            System.out.println(io.getMessage());
        } catch (Exception e) {
            System.out.println("Fallo grave de BIGO");
        }
        return bigo;
    }
}
