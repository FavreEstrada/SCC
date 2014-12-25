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
                PreparedStatement ps = conn.prepareStatement("SELECT ID FROM personeria WHERE Tipo=?");
                ps.setString(1, request.getParameter("tipoPersoneria"));
                ps.execute();
                ResultSet set = ps.getResultSet();
                int idpersoneria = 0;

                while (set.next()) {
                    idpersoneria = Integer.parseInt(set.getString(1));
                }
                ps.close();
                PreparedStatement ps1 = conn.prepareStatement("SELECT ID, Tipo FROM identificacion WHERE PERSONERIA_ID=?");
                ps1.setInt(1, idpersoneria);
                ps1.execute();
                ResultSet rs = ps1.getResultSet();
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