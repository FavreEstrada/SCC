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
                document.getElementById("tec").disabled = true;
                document.getElementById("barrio").disabled = true;
                document.getElementById("serv").disabled = true;
                document.getElementById("trab").disabled = true;
                $('#df').prop("class", "validate[required] text-input input-medium");
                $('#hf').prop("class", "validate[required] text-input input-medium");

            }

            function Tecnico() {
                document.getElementById("df").disabled = true;
                document.getElementById("hf").disabled = true;
                document.getElementById("btn_fil").disabled = false;
                document.getElementById("tec").disabled = false;
                document.getElementById("barrio").disabled = true;
                document.getElementById("serv").disabled = true;
                document.getElementById("trab").disabled = true;

            }

            function Barrio() {
                document.getElementById("df").disabled = true;
                document.getElementById("hf").disabled = true;
                document.getElementById("btn_fil").disabled = false;
                document.getElementById("tec").disabled = true;
                document.getElementById("barrio").disabled = false;
                document.getElementById("serv").disabled = true;
                document.getElementById("trab").disabled = true;

            }

            function TrabajoRealizado() {
                document.getElementById("df").disabled = true;
                document.getElementById("hf").disabled = true;
                document.getElementById("btn_fil").disabled = false;
                document.getElementById("tec").disabled = true;
                document.getElementById("barrio").disabled = true;
                document.getElementById("serv").disabled = false;
                document.getElementById("trab").disabled = false;

            }

            function getTrabajo_Realizar() {
                var tipoPersoneria = $('#serv option:selected').val();

                jQuery.ajax({
                    url: 'ControladoraTR.jsp',
                    type: 'GET',
                    async: true,
                    data: {
                        IDServicio: tipoPersoneria
                    },
                    success: function(data)
                    {
                        if (data.trim() !== "none")
                        {

                            var datos = data.trim().split('#');
                            var valores = new Array();
                            jQuery('#trab').empty();
                            for (var i = 0; i < datos.length - 1; i++)
                            {
                                valores = datos[i].split('$');
                                jQuery('#trab').append('<option></option>');
                                jQuery('#trab option:last').attr('value', valores[1]);
                                jQuery('#trab option:last').append(valores[1]);
                            }

                        }
                        console.log(data);
                    }
                });
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
                        <p id="titulo">Lista de Órdenes de Trabajo</p> 

                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <div id="contenedorforma">
                                    </br>
                                    <strong>Filtrar Órdenes por:</strong>
                                    </br>
                                    <label class="inline radio">
                                        <input name="busqueda" type="radio" id="busqueda_cliente" onclick="Tecnico();" value="Por Tecnico" />
                                        Por Técnico
                                    </label>
                                    <label class="inline radio">
                                        <input name="busqueda" type="radio" id="busqueda_cliente" onclick="Barrio();" value="Por Barrio" />
                                        Por Barrio
                                    </label>
                                    <label class="inline radio">
                                        <input name="busqueda" type="radio" id="busqueda_cliente" onclick="TrabajoRealizado();" value="Por Trabajo" />
                                        Por Trabajo Realizado
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="Fecha();" name="busqueda" value="Por Fecha" id="busqueda_cliente" />
                                        Por Fecha
                                    </label>
                                    <br>
                                    <br>
                                    Técnico:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <select id="tec" disabled="disabled" name="tecnico" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement users = conn.prepareStatement("SELECT Nombre FROM usuario "
                                                        + "WHERE ROL_IDRol = (SELECT IDRol FROM rol WHERE Nombre = 'TECNICO') ORDER BY (Nombre)");
                                                users.execute();
                                                ResultSet usersrs = users.getResultSet();
                                                String tec = "";
                                                while (usersrs.next()) {
                                                    tec = usersrs.getString(1);
                                        %>
                                        <option value="<%=tec%>"><%= tec%></option>
                                        <%}

                                                users.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Tecnico: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Barrio: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="barrio" disabled="disabled" name="barrio" class="input-small">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement barrio = conn.prepareStatement("SELECT IDBarriocolonia,Abreviacion FROM barriocolonia"
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
                                Servicio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="serv" disabled="disabled" class="input-medium" name="servicio" onchange="getTrabajo_Realizar();">
                                        <option>---------</option>
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement serv = conn.prepareStatement("SELECT ID, Nombre FROM servicio"
                                                        + " WHERE Estado = 0");
                                                serv.execute();
                                                ResultSet servrs = serv.getResultSet();
                                                while (servrs.next()) {%>
                                        <option value="<%= servrs.getString(1)%>"><%= servrs.getString(2)%></option>
                                        <%}
                                                serv.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Servicio: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Trabajo Realizado:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="trab" disabled="disabled" name="trabajo" class="input-medium">
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
                                <input name="btn_filtrar" class="btn btn-primary" id="btn_fil" disabled="disabled" type="submit" value="Filtrar" />
                                </br>
                                </br>
                            </div>
                        </form>
                        </br>
                        <p id="titulo">Órdenes de Trabajo</p>
                        <div id="contenedorclientes">
                            <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed">
                                <thead>
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
                                    table.addCell("Fecha");
                                    table.addCell("Técnico");
                                    table.addCell("No. Factura");
                                    table.addCell("Descrip. Factura");
                                    table.addCell("Cantidad Pagada");
                                    table.addCell("Trabajo Realiz.");
                                %>
                                    <tr>
                                        <th>ID</th>
                                        <th>Primer Nombre</th>
                                        <th>Segundo Nombre</th>
                                        <th>Primer Apellido</th>
                                        <th>Segundo Apellido</th>
                                        <th>Barrio/Colonia</th>
                                        <th>No. Contrato</th>
                                        <th>Servicio</th>
                                        <th>Fecha</th>
                                        <th>Técnico</th>
                                        <th>No. Factura</th>
                                        <th>Decripción Factura</th>
                                        <th>Cantidad Pagada</th>
                                        <th>Trabajo Realizado</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        int totalordenes = 0;
                                        Double ingresos = 0.00;

                                        if (request.getParameter("btn_filtrar") != null) {

                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                OC cobro = new OC();
                                                PreparedStatement ps = null;
                                                PreparedStatement pse = null;
                                                PreparedStatement ins = null;
                                                PreparedStatement inse = null;
                                                int IDOT = 0;
                                                if (request.getParameter("busqueda").equals("Por Fecha")) {
                                                    ps = conn.prepareStatement("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado,tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND ot.Fecha BETWEEN ? AND ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    ps.setString(1, request.getParameter("desdefec"));
                                                    ps.setString(2, request.getParameter("hastafec"));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID,Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre,ot.IDOrdenTrabajo"
                                                            + " FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND ot.Fecha BETWEEN ? AND ? "
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    pse.setString(1, request.getParameter("desdefec"));
                                                    pse.setString(2, request.getParameter("hastafec"));
                                                    pse.execute();

                                                    ins = conn.prepareStatement("SELECT ID, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion"
                                                            + " WHERE Estado = 'REALIZADO' AND Fecha BETWEEN ? AND ? AND Nombre_Empresa = '' ");
                                                    ins.setString(1, request.getParameter("desdefec"));
                                                    ins.setString(2, request.getParameter("hastafec"));
                                                    ins.execute();

                                                    inse = conn.prepareStatement("SELECT ID, Nombre_Empresa, Representante, Cargo, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion"
                                                            + " WHERE Estado = 'REALIZADO' AND Fecha BETWEEN ? AND ? AND Primer_Nombre = ''");
                                                    inse.setString(1, request.getParameter("desdefec"));
                                                    inse.setString(2, request.getParameter("hastafec"));
                                                    inse.execute();

                                                } else if (request.getParameter("busqueda").equals("Por Tecnico")) {
                                                    ps = conn.prepareStatement("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND Tecnico_Asignado = ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    ps.setString(1, request.getParameter("tecnico"));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID, Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND Tecnico_Asignado = ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    pse.setString(1, request.getParameter("tecnico"));
                                                    pse.execute();

                                                    ins = conn.prepareStatement("SELECT ID, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion"
                                                            + " WHERE Estado = 'REALIZADO' AND Tecnico = ? AND Nombre_Empresa = ''");
                                                    ins.setString(1, request.getParameter("tecnico"));
                                                    ins.execute();

                                                    inse = conn.prepareStatement("SELECT ID, Nombre_Empresa, Representante, Cargo, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion"
                                                            + " WHERE Estado = 'REALIZADO' AND Tecnico = ? AND Primer_Nombre = ''");
                                                    inse.setString(1, request.getParameter("tecnico"));
                                                    inse.execute();
                                                } else if (request.getParameter("busqueda").equals("Por Barrio")) {
                                                    ps = conn.prepareStatement("SELECT NoID, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND c.IDBarriocolonia = ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    ps.setString(1, request.getParameter("barrio"));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID, Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND c.IDBarriocolonia = ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    pse.setString(1, request.getParameter("barrio"));
                                                    pse.execute();

                                                    ins = conn.prepareStatement("SELECT ID, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion "
                                                            + "WHERE Estado = 'REALIZADO' AND Barrio = (SELECT Abreviacion FROM "
                                                            + "barriocolonia WHERE IDBarriocolonia = ?) AND Nombre_Empresa = ''");
                                                    ins.setString(1, request.getParameter("barrio"));
                                                    ins.execute();

                                                    inse = conn.prepareStatement("SELECT ID, Nombre_Empresa, Representante, Cargo, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion "
                                                            + "WHERE Estado = 'REALIZADO' AND Barrio = (SELECT Abreviacion FROM "
                                                            + "barriocolonia WHERE IDBarriocolonia = ?) AND Primer_Nombre = ''");
                                                    inse.setString(1, request.getParameter("barrio"));
                                                    inse.execute();

                                                } else {

                                                    ps = conn.prepareStatement("SELECT NoID, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND tr.Nombre = ? AND s.ID = ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    ps.setString(1, request.getParameter("trabajo"));
                                                    ps.setInt(2, Integer.parseInt(request.getParameter("servicio")));
                                                    ps.execute();

                                                    pse = conn.prepareStatement("SELECT NoID, Nombre_Empresa, Representante, Cargo, Telefono, ba.Abreviacion,"
                                                            + " c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado, tr.Nombre, ot.IDOrdenTrabajo"
                                                            + " FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                            + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato AND tr.Nombre = ? AND s.ID = ?"
                                                            + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND ESTADO_ORDEN_TRABAJO_ID = (SELECT ID FROM estado_orden_trabajo WHERE Nombre = 'REALIZADO')");
                                                    pse.setString(1, request.getParameter("trabajo"));
                                                    pse.setInt(2, Integer.parseInt(request.getParameter("servicio")));
                                                    pse.execute();

                                                    ins = conn.prepareStatement("SELECT ID, Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion "
                                                            + "WHERE Estado = 'REALIZADO' AND Servicio = (SELECT Nombre FROM servicio WHERE ID = ?)"
                                                            + " AND TrabajoRealizar = ? AND Nombre_EMpresa = ''");
                                                    ins.setInt(1, Integer.parseInt(request.getParameter("servicio")));
                                                    ins.setString(2, request.getParameter("trabajo"));
                                                    ins.execute();

                                                    inse = conn.prepareStatement("SELECT ID, Nombre_Empresa, Representante, Cargo, Barrio,"
                                                            + " Servicio, Fecha, Tecnico, TrabajoRealizar, CantidadPagada, Descripcion"
                                                            + " FROM instalacion "
                                                            + "WHERE Estado = 'REALIZADO' AND Servicio = (SELECT Nombre FROM servicio WHERE ID = ?)"
                                                            + " AND TrabajoRealizar = ? AND Primer_Nombre = ''");
                                                    inse.setInt(1, Integer.parseInt(request.getParameter("servicio")));
                                                    inse.setString(2, request.getParameter("trabajo"));
                                                    inse.execute();

                                                }

                                                ResultSet rsps = ps.getResultSet();
                                                String temp = "";
                                                while (rsps.next()) {

                                                    IDOT = Integer.parseInt(rsps.getString(12));
                                                    PreparedStatement fac = conn.prepareStatement("SELECT IDFactura, Descripcion, Cantidad_Pagada"
                                                            + " FROM factura where ORDEN_TRABAJO_IDOrdenTrabajo = ?");
                                                    fac.setInt(1, IDOT);
                                                    fac.execute();

                                                    String IDfac = "";
                                                    String descf = "";
                                                    String cantf = "0.0";
                                                    ResultSet facrs = fac.getResultSet();
                                                    while (facrs.next()) {
                                                        IDfac = facrs.getString(1);
                                                        descf = facrs.getString(2);
                                                        cantf = facrs.getString(3);
                                                    }
                                                    fac.close();
                                                    ingresos = Double.parseDouble(cantf) + ingresos;
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
                                        <td><%= IDfac%></td>
                                        <% table.addCell(String.valueOf(IDfac));%>
                                        <td><%= descf%></td>
                                        <% table.addCell(String.valueOf(descf));%>
                                        <td><%= cantf%></td>
                                        <% table.addCell(String.valueOf(cantf));%>
                                        <td><%= temp = rsps.getString(11)%></td>
                                         <% table.addCell(temp);%>
                                    </tr>

                                    <%  totalordenes++;
                                        }

                                        ResultSet rspse = pse.getResultSet();
                                        while (rspse.next()) {
                                            IDOT = Integer.parseInt(rspse.getString(12));
                                            PreparedStatement fac = conn.prepareStatement("SELECT IDFactura, Descripcion, Cantidad_Pagada"
                                                    + " FROM factura where ORDEN_TRABAJO_IDOrdenTrabajo = ?");
                                            fac.setInt(1, IDOT);
                                            fac.execute();
                                            String IDfac = "";
                                            String descf = "";
                                            String cantf = "0.0";
                                            ResultSet facrs = fac.getResultSet();
                                            while (facrs.next()) {
                                                IDfac = facrs.getString(1);
                                                descf = facrs.getString(2);
                                                cantf = facrs.getString(3);
                                            }
                                            fac.close();
                                            ingresos = Double.parseDouble(cantf) + ingresos;
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
                                        <td><%= IDfac%></td>
                                        <% table.addCell(String.valueOf(IDfac));%>
                                        <td><%= descf%></td>
                                        <% table.addCell(String.valueOf(descf));%>
                                        <td><%= cantf%></td>
                                        <% table.addCell(String.valueOf(cantf));%>
                                        <td><%= temp = rspse.getString(11)%></td>
                                        <% table.addCell(temp);%>
                                    </tr>

                                    <%  totalordenes++;
                                        }
                                        pse.close();

                                        ResultSet rsins = ins.getResultSet();
                                        String cantf = "0.00";
                                        while (rsins.next()) {
                                            cantf = rsins.getString(11);
                                            ingresos = Double.parseDouble(cantf) + ingresos;
                                    %>

                                    <tr align="center">
                                        <td><%= temp = rsins.getString(1)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(2)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(3)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(4)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(5)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(6)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= ""%></td>
                                         <% table.addCell("");%>
                                        <td><%= temp = rsins.getString(7)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(8)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsins.getString(9)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= ""%></td>
                                         <% table.addCell("");%>
                                        <td><%= temp = rsins.getString(12)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= cantf%></td>
                                        <% table.addCell(String.valueOf(cantf));%>
                                        <td><%= "INSTALACION"%></td>
                                        <% table.addCell("INSTALACION");%>
                                    </tr>

                                    <%  totalordenes++;
                                        }
                                        ResultSet rsinsemp = inse.getResultSet();
                                        while (rsinsemp.next()) {
                                            cantf = rsinsemp.getString(10);
                                            ingresos = Double.parseDouble(cantf) + ingresos;
                                    %>

                                    <tr align="center">
                                        <td><%= temp = rsinsemp.getString(1)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsinsemp.getString(2)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsinsemp.getString(3)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= temp = rsinsemp.getString(4)%></td>
                                         <% table.addCell(temp);%>
                                        <td><%= ""%></td>
                                         <% table.addCell("");%>
                                        <td><%= temp = rsinsemp.getString(5)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= ""%></td>
                                        <% table.addCell("");%>
                                        <td><%= temp = rsinsemp.getString(6)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsinsemp.getString(7)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsinsemp.getString(8)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= ""%></td>
                                        <% table.addCell("");%>
                                        <td><%= temp = rsinsemp.getString(11)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= cantf%></td>
                                        <% table.addCell(String.valueOf(cantf));%>
                                        <td><%= "INSTALACION"%></td>
                                        <% table.addCell("INSTALACION");%>
                                    </tr>

                                    <%  totalordenes++;
                                                }
                                                session.setAttribute("ar", table);

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

                        <label id="est">Total de Órdenes Realizadas: <input class="input-medium" id="est" name="totalordenes" size="4" value="<%= totalordenes%>" type="text" readonly="readonly" /></label>
                        <label id="est">Ingresos:LPS. <input name="ingresos" id="est" class="input-medium" value="<%= ingresos%>" size="10" type="text" readonly="readonly" /></label>
                        <button onclick="Exportar();">Exportar a PDF</button>
                        </br>
                        </br>
                        <script type="text/javascript">
                            function Exportar() {
                                     window.location.href = 'Exportar.jsp?tit=Lista de Órdenes de Trabajo&cant=<%=ingresos%>&tot=<%=totalordenes%>';
                                 }
                        </script>
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
