<%-- 
    Document   : ControladoraOC
    Created on : Mar 24, 2013, 4:15:16 PM
    Author     : Favré Estrada
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%

            int IDIns = Integer.parseInt(request.getParameter("IDIns"));
            String estado = request.getParameter("estado");

            try {
                Dba dba = new Dba();
                dba.conectar();

                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement ot = conn.prepareStatement("UPDATE instalacion SET Estado=? WHERE ID = ?");
                ot.setString(1, estado);
                ot.setInt(2, IDIns);
                ot.execute();
                ot.close();
                conn.close();

            } catch (Exception e) {
                out.print("false");
            }
        %>
    </body>
</html>
