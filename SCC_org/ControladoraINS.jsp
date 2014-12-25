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
            String pn = request.getParameter("PN");
            String sn = request.getParameter("SN");
            String pa = request.getParameter("PA");
            String sa = request.getParameter("SA");
            String empresa = request.getParameter("empresa");
            String representante = request.getParameter("representante");
            String cargo = request.getParameter("cargo");
            String barrio = request.getParameter("barrio");
            String telefono = request.getParameter("telefono");
            String servicio = request.getParameter("servicio");
            String direccion = request.getParameter("direccion");
            String tecnico = request.getParameter("tecnico");
            String prioridad = request.getParameter("prioridad");
            String tipo = request.getParameter("tipo");

            int tel = 0;
            int temp = 1;
            if (tipo.equals("natural")) {
                empresa = "";
                representante = "";
                cargo = "";
            } else {
                pn = "";
                sn = "";
                pa = "";
                sa = "";
                temp = 2;
            }

            String tel2 = "";
            int telint = 0;
            if (!telefono.equals("")) {
                for (int i = 0; i < telefono.length(); i++) {
                    if (telefono.charAt(i) != '-') {
                        tel2 += telefono.charAt(i);
                    }
                }
                tel = Integer.parseInt(tel2);
            }

            try {
                Dba dba = new Dba();
                dba.conectar();

                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement fec = conn.prepareStatement("SELECT CURDATE()");
                fec.execute();
                ResultSet rsfec = fec.getResultSet();

                String fecha = "";
                while (rsfec.next()) {
                    fecha = rsfec.getString(1);
                }
                fec.close();

                PreparedStatement ins = conn.prepareStatement("INSERT INTO instalacion (Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                        + "Segundo_Apellido, Nombre_Empresa, Representante, Cargo, Tipo, Fecha, Barrio, Telefono, Servicio, Direccion, Tecnico, Prioridad)"
                        + " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
                ins.setString(1, pn.toUpperCase());
                ins.setString(2, sn.toUpperCase());
                ins.setString(3, pa.toUpperCase());
                ins.setString(4, sa.toUpperCase());
                ins.setString(5, empresa.toUpperCase());
                ins.setString(6, representante.toUpperCase());
                ins.setString(7, cargo.toUpperCase());
                ins.setInt(8, temp);
                ins.setString(9, fecha);
                ins.setString(10, barrio);
                ins.setInt(11, tel);
                ins.setString(12, servicio);
                ins.setString(13, direccion.toUpperCase());
                ins.setString(14, tecnico);
                ins.setString(15, prioridad);
                ins.execute();
                ins.close();
                conn.close();
            } catch (Exception ex) {
                System.out.println("SQL: " + ex.getMessage());
                out.print("false");
            }

        %>
    </body>
</html>