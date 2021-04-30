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
                    <li>Privacy</li>
                </ul>
                <br>
                
                <!-- Caja --> 
                <div style="border-radius: 5px; border: 1px solid #cccccc; width: 100%; background-color: #ffffff; margin-top: 5px;">
                    <div class="row" style="margin: 3% 8% 3% 8%;">
                        <div class="col-md-12" style="text-align: justify;">
                            <h2 class="article-title" style="text-align: left; font-size: 30px; ">Privacy</h2> 
                            <p style="color: #999999;">Privacy Policy & Disclaimer.</p>
                            <p style="text-align: justify; margin-top: 50px;">BIGO no almacena los datos que usted carga, las búsquedas, filtrados y resultados obtenidos en la aplicación después de que haya abandonado este sitio.</p>
                            <p style="text-align: justify;">Toda la información mencionada anteriormente se considera de carácter privado y únicamente podrá acceder el propietario de dicha información durante la duración de su sesión en el navegador. Al abandonar el sitio web o al expirar el tiempo de la sesión esta información será eliminada automáticamente.</p>
                            <p style="text-align: justify;">BIGO podrá mantener una serie de registros de uso para intentar planificar y mejorar el uso de los servicios que ofrece esta herramienta. Estos registros serán confidenciales y no estarán disponibles para otros fines o terceros.</p>
                            <p style="text-align: justify;">Los integrantes que componen BIGO no se hacen responsables de las consecuencias sufridas por un acceso ilegítimo de un tercero al acceso de los datos almacenados en nuestros servidores, así como, los datos privados almacenados durante una sesión.</p>
                            <p style="text-align: justify;">BIGO es una herramienta pública y gratuita destinada a cualquier tipo de usuario, esta herramienta hace eso de otros recursos públicos por lo que no se puede garantizar la exactitud de los resultados obtenidos a partir de unos datos originales basados en recursos públicos independientes a la herramienta.</p>
                            <p style="text-align: justify;">Esta herramienta podría utilizar recursos o servicios que pueden estar sujetos a derechos de autor, derechos de propiedad intelectual, patentes u otros que restringen el uso de la misma o la distribución de dichos datos. El usuario final es el único responsable del uso que se le de a esta herramienta, así como, posibles infracciones de derechos.</p>
                            <p style="text-align: justify;">Los integrantes que componen BIGO intentarán mantener la continuidad y mejora de esta herramienta. Sin embargo, no aceptamos la responsabilidad y obligatoriedad de mantener esta herramienta ante la falta de disponibilidad o cualquier tipo de recurso.</p>
                        </div>
                    </div>
                </div>
            </div>
        </article>


        <jsp:include page="components/footer.jsp" /> 
    </body>
</html>
