<nav class="navbar navbar-expand-md fixed-top navbar-light custom-header" style="background-color: white;">
    <a class="navbar-brand" href="index.jsp" style="padding-top: 10px;"><img src="images/logo.gif" class="custom-header-logo" alt="BIGO" /></a>
    <div class="collapse navbar-collapse" id="navbarCollapse">
        <ul class="navbar-nav mr-auto">
            <% if (session.getAttribute("active").equals("home")) { %>
            <li class="nav-item active" style="font-weight: bold; text-decoration: underline;"><a class="nav-link" href="index.jsp">Home</a></li>
                <% } else { %>
            <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <% } %>

            <% if (session.getAttribute("active").equals("bigo")) { %>
            <% if (session.getAttribute("startbigo") != null && session.getAttribute("startbigo").equals("yes")) { %>
            <li class="nav-item active" style="font-weight: bold; text-decoration: underline;"><a class="nav-link" href="bigo.jsp?q=y">Start BIGO</a></li>
            <!--<li class="nav-item active" style="font-weight: bold; text-decoration: underline;"><a class="nav-link" href="new_enrichment.jsp#new">Start BIGO</a></li>-->
                <% } else { %>
            <li class="nav-item active" style="font-weight: bold; text-decoration: underline;"><a class="nav-link" href="bigo.jsp?q=y">Start BIGO</a></li>
                <% } %>
                <% } else { %>
                <% if (session.getAttribute("startbigo") != null && session.getAttribute("startbigo").equals("yes")) { %>            
            <li class="nav-item"><a class="nav-link" href="bigo.jsp?q=n">Start BIGO</a></li>
            <!--<li class="nav-item"><a class="nav-link" href="new_enrichment.jsp#new">Start BIGO</a></li>-->
                <% } else { %>
            <li class="nav-item"><a class="nav-link" href="bigo.jsp?q=n">Start BIGO</a></li>
                <% } %>            
                <% } %>

            <% if (session.getAttribute("active").equals("help")) { %>
            <li class="nav-item active" style="font-weight: bold; text-decoration: underline;"><a class="nav-link" href="help.jsp">Help</a></li>
                <% } else { %>
            <li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
                <% }%>
            
            <% if (session.getAttribute("active").equals("contact")) { %>
            <li class="nav-item active" style="font-weight: bold; text-decoration: underline;"><a class="nav-link" href="contact.jsp">Contact us</a></li>
                <% } else { %>
            <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact us</a></li>
                <% }%>            
        </ul>        
    </div>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
</nav>