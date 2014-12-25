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
                $('#tabla tr').each(function (){
                    var est = $(this).find("td:first").text();
                    if (est === "ACTIVO"){
                        $(this).find("a").prop("href","");
                    }
                    if (est === "EN MORA"){
                        $(this).find("a").prop("href","");
                    }
                    if (est === "INACTIVO"){
                        $(this).find("a").prop("href","");
                    }
                });
            });
        </script>

        <style type="text/css">

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                width:70%;
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
                        <p id="titulo">Agregar Nuevo Estado General del Cliente</p>
                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                <div id="contenedorforma">
                                    </br>
                                    Estado:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input name="nombre_estado" class="validate[required] text-input input-large" maxlength="20" type="text" placeholder="Nombre del Estado">
                                    </div>
                                    </br>
                                    </br>
                                    Descripción:<textarea name="descripcion" maxlength="50" placeholder="Descrición"></textarea>
                                    </br>   
                                    </br>
                                    <strong>Estado:</strong>
                                    </br>
                                    <label class="inline radio">
                                        <input type="radio" name="estado" value="Activo" id="estado_activo" checked/>
                                        Activo</label>
                                    <label class="inline radio">
                                        <input type="radio" name="estado" value="Inactivo" id="estado_inactivo" />
                                        Inactivo</label>
                                    </br>   
                                    </br>
                                    <input name="btn_crear" type="submit" class="btn btn-primary" value="Guardar" />
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

                                    PreparedStatement ps = conn.prepareStatement("INSERT INTO estado_general_cliente (Nombre, Descripcion, Estado) VALUES(?,?,?)");
                                    String nombreestado = request.getParameter("nombre_estado");
                                    String descripcion = request.getParameter("descripcion");
                                    ps.setString(1, nombreestado.toUpperCase());
                                    ps.setString(2, descripcion.toUpperCase());
                                    int estadoactual = 0;
                                    if (request.getParameter("estado").equals("Inactivo")) {
                                        estadoactual = 1;
                                    }
                                    ps.setInt(3, estadoactual);

                                    if (ps.execute() == false) {
                                        out.print("<script>alert('El estado fue creado correctamente')</script>");
                                    }
                                    ps.close();
                                    conn.close();
                                } catch (Exception ex) {
                                    System.out.println("SQLException: " + ex.getMessage());

                                }
                            }
                        %>

                        <p id="titulo">Estados Generales del Cliente Existentes</p>
                        <table id="tabla" class="tableWithFloatingHeader stock tablesorter">
                            <thead>
                                <tr>
                                    <th>Nombre del Estado</th>
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

                                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM estado_general_cliente ORDER BY (Nombre)");
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
                                    <td><%= descripcion = rs.getString(3)%></td>
                                    <%
                                        estado = rs.getString(4);
                                        if (estado.equals("0")) {
                                            estado = "Activo";
                                        } else {
                                            estado = "Inactivo";
                                        }%>
                                    <td><%=estado%></td>
                                    <td><a href="Modificar Estado General Cliente.jsp?Llave=<%=llave%>&Nombre=<%=nombre%>&Descrip=<%=descripcion%>"></a></td>
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
