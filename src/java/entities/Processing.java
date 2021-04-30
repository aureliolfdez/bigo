package entities;

import java.io.Serializable;
import java.util.*;

public class Processing implements Serializable {

    private Set cConjuntoTerminos;
    private String[] fileBiclusters;
    private String sFolder;
    private Conversion oConversion;
    
    public Processing(Set cConjuntoTerminos, String sFolder, Conversion oConversion){
        
        this.cConjuntoTerminos = cConjuntoTerminos;
        this.sFolder = sFolder;
        this.oConversion = oConversion;
    }

    public Set getcConjuntoTerminos() {
        return cConjuntoTerminos;
    }

    public void setcConjuntoTerminos(Set cConjuntoTerminos) {
        this.cConjuntoTerminos = cConjuntoTerminos;
    }

    public String[] getFileBiclusters() {
        return fileBiclusters;
    }

    public void setFileBiclusters(String[] fileBiclusters) {
        this.fileBiclusters = fileBiclusters;
    }

    public String getsFolder() {
        return sFolder;
    }

    public void setsFolder(String sFolder) {
        this.sFolder = sFolder;
    }

    public Conversion getoConversion() {
        return oConversion;
    }

    public void setoConversion(Conversion oConversion) {
        this.oConversion = oConversion;
    }
}
