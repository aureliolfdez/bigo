/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

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

/**
 *
 * @author principalpc
 */
public class DownloadEnrichmentCreateAction extends org.apache.struts.action.Action {

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

        //CREATE FILE ZIP
        byte[] buffer = new byte[1024];
        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId;
        String sOutDir = pathSesion + File.separator + "outDir";
        File dirOut = new File(sOutDir);

        try {

            FileOutputStream fos = new FileOutputStream(sOutDir + File.separator + "enrichmentFiles.zip");
            ZipOutputStream zos = new ZipOutputStream(fos);

            if (dirOut.exists() && dirOut.listFiles().length != 0) {
                File[] list = dirOut.listFiles();
                for (File f : list) {
                    String nomFichero = f.getName();
                    if (nomFichero.contains("table")) {
                        ZipEntry ze = new ZipEntry(nomFichero);
                        zos.putNextEntry(ze);
                        FileInputStream in = new FileInputStream(sOutDir + File.separator + nomFichero);
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

            System.out.println("Done");

        } catch (IOException ex) {
            ex.printStackTrace();
        }

        //DOWNLOAD FILE ZIP
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment;filename=enrichmentFiles.zip");

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(sOutDir + File.separator + "enrichmentFiles.zip"));

            //Get it from web path
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

        return mapping.findForward(SUCCESS);
    }
}
