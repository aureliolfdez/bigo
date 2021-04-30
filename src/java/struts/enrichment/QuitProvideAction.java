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
 * @author principalpc
 */
public class QuitProvideAction extends org.apache.struts.action.Action {

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
        request.getSession().setAttribute("executeEnrichment", null);
        int contfile = ((QuitProvideActionForm) form).getContfile();
        if (contfile > 0) {
            String sessionId = ((QuitProvideActionForm) form).getSessionId();
            String applicationPath = request.getServletContext().getRealPath("");
            String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + sessionId;

            //DATADIR
            String pathDataDir = pathSesion + File.separator + "dataDir";
            File dirSesion = new File(pathDataDir);
            File[] list = dirSesion.listFiles();
            //Comprueba si la carpeta dataDir existe
            if (dirSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                if (dirSesion.listFiles().length == 0) {
                    dirSesion.delete();
                } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                    for (File f : list) {
                        String nomFichero = f.getName();
                        File fil = new File(pathDataDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                        fil.delete();
                        File dirData = new File(pathDataDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                        if (dirData.exists() && dirData.listFiles().length == 0) {
                            dirData.delete();
                        }
                    }
                }
            }
            
            //DATADIRPROVIDE
            String pathDataDirProvide = pathSesion + File.separator + "outDirProvide";
            File dirSesionProvide = new File(pathDataDirProvide);
            File[] listProvide = dirSesionProvide.listFiles();
            //Comprueba si la carpeta dataDir existe
            if (dirSesionProvide.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                if (dirSesionProvide.listFiles().length == 0) {
                    dirSesionProvide.delete();
                } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                    for (File f : listProvide) {
                        String nomFichero = f.getName();
                        File fil = new File(pathDataDirProvide + File.separator + nomFichero); // Elimina el fichero seleccionado
                        fil.delete();
                        File dirData = new File(pathDataDirProvide); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                        if (dirData.exists() && dirData.listFiles().length == 0) {
                            dirData.delete();
                        }
                    }
                }
            }
            
            //OUTDIR
            String pathoutDir = pathSesion + File.separator + "outDir";
            File outSesion = new File(pathoutDir);
            File[] listOut = outSesion.listFiles();
            //Comprueba si la carpeta outDir existe
            if (outSesion.exists()) { // Si la carpeta dataDir esta vacia y la elimina
                if (outSesion.listFiles().length == 0) {
                    outSesion.delete();
                } else { // Si la carpeta no esta vacia elimina ficheros y carpeta
                    for (File f : listOut) {
                        String nomFichero = f.getName();
                        File fil = new File(pathoutDir + File.separator + nomFichero); // Elimina el fichero seleccionado
                        fil.delete();
                        File dirData = new File(pathoutDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                        if (dirData.exists() && dirData.listFiles().length == 0) {
                            dirData.delete();
                        }
                    }
                }
            }
            
            //Elimina el resto de ficheros y elimina carpeta de sesion
            File filepathSesion = new File(pathSesion);
            File[] listSesion = filepathSesion.listFiles();
            //Comprueba si la carpeta de sesion existe
            if(filepathSesion.exists()){
                if(filepathSesion.listFiles().length == 0){
                    filepathSesion.delete();
                }else{
                    for (File f: listSesion){
                        String nomFichero = f.getName();
                        File fil = new File(pathSesion + File.separator + nomFichero); // Elimina el fichero seleccionado
                        fil.delete();
                        File dirData = new File(pathSesion); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                        if (dirData.exists() && dirData.listFiles().length == 0) {
                            dirData.delete();
                        }
                    }
                }
            }
        }

        return mapping.findForward(SUCCESS);
    }
}
