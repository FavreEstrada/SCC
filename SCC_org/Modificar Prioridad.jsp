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
        <script>
            function Retornar() {
                location.href = "Agregar Prioridad.jsp";
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
                        <p id="titulo">Modificar Estado de Prioridad</p>
                        <div id="fondotabla">
                            <div id="contenedorforma">
                                </br>
                                <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                    Tipo de Prioridad:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input name="tipo" class="validate[required] text-input input-medium" maxlength="20" type="text" value="<%= request.getParameter("Nombre")%>">
                                </div>
                                </br>
                                </br>
                                Descripción:<textarea name="descripcion" maxlength="50" placeholder="Descripción"><%= request.getParameter("Descrip")%></textarea>
                                </br>   
                                </br>
                                <strong>Estado:</strong>
                                </br>
                                <label class="inline radio">
                                    <input type="radio" name="estado" value="Activo" id="estado_activo" checked />
                                    Activo</label>
                                <label class="radio inline">
                                    <input type="radio" name="estado" value="Inactivo" id="estado_inactivo" />
                                    Inactivo</label>
                                </br>   
                                </br>
                                <input name="btn_modificar" type="submit" class="btn btn-primary" value="Guardar Cambios" />
                                <input name="btn_cancelar" type="button" value="Cancelar" class="btn" onclick="Retornar();" />
                            </form>

                            <%
                                if (request.getParameter("btn_modificar") != null) {

                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                        PreparedStatement ps = conn.prepareStatement("UPDATE prioridad SET Nombre=?,Descripcion=?,Estado=? WHERE ID=?");
                                        String tipo = request.getParameter("tipo");
                                        String des = request.getParameter("descripcion");
                                        ps.setString(1, tipo.toUpperCase());
                                        ps.setString(2, des.toUpperCase());
                                        int estadoactual = 0;
                                        if (request.getParameter("estado").equals("Inactivo")) {
                                            estadoactual = 1;
                                        }
                                        ps.setInt(3, estadoactual);
                                        ps.setInt(4, Integer.parseInt(request.getParameter("Llave")));
                                        if (ps.execute() == false) {
                                            out.print("<script>alert('El estado de prioridad fue actualizado')</script>");
                                             out.print("<script>location.href = 'Agregar Prioridad.jsp';</script>");
                                        }
                                        ps.close();
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
