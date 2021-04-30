/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.graph;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.tomcat.util.codec.binary.Base64;

/**
 *
 * @author aureliolfdez
 */
public class DownloadGraphNoFilteredCreateAction extends org.apache.struts.action.Action {

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

        DownloadGraphNoFilteredCreateActionForm applyForm = (DownloadGraphNoFilteredCreateActionForm)form;
        
        String contentpng = applyForm.getContentpng();
        String contentsvg = applyForm.getContentsvg();
        String type = applyForm.getType();        
        String bigoGraphPath = (String)request.getSession().getAttribute("bigoGraphPath");
        
        //Generacion de imagen del grafo
        OutputStream o = new FileOutputStream(bigoGraphPath + File.separator + "network." + type);
        byte nerStr[];
        if(type.equals("png")){
            response.setContentType("image/png");
             nerStr = Base64.decodeBase64(contentpng);
        }else{
            response.setContentType("image/svg+xml");
            nerStr = contentsvg.getBytes();
        }        
        o.write(nerStr);
        
        response.setHeader("Content-Disposition", "attachment;filename=network."+type);

        try {
            //Get it from file system
            FileInputStream in = new FileInputStream(new File(bigoGraphPath + File.separator + "network."+type));
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
