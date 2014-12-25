<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>

<%if (session.getAttribute("s_user") == null) {
        out.print("<script>location.href = 'index.jsp';</script>");
    }%>


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
        <link href="SpryAssets/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css" media="screen"/>
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery-maskedinput.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }
            });

            jQuery(function($) {
                $("#phone").mask("9999-9999");
            });

            jQuery(function($) {
                $("#celular").mask("9999-9999");
            });

            function Actualizar(id) {
                var cob = $("#" + id + " option:selected").attr("id");
                var cobertura = "SI";
                if (cob == 1) {
                    cobertura = "NO";
                }
                $('#cob').prop("value", cobertura);
            }

        </script>
        <style type="text/css">
            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left: auto;
                margin-right:auto;
                padding: 30px;
                text-align:center;
            }

        </style>
    </head>

    <body>
        <div class="container">
            <jsp:include page="Menu.jsp" flush="false"></jsp:include>
                </br>
                </br>
                </br>
                <div class="row-fluid">
                    <div class="span12">
                        <p id="titulo">Crear Solicitud Rechazada</p>
                        <div id="fondotabla">
                            <form id="forma" class=" form-horizontal" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                <div id="contenedorforma">
                                    </br>
                                    Primer Nombre:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input class="validate[required] text-input input-medium" maxlength="20" name="primer_nombre" type="text" value="" placeholder="Primer Nombre"/>
                                    </div>
                                    Segundo Nombre: 
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input name="segundo_nombre" maxlength="20" class="input-medium" type="text" value="" placeholder="Segundo Nombre"/>
                                    </div>
                                    </br>
                                    </br>
                                    Primer Apellido:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input class="validate[required] text-input input-medium" maxlength="20" name="primer_apellido" type="text" value="" placeholder="Primer Apellido"/>
                                    </div>
                                    Segundo Apellido:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input name="segundo_apellido" maxlength="20" class="input-medium" type="text" value="" placeholder="Segundo Apellido"/>
                                    </div>
                                    </br>
                                    </br>
                                    Barrio o Colonia:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-list"></i></span>
                                        <select name="barriocolonia" id="barrio" class="input-small" onchange="Actualizar(this.id);">
                                            <option>--------</option>
                                        <%
                                            String fecha = "";
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();

                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement ps = conn.prepareStatement("SELECT IDBarriocolonia, Abreviacion, CURDATE(),Cobertura FROM barriocolonia WHERE Estado=0"
                                                        + " ORDER BY (Abreviacion)");
                                                ps.execute();
                                                ResultSet rs = ps.getResultSet();
                                                while (rs.next()) {
                                                    fecha = rs.getString(3);
                                        %>
                                        <option value="<%=rs.getString(1)%>" id="<%=rs.getString(4)%>"><%=rs.getString(2)%></option>
                                        <%}
                                                ps.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Cobertura:<input type="text" id="cob" name="cobertura" class="input-small" readonly="readonly" />
                                </br>
                                </br>
                                Télefono: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="phone" name="telefono" class="input-small" type="tel" value="" size="8" placeholder="Teléfono"/>
                                </div>
                                Celular:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="celular" name="celular" class="input-small" type="tel" placeholder="Celular" value="" size="8"/>
                                </div>
                                </br>
                                </br>
                                Email:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-envelope"></i></span>
                                    <input name="email" maxlength="45" class="input-large" placeholder="Email" type="email" value=""/>
                                </div>
                                </br>
                                </br>
                                Dirección: <textarea class="validate[required] text-input" placeholder="Dirección" maxlength="45" name="direccion"></textarea>
                                </br>
                                </br>
                                <input name="btn_crear" type="submit" class="btn btn-primary" value="Guardar" />
                                <button name="btn_cancelar" type="reset" class="btn">Limpiar</button>
                                </br>
                                </br>
                            </div>
                        </form>
                        <%
                            if (request.getParameter("btn_crear") != null) {
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                    PreparedStatement ps = conn.prepareStatement("INSERT INTO solicitud_rechazada (Primer_Nombre, Segundo_Nombre,"
                                            + " Primer_Apellido, Segundo_Apellido, Direccion, Email,"
                                            + " Telefono, Celular, BARRIOCOLONIA_IDBarriocolonia, USUARIO_IDUsuario, Fecha) "
                                            + "VALUES (?,?,?,?,?,?,?,?,?,?,?)");
                                    String pnombre = request.getParameter("primer_nombre");
                                    String snombre = request.getParameter("segundo_nombre");
                                    String papellido = request.getParameter("primer_apellido");
                                    String sapellido = request.getParameter("segundo_apellido");
                                    String dir = request.getParameter("direccion");
                                    ps.setString(1, pnombre.toUpperCase());
                                    ps.setString(2, snombre.toUpperCase());
                                    ps.setString(3, papellido.toUpperCase());
                                    ps.setString(4, sapellido.toUpperCase());
                                    ps.setString(5, dir.toUpperCase());
                                    ps.setString(6, request.getParameter("email"));
                                    String tel = request.getParameter("telefono");
                                    String tel2 = "";
                                    int telint = 0;
                                    if (!tel.equals("")) {
                                        for (int i = 0; i < tel.length(); i++) {
                                            if (tel.charAt(i) != '-') {
                                                tel2 += tel.charAt(i);
                                            }
                                        }
                                        telint = Integer.parseInt(tel2);
                                    }
                                    ps.setInt(7, telint);

                                    String cel = request.getParameter("celular");
                                    String cel2 = "";
                                    int celint = 0;
                                    if (!cel.equals("")) {
                                        for (int i = 0; i < cel.length(); i++) {
                                            if (cel.charAt(i) != '-') {
                                                cel2 += cel.charAt(i);
                                            }
                                        }
                                        celint = Integer.parseInt(cel2);
                                    }
                                    ps.setInt(8, celint);
                                    ps.setInt(9, Integer.parseInt(request.getParameter("barriocolonia")));
                                    ps.setInt(10, Integer.parseInt(session.getAttribute("s_ID").toString()));
                                    ps.setString(11, fecha);

                                    if (ps.execute() == false) {
                                        out.print("<script>alert('La Solicitud Rechazada fue creada correctamente')</script>");
                                    }
                                    ps.close();
                                    conn.close();

                                } catch (Exception ex) {
                                    System.out.println("SQL: " + ex.getMessage());
                                }
                            }
                        %>
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
