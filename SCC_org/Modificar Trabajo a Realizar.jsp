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
                location.href = "Agregar Trabajo a Realizar.jsp";
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

        </style>
    </head>

    <body>
        <div class="container">
            <div class="row-fluid">
                <div class="span12">
                    <jsp:include page="Menu.jsp" flush="false"></jsp:include>
                        </br>
                        </br>
                        <p id="titulo">Modificar Trabajo a Realizar</p>
                        <div id="fondotabla">
                            <div id="contenedorforma">
                                </br>
                                <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                <%
                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                        PreparedStatement tr = conn.prepareStatement("SELECT tr.Nombre, tr.Descripcion, tr.Pago, tr.Precio, s.Nombre"
                                                + " FROM trabajo_realizar tr, servicio s WHERE tr.ID=? AND tr.SERVICIO_ID = s.ID");
                                        tr.setInt(1, Integer.parseInt(request.getParameter("Llave")));
                                        tr.execute();
                                        ResultSet trrs = tr.getResultSet();
                                        while (trrs.next()) {
                                %>
                                Nombre:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="nombre" type="text" class="validate[required] text-input input-large" maxlength="50" value="<%= trrs.getString(1)%>">
                                </div>
                                </br>
                                </br>
                                Descripción:<textarea name="descripcion" maxlength="50" placeholder="Descripción"><%= trrs.getString(2)%></textarea>
                                </br>   
                                </br>
                                <%
                                    String pag = trrs.getString(3);
                                    String op = "";
                                    if (pag.equals("0")) {
                                        pag = "Si";
                                        op = "No";
                                    } else {
                                        pag = "No";
                                        op = "Si";
                                    }
                                %>
                                Requiere Pago:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="pago" name="pago" class="input-small">
                                        <option value="<%=pag%>" selected="true"><%=pag%></option>
                                        <option value="<%=op%>"><%=op%></option>
                                    </select>
                                </div>
                                </br>
                                </br>

                                Precio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="precio" placeholder="Precio" class="input-small" type="text" id="prec" value="<%=trrs.getString(4)%>"  pattern="^\d*(\.\d{2}$)?" size="9" class="validate[required] text-input" />
                                </div>
                                </br>
                                </br>

                                <%}
                                    } catch (Exception ex) {
                                        System.out.println("SQL MTRABREA: " + ex.getMessage());
                                    }
                                %>
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
                                <input name="btn_modificar" class="btn btn-primary" type="submit" value="Guardar Cambios" />
                                <input name="btn_cancelar" type="button" class="btn" value="Cancelar" onclick="Retornar();" />
                            </form>
                            <%
                                if (request.getParameter("btn_modificar") != null) {

                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                        PreparedStatement ps = conn.prepareStatement("UPDATE trabajo_realizar SET Nombre=?, Descripcion=?, Pago=?, Estado=?, Precio=? WHERE ID=?");
                                        String nombre = request.getParameter("nombre");
                                        String des = request.getParameter("descripcion");
                                        ps.setString(1, nombre.toUpperCase());
                                        ps.setString(2, des.toUpperCase());
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
                                        ps.setDouble(5, Double.parseDouble(request.getParameter("precio")));
                                        ps.setInt(6, Integer.parseInt(request.getParameter("Llave")));

                                        if (ps.execute() == false) {
                                            out.print("<script>alert('El Trabajo a Realizar fue actualizado')</script>");
                                            out.print("<script> location.href = 'Agregar Trabajo a Realizar.jsp' </script>");
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
