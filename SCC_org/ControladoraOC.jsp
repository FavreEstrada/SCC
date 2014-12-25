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
            int IDec = 0;
            int IDoc = 0;
            
            IDoc = Integer.parseInt(request.getParameter("idoc"));
            IDec = Integer.parseInt(request.getParameter("ides"));
            
            try {
                Dba dba = new Dba();
                dba.conectar();
                
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement oc = conn.prepareStatement("UPDATE orden_cobro SET NombreCobrador=?, ESTADO_COBRO_ID=? WHERE IDOrdenCobro = ?");
                oc.setString(1, session.getAttribute("s_user").toString());
                oc.setInt(2, IDec);
                oc.setInt(3, IDoc);
                oc.execute();
                conn.close();
                
            } catch (Exception e) {
                out.print("false");
            }
        %>
    </body>
</html>
