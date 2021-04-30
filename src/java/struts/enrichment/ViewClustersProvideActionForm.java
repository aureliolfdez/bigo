/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

/**
 *
 * @author principalpc
 */
public class ViewClustersProvideActionForm extends org.apache.struts.action.ActionForm {
    
    private String type_character, character, calculate_enrichment, type_resource, include_header;

    public String getType_character() {
        return type_character;
    }

    public void setType_character(String type_character) {
        this.type_character = type_character;
    }

    public String getCharacter() {
        return character;
    }

    public void setCharacter(String character) {
        this.character = character;
    }

    public String getCalculate_enrichment() {
        return calculate_enrichment;
    }

    public void setCalculate_enrichment(String calculate_enrichment) {
        this.calculate_enrichment = calculate_enrichment;
    }

    public String getType_resource() {
        return type_resource;
    }

    public void setType_resource(String type_resource) {
        this.type_resource = type_resource;
    }

    public String getInclude_header() {
        return include_header;
    }

    public void setInclude_header(String include_header) {
        this.include_header = include_header;
    }
    
    public ViewClustersProvideActionForm() {
        super();
    }

    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        if ((getType_character() != null && getType_character().equals("other")) && (getCharacter() == null || getCharacter().length() < 1)) {
            errors.add("character", new ActionMessage("checkEnrichment.error.character.required"));
        }
        return errors;
    }
}
