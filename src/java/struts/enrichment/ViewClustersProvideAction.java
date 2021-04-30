/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author principalpc
 */
public class ViewClustersProvideAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";
        private static final String FAILURE = "failure";

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
        ActionForward af = mapping.findForward(SUCCESS);

        ViewClustersProvideActionForm applyForm = (ViewClustersProvideActionForm) form;
        request.getSession().setAttribute("type_resource_provide", applyForm.getType_resource());
        request.getSession().setAttribute("type_character_provide", applyForm.getType_character());
        request.getSession().setAttribute("character_provide", applyForm.getCharacter());
        request.getSession().setAttribute("calculate_enrichment_provide", applyForm.getCalculate_enrichment());
        request.getSession().setAttribute("include_header_provide", applyForm.getInclude_header());

        String applicationPath = request.getServletContext().getRealPath("");
        String pathSesion = applicationPath + File.separator + "WEB-INF" + File.separator + request.getSession().getId();
        String dataDir = pathSesion + File.separator + "outDirProvide";
        File dirData = new File(dataDir); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
        ArrayList<String> nomFicheros = new ArrayList();
        if (dirData.exists() && dirData.listFiles().length != 0) {
            File[] list = dirData.listFiles();
            for (File f : list) {
                String nomFichero = f.getName();
                nomFicheros.add(nomFichero);
            }
        }
        String pathFile = dataDir + File.separator + nomFicheros.get(0);
        
        String character = "";
        if (applyForm.getType_character() != null && applyForm.getType_character().equals("tab")) {
            character = "\t";
        } else if (applyForm.getType_character() != null && applyForm.getType_character().equals("space")) {
            character = " ";
        } else if (applyForm.getType_character() != null && applyForm.getType_character().equals("other") && applyForm.getCharacter() != null) {
            character = applyForm.getCharacter();
        } else {
            System.out.println("Excepcion gorda.");
        }
        String txt = pathFile;
        File fComprobacion = new File(txt);
        int numColumns = 0;
        if (fComprobacion.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(txt));
            String data, dataFinal = "";
            if ((data = br.readLine()) != null) {
                String[] header = data.split(character);
                numColumns = header.length;
            }
        }
        
        if(numColumns > 30){
            request.getSession().setAttribute("failure_columns_provide", 1);
            af = mapping.findForward(FAILURE);
        }else{
            request.getSession().setAttribute("type_character_provide", applyForm.getType_character());
            request.getSession().setAttribute("character_provide", applyForm.getCharacter());
            request.getSession().setAttribute("calculate_enrichment_provide", applyForm.getCalculate_enrichment());
            request.getSession().setAttribute("type_resource_provide", applyForm.getType_resource());
            request.getSession().setAttribute("include_header_provide", applyForm.getInclude_header());
        }
        
        return af;
    }
}
