/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.graph;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author aureliolfdez
 */
public class ExecuteGraphCreateAction extends org.apache.struts.action.Action {

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
        
        //COMPRUEBO SI EL RANKING BASE ESTA GUARDADO EN LA CARPETA RANKINGS. SI NO ESTA, LO GUARDO.
        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        String pathRankings = pathSesion + File.separator + "rankings";
        
        //Comprueba si la carpeta rankings existe
        File rankingFolder = new File(pathRankings);
        if (!rankingFolder.exists()) {
            rankingFolder.mkdir();
        }
        
        String pathFileBase = pathSesion + File.separator + "output_base.txt";
        String pathFileBaseDest = pathRankings + File.separator + "output_base.txt";
        
        File origen = new File(pathFileBase);
        File destino = new File(pathFileBaseDest);

        if (!destino.exists()) {
            //Copiar output_base.txt dentro de los rankings guardados
            Files.copy(origen.toPath(),destino.toPath());
        }
        
        return mapping.findForward(SUCCESS);
    }
}
