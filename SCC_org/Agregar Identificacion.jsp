<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%        if (session.getAttribute("s_user") == null || !session.getAttribute("s_Rol").equals("ADMINISTRADOR")) {
         out.print("<script>location.href = 'index.jsp';</script>");
    }
%>

<!DOCTYPE>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
            response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
            response.setDateHeader("Expires", 0); // Proxies.
        %>
        <title>Sistema de Control de Clientes</title>

        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="SpryAssets/js/jquery.stickytableheaders.js" type="text/javascript"></script>
        <link href="SpryAssets/css/custom.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/css/tablesorter.css" rel="stylesheet" type="text/css" />
        <script>
            jQuery(document).ready(function() {

                // initialize stickyTableHeaders _after_ tablesorter
                $(".tablesorter").tablesorter();
                $("table").stickyTableHeaders();

                $('#tabla tr').click(function() {
                    var href = $(this).find("a").attr("href");
                    if (href) {
                        window.location = href;
                    }
                });
            });
        </script>
        <style type="text/css">

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                width: 50%;
                margin-left: auto;
                margin-right:auto;
                text-align:center;
                padding: 30px;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="row-fluid">
                <div class="span12">
                    <jsp:include page="Menu.jsp" flush="false"></jsp:include>
                        </br>
                        </br>
                        </br>
                        <p id="titulo">Agregar Nueva Identificación</p>
                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                <div id="contenedorforma">
                                    </br>
                                    Tipo de Identificación:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input type="text" name="tipo" value="" class="validate[required] text-input input-medium" maxlength="45" placeholder="Tipo de Identificación" />	
                                    </div>
                                    </br>
                                    </br>
                                    Usada en Tipo de Personería:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-list"></i></span>
                                        <select name="tipo_personeria" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement ps = conn.prepareStatement("SELECT ID, Tipo FROM personeria where Estado=0 "
                                                        + "ORDER BY (Tipo)");
                                                ps.execute();
                                                ResultSet rs = ps.getResultSet();
                                                while (rs.next()) {
                                        %>
                                        <option value="<%= rs.getString(1)%>"><%=rs.getString(2)%></option>
                                        <%}
                                                ps.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Personeria: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>   
                                </br>   
                                </br>
                                Descripción:<textarea name="descripcion" maxlength="50" placeholder="Descripción"></textarea>
                                </br> 
                                </br>
                                <input name="btn_crear" type="submit" class="btn btn-primary" value="Crear" />
                                <button type="reset" class="btn">Cancelar</button>
                                </br>
                                </br>
                            </div>
                        </form>
                        <!-- Conexion BD !-->
                        <%  if (request.getParameter("btn_crear") != null) {
                                try {

                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                    boolean existe = false;

                                    String tipo = request.getParameter("tipo");

                                    PreparedStatement id = conn.prepareStatement("SELECT ID FROM identificacion"
                                            + " WHERE Tipo=? AND PERSONERIA_ID=?");
                                    id.setString(1, tipo.toUpperCase());
                                    id.setInt(2, Integer.parseInt(request.getParameter("tipo_personeria")));
                                    id.execute();
                                    ResultSet idrs = id.getResultSet();
                                    String per = "";
                                    while (idrs.next()) {
                                        per = idrs.getString(1);
                                    }
                                    id.close();

                                    if (per.equals("")) {

                                        PreparedStatement ps1 = conn.prepareStatement("INSERT INTO identificacion (Tipo, Descripcion, Estado, PERSONERIA_ID) VALUES(?,?,?,?)");
                                        String descripcion = request.getParameter("descripcion");
                                        ps1.setString(1, tipo.toUpperCase());
                                        ps1.setString(2, descripcion.toUpperCase());
                                        ps1.setInt(3, 0);
                                        ps1.setInt(4, Integer.parseInt(request.getParameter("tipo_personeria")));
                                        if (ps1.execute() == false) {
                                            out.print("<script>alert('La identificacion fue creada correctamente')</script>");
                                        }
                                        ps1.close();
                                    } else {
                                        out.println("<script>alert('Ya existe');</script>");
                                    }

                                    conn.close();
                                } catch (Exception ex) {
                                    System.out.println("SQL ID: " + ex.getMessage());
                                }
                            }
                        %>

                        <p id="titulo">Identificaciones Existentes</p>
                        <table id="tabla" class="tableWithFloatingHeader stock tablesorter">
                            <thead>
                                <tr>
                                    <th>Tipo de Identificación</th>
                                    <th>Asociada a Tipo de Personería</th>
                                    <th>Descripción</th>
                                    <th>Estado</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                        PreparedStatement ps = conn.prepareStatement("SELECT id.ID, id.Tipo, id.Descripcion, id.Estado, per.Tipo FROM identificacion AS id, personeria AS per WHERE id.PERSONERIA_ID=per.ID");
                                        ps.execute();
                                        ResultSet rs = ps.getResultSet();
                                        String llave = "";
                                        String nombre = "";
                                        String descripcion = "";
                                        String estado = "";

                                        while (rs.next()) {
                                            llave = rs.getString(1);
                                %>
                                <tr>
                                    <td><%= nombre = rs.getString(2)%></td>
                                    <td><%= rs.getString(5)%></td>
                                    <td><%=descripcion = rs.getString(3)%></td>
                                    <%
                                        estado = rs.getString(4);
                                        if (estado.equals("0")) {
                                            estado = "Activo";
                                        } else {
                                            estado = "Inactivo";
                                        }%>
                                    <td><%=estado%></td>
                                    <td><a href="Modificar Identificacion.jsp?Llave=<%=llave%>&Nombre=<%=nombre%>&Descrip=<%=descripcion%>"></a></td>
                                </tr>
                                <%}
                                        ps.close();
                                        conn.close();
                                    } catch (Exception ex) {
                                        System.out.println("SQLException: " + ex.getMessage());
                                    }
                                %>

                        </table>
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
