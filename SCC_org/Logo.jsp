<%-- 
    Document   : Logo
    Created on : May 21, 2013, 12:24:31 AM
    Author     : Favré Estrada
--%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="image/jpeg" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces ="true"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Dba dba = new Dba();
            dba.conectar();
            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

            PreparedStatement ps = conn.prepareStatement("SELECT Logo FROM parametrizacion");
            ps.execute();
            ResultSet rs = ps.getResultSet();
            byte[] buffer = null;
            while (rs.next()) {
                buffer = rs.getBytes(1);
            }
            ps.close();
            conn.close();
            response.setContentType("image/jpeg");
            response.getOutputStream().write(buffer);
            response.getOutputStream().flush();
            response.getOutputStream().close();
            out.clear();
            out = pageContext.pushBody();
        %>
    </body>
</html>
