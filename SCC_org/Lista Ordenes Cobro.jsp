<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="BD.OC"%>
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

            function Fecha() {
                document.getElementById("df").disabled = false;
                document.getElementById("hf").disabled = false;
                document.getElementById("btn_fil").disabled = false;
                document.getElementById("cob").disabled = true;
                document.getElementById("barrio").disabled = true;
                $('#df').prop("class", "validate[required] text-input input-medium");
                $('#hf').prop("class", "validate[required] text-input input-medium");
            }

            function Cobrador() {
                document.getElementById("df").disabled = true;
                document.getElementById("hf").disabled = true;
                document.getElementById("btn_fil").disabled = false;
                document.getElementById("cob").disabled = false;
                document.getElementById("barrio").disabled = true;
            }

            function Barrio() {
                document.getElementById("df").disabled = true;
                document.getElementById("hf").disabled = true;
                document.getElementById("btn_fil").disabled = false;
                document.getElementById("cob").disabled = true;
                document.getElementById("barrio").disabled = false;
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
                height: 500px;
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
                        <p id="titulo">Lista de Órdenes de Cobro</p> 
                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <div id="contenedorforma">
                                    </br>
                                    <strong>Filtrar Órdenes por:</strong>
                                    </br>
                                    <label class="inline radio">
                                        <input name="busqueda" type="radio" id="busqueda_cliente" onclick="Cobrador();" value="Por Cobrador" />
                                        Por Cobrador
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="Fecha();" name="busqueda" value="Por Fecha" id="busqueda_cliente" />
                                        Por Fecha
                                    </label>
                                    <label class="inline radio">
                                        <input name="busqueda" type="radio" id="busqueda_cliente" onclick="Barrio();" value="Por Barrio" />
                                        Por Barrio
                                    </label>
                                    <br>
                                    <br>
                                    Cobrador: 
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <select id="cob" disabled="disabled" name="cobrador" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                String usuario = "";
                                                PreparedStatement users = conn.prepareStatement("SELECT Nombre FROM usuario"
                                                        + " WHERE Estado = 0 ORDER BY (Nombre)");
                                                users.execute();
                                                ResultSet usersrs = users.getResultSet();
                                                while (usersrs.next()) {
                                                    usuario = usersrs.getString(1);
                                        %>
                                        <option value="<%=usuario%>"><%= usuario%></option>
                                        <%}

                                                users.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Cobrador: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                Desde:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-calendar"></i></span>
                                    <input id="df" disabled="disabled" name="desdefec" type="date" class="input-medium" />
                                </div>
                                Hasta:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-calendar"></i></span>
                                    <input id="hf" disabled="disabled" name="hastafec" type="date" class="input-medium" />
                                </div>
                                </br>
                                </br>
                                Barrio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="barrio" disabled="disabled" name="barrio" class="input-small">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement barrio = conn.prepareStatement("SELECT IDBarriocolonia, Abreviacion FROM barriocolonia"
                                                        + " WHERE Estado = 0 ORDER BY (Abreviacion)");
                                                barrio.execute();
                                                ResultSet barriors = barrio.getResultSet();
                                                while (barriors.next()) {%>
                                        <option value="<%= barriors.getString(1)%>"><%= barriors.getString(2)%></option>
                                        <%}
                                                barrio.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Barrio: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                <input name="btn_filtrar" id="btn_fil" disabled="disabled" class="btn btn-primary" type="submit" value="Filtrar" />
                                </br>
                                </br>
                            </div>
                        </form>
                        </br>
                        <p id="titulo">Órdenes de Cobro</p>
                        <div id="contenedorclientes">
                            <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed">
                                <%
                                    PdfPTable table = new PdfPTable(14);
                                    table.addCell("ID");
                                    table.addCell("Primer Nombre");
                                    table.addCell("Segundo Nombre");
                                    table.addCell("Primer Apellido");
                                    table.addCell("Segundo Apellido");
                                    table.addCell("Barrio/Colonia");
                                    table.addCell("No. Contrato");
                                    table.addCell("Servicio");
                                    table.addCell("Estado Fecha Cobrado");
                                    table.addCell("Cobrado Por");
                                    table.addCell("Mes");
                                    table.addCell("Total");
                                    table.addCell("Descuento");
                                    table.addCell("Cantidad Pagada");
                                %>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Primer Nombre</th>
                                        <th>Segundo Nombre</th>
                                        <th>Primer Apellido</th>
                                        <th>Segundo Apellido</th>
                                        <th>Barrio/Colonia</th>
                                        <th>No. Contrato</th>
                                        <th>Servicio</th>
                                        <th>Fecha Cobrado</th>
                                        <th>Cobrado Por</th>
                                        <th>Mes</th>
                                        <th>Total</th>
                                        <th>Descuento</th>
                                        <th>Cantidad Pagada</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int totalordenes = 0;
                                        Double ingresos = 0.00;
                                        Double total = 0.00;
                                        Double cantpag = 0.00;
                                        Double desc = 0.00;
                                        if (request.getParameter("btn_filtrar") != null) {

                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                OC cobro = new OC();
                                                PreparedStatement ps = null;
                                                PreparedStatement pse = null;

                                                if (request.getParameter("busqueda").equals("Por Fecha")) {
                                                    ps = conn.prepareStatement("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato,s.Nombre,Fecha_Pagada,NombreCobrador,oc.Fecha,oc.CantidadPagar,Descuento FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_cobro oc"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = oc.CONTRATO_IDContrato AND Fecha_Pagada BETWEEN ? AND ?");
                                                    ps.setString(1, request.getParameter("desdefec"));
                                                    ps.setString(2, request.getParameter("hastafec"));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID,Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato,s.Nombre,Fecha_Pagada,NombreCobrador,oc.Fecha,oc.CantidadPagar,Descuento FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_cobro oc"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = oc.CONTRATO_IDContrato AND Fecha_Pagada BETWEEN ? AND ?");
                                                    pse.setString(1, request.getParameter("desdefec"));
                                                    pse.setString(2, request.getParameter("hastafec"));
                                                    pse.execute();

                                                } else if (request.getParameter("busqueda").equals("Por Cobrador")) {
                                                    ps = conn.prepareStatement("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato,s.Nombre,Fecha_Pagada,NombreCobrador,oc.Fecha,oc.CantidadPagar,Descuento FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_cobro oc"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = oc.CONTRATO_IDContrato AND oc.NombreCobrador = ? AND Fecha_Pagada!='0000-00-00'");
                                                    ps.setString(1, request.getParameter("cobrador"));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID, Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato,s.Nombre,Fecha_Pagada,NombreCobrador,oc.Fecha,oc.CantidadPagar,Descuento FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_cobro oc"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = oc.CONTRATO_IDContrato AND oc.NombreCobrador = ? AND Fecha_Pagada!='0000-00-00'");
                                                    pse.setString(1, request.getParameter("cobrador"));
                                                    pse.execute();

                                                } else {
                                                    ps = conn.prepareStatement("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato,s.Nombre,Fecha_Pagada,NombreCobrador,oc.Fecha,oc.CantidadPagar,Descuento FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_cobro oc"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = oc.CONTRATO_IDContrato AND c.IDBarriocolonia = ? AND Fecha_Pagada!='0000-00-00'");
                                                    ps.setString(1, request.getParameter("barrio"));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID, Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato,s.Nombre,Fecha_Pagada,NombreCobrador,oc.Fecha,oc.CantidadPagar,Descuento FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_cobro oc"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = oc.CONTRATO_IDContrato AND c.IDBarriocolonia = ? AND Fecha_Pagada!='0000-00-00'");
                                                    pse.setString(1, request.getParameter("barrio"));
                                                    pse.execute();
                                                }

                                                ResultSet rsps = ps.getResultSet();
                                                String temp = "";
                                                while (rsps.next()) {
                                                    cantpag = Double.parseDouble(rsps.getString(12));
                                                    desc = Double.parseDouble(rsps.getString(13));
                                                    total = cantpag - desc;
                                                    ingresos = total + ingresos;
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
                                        <td><%= temp = rsps.getString(5)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(6)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(7)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(8)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(9)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(10)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = cobro.MesActual(rsps.getString(11))%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= cantpag%></td>
                                        <% table.addCell(String.valueOf(cantpag));%>
                                        <td><%= desc%></td>
                                        <% table.addCell(String.valueOf(desc));%>
                                        <td><%= total%></td>
                                        <% table.addCell(String.valueOf(total));%>
                                    </tr>

                                    <%  totalordenes++;
                                        }
                                        ResultSet rspse = pse.getResultSet();
                                        while (rspse.next()) {
                                            cantpag = Double.parseDouble(rspse.getString(12));
                                            desc = Double.parseDouble(rspse.getString(13));
                                            total = cantpag - desc;
                                            ingresos = total + ingresos;
                                    %>

                                    <tr align="center">
                                        <td><%= temp = rspse.getString(1)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(2)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(3)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(4)%></td>
                                        <% table.addCell(temp);%>
                                        <td></td>
                                        <% table.addCell("");%>
                                        <td><%= temp = rspse.getString(6)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(7)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(8)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(9)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(10)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = cobro.MesActual(rspse.getString(11))%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= cantpag%></td>
                                        <% table.addCell(String.valueOf(cantpag));%>
                                        <td><%= desc%></td>
                                        <% table.addCell(String.valueOf(desc));%>
                                        <td><%= total%></td>
                                        <% table.addCell(String.valueOf(total));%>
                                    </tr>

                                    <%  totalordenes++;
                                                }
                                                session.setAttribute("ar", table);
                                                pse.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL LISTA ORD. COBROS: " + ex.getMessage());
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                            <br/>
                        </div>
                        </br>
                        <label id="est">Total de Órdenes Cobradas: <input id="est" class="input-medium" name="totalordenes" size="4" value="<%= totalordenes%>" type="text" readonly="readonly" /></label>
                        <label id="est">Ingresos: LPS. <input name="ingresos" class="input-medium" id="est" value="<%= ingresos%>" size="10" type="text" readonly="readonly" /></label>
                         <button onclick="Exportar();">Exportar a PDF</button>
                        </br>
                        </br>
                        <script type="text/javascript">
                            function Exportar() {
                                window.location.href = 'Exportar.jsp?tit=Lista de Órdenes de Cobro&cant=<%=ingresos%>&tot=<%=totalordenes%>';
                            }
                        </script>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
