/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author principalpc
 */
public class SelectGenesProvideAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String NOGENES = "noGenes";
    private static final String WITHGENES = "withGenes";
    private static final String PRIVATE_FILES = "WEB-INF";

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

        SelectGenesProvideActionForm applyForm = (SelectGenesProvideActionForm) form;
        ActionForward fa = mapping.findForward(NOGENES);
        //Obtenemos datos de los select
        List<String> datosSelect = obtenerSelect(applyForm);
        int numColumns = applyForm.getNumColumns();
        int numColumListaGenes = 0; //Variable para captar la columna donde se ha indicado que corresponde a la lista de genes
        boolean bNulo = false;
        for (int i = 0; i < datosSelect.size() && !bNulo; i++) {
            if (datosSelect.get(i) == null) {
                bNulo = true;
            } else if (datosSelect.get(i).equals("genesList")) {
                fa = mapping.findForward(WITHGENES);
                numColumListaGenes = i;
            }
        }

        if (fa == mapping.findForward(NOGENES)) {
            //Si el fichero de enriquecimiento no tiene lista de genes, SOLICITAMOS FICHEROS DE GENES. Dejamos en blanco.
            request.getSession().setAttribute("datosSelect", datosSelect); //Paso a sesion la variable bigo para obtener datos
        } else {
            //Si el fichero de enriquecimiento tiene lista de genes, EJECUTAMOS BIGO aqui ponemos la codificacion nueva.
            
            //Pillo algunas variables de sesion, como rutas y demás
            HttpSession session = request.getSession();
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = session.getId();
            String pathProvide = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "outDirProvide";
            String separador = (String) session.getAttribute("separador");
            //En pathProvide tengo la ruta completa donde se encuentran todos los archios de enriquecimiento subidos anteriormente
            File folder = new File(pathProvide);
            File[] listOfFiles = folder.listFiles();
            boolean cabecera = true;//Para comprobar si los ficheros incluyen cabecera o no
            if (session.getAttribute("include_header_provide") != null && session.getAttribute("include_header_provide").equals("no")) {
                cabecera = false;
            }
            for (File file : listOfFiles) {//Recorremos todos los archivos para ir obteniendo la lista de genes de cada uno de ellos
                if (file.isFile()) {
                    //Recorremos cada fichero
                    obtenerGenes(file, numColumListaGenes, separador, pathProvide, cabecera);
                }
            }
            request.getSession().setAttribute("datosSelect", datosSelect); //Paso a sesion la variable bigo para obtener datos
        }

        return fa;
    }

    private void obtenerGenes(File fileEnri, int columnaGenes, String separador, String ruta, boolean cabecera) throws FileNotFoundException, IOException {
        BufferedReader br = new BufferedReader(new FileReader(fileEnri.getAbsolutePath()));

        String data = "";
        Set<String> conjuntoGenes = new HashSet();
        Set<String> conjuntoGenesSeparados = new HashSet();
        String[] genes;
        String genesJuntos, separadorGenes = null;
        char caracter;
        boolean haySeparador = false;

        if (cabecera) {//Si el fichero incluye cabecera
            data = br.readLine();//De esta forma omitimos la cabecera 
        }
        //Body file
        while ((data = br.readLine()) != null) {
            String[] body = data.split(separador);
            conjuntoGenes.add(body[columnaGenes]);
        }

        Iterator it = conjuntoGenes.iterator();
        while (it.hasNext()) {
            genesJuntos = it.next().toString();
            if (!haySeparador) {//La comprobacion de separador de genes lo haremos tantas veces como sea necesario, hasta 
                //localizar un separador en concreto, ya que puede ser que no todas las filas tengan multiples genes.
                for (int i = 0; i < genesJuntos.length() && !haySeparador; i++) {
                    caracter = genesJuntos.charAt(i);
                    if (caracter == '\t') {//Separado por tabuladores
                        separadorGenes = "\t";
                        haySeparador = true;
                    } else if (caracter == ' ') {//Separado por espacios
                        separadorGenes = " ";
                        haySeparador = true;
                    } else if (caracter == ',') {//Separado por comas
                        separadorGenes = ",";
                        haySeparador = true;
                    } else if (caracter == ';') {//Separado por puntos y comas
                        separadorGenes = ";";
                        haySeparador = true;
                    }
                }

            }
            
            if (separadorGenes != null && (genesJuntos.split(separadorGenes).length > 1)) {//Si esta fila contiene más de un Gen
                genes = genesJuntos.split(separadorGenes);
                for (int i = 0; i < genes.length; i++) {
                    conjuntoGenesSeparados.add(genes[i]);
                }
            } else {//Solo hay un gen
                conjuntoGenesSeparados.add(genesJuntos);//Solo añado el unico gen de esa fila
            }

        }
        //Abro stream, crea el fichero si no existe
        FileWriter fw = new FileWriter(ruta + File.separator + "GEN_FILE-" + fileEnri.getName());
        Iterator it2 = conjuntoGenesSeparados.iterator();
        while (it2.hasNext()) {
            //Escribimos en el fichero
            fw.write(it2.next().toString() + "\r\n");
        }
        //Cierro el stream
        fw.close();

    }

    private List<String> obtenerSelect(SelectGenesProvideActionForm applyForm) {
        List<String> datosSelect = new ArrayList<String>();
        datosSelect.add(applyForm.getCluster_columns_0());
        datosSelect.add(applyForm.getCluster_columns_1());
        datosSelect.add(applyForm.getCluster_columns_2());
        datosSelect.add(applyForm.getCluster_columns_3());
        datosSelect.add(applyForm.getCluster_columns_4());
        datosSelect.add(applyForm.getCluster_columns_5());
        datosSelect.add(applyForm.getCluster_columns_6());
        datosSelect.add(applyForm.getCluster_columns_7());
        datosSelect.add(applyForm.getCluster_columns_8());
        datosSelect.add(applyForm.getCluster_columns_9());
        datosSelect.add(applyForm.getCluster_columns_10());
        datosSelect.add(applyForm.getCluster_columns_11());
        datosSelect.add(applyForm.getCluster_columns_12());
        datosSelect.add(applyForm.getCluster_columns_13());
        datosSelect.add(applyForm.getCluster_columns_14());
        datosSelect.add(applyForm.getCluster_columns_15());
        datosSelect.add(applyForm.getCluster_columns_16());
        datosSelect.add(applyForm.getCluster_columns_17());
        datosSelect.add(applyForm.getCluster_columns_18());
        datosSelect.add(applyForm.getCluster_columns_19());
        datosSelect.add(applyForm.getCluster_columns_20());
        datosSelect.add(applyForm.getCluster_columns_21());
        datosSelect.add(applyForm.getCluster_columns_22());
        datosSelect.add(applyForm.getCluster_columns_23());
        datosSelect.add(applyForm.getCluster_columns_24());
        datosSelect.add(applyForm.getCluster_columns_25());
        datosSelect.add(applyForm.getCluster_columns_26());
        datosSelect.add(applyForm.getCluster_columns_27());
        datosSelect.add(applyForm.getCluster_columns_28());
        datosSelect.add(applyForm.getCluster_columns_29());
        datosSelect.add(applyForm.getCluster_columns_30());
        return datosSelect;
    }
}
