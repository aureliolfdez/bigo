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
public class ExecuteComparativeRankingCreateActionForm extends org.apache.struts.action.ActionForm {
    
    private String select_cluster1, select_cluster2;
    int clusters;

    public int getClusters() {
        return clusters;
    }

    public void setClusters(int clusters) {
        this.clusters = clusters;
    }

    public String getSelect_cluster1() {
        return select_cluster1;
    }

    public void setSelect_cluster1(String select_cluster1) {
        this.select_cluster1 = select_cluster1;
    }

    public String getSelect_cluster2() {
        return select_cluster2;
    }

    public void setSelect_cluster2(String select_cluster2) {
        this.select_cluster2 = select_cluster2;
    }
    
    /**
     *
     */
    public ExecuteComparativeRankingCreateActionForm() {
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
