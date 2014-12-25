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
            int IDoc = 0;
            IDoc = Integer.parseInt(request.getParameter("idoc"));
            
            
            try {
                Dba dba = new Dba();
                dba.conectar();
                
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement oc = conn.prepareStatement("UPDATE orden_cobro SET Fecha_Visita=? WHERE IDOrdenCobro = ?");
                oc.setString(1, request.getParameter("fecha"));
                oc.setInt(2, IDoc);
                oc.execute();
                conn.close();
                
            } catch (Exception e) {
                out.print("false");
            }
        %>
    </body>
</html>
