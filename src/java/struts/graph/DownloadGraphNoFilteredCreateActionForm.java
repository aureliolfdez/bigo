/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.graph;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

/**
 *
 * @author aureliolfdez
 */
public class DownloadGraphNoFilteredCreateActionForm extends org.apache.struts.action.ActionForm {

    private String contentpng, contentsvg, type;

    public String getContentpng() {
        return contentpng;
    }

    public void setContentpng(String contentpng) {
        this.contentpng = contentpng;
    }

    public String getContentsvg() {
        return contentsvg;
    }

    public void setContentsvg(String contentsvg) {
        this.contentsvg = contentsvg;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
    
    /**
     *
     */
    public DownloadGraphNoFilteredCreateActionForm() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * This is the action called from the Struts framework.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param request The HTTP Request we are processing.
     * @return
     */
    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        return errors;
    }
}
