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
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.ServletOutputStream;
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
public class DownloadGraphInfoCreateAction extends org.apache.struts.action.Action {

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
        
        
        Bigo b = (Bigo)request.getSession().getAttribute("bigoGraph");
        String base = (String)request.getSession().getAttribute("bigoGraphBase");
        
        //Generamos el fichero .CSV
        if(base.equals("base")){
            b.getoOutput_base().downloadInfoGraph();
        }else{
            b.getoOutput().downloadInfoGraph();
        }
        
        //Descarga CSV
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String graphsPath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "graphs";
        File dirGraphs = new File(graphsPath);
        //CREATE FILE ZIP
        byte[] buffer = new byte[1024];
        
        
        
        try {
            FileOutputStream fos = new FileOutputStream(graphsPath + File.separator + "graphStats.zip");
            ZipOutputStream zos = new ZipOutputStream(fos);

            if (dirGraphs.exists() && dirGraphs.listFiles().length != 0) {
                File[] list = dirGraphs.listFiles();
                for (File f : list) {
                    String nomFichero = f.getName();
                    if (!nomFichero.equals("graphStats.zip") && (nomFichero.equals("general.csv") || nomFichero.equals("genes.csv") || nomFichero.equals("terms.csv"))) {
                        ZipEntry ze = new ZipEntry(nomFichero);
                        zos.putNextEntry(ze);
                        FileInputStream in = new FileInputStream(dirGraphs + File.separator + nomFichero);
                        int len;
                        while ((len = in.read(buffer)) > 0) {
                            zos.write(buffer, 0, len);
                        }
                        in.close();
                        zos.closeEntry();
                    }
                }
            }

            //remember close it
            zos.close();

        } catch (IOException ex) {
            ex.printStackTrace();
        }      
        
        //DOWNLOAD FILE ZIP
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=graphStats.zip");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(dirGraphs + File.separator + "graphStats.zip"));

            ServletOutputStream out = response.getOutputStream();

            byte[] buf = new byte[1024];
            int n = 0;
            while (-1 != (n = in.read(buf))) {
                out.write(buf, 0, n);
            }
            in.close();
            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        
        
        
        
        
        /*response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment;filename=general.csv");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(graphsPath + File.separator + "general.csv"));

            ServletOutputStream out = response.getOutputStream();

            byte[] buf = new byte[1024];
            int n = 0;
            while (-1 != (n = in.read(buf))) {
                out.write(buf, 0, n);
            }
            in.close();
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment;filename=genes.csv");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(graphsPath + File.separator + "genes.csv"));

            ServletOutputStream out = response.getOutputStream();

            byte[] buf = new byte[1024];
            int n = 0;
            while (-1 != (n = in.read(buf))) {
                out.write(buf, 0, n);
            }
            in.close();
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment;filename=terms.csv");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(graphsPath + File.separator + "terms.csv"));

            ServletOutputStream out = response.getOutputStream();

            byte[] buf = new byte[1024];
            int n = 0;
            while (-1 != (n = in.read(buf))) {
                out.write(buf, 0, n);
            }
            in.close();
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }*/
                
        return mapping.findForward(SUCCESS);
    }
}
