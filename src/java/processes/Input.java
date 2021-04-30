package processes;

/*
 The "input" process involves loading the clusters with their corresponding genes in BIGO.

 Furthermore, this process is responsible for a possible conversion of gene annotations 
 through a .CSV file provided by the user.
 */
import entities.Cluster;
import entities.Conversion;
import java.io.*;
import java.util.*;
import java.io.File;

public class Input implements Serializable {

    private Conversion oConversion;     //An object representing the possible conversion of annotations.
    private char separator;

    public Input(Conversion oConversion, char separator) {
        this.oConversion = oConversion;
        this.separator = separator;
    }

    public Conversion getoConversion() {
        return oConversion;
    }

    public void setoConversion(Conversion oConversion) {
        this.oConversion = oConversion;
    }

    public char getSeparator() {
        return separator;
    }

    public void setSeparator(char separator) {
        this.separator = separator;
    }

    // Main method.
    public void start() throws FileNotFoundException, IOException {
        File fFolder = new File(oConversion.getDataDir());         // Get clusters folder.
        String[] fileBiclusters = fFolder.list();           // Get files in that folder.
        for (int x = 0; x < fileBiclusters.length; x++) {   // We do a loop with all files (clusters) of "dataDir" folder.
            File file = new File(oConversion.getDataDir() + File.separator + fileBiclusters[x]); // Get file path.

            // With the following code, I get the number of cluster.
            String sNameBicluster = fileBiclusters[x].substring(0, fileBiclusters[x].length() - 4);
            Cluster oBicl = new Cluster(sNameBicluster);

            // With this code, I get the list of genes.
            BufferedReader br = new BufferedReader(new FileReader(file));
            String sGen;
            while ((sGen = br.readLine()) != null) {       // We do a loop with all cluster genes specifically (file).
                String sGenAux = sGen;
                if (oConversion.isbConversion()) {         // If the user wants to turn the annotations of genes.
                    sGenAux = searchGen(sGen);             // We obtain the new gene annotation.
                }
                oBicl.anadirGen(sGenAux);                  // We add gen to cluster.
            }
            oConversion.getcGroupGenes().add(oBicl);      // We add cluster to set
            if (oConversion.isbConversion()) {
                List<String> listaGenes = new LinkedList();    // We convert the set of genes to list.
                listaGenes.addAll(oBicl.getcGenes());
                saveGenFlyBase(listaGenes, file);              // We modify the entire file for all new annotations have listed.
            }
        }
        //}

    }

    // Method. Returns the new annotation from the old annotation introduced by parameter.
    // The procedure is performed by finding the library created for this purpose (genes.csv).
    public String searchGen(String sGen) throws FileNotFoundException, IOException {
        String sLine = "";                                              // sLine. Complete line of the library "genes.csv" (OldAnnotation;NewAnnotation).
        String sGenConversion = "Unspecified";                          // sGenConversion. Result variable with new annotation.
        boolean bFound = false;                                         //bFound. True --> If the gene has benn found in the library. False --> The opposite.
        File file = new File(oConversion.getCsvConversion());           //file. Library containning all annotations genes.
        BufferedReader br = new BufferedReader(new FileReader(file));
        while ((sLine = br.readLine()) != null && !bFound) {
            boolean bColumn = false;                                    //bColumn. Flag for when the gene has been found in the library stop searching for the same.
            String sCad = "";                                           //sCad. Old anotacion.
            for (int i = 0; i < sLine.length() && !bColumn; i++) {
                if (sLine.charAt(i) != ';') {
                    sCad += sLine.charAt(i);
                } else {
                    bColumn = true;
                    if (sGen.equals(sCad) || sGen.equals(sLine.substring(i + 1, sLine.length()))) {
                        sGenConversion = sLine.substring(i + 1, sLine.length());
                        bFound = true;
                    }
                }
            }
        }
        return sGenConversion;
    }

    /*
     Method. Replaces the particular file. In conclusion, replaces the previous 
     annotations to new annotations in the cluster files.
     */
    public void saveGenFlyBase(List<String> listaGenes, File file) throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter(file, false));
        PrintWriter salida = new PrintWriter(bw);
        for (String sLinea : listaGenes) {
            salida.print(sLinea);
            if (listaGenes.indexOf(sLinea) != listaGenes.size() - 1) {    // I make the last gene doesn't make a line break for the line break a new gene isn't considered.
                salida.print("\r\n");
            }
        }
        salida.close();
    }
}
