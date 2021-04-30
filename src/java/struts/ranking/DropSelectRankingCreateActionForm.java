/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

/**
 *
 * @author aureliolfdez
 */
public class DropSelectRankingCreateActionForm extends org.apache.struts.action.ActionForm {
    
    private String[] gosdelete;

    public String[] getGosdelete() {
        return gosdelete;
    }

    public void setGosdelete(String[] gosdelete) {
        this.gosdelete = gosdelete;
    }
    
    /**
     *
     */
    public DropSelectRankingCreateActionForm() {
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
