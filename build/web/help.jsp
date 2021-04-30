<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page session="true" %>
<!DOCTYPE html>
<html>
    <head>  
        <title>BIGO - Improve gene enrichment analysis in collections of genes</title>
        <meta name="keywords" content="enrichment analysis, cytoscape web plugin, bigo" />
        <meta name="description" content="BIGO. A tool to improve gene enrichment analysis in collections of genes">

        <!-- Frameworks -->
        <!--<link rel="stylesheet" href="css/bootstrap.min.css">-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>


        <!-- Smartphones -->
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->

        <!-- Own web CSS -->
        <link rel="stylesheet" href="css/style.css">        
        <script src="js/cross_animated.js" type="text/javascript" charset="utf-8"></script>

        <!-- DataTable -->
        <link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.min.css">        
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="//cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/new_enrichment_desple.js"></script>
        <script type="text/javascript" src="js/bootstrap-filestyle.js"></script>

    </head>
    <body style="background-color: #f4f4f4;">
        <% session.setAttribute("active", "help");%>
        <jsp:include page="components/header.jsp" />

        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li>Help</li>
                </ul>
                <br>

                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div class="row" style="margin: 3% 8% 3% 8%;">
                        <div class="col-md-3" style="text-align: center;">
                            <img src="images/contact/help-online.png" style="width: 60%;">
                        </div>
                        <div class="col-md-9" style="padding-top: 20px;">
                            <h2>Help</h2> 
                            <h5 style="color: #999999; font-weight: lighter;">You have a complete and detailed manual about BIGO tool at your disposal.</h5>
                        </div>   
                    </div> 

                    <hr style="margin: 0% 8% 0% 8%;"> 

                    <div class="row" style="margin: 4% 8% 0% 8%;">
                        <div class="col-md-4" style="border: 1px solid #cccccc; padding: 10px 10px 10px 10px; ">                            
                            <span style="font-weight: bold;">Table of contents</span>
                            <ol style="text-align: left; color: #3f7ab7;">
                                <li><a href="#intro">Introduction</a></li>
                                <li><a href="#first">First step: Enrichment Processor</a></li>
                                <li><a href="#second">Second step: Ranking generator</a></li>
                                <li><a href="#third">Third step: Network generator</a></li>
                            </ol>                            
                        </div>
                    </div>
                    <a name="intro">&nbsp;</a>

                    <div class="row" style="margin: 6% 8% 4% 8%;">
                        <div class="col-md-12">
                            <h4>Introduction</h4>
                            <hr>
                            <div>BIGO's services are organized into three different processes that are connected in a sequential workow, as it is showed in the next figure:</div>
                            <br><div style="text-align: center;"><img src="images/help/bigo_workflow.jpg" style=" width: 100%;"></div>
                            <div style="font-style: italic; font-size: 11px; text-align: center;">Figure 1: The operational workflow of the BIGO web tool is represented in process management notation. As shown, there are three main services that are connected in a sequential and bidirectional path, each with an input and an output.</div>
                        </div>
                    </div>

                    <a name="first">&nbsp;</a>

                    <div class="row" style="margin: 6% 8% 4% 8%; text-align: justify;">
                        <div class="col-md-12">
                            <h4 style="text-align: left;">First step: Enrichment Processor</h4>
                            <hr>
                            <div>Each group of genes is uploaded to BIGO in a single-column text files format. Then, an enrichment analysis of each group of genes is performed. BIGO includes the following parameters regarding this process:</div>
                            <br>
                            <div>
                                <ul>
                                    <li style="padding-bottom: 10px;"><strong>Basic options:</strong> he user may select files related to annotations, ontologies and the experiment population. Regarding the annotation files, BIGO currently offers 6 different organisms (Caenorhabditis elegans, Drosophila melanogaster, Homo sapiens, Mus musculus, Oryza sativa and Saccharomyces cerevisiae), as well as annotation files from Protein Data Bank and any annotation file provided by the user. Additionally, BIGO allows the user to download the last OBO file version from Gene Ontology. Finally, the population file is a single-column text file with all genes involved in the experiment.</li>
                                </ul>
                                <div style="text-align: center;"><img src="images/help/first_1.png" style=" width: 100%;"></div><br>
                                <ul>
                                    <li><strong>Advanced options:</strong> Are related to the statistical measures used in this process, that is, the enrichment analysis method and the multi-testing correction method. Finally, gene id conversion is very adaptable since users provide their own gene id conversion file.</li>
                                </ul>
                                <div style="text-align: center;"><img src="images/help/first_2.png" style=" width: 100%;"></div><br>
                            </div>
                            <div>To start the process, please click on 'Execute' button.</div>
                            <br><div style="text-align: center;"><img src="images/help/first_3.png" style='width: 20%;'></div><br>
                            <div>For every group of genes, the enrichment analysis results are presented as an interactive and can be downloaded in csv format.</div>                        
                            <br><div style="text-align: center;"><img src="images/help/first_4.png" style=" width: 100%;"></div>
                            <div style="font-style: italic; font-size: 11px; text-align: center;">Figure 2: Representation of the results from the enrichment analysis.</div>
                            <br><div style="text-align: center;"><img src="images/help/first_5.png" style=" width: 100%;"></div>
                            <div style="font-style: italic; font-size: 11px; text-align: center;">Figure 3: Multiple options to handle enrichment analysis</div>
                        </div>
                    </div>

                    <a name="second">&nbsp;</a>

                    <div class="row" style="margin: 6% 8% 4% 8%; text-align: justify;">
                        <div class="col-md-12">
                            <h4 style="text-align: left;">Second step: Ranking generator</h4>
                            <hr>
                            <div>All the biological terms generated in the previous phase are organized into a single ranking. The aim of this ranking is to provide different criteria to help researchers to focus on a specific portion of the enrichment analysis results.</div><br>
                            <div>In addition, there are some options to handle the ranking results:</div>
                            <br><div style="text-align: center;"><img src="images/help/second_1.png" style=" width: 100%;"></div>
                            <div style="font-style: italic; font-size: 11px; text-align: center;">Figure 4: Multiple options to filter and manage the ranking results</div><br>
                            <br><div style="font-style: italic; font-weight: bold;">Which kind of information is contained within the ranking?</div>
                            <br><div>This ranking contains a list of attributes for every biological term: GO term id, GO term name, Information content (IC), Adjusted P-value, Frequency and Groups of genes.</div>
                            <br><div>The increasing order of the ranking is based on the <span style="font-style: italic;">Frequency</span> attribute and it represents the number of groups of genes with which a biological term is associated. That is, a biological term and a group of genes are associated if the term appears in the enrichment analysis results belonging to the group of genes. The list of these groups of genes is shown in the attribute Groups. The attribute <span style="font-style: italic;">Information content (IC)</span> can be used to measure how specific and informative a biological term is.</div>

                            <br><br>
                            <div style="font-style: italic; font-weight: bold;">It is possible to modify the original ranking?</div>
                            <br><div>Once a ranking has been generated, the user can filter it using a combination of the following parameters: Information content (IC), LFP (Low-Frequency Percentage), HFP (High-Frequency Percentage) and P-value Cut-off.</div>
                            <br><div>For example, the user could eliminate biological terms with an IC greater than a certain threshold to focus on the more specific terms from an ontological point of view.</div>
                            <br><div>The Low-Frequency Percentage (LFP) is used to detect terms that appear in a low number of groups of genes, which are classified as LF (Low-Frequency) terms. If a term has a frequency greater than the High-Frequency Percentage (HFP) it is considered a HF (High-Frequency) term. Both LF and HF terms are colored in the filtered ranking: <span style="color: green; font-weight: bold;">green</span> for the former and <span style="color: red; font-weight: bold;">red</span> for the latter.</div>
                            <br><div>Finally, the p-value filtering parameter helps users to remove the enrichment results with the least biological relevance.</div>

                            <br><br>
                            <div style="font-style: italic; font-weight: bold;">Can I save different versions of the ranking?</div>
                            <br><div>Of course, every combination of the filtering options could lead to a different version, which can be stored by BIGO, Furthermore, BIGO provides the ability to compare saved rankings according
                                to the global number of terms, the number of HF and LF terms, etc.</div>
                        </div>
                    </div>

                    <a name="third">&nbsp;</a>

                    <div class="row" style="margin: 6% 8% 4% 8%; text-align: justify;">
                        <div class="col-md-12">
                            <h4 style="text-align: left;">Third step: Network generator</h4>
                            <hr>                            
                            <div>This is the final phase in BIGO's sequential workflow, and its objective is to extract high-level relationships between groups of genes from the rankings and display them visually. </div>
                            <br><div style="text-align: center;"><img src="images/help/third_1.png" style=" width: 100%;"></div>
                            <div style="font-style: italic; font-size: 11px; text-align: center;">Figure 5: Representation of the networks to be generated from the saved and original rankings.</div><br>
                            <br><div style="text-align: center;"><img src="images/help/third_2.png" style=" width: 60%;"></div>
                            <div style="font-style: italic; font-size: 11px; text-align: center;">Figure 6: Final network from the analysis</div><br>
                            <br><br>
                            <div style="font-style: italic; font-weight: bold;">Can I use any ranking to generate a network?</div>
                            <br><div>Yes. Every saved ranking generated by a previous process can be used to generate a network in which a node represents a group of genes and an edge connects two nodes if they share biological terms extracted from the enrichment analysis. The value on the edge represents the percentage of shared biological terms.</div>

                            <br><br>
                            <div style="font-style: italic; font-weight: bold;">What is the aim of these networks?</div>
                            <br><div>By using these networks, users can highlight different subgraphs in which the nodes are highly interrelated or discover that two disjoint groups of genes, each presumably associated with a different biological category, have interesting biological terms in common.</div>
                            <br><div>After a network is generated, it can be visualized as an interactive graph. By clicking on a node in this graph, the user can access additional information about the biological terms and genes related to that group of genes. By clicking on an edge, the user can access additional information about the biological terms and genes shared by the two groups of genes that are connected. Furthermore, the user can change the form of the graph and zoom in or out.</div>

                            <br><br>
                            <div style="font-style: italic; font-weight: bold;">It is possible to modify the network?</div>
                            <br><div>To improve the visualization of the graph, it can be filtered using at least one of the following options:</div>
                            <br><div>
                                <ul>
                                    <li><span style="font-weight: bold;">Min. Percentage:</span> Edges with a percentage less than this value are removed from the graph.</li>
                                    <li><span style="font-weight: bold;">Max. Percentage:</span> Edges with a percentage greater than this value are removed from the graph.</li>
                                </ul>
                            </div>
                        </div>
                    </div>




                </div>              
            </div>
        </article>
        <jsp:include page="components/footer.jsp" /> 
    </body>
</html>
