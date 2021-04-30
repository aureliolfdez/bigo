package entities;

import java.util.*;

public class GraphNodeRelation implements Comparable {

    private List<Row> listaGo; // At first, to create the possibilities will only a single element, whereas when one with the resultant, this list will contain all GO concerning one of the two nodes of the couple's relationship terms.
    private List<Row> listaGoNodoA;
    private List<Row> listaGoNodoB;
    private String[] pareja;
    private int iNumVeces;

    public GraphNodeRelation() {
        this.iNumVeces = 0;
        listaGo = new LinkedList();
        listaGoNodoA = new LinkedList();
        listaGoNodoB = new LinkedList();
    }

    public GraphNodeRelation(String[] pareja) {
        this.pareja = pareja;
        this.iNumVeces = 0;
        listaGo = new LinkedList();
        listaGoNodoA = new LinkedList();
        listaGoNodoB = new LinkedList();
    }

    public GraphNodeRelation(String[] pareja, Row oGo) {
        this.pareja = pareja;
        this.iNumVeces = 0;
        listaGo = new LinkedList();
        listaGoNodoA = new LinkedList();
        listaGoNodoB = new LinkedList();
        listaGo.add(oGo);
    }
    
    public int getCommonTermsNodoA(){
        int iComunes = 0;
        for (Row oGo: listaGoNodoA){
            if(listaGoNodoB.contains(oGo)){
                iComunes = iComunes + 1;
            }
        }
        return iComunes;
    }
    
    public double getCommonTermsNodoB(){
        int iComunes = 0;
        for (Row oGo: listaGoNodoB){
            if(listaGoNodoA.contains(oGo)){
                iComunes = iComunes + 1;
            }
        }
        return iComunes;
    }
    
    public double getPorcentajeNodoA(){
        double dPerc;
        int iComunes = 0;
        for (Row oGo: listaGoNodoA){
            if(listaGoNodoB.contains(oGo)){
                iComunes = iComunes + 1;
            }
        }
        dPerc = ((iComunes + 0.0) * 100) / (listaGoNodoA.size()+0.0);
        return dPerc;
    }
    
    public double getPorcentajeNodoB(){
        double dPerc;
        int iComunes = 0;
        for (Row oGo: listaGoNodoB){
            if(listaGoNodoA.contains(oGo)){
                iComunes = iComunes + 1;
            }
        }
        dPerc = ((iComunes + 0.0) * 100) / (listaGoNodoB.size()+0.0);
        return dPerc;
    }

    public List<Row> getListaGo() {
        return listaGo;
    }

    public void setListaGo(List<Row> listaGo) {
        this.listaGo = listaGo;
    }

    public void añadirGo(Row oGo) {
        this.listaGo.add(oGo);
    }

    public List<Row> getListaGoNodoA() {
        return listaGoNodoA;
    }

    public void setListaGoNodoA(List<Row> listaGoNodoA) {
        this.listaGoNodoA = listaGoNodoA;
    }

    public List<Row> getListaGoNodoB() {
        return listaGoNodoB;
    }

    public void setListaGoNodoB(List<Row> listaGoNodoB) {
        this.listaGoNodoB = listaGoNodoB;
    }

    public void añadirGoNodoA(Row oGo) {
        this.listaGoNodoA.add(oGo);
    }

    public void añadirGoNodoB(Row oGo) {
        this.listaGoNodoB.add(oGo);
    }

    public String[] getPareja() {
        return pareja;
    }

    public void setPareja(String[] pareja) {
        this.pareja = pareja;
    }

    public int getiNumVeces() {
        return iNumVeces;
    }

    public void setiNumVeces(int iNumVeces) {
        this.iNumVeces = iNumVeces;
    }

    public void aumentarVeces() {
        this.iNumVeces = this.iNumVeces + 1;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 37 * hash + Arrays.hashCode(this.pareja);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final GraphNodeRelation other = (GraphNodeRelation) obj;
        if (!Arrays.equals(this.pareja, other.pareja)) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "pareja=" + "[" + pareja[0] + "," + pareja[1] + "]" + ", iNumVeces=" + iNumVeces;
    }

    @Override
    public int compareTo(Object o) {
        final GraphNodeRelation other = (GraphNodeRelation) o;
        return other.getiNumVeces() - this.getiNumVeces();
    }

}
