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
public class ViewGraphCreateActionForm extends org.apache.struts.action.ActionForm {
    
    private double savedIc, savedConfidence;
    private int savedLevel, savedMinLevel, savedStopwords, savedUniques;
    private String base;

    public int getSavedStopwords() {
        return savedStopwords;
    }

    public void setSavedStopwords(int savedStopwords) {
        this.savedStopwords = savedStopwords;
    }

    public int getSavedUniques() {
        return savedUniques;
    }

    public void setSavedUniques(int savedUniques) {
        this.savedUniques = savedUniques;
    }

    public String getBase() {
        return base;
    }

    public void setBase(String base) {
        this.base = base;
    }

    public double getSavedIc() {
        return savedIc;
    }

    public void setSavedIc(double savedIc) {
        this.savedIc = savedIc;
    }

    public double getSavedConfidence() {
        return savedConfidence;
    }

    public void setSavedConfidence(double savedConfidence) {
        this.savedConfidence = savedConfidence;
    }

    public int getSavedLevel() {
        return savedLevel;
    }

    public void setSavedLevel(int savedLevel) {
        this.savedLevel = savedLevel;
    }

    public int getSavedMinLevel() {
        return savedMinLevel;
    }

    public void setSavedMinLevel(int savedMinLevel) {
        this.savedMinLevel = savedMinLevel;
    }
    
    /**
     *
     */
    public ViewGraphCreateActionForm() {
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
