/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
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
public class ExecuteRankingCreateAction extends org.apache.struts.action.Action {

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
        String filePath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId;
        File origen = new File(filePath + File.separator + "output.txt");
        File destino = new File(filePath + File.separator + "output_base.txt");
        Boolean bExecute = false;
        if (request.getSession().getAttribute("executeRanking") != null) {
            bExecute = (Boolean) request.getSession().getAttribute("executeRanking");
        }
        if (!destino.exists()) {
            //Ejecutar Ranking sin filtrado
            Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
            bigo.startCreateRanking("base", bExecute);
            request.getSession().setAttribute("bigo", bigo);

            //Copiar output.txt - output_base.txt
            Files.copy(origen.toPath(),destino.toPath());
            
            //Esta sesion es por si el usuario pulsa el boton actualizar del navegador no se vuelva a ejecutar
            request.getSession().setAttribute("executeRanking", true);
            //Esta sesion es para que en el primer ranking no aparezcan ni verdes ni rojos.
            request.getSession().setAttribute("firstRanking", "true");
            
            Bigo bigoBaseClone = bigo.clone();
            request.getSession().setAttribute("bigo_base", bigoBaseClone);
        }

        return mapping.findForward(SUCCESS);
    }
}
