/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.ranking;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author principalpc
 */
public class ExecuteComparativeRankingCreateAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";

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

        ExecuteComparativeRankingCreateActionForm applyForm = (ExecuteComparativeRankingCreateActionForm) form;
        String cluster1 = applyForm.getSelect_cluster1();
        String cluster2 = applyForm.getSelect_cluster2();
        String private_files = "WEB-INF";
        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = request.getSession().getId();
        String pathSesion = applicationPath + File.separator + private_files + File.separator + sesionId + File.separator + "rankings";

        int clusters = applyForm.getClusters();

        // Cluster 1
        int numGoTermsFiltrado_cluster1 = 0, stopwords_cluster1 = 0, unique_cluster1 = 0;

        String pathCluster1 = pathSesion + File.separator + cluster1;
        int limit_ic_cluster1 = cluster1.indexOf("-", 7);
        int limit_minlevel_cluster1 = cluster1.indexOf("-", limit_ic_cluster1 + 1);
        int limit_maxlevel_cluster1 = cluster1.indexOf("-", limit_minlevel_cluster1 + 1);
        int limit_confidence_cluster1 = cluster1.indexOf("-", limit_maxlevel_cluster1 + 1);
        int limit_stopwords_cluster1 = cluster1.indexOf("-", limit_confidence_cluster1 + 1);
        String ic_cluster1 = cluster1.substring(7, limit_ic_cluster1);
        String minlevel_cluster1 = cluster1.substring(limit_ic_cluster1 + 1, limit_minlevel_cluster1);
        String maxlevel_cluster1 = cluster1.substring(limit_minlevel_cluster1 + 1, limit_maxlevel_cluster1);
        String confidence_cluster1 = cluster1.substring(limit_maxlevel_cluster1 + 1, limit_confidence_cluster1).replace("_", ".");
        String stopwords_s_cluster1 = cluster1.substring(limit_confidence_cluster1 + 1, limit_stopwords_cluster1);
        String uniques_s_cluster1 = cluster1.substring(limit_stopwords_cluster1 + 1, cluster1.length() - 4);

        int levelUser_cluster1 = 101;
        if (!maxlevel_cluster1.equals("no")) {
            levelUser_cluster1 = Integer.parseInt(maxlevel_cluster1);
        }
        int minLevelUser_cluster1 = 0;
        if (!minlevel_cluster1.equals("no")) {
            minLevelUser_cluster1 = Integer.parseInt(minlevel_cluster1);
        }

        File fComprobacionFiltrado = new File(pathSesion + File.separator + cluster1);
        if (fComprobacionFiltrado.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(pathSesion + File.separator + cluster1));
            String data;
            br.readLine();
            br.readLine();
            br.readLine();
            //Body file
            while ((data = br.readLine()) != null) {
                String[] body = data.split(";");
                if (body.length == 6) {
                    //int numClusterRow = Integer.parseInt(body[4].substring(0, body[4].indexOf("/")));
                    String sCluster = body[4].substring(body[4].indexOf("(") + 1, body[4].length() - 2).replace(",", ".");
                    double numClusterRow = Double.parseDouble(sCluster);
                    boolean bStopword = levelUser_cluster1 <= numClusterRow;
                    boolean bUnique = minLevelUser_cluster1 >= numClusterRow;
                    if (bStopword) {
                        stopwords_cluster1++;
                    }
                    if (bUnique) {
                        unique_cluster1++;
                    }
                    numGoTermsFiltrado_cluster1++;
                }
            }
            br.close();
        }

//Datos del cluster 2
        int numGoTermsFiltrado_cluster2 = 0, stopwords_cluster2 = 0, unique_cluster2 = 0;
        String pathCluster2 = pathSesion + File.separator + cluster2;
        int limit_ic_cluster2 = cluster2.indexOf("-", 7);
        int limit_minlevel_cluster2 = cluster2.indexOf("-", limit_ic_cluster2 + 1);
        int limit_maxlevel_cluster2 = cluster2.indexOf("-", limit_minlevel_cluster2 + 1);
        int limit_confidence_cluster2 = cluster2.indexOf("-", limit_maxlevel_cluster2 + 1);
        int limit_stopwords_cluster2 = cluster2.indexOf("-", limit_confidence_cluster2 + 1);
        String ic_cluster2 = cluster2.substring(7, limit_ic_cluster2);
        String minlevel_cluster2 = cluster2.substring(limit_ic_cluster2 + 1, limit_minlevel_cluster2);
        String maxlevel_cluster2 = cluster2.substring(limit_minlevel_cluster2 + 1, limit_maxlevel_cluster2);
        String confidence_cluster2 = cluster2.substring(limit_maxlevel_cluster2 + 1, limit_confidence_cluster2).replace("_", ".");
        String stopwords_s_cluster2 = cluster2.substring(limit_confidence_cluster2 + 1, limit_stopwords_cluster2);
        String uniques_s_cluster2 = cluster2.substring(limit_stopwords_cluster2 + 1, cluster2.length() - 4);

        int levelUser_cluster2 = 101;
        if (!maxlevel_cluster2.equals("no")) {
            levelUser_cluster2 = Integer.parseInt(maxlevel_cluster2);
        }
        int minLevelUser_cluster2 = 0;
        if (!minlevel_cluster2.equals("no")) {
            minLevelUser_cluster2 = Integer.parseInt(minlevel_cluster2);
        }

        fComprobacionFiltrado = new File(pathSesion + File.separator + cluster2);
        if (fComprobacionFiltrado.exists()) {
            BufferedReader br = new BufferedReader(new FileReader(pathSesion + File.separator + cluster2));
            String data;
            br.readLine();
            br.readLine();
            br.readLine();
            //Body file
            while ((data = br.readLine()) != null) {
                String[] body = data.split(";");
                if (body.length == 6) {
                    //int numClusterRow = Integer.parseInt(body[4].substring(0, body[4].indexOf("/")));
                    String sCluster = body[4].substring(body[4].indexOf("(") + 1, body[4].length() - 2).replace(",", ".");
                    double numClusterRow = Double.parseDouble(sCluster);
                    boolean bStopword = levelUser_cluster2 <= numClusterRow;
                    boolean bUnique = minLevelUser_cluster2 >= numClusterRow;
                    if (bStopword) {
                        stopwords_cluster2++;
                    }
                    if (bUnique) {
                        unique_cluster2++;
                    }
                    numGoTermsFiltrado_cluster2++;
                }
            }
            br.close();
        }

        //Pasamos los datos por sesiones
        request.getSession().setAttribute("executeComparative", "true"); //Sesion para que aparezca/desaparezca review
        request.getSession().setAttribute("numGoTermsFiltrado_cluster1", numGoTermsFiltrado_cluster1);
        request.getSession().setAttribute("stopwords_cluster1", stopwords_cluster1);
        request.getSession().setAttribute("unique_cluster1", unique_cluster1);
        request.getSession().setAttribute("confidence_cluster1", confidence_cluster1);
        request.getSession().setAttribute("ic_cluster1", ic_cluster1);
        request.getSession().setAttribute("minLevelUser_cluster1", minLevelUser_cluster1);
        request.getSession().setAttribute("levelUser_cluster1", levelUser_cluster1);
        request.getSession().setAttribute("cluster1", cluster1);

        request.getSession().setAttribute("numGoTermsFiltrado_cluster2", numGoTermsFiltrado_cluster2);
        request.getSession().setAttribute("stopwords_cluster2", stopwords_cluster2);
        request.getSession().setAttribute("unique_cluster2", unique_cluster2);
        request.getSession().setAttribute("confidence_cluster2", confidence_cluster2);
        request.getSession().setAttribute("ic_cluster2", ic_cluster2);
        request.getSession().setAttribute("minLevelUser_cluster2", minLevelUser_cluster2);
        request.getSession().setAttribute("levelUser_cluster2", levelUser_cluster2);
        request.getSession().setAttribute("cluster2", cluster2);

        request.getSession().setAttribute("executeComparativeRanking", null); // Si le das a COMPARE se quitara de mostrar el ranking.

        return mapping.findForward(SUCCESS);
    }
}
