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
                location.href = "Agregar Identificacion.jsp";
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
                width: 50%;
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
                        <p id="titulo">Modificar Identificación</p>
                        <div id="fondotabla">
                            <div id="contenedorforma">
                                </br>
                                <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                    Tipo de Identificación: 
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input type="text" name="tipo" value="<%=request.getParameter("Nombre")%>" class="validate[required] text-input input-medium" maxlength="45" />	
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

                                                PreparedStatement ps = conn.prepareStatement("SELECT Tipo FROM personeria where Estado=0");
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
                                Descripción:<textarea name="descripcion" maxlength="50" placeholder="Descripción"><%=request.getParameter("Descrip")%></textarea>
                                </br> 
                                </br>
                                <strong>Estado:</strong>
                                </br>
                                <label class="inline radio">
                                    <input type="radio" name="estado" value="Activo" id="estado_activo" checked />
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

                                        PreparedStatement ps = conn.prepareStatement("SELECT ID FROM personeria WHERE Tipo=?");
                                        ps.setString(1, request.getParameter("tipo_personeria"));
                                        ps.execute();

                                        ResultSet set = ps.getResultSet();
                                        int idpersoneria = 0;

                                        while (set.next()) {
                                            idpersoneria = Integer.parseInt(set.getString(1));
                                        }
                                        ps.close();

                                        PreparedStatement ps1 = conn.prepareStatement("UPDATE identificacion SET Tipo=?, Descripcion=?, Estado=?, PERSONERIA_ID=? WHERE ID=?");
                                        String tipo = request.getParameter("tipo");
                                        String des = request.getParameter("descripcion");
                                        ps1.setString(1, tipo.toUpperCase());
                                        ps1.setString(2, des.toUpperCase());
                                        int estadoactual = 0;

                                        if (request.getParameter("estado").equals("Inactivo")) {
                                            estadoactual = 1;
                                        }

                                        ps1.setInt(3, estadoactual);
                                        ps1.setInt(4, idpersoneria);
                                        ps1.setInt(5, Integer.parseInt(request.getParameter("Llave")));
                                        if (ps1.execute() == false) {
                                            out.print("<script>alert('El tipo de identificación fue modificado correctamente')</script>");
                                            out.print("<script>location.href = 'Agregar Identificacion.jsp';</script>");
                                        }
                                        ps1.close();
                                        conn.close();
                                    } catch (Exception ex) {
                                        System.out.println("SQLException: " + ex.getMessage());

                                    }
                                }
                            %>
                        </div>	
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
