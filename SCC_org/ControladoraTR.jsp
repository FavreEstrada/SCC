<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Sistema de Control de Clientes</title>
    </head>
    <body>
        <%
            try {
                Dba dba = new Dba();
                dba.conectar();

                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                
                PreparedStatement ps = conn.prepareStatement("SELECT ID,Nombre FROM trabajo_realizar WHERE Estado = 0 AND SERVICIO_ID = ?");
                ps.setString(1, request.getParameter("IDServicio"));
                ps.execute();
                ResultSet rs = ps.getResultSet();
                String ids = "";
                while (rs.next()) {
                    ids += rs.getString(1) + "$" + rs.getString(2) + "#";
                }
                out.print(ids);
                ps.close();
                conn.close();
            } catch (Exception ex) {
                out.print("false");
            }

        %>
    </body>
</html>