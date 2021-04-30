/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package struts.enrichment;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;
import processes.Bigo;

/**
 *
 * @author principalpc
 */
public class ExecuteNewEnrichmentAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";
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

        request.getSession().setAttribute("clickBack", null); //Para redirigir en new_enrichment.jsp al Step 2
        request.getSession().setAttribute("optionsEnrichment", null);
        ExecuteNewEnrichmentActionForm fileUploadForm = (ExecuteNewEnrichmentActionForm) form;

        String applicationPath = request.getServletContext().getRealPath("");
        String sesionId = fileUploadForm.getSessionId();
        String filePath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId;

        File folder = new File(filePath);
        if (!folder.exists()) {
            folder.mkdir();
        } else { //Si existe hay que eliminar la carpeta outDir.
            String outPath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "outDir";
            File outDirfolder = new File(outPath);
            if (outDirfolder.exists()) {
                File[] list = outDirfolder.listFiles();
                for (File f : list) {
                    String nomFichero = f.getName();
                    File fil = new File(outPath + File.separator + nomFichero); // Elimina el fichero seleccionado
                    fil.delete();
                    File dirData = new File(outPath); // Codigo para comprobar despues de borrar si en la carpeta no hay ficheros, si no existe se elimina toda la sesion automaticamente
                    if (dirData.exists() && dirData.listFiles().length == 0) {
                        dirData.delete();
                    }
                }
            }
        }

        if (fileUploadForm.getAnnoFile_file() != null) {
            uploadFile(fileUploadForm.getAnnoFile_file(), filePath, request);
        }

        if (fileUploadForm.getOboFile_file() != null) {
            uploadFile(fileUploadForm.getOboFile_file(), filePath, request);
        }

        if (fileUploadForm.getPopFile() != null) {
            uploadFile(fileUploadForm.getPopFile(), filePath, request);
        }

        if (fileUploadForm.getsGenesCsv() != null) {
            uploadFile(fileUploadForm.getsGenesCsv(), filePath, request);
        }

        Bigo bigo = executeBigo(filePath, request, fileUploadForm);

        //Modificar la columna ID por GO_ID del enrichment para abrir correctamente en Excel
        if (bigo != null) {
            String outPath = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId + File.separator + "outDir";
            File outDirfolder = new File(outPath);
            if (outDirfolder.exists()) {
                File[] list = outDirfolder.listFiles();
                for (File f : list) {
                    List<String> listaDatos = Files.readAllLines(f.toPath());
                    listaDatos.set(0, listaDatos.get(0).replace("ID", "GO_ID"));
                    Files.write(f.toPath(), listaDatos);
                }
            }
        }
        request.getSession().setAttribute("bigo", bigo); //Paso a sesion la variable bigo para obtener datos
        return mapping.findForward(SUCCESS);
    }

    private Bigo executeBigo(String pathSesion, HttpServletRequest request, ExecuteNewEnrichmentActionForm fileUploadForm) throws Exception {
        String applicationPath = request.getServletContext().getRealPath(""); //Para ficheros no subidos

        String contentDisp = "";

        //dataDIR
        String sDataDir = pathSesion + File.separator + "dataDir";

        //outDir
        String sFolder = pathSesion + File.separator + "outDir";

        //Si se ha ejecutado anteriormente hay que eliminar todo primeramente
        //Annotations file
        String sAnnoFile = "";
        if (fileUploadForm.getAnnoFile().equals("own_file")) {
            sAnnoFile = pathSesion + File.separator + fileUploadForm.getAnnoFile_file().getFileName();            
        }else{
            sAnnoFile = applicationPath + File.separator + "annotations" + File.separator + request.getParameter("annoFile");
        }

        //Ontology file (OBO)
        String sOboFile = "";
        if (fileUploadForm.getOboFile().equals("own_file")) {
            sOboFile = pathSesion + File.separator + fileUploadForm.getOboFile_file().getFileName();
        }else{
            sOboFile = applicationPath + File.separator + "ontologies" + File.separator + "go.obo";
        }

        //Population file
        String sPopFile = "";
        if (fileUploadForm.getPopulationFile() != null && fileUploadForm.getPopulationFile().equals("population_file_demo")) {
            sPopFile = pathSesion + File.separator + "Population_DUP.txt";
        }else{
            sPopFile = pathSesion + File.separator + fileUploadForm.getPopFile().getFileName();
        }

        //MTC Method to use (Correction)
        String sCorrection = fileUploadForm.getMtcMethod();

        //Calculation
        String sCalculation = fileUploadForm.getCalculationMethod();

        //Conversion genes
        String sConversion = fileUploadForm.getsConversion();

        //Conversion genes file
        String sGenesCsv = "";
        if (sConversion.equals("y")) {
            sGenesCsv = pathSesion + File.separator + fileUploadForm.getsGenesCsv().getFileName();
        }

        //Character separator
        String sSeparator = "\t";
        if (fileUploadForm.getType_character().equals("other")) {
            sSeparator = fileUploadForm.getsSeparator();
        } else if (fileUploadForm.getType_character().equals("space")) {
            sSeparator = " ";
        }

        //Ranking TXT
        String sOutFile = pathSesion + File.separator + "output.txt";

        //Graph DOT
        String sOutFileGraph = pathSesion + File.separator + "output.dot";
        Bigo bigo = new Bigo(sDataDir, sFolder, sAnnoFile, sOboFile, sPopFile, sCorrection, "0.001", sCalculation, sOutFile, sOutFileGraph, 9999, 101, 100, 0, sConversion, sGenesCsv, sSeparator, 1, 0);
        try {
            bigo.startCreateEnrichment(pathSesion);
        } catch (FileNotFoundException io) {
            System.out.println("Usuario intenta realizar una inyeccion metiendo codigo fuente en ficheros clusters");
            System.out.println(io.getMessage());
        } catch (Exception e) {
            System.out.println("Fallo grave de BIGO");
        }
        return bigo;
    }

    public void uploadFile(FormFile file, String filePath, HttpServletRequest request) throws FileNotFoundException, IOException {
        String fileName = file.getFileName();

        if (!("").equals(fileName)) {
            File newFile = new File(filePath, fileName);
            if (!newFile.exists()) {
                Files.createFile(newFile.toPath());
                Files.write(newFile.toPath(), file.getFileData());
            }
            request.setAttribute("uploadedFilePath", newFile.getAbsoluteFile());
            request.setAttribute("uploadedFileName", newFile.getName());
        }
    }
}
