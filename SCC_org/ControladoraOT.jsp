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
            int IDeot = 0;
            int IDOrden = 0;
            
            IDeot = Integer.parseInt(request.getParameter("IDeot"));
            IDOrden = Integer.parseInt(request.getParameter("IDOrden"));
            
            try {
                Dba dba = new Dba();
                dba.conectar();
                
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement oc = conn.prepareStatement("UPDATE orden_trabajo SET ESTADO_ORDEN_TRABAJO_ID=?, Fecha=(SELECT CURDATE()) WHERE IDOrdenTrabajo = ?");
                oc.setInt(1, IDeot);
                oc.setInt(2, IDOrden);
                oc.execute();
                conn.close();
                
            } catch (Exception e) {
                out.print("false");
            }
        %>
    </body>
</html>
