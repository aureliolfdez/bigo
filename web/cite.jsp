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

        <!-- Own web CSS -->
        <link rel="stylesheet" href="css/style.css">        

        <!--[if IE]>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <![endif]-->

    </head>
    <body style="background-color: #f4f4f4;">
        <% session.setAttribute("active", "none");%>
        <jsp:include page="components/header.jsp" />

        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li>Cite us</li>
                </ul>
                <br>
                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div class="row" style="margin: 3% 8% 3% 8%;">
                        <div class="col-md-2" style="text-align: center;">
                            <img src="images/cite/specific-data.png" style="width: 100px;">
                        </div>
                        <div class="col-md-10" style="padding-top: 20px;">
                            <h2>Cite us</h2> 
                            <h5 style="color: #999999; font-weight: lighter;">If you are using BIGO for your own research, please cite.</h5>
                        </div>   
                    </div>    
                    <div class="row" style="margin-bottom: 12%;">
                        <div class="col-md-12" style="text-align: center;">
                            <hr style="margin: 0% 8% 8% 8%;">                    
                            <p><img src="images/cite/cite.jpg" style="width: 18%;"></p>
                            <h2>To cite BIGO in your publications</h2> 
                            <p style="font-style: italic;">No articles yet.</p>
                        </div>
                    </div>
                </div>              
            </div>
        </article>
        <div style="clear: both;"></div>
        <jsp:include page="components/footer.jsp" /> 
    </body>
</html>
