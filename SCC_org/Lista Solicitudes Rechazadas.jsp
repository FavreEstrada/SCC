<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="BD.Dba"%>
<%@page import="BD.CalcMeses"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
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
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="SpryAssets/js/jquery.stickytableheaders.js" type="text/javascript"></script>
        <link href="SpryAssets/css/custom.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/css/tablesorter.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            $(document).ready(function() {
                // initialize stickyTableHeaders _after_ tablesorter
                $(".tablesorter").tablesorter();
                $("table").stickyTableHeaders();

            });

            function disableid() {
                document.getElementById("empresa").disabled = true;
                document.getElementById("barrio").disabled = true;
                document.getElementById("pn").disabled = false;
                document.getElementById("pa").disabled = false;
                $('#pn').prop("class", "validate[required] text-input input-medium");
                $('#pa').prop("class", "validate[required] text-input input-medium");
                document.getElementById("btn_buscar").disabled = false;
            }

            function disablecom() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("empresa").disabled = false;
                document.getElementById("barrio").disabled = true;
                $('#empresa').prop("class", "validate[required] text-input input-large");
                document.getElementById("btn_buscar").disabled = false;
            }
            function disableba() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("empresa").disabled = true;
                document.getElementById("barrio").disabled = false;
                document.getElementById("btn_buscar").disabled = false;
            }

            
        </script>

        <style type="text/css">

            #fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left:auto;
                margin-right:auto;
                text-align: center;
                padding: 10px;
            }

            div#contenedorclientes{
                overflow: scroll;
                height: 600px;
            }
             #est{
                font-weight: bold;
                font-size:16px;
                text-align: center;
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
                        <p id="titulo">Lista de Solicitudes Rechazadas</p> 

                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <div id="contenedorforma">
                                    </br>
                                    <strong>Buscar Cliente:</strong>
                                    </br>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disableid();" name="busqueda" value="Por Cliente" id="busqueda_cliente" />
                                        Por Cliente</label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disablecom();" name="busqueda" value="Por Empresa" id="busqueda_empresa" />
                                        Por Nombre Empresa
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disableba();" name="busqueda" value="Por Barrio" id="busqueda_barrio" />
                                        Por Barrio/Colonia
                                    </label>
                                    </br>
                                    </br>
                                    Primer Nombre:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input id="pn" disabled="true" name="primer_nombre" type="text" class="input-medium" placeholder="Primer Nombre" />
                                    </div>
                                    Primer Apellido: 
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input id="pa" disabled="true" name="primer_apellido" type="text" class="input-medium" placeholder="Primer Apellido" />
                                    </div>
                                    </br>
                                    </br>
                                    Nombre Empresa:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-briefcase"></i></span>
                                        <input id="empresa" disabled="true" name="nombre_empresa" type="text" class="input-large" placeholder="Nombre de la Empresa" />
                                    </div>
                                    Barrio/Colonia:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-list"></i></span>
                                        <select name="barriocolonia" id="barrio" class="input-small" disabled="disabled">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();

                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement ps = conn.prepareStatement("SELECT IDBarriocolonia, Abreviacion FROM barriocolonia WHERE Estado=0"
                                                        + " ORDER BY (Abreviacion)");
                                                ps.execute();
                                                ResultSet rs = ps.getResultSet();
                                                while (rs.next()) {
                                        %>
                                        <option value="<%=rs.getString(1)%>"><%=rs.getString(2)%></option>
                                        <%}
                                                ps.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                <input name="btn_buscar" type="submit" class="btn btn-primary" id="btn_buscar" disabled="disabled" value="Buscar" />
                                </br>
                                </br>
                            </div>
                        </form>
                        </br>
                        </br>
                        <div id="contenedorclientes">
                            <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed">
                                    <%
                                            PdfPTable table = new PdfPTable(11);
                                            table.addCell("Primer Nombre");
                                            table.addCell("Segundo Nombre");
                                            table.addCell("Primer Apellido");
                                            table.addCell("Segundo Apellido");
                                            table.addCell("Barrio/Colonia");
                                            table.addCell("Dirección");
                                            table.addCell("Teléfono");
                                            table.addCell("Celular");
                                            table.addCell("Email");
                                            table.addCell("Fecha de Solicitud");
                                            table.addCell("Ingresada por:");
                                    %>
                                <thead>
                                    <tr>
                                        <th>Primer Nombre</th>
                                        <th>Segundo Nombre</th>
                                        <th>Primer Apellido</th>
                                        <th>Segundo Apellido</th>
                                        <th>Barrio/Colonia</th>
                                        <th>Dirección</th>
                                        <th>Teléfono</th>
                                        <th>Celular</th>
                                        <th>Email</th>
                                        <th>Fecha de Solicitud</th>
                                        <th>Ingresada por:</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                            int contador = 0;
                                        try {
                                            Dba dba = new Dba();
                                            dba.conectar();
                                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                            PreparedStatement ps = null;
                                            if (request.getParameter("btn_buscar") != null) {
                                                if (request.getParameter("busqueda").equals("Por Cliente")) {
                                                    ps = conn.prepareStatement(" SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido,"
                                                            + "Direccion, Email, Telefono, Celular, ba.Abreviacion, u.Nombre, Fecha FROM solicitud_rechazada sr, barriocolonia ba, usuario u "
                                                            + "WHERE sr.BARRIOCOLONIA_IDBarriocolonia = ba.IDBarriocolonia AND sr.USUARIO_IDUsuario = u.IDUsuario"
                                                            + " AND Primer_Nombre = ? AND Primer_Apellido = ?");
                                                    ps.setString(1, request.getParameter("primer_nombre"));
                                                    ps.setString(2, request.getParameter("primer_apellido"));
                                                    ps.execute();
                                                } else if (request.getParameter("busqueda").equals("Por Empresa")) {
                                                    ps = conn.prepareStatement(" SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido,"
                                                            + "Direccion, Email, Telefono, Celular, ba.Abreviacion, u.Nombre, Fecha FROM solicitud_rechazada sr, barriocolonia ba, usuario u "
                                                            + "WHERE sr.BARRIOCOLONIA_IDBarriocolonia = ba.IDBarriocolonia AND sr.USUARIO_IDUsuario = u.IDUsuario"
                                                            + " AND Primer_Nombre = ?");
                                                    ps.setString(1, request.getParameter("primer_nombre"));
                                                    ps.execute();
                                                } else {
                                                    ps = conn.prepareStatement(" SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido,"
                                                            + "Direccion, Email, Telefono, Celular, ba.Abreviacion, u.Nombre, Fecha FROM solicitud_rechazada sr, barriocolonia ba, usuario u "
                                                            + "WHERE sr.BARRIOCOLONIA_IDBarriocolonia = ba.IDBarriocolonia AND sr.USUARIO_IDUsuario = u.IDUsuario"
                                                            + " AND sr.BARRIOCOLONIA_IDBarriocolonia = ?");
                                                    ps.setString(1, request.getParameter("barriocolonia"));
                                                    ps.execute();
                                                }
                                            } else {
                                                ps = conn.prepareStatement(" SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido,"
                                                        + "Direccion, Email, Telefono, Celular, ba.Abreviacion, u.Nombre, Fecha FROM solicitud_rechazada sr, barriocolonia ba, usuario u "
                                                        + "WHERE sr.BARRIOCOLONIA_IDBarriocolonia = ba.IDBarriocolonia AND sr.USUARIO_IDUsuario = u.IDUsuario");
                                                ps.execute();

                                            }
                                            ResultSet rsps = ps.getResultSet();
                                            String temp = "";
                                            while (rsps.next()) {

                                    %>

                                    <tr align="center">
                                        <td><%= temp = rsps.getString(1)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(2)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(3)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(4)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(9)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(5)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(7)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(8)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(6)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(11)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(10)%></td>
                                        <% table.addCell(temp);%>
                                    </tr>

                                    <%
                                                contador++;
                                                session.setAttribute("ar", table);
                                            }
                                            ps.close();
                                        } catch (Exception ex) {
                                            System.out.println("SQL LISTA SOL. RECHAZADAS: " + ex.getMessage());
                                        }
                                    %>
                                </tbody>
                            </table>
                            <br/>
                        </div>
                        </br>
                        <label id="est">Total: <input class="input-medium" name="clientes" id="est" value="<%= contador%>" size="8" type="text" readonly="readonly" /></label>
                        <button onclick="Exportar();">Exportar a PDF</button>
                        </br>
                        <script type="text/javascript">
                            function Exportar() {
                                window.location.href = 'Exportar.jsp?tit=Lista de Solicitudes Rechazadas&tot=<%=contador%>';
                            }
                        </script>
                    </div>
                </div>
            </div>

    </body>
</html>
