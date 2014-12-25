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
        <script>
            function Retornar() {
                location.href = "Crear Usuario.jsp";
            }
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
            <p id="titulo">Modificar Usuario</p>
            <div id="fondotabla">
                <div id="contenedorforma">
                    </br>
                    <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                        Nombre de Usuario:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input type="text" name="nombre_usuario" maxlength="20" class="validate[required] text-input input-medium" value="<%=request.getParameter("Nombre")%>" />	
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
                    <%
                        String pass = "";
                        try {
                            Dba dba = new Dba();
                            dba.conectar();
                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                            PreparedStatement ps = conn.prepareStatement("SELECT Password FROM usuario where IDUsuario=?");
                            ps.setInt(1, Integer.parseInt(request.getParameter("Llave")));
                            ps.execute();
                            ResultSet rs = ps.getResultSet();

                            while (rs.next()) {
                                Blob blob = rs.getBlob(1);
                                InputStream is = blob.getBinaryStream();
                                BufferedReader br = new BufferedReader(new InputStreamReader(is));
                                StringBuilder contrasena = new StringBuilder();
                                String line;
                                while ((line = br.readLine()) != null) {
                                    contrasena.append(line);
                                }
                                pass = contrasena.toString();
                                is.close();
                            }
                            
                    %>
                    Contraseña:
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-lock"></i></span>
                        <input type="password" class="validate[required] text-input" name="password_usuario" value="<%=pass%>" />	
                        <%
                                ps.close();
                                conn.close();
                            } catch (Exception ex) {
                                System.out.println("SQLException: " + ex.getMessage());
                            }
                        %>
                    </div>
                    </br>
                    </br>
                    <strong>Estado:</strong>
                    </br>
                    <label class="inline radio">
                        <input type="radio" name="estado" value="Activo" id="estado_activo" checked="checked" />
                        Activo</label>
                    <label class="inline radio">
                        <input type="radio" name="estado" value="Inactivo" id="estado_inactivo" />
                        Inactivo</label>
                    </br>   
                    </br>
                    <input name="btn_modificar" type="submit" class="btn btn-primary" value="Guardar Cambios" />
                    <input name="btn_cancelar" type="button" value="Cancelar" class="btn" onclick="Retornar();" />
                </form>
                <!-- Conexion BD !-->
                <%

                    if (request.getParameter("btn_modificar") != null) {
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

                            String passenc = request.getParameter("password_usuario");
                            if (!request.getParameter("password_usuario").equals(pass)) {

                                PreparedStatement enc = conn.prepareStatement("SELECT MD5(?)");
                                enc.setString(1, request.getParameter("password_usuario"));
                                enc.execute();
                                ResultSet s = enc.getResultSet();

                                while (s.next()) {
                                    passenc = s.getString(1);
                                }
                                enc.close();
                            }

                            PreparedStatement ps1 = conn.prepareStatement("UPDATE usuario SET Nombre=?,Estado=?, ROL_IDRol=?, Password=? WHERE IDUsuario=?");
                            ps1.setString(1, request.getParameter("nombre_usuario"));
                            int estadoactual = 0;
                            if (request.getParameter("estado").equals("Inactivo")) {
                                estadoactual = 1;
                            }
                            ps1.setInt(2, estadoactual);
                            ps1.setInt(3, idrol);
                            ps1.setString(4, passenc);
                            ps1.setInt(5, Integer.parseInt(request.getParameter("Llave")));

                            if (ps1.execute() == false) {
                                out.print("<script>alert('El usuario fue modificado correctamente')</script>");
                                out.print("<script>location.href = 'Crear Usuario.jsp';</script>");
                            }

                            conn.commit();
                            ps1.close();
                            conn.close();
                        } catch (Exception ex) {
                            System.out.println("SQLException: " + ex.getMessage());

                        }
                    }
                %>

            </div>	
        </div>	
    </body>
</html>
