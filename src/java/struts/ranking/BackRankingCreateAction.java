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
public class BackRankingCreateAction extends org.apache.struts.action.Action {

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

        // Eliminar output.txt
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String filePath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId;
        File nobase = new File(filePath + File.separator + "output.txt");
        if (nobase.exists()) {
            nobase.delete();
        }
        
        File origen = new File(filePath + File.separator + "output_base.txt");
        File destino = new File(filePath + File.separator + "output.txt");
        //Copiar output_base.txt - output.txt
            try {
                InputStream in = new FileInputStream(origen);
                OutputStream out = new FileOutputStream(destino);

                byte[] buf = new byte[1024];
                int len;

                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
                in.close();
                out.close();
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }

        // Eliminar output_base.txt        
        File base = new File(filePath + File.separator + "output_base.txt");
        if (base.exists()) {
            base.delete();
        }
        
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

        // Eliminar carpeta rankings
        //DATADIR
        String pathRankingDir = filePath + File.separator + "rankings";
        File dirSesion = new File(pathRankingDir);
        File[] list = dirSesion.listFiles();
        //Comprueba si la carpeta dataDir existe
        if (dirSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
            if (dirSesion.listFiles().length == 0) {
                dirSesion.delete();
            } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                for (File f : list) {
                    String nomFichero = f.getName();
                    File fil = new File(pathRankingDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                    fil.delete();
                    File dirData = new File(pathRankingDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                    if (dirData.exists() && dirData.listFiles().length == 0) {
                        dirData.delete();
                    }
                }
            }
        }

        // Aqui indico que la actualizacion del ranking del navegador se anula porque ya no se encuentra en esa ventana.
        request.getSession().setAttribute("listaBigos", null);
        request.getSession().setAttribute("confidenceFactor", null);
        request.getSession().setAttribute("level", null);
        request.getSession().setAttribute("minLevel", null);
        request.getSession().setAttribute("maxIC", null);
        request.getSession().setAttribute("firstRanking", null);
        request.getSession().setAttribute("optionsEnrichment", null);
        request.getSession().setAttribute("enabled_maxIC", null);
        request.getSession().setAttribute("enabled_minLevel", null);
        request.getSession().setAttribute("enabled_level", null);
        request.getSession().setAttribute("enabled_confidence", null);
        request.getSession().setAttribute("prevLevel", null);
        request.getSession().setAttribute("prevIc", null);
        request.getSession().setAttribute("prevConfidence", null);
        request.getSession().setAttribute("prevMinLevel", null);
        request.getSession().setAttribute("stopwordsRanking", null);
        request.getSession().setAttribute("uniquesRanking", null);
        request.getSession().setAttribute("undo", null);
        
        Bigo bigo = (Bigo) request.getSession().getAttribute("bigo");
        int clusters = bigo.getcConjuntoTerminos().size();
        bigo.setLevel(clusters);
        bigo.setMinLevel(0);
        bigo.setMaxIC(9999);
        bigo.setConfidenceFactor(1);
        request.getSession().setAttribute("bigo", bigo);
        return mapping.findForward(SUCCESS);
    }
}
