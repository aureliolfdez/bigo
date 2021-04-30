package web;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.servlet.http.HttpSession;

@WebServlet("/FilesServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 500000,
        maxFileSize = 1024 * 1024 * 500000,
        maxRequestSize = 1024 * 1024 * 5 * 500000)
public class FilesServlet extends HttpServlet {

    private static final long serialVersionUID = 205242440643911308L;
    private static final String UPLOAD_DIR = "dataDir";
    private static final String UPLOAD_DIR_PROVIDE = "outDirProvide";
    private static final String PRIVATE_FILES = "WEB-INF";

    protected void sendErrorRedirect(HttpServletRequest request, HttpServletResponse response, String errorPageURL, Throwable e) throws ServletException, IOException {
        getServletConfig().getServletContext().getRequestDispatcher(errorPageURL).forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String applicationPath = request.getServletContext().getRealPath("");
            String sesionId = session.getId();
            String pathSesion = applicationPath + File.separator + PRIVATE_FILES + File.separator + sesionId;
            String genesFileProvide = request.getParameter("genesProvide");            
            String nameFileProvide = request.getParameter("nameFileProvide");

            session.setAttribute("error_extension", 0);
            session.setAttribute("error_exists", 0);
            int error_type[];
            if (genesFileProvide != null && genesFileProvide.equals("yes")) { //Upload complete gene file (Provide)
                error_type = uploadGenesComplete(pathSesion, request);
            } else if (nameFileProvide != null) {                           //Upload genes (provide)
                error_type = uploadFilesGenesDir(pathSesion, request);
            } else {
                error_type = uploadFilesDir(pathSesion, request);
            }

            if (error_type[0] == 1) {
                session.setAttribute("error_extension", 1);
            }
            if (error_type[1] == 1) {
                session.setAttribute("error_exists", 1);
            }
            if (error_type[2] == 1) {
                session.setAttribute("error_size", 1);
            }
            if (error_type[3] == 1) {
                session.setAttribute("error_max_size", 1);
            }
            if (error_type[4] == 1) {
                session.setAttribute("error_max_size_folder", 1);
            }
            forwardWebGraph(request, response, request.getParameter("enrichment"));
        } catch (Exception ex) {
            Logger.getLogger(FilesServlet.class.getName()).log(Level.SEVERE, null, ex);
            try {
                sendErrorRedirect(request, response, "/new_enrichment.jsp#new", ex); //Si existe un error redirigira a new_enrichment
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /*
     RETURN: 0 --> NONE. 1 --> ERROR EXTENSION FILE. 2 --> EXISTS SAME FILE.
     */
    private int[] uploadFilesDir(String pathSesion, HttpServletRequest request) throws Exception {
        int error_type[] = {0, 0, 0, 0, 0};
        boolean extension_valid = false, exists = false;
        String extensiones_permitidas[] = {".txt", ".csv"};
        String pathDataDir = "";
        if(request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("no")){
            pathDataDir = pathSesion + File.separator + UPLOAD_DIR_PROVIDE;
        }else{
            pathDataDir = pathSesion + File.separator + UPLOAD_DIR;
        }
        File dirDataDir = new File(pathDataDir);
        File dirSesion = new File(pathSesion);
        if (!dirSesion.exists()) {
            dirSesion.mkdirs();
            dirDataDir.mkdirs();
        }
        if (!dirDataDir.exists()) {
            dirDataDir.mkdirs();
        }

        String fileName = null;

        for (Part part : request.getParts()) {
            if (part.getName().equals("dataDir") || part.getName().equals("outDirProvide")) {
                if (part.getSize() <= 52428800) { // Limite del fichero a 50 MB
                    long length = 0;
                    for (File fil : dirDataDir.listFiles()) {
                        if (fil.isFile()) {
                            length += fil.length();
                        }
                    }
                    if (length <= 1073741824) { //Si el total en el dataDir no sobrepasa 1 GB
                        String contentDisp = part.getHeader("content-disposition");
                        fileName = contentDisp.substring(contentDisp.indexOf("filename") + 10, contentDisp.length() - 1);
                        fileName = fileName.replace(" ", "_");
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());

                        File[] listFiles = new File(pathDataDir).listFiles();
                        for (File f : listFiles) {
                            if (f.getName().equals(fileName)) {
                                error_type[1] = 1;
                            }
                        }

                        for (String s : extensiones_permitidas) {
                            if (s.equals(fileExtension)) {
                                extension_valid = true;
                            }
                        }

                        if (extension_valid) {
                            if (part.getSize() == 0) {
                                error_type[2] = 1;
                            } else {
                                part.write(pathDataDir + File.separator + fileName);
                            }
                        } else {
                            error_type[0] = 1;
                        }
                    } else {
                        error_type[4] = 1;
                    }

                } else {
                    error_type[3] = 1; // Si sobrepasa el total de 50 MB del fichero.
                }

            } else if (part.getName().equals("popFile") || part.getName().equals("sGenesCsv")) {
                String contentDisp = part.getHeader("content-disposition");
                fileName = contentDisp.substring(contentDisp.indexOf("filename") + 10, contentDisp.length() - 1);
                if (part.getSize() == 0) {
                    error_type[2] = 1;
                } else {
                    if (part.getSize() <= 104857600) { //Limite en 100 MB para los ficheros POPFILE y conversion de genes
                        part.write(dirSesion + File.separator + fileName);
                    } else {
                        error_type[3] = 1; // Si sobrepasa el total de 50 MB del fichero.
                    }
                }
            }
        }

        return error_type;
    }

    /*
     RETURN: 0 --> NONE. 1 --> ERROR EXTENSION FILE. 2 --> EXISTS SAME FILE.
     */
    private int[] uploadGenesComplete(String pathSesion, HttpServletRequest request) throws Exception {
        int error_type[] = {0, 0, 0, 0, 0};
        boolean extension_valid = false, exists = false;
        String extensiones_permitidas[] = {".txt", ".csv"};
        String pathDataDir = "";
        if(request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("genesProvide")){
            pathDataDir = pathSesion + File.separator + "dataDirProvide";
        }else{
            pathDataDir = pathSesion + File.separator + UPLOAD_DIR;
        }
        
        File dirDataDir = new File(pathDataDir);
        File dirSesion = new File(pathSesion);
        if (!dirSesion.exists()) {
            dirSesion.mkdirs();
            dirDataDir.mkdirs();
        }
        if (!dirDataDir.exists()) {
            dirDataDir.mkdirs();
        }    
        
        if (!dirDataDir.exists()) {
            dirDataDir.mkdirs();
        }else{ //Si existe es que hay algun fichero de genes manual, por lo que lo eliminamos todo y dejamos la carpeta vacia
            File[] listFiles = dirDataDir.listFiles();
            if(listFiles != null && listFiles.length > 0){
                for(File f: listFiles){
                    request.getSession().setAttribute(f.getName(), null);
                    f.delete();
                }
            }
        }
        
        /*String pathDataDir = pathSesion + File.separator + UPLOAD_DIR;
        String pathDataGenesDir = pathSesion + File.separator + "dataDirProvide";
        File dirDataDir = new File(pathDataDir);
        File dirDataDir = new File(pathDataGenesDir);
        File dirSesion = new File(pathSesion);
        File dirDataGenesDir = new File(pathDataGenesDir);
        if (!dirSesion.exists()) {
            dirSesion.mkdirs();
            dirDataDir.mkdirs();
        }
        if (!dirDataDir.exists()) {
            dirDataDir.mkdirs();
        }
        if (!dirDataGenesDir.exists()) {
            dirDataGenesDir.mkdirs();
        }else{ //Si existe es que hay algun fichero de genes manual, por lo que lo eliminamos todo y dejamos la carpeta vacia
            File[] listFiles = dirDataGenesDir.listFiles();
            if(listFiles != null && listFiles.length > 0){
                for(File f: listFiles){
                    request.getSession().setAttribute(f.getName(), null);
                    f.delete();
                }
            }
        }*/

        String fileName = null;

        for (Part part : request.getParts()) {
            if (part.getName().equals("dataDir")) {
                if (part.getSize() <= 52428800) { // Limite del fichero a 50 MB
                    long length = 0;
                    for (File fil : dirDataDir.listFiles()) {
                        if (fil.isFile()) {
                            length += fil.length();
                        }
                    }
                    if (length <= 1073741824) { //Si el total en el dataDir no sobrepasa 1 GB
                        String contentDisp = part.getHeader("content-disposition");
                        fileName = contentDisp.substring(contentDisp.indexOf("filename") + 10, contentDisp.length() - 1);
                        fileName = fileName.replace(" ", "_");
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());

                        File[] listFiles = new File(pathDataDir).listFiles();
                        for (File f : listFiles) {
                            if (f.getName().equals(fileName)) {
                                error_type[1] = 1;
                            }
                        }

                        for (String s : extensiones_permitidas) {
                            if (s.equals(fileExtension)) {
                                extension_valid = true;
                            }
                        }

                        if (extension_valid) {
                            if (part.getSize() == 0) {
                                error_type[2] = 1;
                            } else {
                                part.write(pathDataDir + File.separator + "genesComplete.txt");
                                //part.write(pathDataGenesDir + File.separator + "genesComplete.txt");
                                request.getSession().setAttribute("uploadedGenesTotalProvide", "yes");
                            }
                        } else {
                            error_type[0] = 1;
                        }
                    } else {
                        error_type[4] = 1;
                    }

                } else {
                    error_type[3] = 1; // Si sobrepasa el total de 50 MB del fichero.
                }

            } else if (part.getName().equals("popFile") || part.getName().equals("sGenesCsv")) {
                String contentDisp = part.getHeader("content-disposition");
                fileName = contentDisp.substring(contentDisp.indexOf("filename") + 10, contentDisp.length() - 1);
                if (part.getSize() == 0) {
                    error_type[2] = 1;
                } else {
                    if (part.getSize() <= 104857600) { //Limite en 100 MB para los ficheros POPFILE y conversion de genes
                        part.write(dirSesion + File.separator + fileName);
                    } else {
                        error_type[3] = 1; // Si sobrepasa el total de 50 MB del fichero.
                    }
                }
            }
        }

        /*File[] listFiles = new File(pathDataDir).listFiles();
         if (dirSesion.exists() && listFiles.length == 0) {
         borrarDirectorio(dirSesion);
         dirSesion.delete();
         }*/
        return error_type;
    }

    public static void borrarDirectorio(File directorio) {
        File[] ficheros = directorio.listFiles();
        for (int x = 0; x < ficheros.length; x++) {
            if (ficheros[x].isDirectory()) {
                borrarDirectorio(ficheros[x]);
            }
            ficheros[x].delete();
        }
    }

    private void forwardWebGraph(HttpServletRequest request, HttpServletResponse response, String type) throws IOException, ServletException {
        if (type.equals("yes")) {
            response.sendRedirect("new_enrichment.jsp#new");
        } else if (type.equals("genesProvide")) {
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/WEB-INF/enrichment/provide/selectGenes.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendRedirect("bigo.jsp?enrichment=no#own");
        }
    }

    private int[] uploadFilesGenesDir(String pathSesion, HttpServletRequest request) throws IOException, ServletException {
        int error_type[] = {0, 0, 0, 0, 0};
        boolean extension_valid = false, exists = false;
        String extensiones_permitidas[] = {".txt", ".csv"};
        String nameFileProvide = request.getParameter("nameFileProvide");
        String pathDataDir = "";
        if(request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("genesProvide")){
            pathDataDir = pathSesion + File.separator + "dataDirProvide";
        }else{
            pathDataDir = pathSesion + File.separator + UPLOAD_DIR;
        }        
        File dirDataDir = new File(pathDataDir);
        File dirSesion = new File(pathSesion);
        if (!dirSesion.exists()) {
            dirSesion.mkdirs();
            dirDataDir.mkdirs();
        }
        if (!dirDataDir.exists()) {
            dirDataDir.mkdirs();
        }    
        
 
        
        
        
        
        
        
        
        
        
        /*String pathDataDir = pathSesion + File.separator + UPLOAD_DIR;
        String pathDataGenesDir = pathSesion + File.separator + "dataDirProvide";
        String nameFileProvide = request.getParameter("nameFileProvide");
        File dirDataDir = new File(pathDataDir);
        File dirSesion = new File(pathSesion);
        File dirDataGenesDir = new File(pathDataGenesDir);
        if (!dirSesion.exists()) {
            dirSesion.mkdirs();
            dirDataDir.mkdirs();
        }
        if (!dirDataDir.exists()) {
            dirDataDir.mkdirs();
        }
        if (!dirDataGenesDir.exists()) {
            dirDataGenesDir.mkdirs();
        }*/

        String fileName = null;

        for (Part part : request.getParts()) {
            if (part.getName().equals("dataDir")) {
                if (part.getSize() <= 52428800) { // Limite del fichero a 50 MB
                    long length = 0;
                    for (File fil : dirDataDir.listFiles()) {
                        if (fil.isFile()) {
                            length += fil.length();
                        }
                    }
                    if (length <= 1073741824) { //Si el total en el dataDir no sobrepasa 1 GB
                        String contentDisp = part.getHeader("content-disposition");
                        fileName = contentDisp.substring(contentDisp.indexOf("filename") + 10, contentDisp.length() - 1);
                        fileName = fileName.replace(" ", "_");
                        String fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());

                        File[] listFiles = new File(pathDataDir).listFiles();
                        for (File f : listFiles) {
                            if (f.getName().equals(fileName)) {
                                error_type[1] = 1;
                            }
                        }

                        for (String s : extensiones_permitidas) {
                            if (s.equals(fileExtension)) {
                                extension_valid = true;
                            }
                        }

                        if (extension_valid) {
                            if (part.getSize() == 0) {
                                error_type[2] = 1;
                            } else {
                                part.write(pathDataDir + File.separator + nameFileProvide);
                                
                                //part.write(pathDataGenesDir + File.separator + nameFileProvide);
                                request.getSession().setAttribute(nameFileProvide, nameFileProvide);
                            }
                        } else {
                            error_type[0] = 1;
                        }
                    } else {
                        error_type[4] = 1;
                    }

                } else {
                    error_type[3] = 1; // Si sobrepasa el total de 50 MB del fichero.
                }

            } else if (part.getName().equals("popFile") || part.getName().equals("sGenesCsv")) {
                String contentDisp = part.getHeader("content-disposition");
                fileName = contentDisp.substring(contentDisp.indexOf("filename") + 10, contentDisp.length() - 1);
                if (part.getSize() == 0) {
                    error_type[2] = 1;
                } else {
                    if (part.getSize() <= 104857600) { //Limite en 100 MB para los ficheros POPFILE y conversion de genes
                        part.write(dirSesion + File.separator + fileName);
                    } else {
                        error_type[3] = 1; // Si sobrepasa el total de 50 MB del fichero.
                    }
                }
            }
        }
        return error_type;
    }
}
