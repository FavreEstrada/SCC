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
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap-responsive.css" type="text/css" media="screen"/>
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

                $('#tabla tr').click(function(){
                    var href = $(this).find("a").attr("href");
                    if (href) {
                        window.location = href;
                    }
                });
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }
            });

            function disableid() {
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = true;
                document.getElementById("pn").disabled = false;
                document.getElementById("pa").disabled = false;
                $('#pn').prop("class", "validate[required] text-input input-medium");
                $('#pa').prop("class", "validate[required] text-input input-medium");
                document.getElementById("btn_buscar").disabled = false;
            }

            function disablename() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = false;
                document.getElementById("empresa").disabled = true;
                $('#id').prop("class", "validate[required] text-input input-medium");
                document.getElementById("btn_buscar").disabled = false;
            }

            function disablecom() {
                document.getElementById("pn").disabled = true;
                document.getElementById("pa").disabled = true;
                document.getElementById("id").disabled = true;
                document.getElementById("empresa").disabled = false;
                $('#empresa').prop("class", "validate[required] text-input input-large");
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
                        <p id="titulo">Lista de Cobro</p> 

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
                                        <input type="radio" onclick="disablename();" name="busqueda" value="Por ID" id="busqueda_id" />
                                        Por Identificación</label>
                                    <label class="inline radio">
                                        <input type="radio" onclick="disablecom();" name="busqueda" value="Por Empresa" id="busqueda_empresa" />
                                        Por Nombre Empresa
                                    </label>
                                    </br>
                                    </br>
                                    Primer Nombre:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input id="pn" disabled="true" class="input-medium" name="primer_nombre" type="text" placeholder="Primer Nombre" />
                                    </div>
                                    Primer Apellido:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input id="pa" class="" disabled="true" class="input-medium" name="primer_apellido" type="text" placeholder="Primer Apellido" />
                                    </div>
                                    </br>
                                    </br>
                                    No. ID:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-pencil"></i></span>
                                        <input id="id" disabled="true" class="" name="no_identidad" class="input-medium" type="text" placeholder="No.ID" />
                                    </div>
                                    Nombre Empresa:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-briefcase"></i></span>
                                        <input id="empresa" class="" disabled="true" class="input-large" name="nombre_empresa" type="text" placeholder="Nombre de la Empresa" />
                                    </div>
                                    </br>
                                    </br>
                                    <input name="btn_buscar" type="submit" id="btn_buscar" class="btn btn-primary" disabled="disabled" value="Buscar" />
                                    </br>
                                    </br>
                                </div>
                            </form>
                            </br>
                            </br>
                            <div id="contenedorordenes">
                                <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Primer Nombre</th>
                                            <th>Segundo Nombre</th>
                                            <th>Primer Apellido</th>
                                            <th>Segundo Apellido</th>
                                            <th>Barrio/Colonia</th>
                                            <th>Mes(es) a Pagar</th>
                                            <th>Estado de Cobro</th>
                                            <th>Fecha Visita</th>
                                            <th>Servicio</th>
                                            <th>Cant. a Pagar</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        try {
                                            Dba dba = new Dba();
                                            dba.conectar();
                                            CalcMeses meses = new CalcMeses();

                                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                            PreparedStatement ps = null;
                                            PreparedStatement pse = null;
                                            Boolean emp = false;
                                            if (request.getParameter("btn_buscar") != null) {
                                                if (request.getParameter("busqueda").equals("Por Cliente")) {
                                                    ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                            + "Segundo_Apellido, ba.Abreviacion,oc.Fecha_Visita, NoID, No_Conexiones, count(oc.Fecha), ec.Nombre , SUM(CantidadPagar), s.Nombre"
                                                            + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, orden_cobro oc, estado_cobro ec, estado_pago_cliente ep, servicio s"
                                                            + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                            + " AND oc.CONTRATO_IDContrato = IDContrato AND ec.ID = oc.ESTADO_COBRO_ID AND ep.ID=oc.ESTADO_PAGO_CLIENTE_ID AND oc.Fecha < CURDATE() AND Fecha_Pagada='0000-00-00'"
                                                            + "AND con.SERVICIO_ID=s.ID AND Primer_Nombre=? AND Primer_Apellido=? AND ESTADO_GENERAL_CLIENTE_ID != (SELECT ID FROM estado_general_cliente WHERE Nombre = 'INACTIVO') GROUP BY (Primer_Nombre)");
                                                    String pn = request.getParameter("primer_nombre");
                                                    String pa = request.getParameter("primer_apellido");
                                                    ps.setString(1, pn.toUpperCase());
                                                    ps.setString(2, pa.toUpperCase());
                                                    ps.execute();
                                                } else if (request.getParameter("busqueda").equals("Por ID")) {
                                                    ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                            + "Segundo_Apellido, ba.Abreviacion,oc.Fecha_Visita, NoID, No_Conexiones, count(oc.Fecha), ec.Nombre , SUM(CantidadPagar), s.Nombre"
                                                            + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, orden_cobro oc, estado_cobro ec, estado_pago_cliente ep, servicio s"
                                                            + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                            + " AND oc.CONTRATO_IDContrato = IDContrato AND ec.ID = oc.ESTADO_COBRO_ID AND ep.ID=oc.ESTADO_PAGO_CLIENTE_ID AND oc.Fecha < CURDATE() AND Fecha_Pagada='0000-00-00'"
                                                            + "AND con.SERVICIO_ID=s.ID AND NoID=? AND ESTADO_GENERAL_CLIENTE_ID != (SELECT ID FROM estado_general_cliente WHERE Nombre = 'INACTIVO') GROUP BY (Primer_Nombre)");
                                                    String ID = request.getParameter("no_identidad");
                                                    ps.setString(1, ID.toUpperCase());
                                                    ps.execute();
                                                } else {
                                                    ps = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                            + " ba.Abreviacion,oc.Fecha_Visita, NoID, No_Conexiones, count(oc.Fecha), ec.Nombre , SUM(CantidadPagar), s.Nombre"
                                                            + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, orden_cobro oc, estado_cobro ec, estado_pago_cliente ep, servicio s"
                                                            + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                            + " AND oc.CONTRATO_IDContrato = IDContrato AND ec.ID = oc.ESTADO_COBRO_ID AND ep.ID=oc.ESTADO_PAGO_CLIENTE_ID AND oc.Fecha < CURDATE() AND Fecha_Pagada='0000-00-00'"
                                                            + "AND con.SERVICIO_ID=s.ID AND ESTADO_GENERAL_CLIENTE_ID != (SELECT ID FROM estado_general_cliente WHERE Nombre = 'INACTIVO') AND Nombre_Empresa=? GROUP BY (Nombre_Empresa)");
                                                    String empresa = request.getParameter("nombre_empresa");
                                                    ps.setString(1, empresa.toUpperCase());
                                                    ps.execute();
                                                }
                                            } else {
                                                ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                                        + "Segundo_Apellido, ba.Abreviacion,oc.Fecha_Visita, NoID, No_Conexiones,ec.Nombre , s.Nombre, IDContrato"
                                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con, orden_cobro oc, estado_cobro ec, estado_pago_cliente ep, servicio s"
                                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND oc.CONTRATO_IDContrato = IDContrato AND ec.ID = oc.ESTADO_COBRO_ID AND ep.ID=oc.ESTADO_PAGO_CLIENTE_ID AND oc.Fecha < CURDATE() AND Fecha_Pagada='0000-00-00'"
                                                        + "AND con.SERVICIO_ID=s.ID AND ESTADO_GENERAL_CLIENTE_ID != (SELECT ID FROM estado_general_cliente WHERE Nombre = 'INACTIVO') GROUP BY (Primer_Nombre)");
                                                ps.execute();

                                                pse = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo, Fax,"
                                                        + " ba.Abreviacion,oc.Fecha_Visita, NoID, No_Conexiones, ec.Nombre, s.Nombre,IDContrato"
                                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con, orden_cobro oc, estado_cobro ec, estado_pago_cliente ep, servicio s"
                                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                                        + " AND oc.CONTRATO_IDContrato = IDContrato AND ec.ID = oc.ESTADO_COBRO_ID AND ep.ID=oc.ESTADO_PAGO_CLIENTE_ID AND oc.Fecha < CURDATE() AND Fecha_Pagada='0000-00-00'"
                                                        + "AND con.SERVICIO_ID=s.ID AND ESTADO_GENERAL_CLIENTE_ID != (SELECT ID FROM estado_general_cliente WHERE Nombre = 'INACTIVO') GROUP BY (Nombre_Empresa)");
                                                pse.execute();
                                                emp = true;
                                            }
                                            ResultSet rsps = ps.getResultSet();
                                            while (rsps.next()) {
                                                String fechavisita = rsps.getString(7);
                                                if (fechavisita == null) {
                                                    fechavisita = "";
                                                }
                                                int mes = 0;
                                                double cuenta = 0.00;
                                                PreparedStatement ordps = conn.prepareStatement("SELECT COUNT(Fecha), SUM(CantidadPagar) FROM orden_cobro"
                                                        + " WHERE CONTRATO_IDCONTRATO = ? AND Fecha < CURDATE()"
                                                        + " AND Fecha_Pagada = '0000-00-00'");
                                                ordps.setInt(1, Integer.parseInt(rsps.getString(12)));
                                                ordps.execute();
                                                ResultSet ordrs = ordps.getResultSet();
                                                while (ordrs.next()) {
                                                    mes = Integer.parseInt(ordrs.getString(1));
                                                    cuenta = Double.parseDouble(ordrs.getString(2));
                                                }
                                                ordps.close();

                                    %>

                                    <tr align="center">
                                        <td><%= rsps.getString(8)%></td>
                                        <td><%= rsps.getString(2)%></td>
                                        <td><%= rsps.getString(3)%></td>
                                        <td><%= rsps.getString(4)%></td>
                                        <td><%= rsps.getString(5)%></td>
                                        <td><%= rsps.getString(6)%></td>
                                        <td><%= mes%></td>
                                        <td><%= rsps.getString(10)%></td>
                                        <td><%= fechavisita%></td>
                                        <td><%= rsps.getString(11)%></td>
                                        <td><%= cuenta%></td>
                                        <td><a href="Cobro_PagoCliente.jsp?ID=<%=rsps.getString(1)%>&Tip=1"></a></td>
                                    </tr>

                                    <%}
                                        ps.close();
                                        if (emp != false) {
                                            ResultSet rspse = pse.getResultSet();
                                            while (rspse.next()) {
                                                String fechavisita = rspse.getString(7);
                                                if (fechavisita == null) {
                                                    fechavisita = "";
                                                }
                                                int mes = 0;
                                                double cuenta = 0.00;
                                                PreparedStatement ordps = conn.prepareStatement("SELECT COUNT(Fecha), SUM(CantidadPagar) FROM orden_cobro"
                                                        + " WHERE CONTRATO_IDCONTRATO = ? AND Fecha < CURDATE()"
                                                        + " AND Fecha_Pagada = '0000-00-00'");
                                                ordps.setInt(1, Integer.parseInt(rspse.getString(12)));
                                                ordps.execute();
                                                ResultSet ordrs = ordps.getResultSet();
                                                while (ordrs.next()) {
                                                    mes = Integer.parseInt(ordrs.getString(1));
                                                    cuenta = Double.parseDouble(ordrs.getString(2));
                                                }
                                                ordps.close();
                                    %>

                                    <tr align="center">
                                        <td><%= rspse.getString(8)%></td>
                                        <td><%= rspse.getString(2)%></td>
                                        <td><%= rspse.getString(3)%></td>
                                        <td><%= rspse.getString(4)%></td>
                                        <td></td>
                                        <td><%= rspse.getString(6)%></td>
                                        <td><%= mes%></td>
                                        <td><%= rspse.getString(10)%></td>
                                        <td><%= fechavisita%></td>
                                        <td><%= rspse.getString(11)%></td>
                                        <td><%= cuenta%></td>
                                        <td><a href="Cobro_PagoCliente.jsp?ID=<%=rspse.getString(1)%>&Tip=2"></a></td>
                                    </tr>
                                    <%}
                                                pse.close();
                                            }
                                        } catch (Exception ex) {
                                            System.out.println("SQL LISTA COBROS TABLA: " + ex.getMessage());
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <br/>	
                    </div>
                </div>
            </div>
    </body>
</html>
