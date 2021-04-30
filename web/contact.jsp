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
        <% session.setAttribute("active", "contact");%>
        <jsp:include page="components/header.jsp" />

        <article style="margin-top: 30px;">
            <div class="container">
                <!-- Breadcrumb -->
                <ul id="breadcrumb">
                    <li><a href="index.jsp" title="Home"><img src="images/home.gif" alt="Home" class="home" id="cite" /></a></li>
                    <li>Contact us</li>
                </ul>
                <br>

                <!-- Caja -->
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div class="row" style="margin: 3% 8% 3% 8%;">
                        <div class="col-md-3" style="text-align: center;">
                            <img src="images/contact/contact.jpg" style="width: 100%; padding-top: 30px;">
                        </div>
                        <div class="col-md-9" style="padding-top: 20px;">
                            <h2>Contact us</h2> 
                            <h5 style="color: #999999; font-weight: lighter;">Need help? If you need technical information or to resolve doubts about BIGO this is the right place to get answers. You can also provide suggestions. Your feedback is important to us.</h5>
                        </div>   
                    </div> 

                    <hr style="margin: 0% 8% 0% 8%;">  

                    <div class="row" style="margin: 4% 8% 0% 8%;">                                        
                        <div class="col-md-2" style="text-align: center;">
                            <img src="images/contact/contact-form.png" style="width: 100%;">
                        </div>
                        <div class="col-md-10" style="padding-top: 20px;">
                            <span style="font-weight: bold; font-size: 16px;">Personal contact</span>
                            <p style="margin-top: 10px; margin-bottom: 75px;">You can also contact us personally by email. <br><a href="#" data-toggle="modal" data-target=".bd-example-modal-sm">Contact us personally</a> <span style="font-size: 12px; color:#337ab7;">&#9658;</span></p>
                            <div class="modal fade bd-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" id="mySmallModalLabel">Personal contact</h4>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <p style="text-align: center;"><img src="images/contact/upo.JPG" style="width: 50%;"></p>
                                            <p style="margin-top: 30px;">Intelligent Data Analysis Group<br>
                                                Universidad Pablo de Olavide - UPO<br>
                                                Ctra. de Utrera, km 1<br>
                                                41013 Sevilla<br></p>
                                            <p style=" margin-bottom: 20px;">email: <a href="mailto:alopfer1@upo.es">alopfer1(at)upo(dot).es</a></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>   
                    </div> 

                    <hr style="margin: 0% 8% 0% 8%;">  


                    <div class="row" style="margin: 4% 8% 10% 8%;">                                        
                        <div class="col-md-2" style="text-align: center;">
                            <img src="images/contact/personal-contact.png" style="width: 100%;">
                        </div>
                        <div class="col-md-10" style="padding-top: 20px;">
                            <span style="font-weight: bold; font-size: 16px;">Social networks</span>
                            <p style="margin-top: 10px;">Finally, you can provide suggestions or ask questions in our social networks.</p>
                            <p><a href="https://www.linkedin.com/groups/8261600" target="_blank"><img src="images/linkedin.gif" style="width: 30px;"></a> <a href="https://twitter.com/bigodatai" target="_blank"><img src="images/twitter.gif" style="width: 30px;"></a></p>
                        </div>   
                    </div> 
                </div>
            </div>              
        </article>
        <jsp:include page="components/footer.jsp" /> 
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </body>
</html>
