<div class="row">
    <div class="col-md-6">
        <% if (request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("yes") && request.getParameter("demo") != null && request.getParameter("demo").equals("no")) { %>
        <div style="width: 99%; border: 2px solid #0e8ad3; border-radius: 5px; padding-bottom: 10px; padding-left: 5px; padding-right: 5px; padding-top: 0px;">
            <% } %>
            <a href="new_enrichment.jsp?demo=no#new">
                <img src="images/bigo/new_enrichment3.jpg" style="width: 40%;" />
            </a>
            <div>
                <h3>
                    <a href="new_enrichment.jsp?demo=no#new" style="font-size: 22px;">Create a new gene enrichment analysis</a>
                </h3>
            </div>
            <% if (request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("yes") && request.getParameter("demo") != null && request.getParameter("demo").equals("no")) { %>
        </div>
        <% }%>
    </div>
    <div class="col-md-6">
        <% if (request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("yes") && request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
        <div style="width: 99%; border: 2px solid #0e8ad3; border-radius: 5px; padding-bottom: 10px; padding-left: 5px; padding-right: 5px; padding-top: 0px;">
            <% } %>
            <a href="new_enrichment.jsp?demo=yes#new">
                <img src="images/bigo/demo.png" style="width: 40%;" />
            </a>
            <div>
                <h3>
                    <a href="new_enrichment.jsp?demo=yes#new" style="font-size: 22px;">Launch demo</a>
                </h3>
            </div>
            <% if (request.getParameter("enrichment") != null && request.getParameter("enrichment").equals("yes") && request.getParameter("demo") != null && request.getParameter("demo").equals("yes")) { %>
        </div>
        <% }%>
    </div>
</div>
<div class="row" style="margin-top: 50px;">
    <div class="col-md-12">
        For more information <a href="contact.jsp">contact us</a>.
    </div>
</div>





