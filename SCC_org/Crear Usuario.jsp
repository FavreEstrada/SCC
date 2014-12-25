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
                width: 40%;
                margin-left: auto;
                margin-right:auto;
                text-align:center;
                padding: 30px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="Menu.jsp" flush="false"></jsp:include>
            </br>
            </br>
            </br>
            <p id="titulo">Crear Nuevo Usuario</p>
            <div id="fondotabla">
                <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                    <div id="contenedorforma">
                        </br>
                        Nombre de Usuario: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input type="text" name="nombre_usuario" value="" class="validate[required] text-input input-medium" maxlength="20" placeholder="Nombre del Usuario" />	
                        </div>
                        </br>
                        </br>
                        Tipo de Usuario:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-list"></i></span>
                            <select name="tipo_usuario" class="input-medium">
                            <%
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                    PreparedStatement ps = conn.prepareStatement("SELECT Nombre FROM rol where Estado=0");
                                    ps.execute();
                                    ResultSet rs = ps.getResultSet();
                                    while (rs.next()) {
                            %>
                            <option><%=rs.getString(1)%></option>
                            <%}
                                    ps.close();
                                    conn.close();
                                } catch (Exception ex) {
                                    System.out.println("SQLException: " + ex.getMessage());
                                }
                            %>
                        </select>
                    </div>   
                    </br>   
                    </br>
                    Contraseña:
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-lock"></i></span>
                        <input type="password" name="password_usuario" value="" class="validate[required] text-input input-medium" placeholder="Contraseña" />	
                    </div>
                    </br>
                    </br>
                    <input name="btn_crear" class="btn btn-primary" type="submit" value="Guardar" />
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

                        PreparedStatement ps = conn.prepareStatement("SELECT IDRol FROM rol WHERE Nombre=?");
                        ps.setString(1, request.getParameter("tipo_usuario"));
                        ps.execute();

                        ResultSet set = ps.getResultSet();
                        int idrol = 0;

                        while (set.next()) {
                            idrol = Integer.parseInt(set.getString(1));
                        }
                        ps.close();

                        //Query de Encriptacion
                        PreparedStatement enc = conn.prepareStatement("SELECT MD5(?)");
                        enc.setString(1, request.getParameter("password_usuario"));
                        enc.execute();
                        ResultSet s = enc.getResultSet();
                        String passenc = "";
                        while (s.next()) {
                            passenc = s.getString(1);
                        }
                        enc.close();

                        PreparedStatement ps1 = conn.prepareStatement("INSERT INTO usuario (Nombre, Estado, ROL_IDRol, Password) VALUES(?,?,?,?)");
                        ps1.setString(1, request.getParameter("nombre_usuario"));
                        ps1.setInt(2, 0);
                        ps1.setInt(3, idrol);
                        ps1.setString(4, passenc);
                        if (ps1.execute() == false) {
                            out.print("<script>alert('El usuario fue creado correctamente')</script>");
                        }

                        ps1.close();
                        conn.close();

                    } catch (Exception ex) {
                        System.out.println("SQLException: " + ex.getMessage());

                    }
                }
            %>

            <p id="titulo">Usuarios Existentes</p>
            <table id="tabla" class="tableWithFloatingHeader stock tablesorter">
                <thead>
                    <tr>
                        <th>Nombre del Usuario</th>
                        <th>Tipo de Usuario</th>
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

                            PreparedStatement ps = conn.prepareStatement("SELECT u.IDUsuario, u.Nombre, u.Estado, u.ROL_IDRol, r.Nombre FROM usuario u, rol r WHERE u.ROL_IDRol=r.IDRol ");
                            ps.execute();
                            ResultSet rs = ps.getResultSet();
                            String llave = "";
                            String nombre = "";
                            String tipo = "";
                            String estado = "";

                            while (rs.next()) {
                                llave = rs.getString(1);
                    %>
                    <tr>
                        <td><%= nombre = rs.getString(2)%></td>
                        <td><%= tipo = rs.getString(5)%></td>
                        <%
                            estado = rs.getString(3);
                            if (estado.equals("0")) {
                                estado = "Activo";
                            } else {
                                estado = "Inactivo";
                            }%>
                        <td><%=estado%></td>
                        <td><a href="Modificar Usuario.jsp?Llave=<%=llave%>&Nombre=<%=nombre%>"></a></td>
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
    </body>
</html>
