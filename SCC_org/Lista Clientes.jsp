<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="java.util.ArrayList"%>
<%@page import="BD.Dba"%>
<%@page import="BD.CalcMeses"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<%@page import="java.io.FileOutputStream"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.*"%>
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

                $('#tabla tr').dblclick(function() {
                    var href = $(this).find("a").attr("href");
                    if (href) {
                        window.location = href;
                    }
                });

            });

            function disableid() {
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = true;
                document.getElementById("pn").disabled = false;
                document.getElementById("pa").disabled = false;
                document.getElementById("estado").disabled = true;
                document.getElementById("serv").disabled = true;
                document.getElementById("bar").disabled = true;
                $('#pn').prop("class", "validate[required] text-input input-medium");
                $('#pa').prop("class", "validate[required] text-input input-medium");

            }

            function disablename() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = false;
                document.getElementById("empresa").disabled = true;
                document.getElementById("estado").disabled = true;
                document.getElementById("serv").disabled = true;
                document.getElementById("bar").disabled = true;
                $('#id').prop("class", "validate[required] text-input input-medium");

            }

            function disablecom() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = false;
                document.getElementById("estado").disabled = true;
                document.getElementById("serv").disabled = true;
                document.getElementById("bar").disabled = true;
                $('#empresa').prop("class", "validate[required] text-input input-large");

            }

            function disableserv() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = true;
                document.getElementById("estado").disabled = true;
                document.getElementById("serv").disabled = false;
                document.getElementById("bar").disabled = true;

            }

            function disableest() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = true;
                document.getElementById("estado").disabled = false;
                document.getElementById("serv").disabled = true;
                document.getElementById("bar").disabled = true;

            }

            function disablebar() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = true;
                document.getElementById("estado").disabled = true;
                document.getElementById("serv").disabled = true;
                document.getElementById("bar").disabled = false;

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
                        <p id="titulo">Lista de Clientes</p> 

                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <div id="contenedorforma">
                                    </br>
                                    <strong>Buscar Cliente:</strong>
                                    </br>
                                    <label class="inline radio">    
                                        <input type="radio" onclick="disableid();" name="busqueda" value="Por Cliente" id="busqueda_cliente" />
                                        Por Cliente
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disablename();" name="busqueda" value="Por ID" id="busqueda_id" />
                                        Por Identificación
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disablecom();" name="busqueda" value="Por Empresa" id="busqueda_empresa" />
                                        Por Nombre Empresa 
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disableest();" name="busqueda" value="Por Estado" id="busqueda_empresa" />
                                        Por Estado de Cliente
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disableserv();" name="busqueda" value="Por Servicio" id="busqueda_empresa" />
                                        Por Servicio
                                    </label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disablebar();" name="busqueda" value="Por Barrio" id="busqueda_empresa" />
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
                                    No. ID:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input title="No válido para clientes jurídicos" id="id" disabled="true" name="no_identidad" type="text" class="input-medium" placeholder="No.ID" />
                                    </div>
                                    Nombre Empresa: 
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-briefcase"></i></span>
                                        <input id="empresa"disabled="true" name="nombre_empresa" type="text" class="input-large" placeholder="Nombre de la Empresa" />
                                    </div>
                                    </br>
                                    </br>
                                    Estado Cliente:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-list"></i></span>
                                        <select id="estado" disabled="disabled" name="estadocliente" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement estado = conn.prepareStatement("SELECT ID, Nombre FROM estado_general_cliente"
                                                        + " WHERE Estado = 0 ORDER BY (Nombre)");
                                                estado.execute();
                                                ResultSet estadors = estado.getResultSet();
                                                while (estadors.next()) {%>
                                        <option value="<%= estadors.getString(1)%>"><%= estadors.getString(2)%></option>
                                        <%}
                                                estado.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL EstadoCliente: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Servicio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="serv" disabled="disabled" name="servicio" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement servicio = conn.prepareStatement("SELECT ID, Nombre FROM servicio"
                                                        + " WHERE Estado = 0 ORDER BY (Nombre)");
                                                servicio.execute();
                                                ResultSet servrs = servicio.getResultSet();
                                                while (servrs.next()) {%>
                                        <option value="<%= servrs.getString(1)%>"><%= servrs.getString(2)%></option>
                                        <%}
                                                servicio.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Servicio: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Barrio: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="bar" disabled="disabled" name="Barrio" class="input-small">
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
                                <input name="btn_buscar" type="submit" class="btn btn-primary" value="Buscar" />
                                </br>
                                </br>
                            </div>
                        </form>
                        </br>
                        </br>
                        <div id="contenedorclientes">
                            <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed">
                                <%
                                    int contador = 0;
                                    try {

                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                        PdfPTable table = new PdfPTable(10);
                                        table.addCell("ID");
                                        table.addCell("Primer Nombre");
                                        table.addCell("Segundo Nombre");
                                        table.addCell("Primer Apellido");
                                        table.addCell("Segundo Apellido");
                                        table.addCell("Barrio/Colonia");
                                        table.addCell("Estado Cliente");
                                        table.addCell("No. Contrato");
                                        table.addCell("Servicio");
                                        table.addCell("Fecha de Instalación");

                                %>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Primer Nombre</th>
                                        <th>Segundo Nombre</th>
                                        <th>Primer Apellido</th>
                                        <th>Segundo Apellido</th>
                                        <th>Barrio/Colonia</th>
                                        <th>Estado de Cliente</th>
                                        <th>No. Contrato</th>
                                        <th>Servicio</th>
                                        <th>Fecha de Instalación</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%


                                        CalcMeses meses = new CalcMeses();
                                        PreparedStatement ps = null;
                                        PreparedStatement pse = null;
                                        Boolean emp = false;
                                        if (request.getParameter("btn_buscar") != null) {
                                            if (request.getParameter("busqueda").equals("Por Cliente")) {
                                                ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                        + "Segundo_Apellido, ba.Abreviacion, NoID, IDContrato, eg.Nombre , s.Nombre, con.Fecha"
                                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s"
                                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID"
                                                        + " AND Primer_Nombre=? AND Primer_Apellido=? ORDER BY (Primer_Nombre)");
                                                String pn = request.getParameter("primer_nombre");
                                                String pa = request.getParameter("primer_apellido");
                                                ps.setString(1, pn.toUpperCase());
                                                ps.setString(2, pa.toUpperCase());
                                                ps.execute();

                                            } else if (request.getParameter("busqueda").equals("Por ID")) {
                                                ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                        + "Segundo_Apellido, ba.Abreviacion, NoID, IDContrato, eg.Nombre , s.Nombre, con.Fecha"
                                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s"
                                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID "
                                                        + " AND NoID = ? ORDER BY (Primer_Nombre)");
                                                String ID = request.getParameter("no_identidad");
                                                ps.setString(1, ID.toUpperCase());
                                                ps.execute();

                                            } else if (request.getParameter("busqueda").equals("Por Empresa")) {
                                                ps = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                        + " ba.Abreviacion, NoID, IDContrato, eg.Nombre, s.Nombre, con.Fecha"
                                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg, servicio s"
                                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cj.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID"
                                                        + " AND Nombre_Empresa = ? ORDER BY (Nombre_Empresa)");
                                                String empresa = request.getParameter("nombre_empresa");
                                                ps.setString(1, empresa.toUpperCase());
                                                ps.execute();

                                            } else if (request.getParameter("busqueda").equals("Por Estado")) {
                                                ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                        + "Segundo_Apellido, ba.Abreviacion, NoID, IDContrato, eg.Nombre , s.Nombre, con.Fecha"
                                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s"
                                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID "
                                                        + " AND eg.ID = ? ORDER BY (eg.Nombre)");
                                                ps.setInt(1, Integer.parseInt(request.getParameter("estadocliente")));
                                                ps.execute();

                                                pse = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                        + " ba.Abreviacion, NoID, IDContrato, eg.Nombre, s.Nombre, con.Fecha"
                                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg, servicio s"
                                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cj.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID"
                                                        + " AND eg.ID = ? ORDER BY (eg.Nombre)");
                                                pse.setInt(1, Integer.parseInt(request.getParameter("estadocliente")));
                                                pse.execute();
                                                emp = true;

                                            } else if (request.getParameter("busqueda").equals("Por Servicio")) {
                                                ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                        + "Segundo_Apellido, ba.Abreviacion, NoID, IDContrato, eg.Nombre , s.Nombre, con.Fecha"
                                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s"
                                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID "
                                                        + " AND s.ID = ? ORDER BY (s.Nombre)");
                                                ps.setInt(1, Integer.parseInt(request.getParameter("servicio")));
                                                ps.execute();

                                                pse = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                        + " ba.Abreviacion, NoID, IDContrato, eg.Nombre, s.Nombre, con.Fecha"
                                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg, servicio s"
                                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cj.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID"
                                                        + " AND s.ID = ? ORDER BY (s.Nombre)");
                                                pse.setInt(1, Integer.parseInt(request.getParameter("servicio")));
                                                pse.execute();
                                                emp = true;

                                            } else {
                                                ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                        + "Segundo_Apellido, ba.Abreviacion, NoID, IDContrato, eg.Nombre , s.Nombre, con.Fecha"
                                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s"
                                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID "
                                                        + " AND ba.IDBarriocolonia = ? ORDER BY (ba.Abreviacion)");
                                                ps.setInt(1, Integer.parseInt(request.getParameter("Barrio")));
                                                ps.execute();

                                                pse = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                        + " ba.Abreviacion, NoID, IDContrato, eg.Nombre, s.Nombre, con.Fecha"
                                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg, servicio s"
                                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND cj.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID"
                                                        + " AND ba.IDBarriocolonia = ? ORDER BY (ba.Abreviacion)");
                                                pse.setInt(1, Integer.parseInt(request.getParameter("Barrio")));
                                                pse.execute();
                                                emp = true;

                                            }
                                        } else {
                                            ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                    + "Segundo_Apellido, ba.Abreviacion, NoID, IDContrato, eg.Nombre , s.Nombre, con.Fecha"
                                                    + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg,  servicio s"
                                                    + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                    + " AND cn.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID ORDER BY (Primer_Nombre)");
                                            ps.execute();

                                            pse = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                    + " ba.Abreviacion, NoID, IDContrato, eg.Nombre, s.Nombre, con.Fecha"
                                                    + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, estado_general_cliente eg, servicio s"
                                                    + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                    + " AND cj.ESTADO_GENERAL_CLIENTE_ID = eg.ID AND con.SERVICIO_ID=s.ID ORDER BY (Nombre_Empresa)");
                                            pse.execute();
                                            emp = true;
                                        }
                                        ResultSet rsps = ps.getResultSet();
                                        String temp = "";
                                        while (rsps.next()) {

                                    %>

                                    <tr align="center">
                                        <td><%= temp = rsps.getString(7)%></td>
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
                                        <td><%= temp = rsps.getString(9)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(8)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(10)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rsps.getString(11)%></td>
                                        <% table.addCell(temp);%>
                                        <td><a href="Modificar Cliente Natural.jsp?ID=<%=rsps.getString(1)%>"></a></td>
                                    </tr>

                                    <% contador++;
                                        }
                                        ps.close();
                                        if (emp != false) {
                                            ResultSet rspse = pse.getResultSet();

                                            while (rspse.next()) {

                                    %>

                                    <tr align="center">
                                        <td><%= temp = rspse.getString(7)%></td>
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
                                        <td><%= temp = rspse.getString(9)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(8)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(10)%></td>
                                        <% table.addCell(temp);%>
                                        <td><%= temp = rspse.getString(11)%></td>
                                        <% table.addCell(temp);%>
                                        <td><a href="Modificar Cliente Juridico.jsp?ID=<%=rspse.getString(1)%>"></a></td>
                                    </tr>
                                    <% contador++;
                                                }
                                            }
                                        session.setAttribute("ar", table); 
                                        } catch (Exception ex) {
                                            System.out.println("SQL: " + ex.getMessage());
                                        }
                                    %>
                                </tbody>
                            </table>
                            <br/>
                        </div>
                        </br>
                        <label id="est">Total de Clientes: <input class="input-medium" name="clientes" id="est" value="<%= contador%>" size="8" type="text" readonly="readonly" /></label>
                         <button onclick="Exportar();">Exportar a PDF</button>
                        <script type="text/javascript">
                            function Exportar() {
                                window.location.href = 'Exportar.jsp?tit=Lista de Clientes&tot=<%=contador%>';
                            }
                        </script>
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
