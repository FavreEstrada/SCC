<%@page import="BD.Dba"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>

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

            function Precio() {
                var pago = $('#pago').val();
                if (pago == "Si") {
                    $('#P').css("display", "inline");
                }
                else {
                    $('#P').css("display", "none");
                }
            }
        </script>

        <style type="text/css">

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left: auto;
                margin-right:auto;
                text-align:center;
                padding: 30px;
                width: 60%;
            }
            div#P{
                display:none;
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
                        <p id="titulo">Agregar Trabajo a Realizar</p>
                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                <div id="contenedorforma">
                                    </br>
                                    Servicio:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-list"></i></span>
                                        <select name="servicio" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement psser = conn.prepareStatement("SELECT ID, Nombre FROM servicio"
                                                        + " WHERE Estado = 0 ORDER BY (Nombre)");
                                                psser.execute();
                                                ResultSet rser = psser.getResultSet();
                                                while (rser.next()) {
                                        %>
                                        <option value="<%= rser.getString(1)%>"><%= rser.getString(2)%></option>
                                        <%}
                                            } catch (Exception ex) {
                                                System.out.println("SQL TRSER: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                Nombre: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="nombre" type="text" class="validate[required] text-input input-large" placeholder="Trabajo a Realizar" maxlength="50">
                                </div>
                                </br>
                                </br>
                                Descripción:<textarea name="descripcion" maxlength="50" placeholder="Descripción"></textarea>
                                </br>   
                                </br>
                                Requiere Pago:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="pago" name="pago" onchange="Precio();" class="input-small">
                                        <option value="Si">Si</option>
                                        <option selected="true" value="No">No</option>
                                    </select>
                                </div>
                                </br>
                                </br>
                                <div id="P">
                                    Precio:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input name="precio" type="text" id="prec" class="input-small" Placeholder ="Precio" pattern="^\d*(\.\d{2}$)?" size="9" class="validate[required] text-input" />
                                    </div>
                                    </br>
                                    </br>
                                </div>
                                <strong>Estado:</strong>
                                </br>
                                <label class="inline radio">
                                    <input type="radio" name="estado" value="Activo" id="estado_activo" checked="true" />
                                    Activo</label>
                                <label class="inline radio">
                                    <input type="radio" name="estado" value="Inactivo" id="estado_inactivo" />
                                    Inactivo</label>
                                </br>   
                                </br>
                                <input name="btn_crear" class="btn btn-primary" type="submit" value="Crear" />
                                <button type="reset" class="btn">Cancelar</button>
                                </br>
                                </br>
                            </div>
                        </form>
                        <!-- Conexion BD !-->
                        <%

                            if (request.getParameter("btn_crear") != null) {
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                    PreparedStatement ps = conn.prepareStatement("INSERT INTO trabajo_realizar (Nombre, Descripcion, Pago, Estado, SERVICIO_ID, Precio) VALUES(?,?,?,?,?,?)");
                                    String nombre = request.getParameter("nombre");
                                    String desc = request.getParameter("descripcion");
                                    ps.setString(1, nombre.toUpperCase());
                                    ps.setString(2, desc.toUpperCase());
                                    int pago = 1;
                                    if (request.getParameter("pago").equals("Si")) {
                                        pago = 0;
                                    }
                                    ps.setInt(3, pago);

                                    int estadoactual = 0;
                                    if (request.getParameter("estado").equals("Inactivo")) {
                                        estadoactual = 1;
                                    }
                                    ps.setInt(4, estadoactual);
                                    ps.setInt(5, Integer.parseInt(request.getParameter("servicio")));
                                    ps.setDouble(6, Double.parseDouble(request.getParameter("precio")));
                                    if (ps.execute() == false) {
                                        out.print("<script>alert('Fue creado correctamente')</script>");
                                    }
                                    ps.close();
                                    conn.close();
                                } catch (Exception ex) {
                                    System.out.println("SQLException: " + ex.getMessage());

                                }
                            }
                        %>

                        <p id="titulo">Trabajos a Realizar Existentes</p>
                        <table id="tabla" class="tableWithFloatingHeader stock tablesorter">
                            <thead>
                                <tr>
                                    <th>Trabajo a Realizar</th>
                                    <th>Servicio</th>
                                    <th>Descripción</th>
                                    <th>Pago</th>
                                    <th>Precio</th>
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

                                        PreparedStatement ps = conn.prepareStatement("SELECT tr.ID,tr.Nombre,tr.Descripcion,Pago,tr.Estado,s.Nombre,tr.Precio FROM trabajo_realizar tr, servicio s"
                                                + " WHERE tr.SERVICIO_ID=s.ID ORDER BY (tr.Nombre)");
                                        ps.execute();
                                        ResultSet rs = ps.getResultSet();
                                        String llave = "";
                                        String nombre = "";
                                        String descripcion = "";
                                        String pago = "";
                                        String estado = "";
                                        String precio = "";
                                        while (rs.next()) {
                                            llave = rs.getString(1);
                                            precio = rs.getString(7);
                                %>
                                <tr>
                                    <td><%= nombre = rs.getString(2)%></td>
                                    <td><%= rs.getString(6)%></td>
                                    <td><%= descripcion = rs.getString(3)%></td>
                                    <%
                                        pago = rs.getString(4);
                                        if (pago.equals("0")) {
                                            pago = "Si";
                                        } else {
                                            pago = "No";
                                        }
                                        estado = rs.getString(5);
                                        if (estado.equals("0")) {
                                            estado = "Activo";
                                        } else {
                                            estado = "Inactivo";
                                        }

                                    %>
                                    <td><%=pago%></td>
                                    <td><%=precio%></td>
                                    <td><%=estado%></td>
                                    <td><a href="Modificar Trabajo a Realizar.jsp?Llave=<%=llave%>"></a></td>
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
