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
 * @author principalpc
 */
public class ApplyFiltersGraphCreateActionForm extends org.apache.struts.action.ActionForm {
    
    private double minEdge, maxEdge;
    private String enable_minEdge, enable_maxEdge;

    public String getEnable_maxEdge() {
        return enable_maxEdge;
    }

    public void setEnable_maxEdge(String enable_maxEdge) {
        this.enable_maxEdge = enable_maxEdge;
    }

    public String getEnable_minEdge() {
        return enable_minEdge;
    }

    public void setEnable_minEdge(String enable_minEdge) {
        this.enable_minEdge = enable_minEdge;
    }

    public double getMinEdge() {
        return minEdge;
    }

    public void setMinEdge(double minEdge) {
        this.minEdge = minEdge;
    }

    public double getMaxEdge() {
        return maxEdge;
    }

    public void setMaxEdge(double maxEdge) {
        this.maxEdge = maxEdge;
    } 

    /**
     *
     */
    public ApplyFiltersGraphCreateActionForm() {
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
