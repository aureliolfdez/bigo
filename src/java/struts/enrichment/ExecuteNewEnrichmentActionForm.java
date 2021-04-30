/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

import java.io.File;
import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.upload.FormFile;

/**
 *
 * @author principalpc
 */
public class ExecuteNewEnrichmentActionForm extends org.apache.struts.action.ActionForm {

    private String annoFile, oboFile, populationFile, mtcMethod, calculationMethod, sConversion, type_character, sSeparator, sessionId;
    private FormFile annoFile_file, oboFile_file, popFile, sGenesCsv;

    public String getPopulationFile() {
        return populationFile;
    }

    public void setPopulationFile(String populationFile) {
        this.populationFile = populationFile;
    }
   
    public String getAnnoFile() {
        return annoFile;
    }

    public void setAnnoFile(String annoFile) {
        this.annoFile = annoFile;
    }

    public String getOboFile() {
        return oboFile;
    }

    public void setOboFile(String oboFile) {
        this.oboFile = oboFile;
    }

    public String getMtcMethod() {
        return mtcMethod;
    }

    public void setMtcMethod(String mtcMethod) {
        this.mtcMethod = mtcMethod;
    }

    public String getCalculationMethod() {
        return calculationMethod;
    }

    public void setCalculationMethod(String calculationMethod) {
        this.calculationMethod = calculationMethod;
    }

    public String getsConversion() {
        return sConversion;
    }

    public void setsConversion(String sConversion) {
        this.sConversion = sConversion;
    }

    public String getType_character() {
        return type_character;
    }

    public void setType_character(String type_character) {
        this.type_character = type_character;
    }

    public String getsSeparator() {
        return sSeparator;
    }

    public void setsSeparator(String sSeparator) {
        this.sSeparator = sSeparator;
    }

    public FormFile getAnnoFile_file() {
        return annoFile_file;
    }

    public void setAnnoFile_file(FormFile annoFile_file) {
        this.annoFile_file = annoFile_file;
    }

    public FormFile getOboFile_file() {
        return oboFile_file;
    }

    public void setOboFile_file(FormFile oboFile_file) {
        this.oboFile_file = oboFile_file;
    }

    public FormFile getPopFile() {
        return popFile;
    }

    public void setPopFile(FormFile popFile) {
        this.popFile = popFile;
    }

    public FormFile getsGenesCsv() {
        return sGenesCsv;
    }

    public void setsGenesCsv(FormFile sGenesCsv) {
        this.sGenesCsv = sGenesCsv;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    
    public ExecuteNewEnrichmentActionForm() {
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
        //Limite en 4 GB
        long limite = 4294967296L;
        
        if (getAnnoFile() != null && getAnnoFile().equals("own_file") && getAnnoFile_file().getFileSize() == 0) {
            errors.add("annotations", new ActionMessage("checkEnrichment.error.annotations.required"));
        }
        
        if (getAnnoFile() != null && getAnnoFile().equals("own_file") && getAnnoFile_file().getFileSize() > limite) {
            errors.add("annotations", new ActionMessage("checkEnrichment.error.annotations.limit"));
        }
                
        if (getOboFile() != null && getOboFile().equals("own_file") && getOboFile_file().getFileSize() == 0) {
            errors.add("ontology", new ActionMessage("checkEnrichment.error.ontology.required"));
        }
        
        if (getOboFile() != null && getOboFile().equals("own_file") && getOboFile_file().getFileSize() > limite) {
            errors.add("ontology", new ActionMessage("checkEnrichment.error.ontology.limit"));
        }
        
        if (getPopFile() != null && getPopFile().getFileSize() == 0) {
            errors.add("popfile", new ActionMessage("checkEnrichment.error.popfile.required"));
        }
        
        if (getPopFile() != null && getPopFile().getFileSize() > limite) {
            errors.add("popfile", new ActionMessage("checkEnrichment.error.popfile.limit"));
        }
        
        if (getsConversion() != null && getsConversion().equals("y") && getsGenesCsv().getFileSize() == 0) {
            errors.add("conversion", new ActionMessage("checkEnrichment.error.conversion.required"));
        }
        
        if (getsConversion() != null && getsConversion().equals("y") && getsGenesCsv().getFileSize() > limite) {
            errors.add("conversion", new ActionMessage("checkEnrichment.error.conversion.limit"));
        }
        
        if(getType_character().equals("other") && getsSeparator() == null){
            errors.add("characternewenrich", new ActionMessage("checkEnrichment.error.characternewenrich.required"));
        }

        return errors;
    }
}
