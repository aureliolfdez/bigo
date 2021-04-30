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
public class ViewSavedRankingActionForm extends org.apache.struts.action.ActionForm {
    
    private double savedIc, savedConfidence;
    private int savedLevel, savedMinLevel, savedStopwords, savedUniques;

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

    public int getSavedMinLevel() {
        return savedMinLevel;
    }

    public void setSavedMinLevel(int savedMinLevel) {
        this.savedMinLevel = savedMinLevel;
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

    public ViewSavedRankingActionForm() {
        super();
    }

    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        return errors;
    }
}
