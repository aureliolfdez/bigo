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
 * @author principalpc
 */
public class ApplyFiltersCreateActionForm extends org.apache.struts.action.ActionForm {
    
    private double maxIC, confidenceFactor;
    private int level, minLevel;
    private String enable_maxIC, enable_minLevel, enable_level, enable_confidence;

    public String getEnable_confidence() {
        return enable_confidence;
    }

    public void setEnable_confidence(String enable_confidence) {
        this.enable_confidence = enable_confidence;
    }

    public String getEnable_level() {
        return enable_level;
    }

    public void setEnable_level(String enable_level) {
        this.enable_level = enable_level;
    }

    public String getEnable_minLevel() {
        return enable_minLevel;
    }

    public void setEnable_minLevel(String enable_minLevel) {
        this.enable_minLevel = enable_minLevel;
    }
    
    public String getEnable_maxIC() {
        return enable_maxIC;
    }

    public void setEnable_maxIC(String enable_maxIC) {
        this.enable_maxIC = enable_maxIC;
    }

    public int getMinLevel() {
        return minLevel;
    }

    public void setMinLevel(int minLevel) {
        this.minLevel = minLevel;
    }

    public double getMaxIC() {
        return maxIC;
    }

    public void setMaxIC(double maxIC) {
        this.maxIC = maxIC;
    }

    public double getConfidenceFactor() {
        return confidenceFactor;
    }

    public void setConfidenceFactor(double confidenceFactor) {
        this.confidenceFactor = confidenceFactor;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    /**
     *
     */
    public ApplyFiltersCreateActionForm() {
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
