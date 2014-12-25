<%-- 
    Document   : Autenticacion
    Created on : Ene 16, 2013, 7:26:28 PM
    Author     : Favré Estrada
--%>

<%@page import="BD.OC"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="BD.Dba"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sistema de Control de Clientes</title>
    </head>
    <body>
        <%
            try {
                Dba dba = new Dba();
                dba.conectar();
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement ps = conn.prepareStatement("SELECT IDUsuario, s.Nombre, s.Estado, Password, rol.Nombre from usuario s, rol WHERE s.Nombre=? "
                        + "AND s.ROL_IDRol = rol.IDRol");
                ps.setString(1, request.getParameter("usuario_id"));
                ps.execute();

                String pass = "";
                PreparedStatement ps1 = conn.prepareStatement("SELECT MD5(?)");
                ps1.setString(1, request.getParameter("usuario_pass"));
                ps1.execute();
                ResultSet rs1 = ps1.getResultSet();

                while (rs1.next()) {
                    pass = rs1.getString(1);
                }
                ps1.close();

                ResultSet rs = ps.getResultSet();
                String IDUsuario = "";
                String usuario = "";
                String password = "";
                String estado = "";
                String rol = "";

                while (rs.next()) {
                    IDUsuario = rs.getString(1);
                    usuario = rs.getString(2);
                    estado = rs.getString(3);
                    password = rs.getString(4);
                    rol = rs.getString(5);

                }
                String centinela = "n";
                if (request.getParameter("usuario_id").equals(usuario) && pass.equals(password)) {
                    if (estado.equals("0")) {
                        centinela = "s";
                    } else {
                         out.print("<script>alert('El usuario no existe')</script>");
                         out.print("<script>location.href = 'index.jsp' </script>");
                    }
                }
                if (centinela.equals("s")) {
                    session.setAttribute("s_user", request.getParameter("usuario_id"));
                    session.setAttribute("s_pass", pass);
                    session.setAttribute("s_ID", IDUsuario);
                    session.setAttribute("s_Rol", rol);
                    response.sendRedirect("Principal.jsp");
                    OC oc = new OC();
                    oc.revisarOrdenes();
                } else {
                    out.print("<script>alert('Datos Incorrectos')</script>");
                    out.print("<script>location.href = 'index.jsp' </script>");
                }

                ps.close();
                conn.close();

            } catch (Exception ex) {
                System.out.println("SQL: " + ex.getMessage());
            }
        %>
    </body>
</html>
