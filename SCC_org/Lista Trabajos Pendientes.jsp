<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
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
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="SpryAssets/js/jquery.stickytableheaders.js" type="text/javascript"></script>
        <link href="SpryAssets/css/custom.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/css/tablesorter.css" rel="stylesheet" type="text/css" />
        <script>
            var href;
            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }

                // initialize stickyTableHeaders _after_ tablesorter
                $(".tablesorter").tablesorter();
                $("table").stickyTableHeaders();

                $('#tabla tr').click(function() {
                    href = $(this).find("a").attr("href");
                });

                $('#tabla tr').dblclick(function() {
                    var sel = $(this).find("select").attr("id");
                    var id = "#" + sel + " option:selected";
                    var estado = $(id).attr("id");
                    var href = $(this).find("a").attr("href");
                    if (href) {
                        window.location = href + "&est=" + estado;
                    }
                });
            });

            function Actualizar(IDOrden, ids) {
                var id = "#" + ids + " option:selected";
                var estado = $(id).attr("id");
                var pagonecesario = $('#pago').attr("value");
                var IDeot = $(id).val();
                if (estado === "REALIZADO") {
                    if (pagonecesario === "0") {
                        window.location = href + "&est=" + estado;
                    }
                    else {
                        jQuery.ajax({
                            url: "ControladoraOT.jsp",
                            async: true,
                            data: {
                                IDeot: IDeot,
                                IDOrden: IDOrden
                            },
                            success: function(data) {
                                console.log(data);
                                 
                                    window.location.reload();
                                
                            }
                        });

                    }
                }
                else {
                    jQuery.ajax({
                        url: "ControladoraOT.jsp",
                        async: true,
                        data: {
                            IDeot: IDeot,
                            IDOrden: IDOrden
                        },
                        success: function(data) {
                            console.log(data);
                        }
                    });
                }
            }

            function ActInst(IDInst, IDSelect) {
                var estado = $("#" + IDSelect + " option:selected").text();
                if (estado !== "REALIZADO") {
                    $.ajax({
                        url: "ControladoraOTINS.jsp",
                        async: true,
                        data: {
                            IDIns: IDInst,
                            estado: estado
                        },
                        success: function(data) {
                            console.log(data);
                        }
                    });
                }
                else {
                    if (href) {
                        window.location = href + "&est=" + estado;
                    }
                }
            }
        </script>

        <style type="text/css">

            #fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                padding: 10px;
                width: 110%;
            }
        </style>
    </head>

    <body>
        <jsp:include page="Menu.jsp" flush="false"></jsp:include>
            </br>
            </br>
            </br>
            <p id="titulo">Lista de Trabajos Pendientes</p>
            <div class="span12">
                <div id="fondotabla">
                    </br>
                    <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Primer Nombre</th>
                                <th>Segundo Nombre</th>
                                <th>Primer Apellido</th>
                                <th>Segundo Apellido</th>
                                <th>Barrio/Colonia</th>
                                <th>Servicio</th>
                                <th>Trabajo a Realizar</th>
                                <th>Prioridad</th>
                                <th>Estado de Orden</th>
                                <th>Técnico</th>
                                <th>Fecha</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            int cont = 0;
                            try {
                                Dba dba = new Dba();
                                dba.conectar();
                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                PreparedStatement ps = conn.prepareStatement("SELECT cn.IDCliente,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                        + "Segundo_Apellido, ba.Abreviacion, NoID,IDContrato, eoc.Nombre, tr.Nombre, s.Nombre, ot.Fecha, p.Nombre, eoc.ID,tr.Pago, Tecnico_Asignado, IDOrdenTrabajo"
                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl, contrato con, orden_trabajo ot, estado_orden_trabajo eoc, servicio s, prioridad p, trabajo_realizar tr"
                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                        + " AND ot.CONTRATO_IDContrato = IDContrato AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.ID=ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.Nombre!='REALIZADO'"
                                        + "AND con.SERVICIO_ID=s.ID AND ot.PRIORIDAD_ID = p.ID AND ot.TRABAJO_REALIZAR_ID = tr.ID  ORDER BY (Primer_Nombre)");
                                ps.execute();

                                PreparedStatement pse = conn.prepareStatement("SELECT cj.IDCliente,Nombre_Empresa, Representante, Cargo,"
                                        + "Fax, ba.Abreviacion, NoID,IDContrato, eoc.Nombre, tr.Nombre, s.Nombre, ot.Fecha, p.Nombre, eoc.ID,tr.Pago, Tecnico_Asignado, IDOrdenTrabajo"
                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl, contrato con, orden_trabajo ot, estado_orden_trabajo eoc, servicio s, prioridad p, trabajo_realizar tr"
                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                        + " AND ot.CONTRATO_IDContrato = IDContrato AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.ID=ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.Nombre!='REALIZADO'"
                                        + "AND con.SERVICIO_ID=s.ID AND ot.PRIORIDAD_ID = p.ID AND ot.TRABAJO_REALIZAR_ID = tr.ID  ORDER BY (Nombre_Empresa)");
                                pse.execute();

                                ResultSet rsps = ps.getResultSet();
                                while (rsps.next()) {
                                    String estadoorden = rsps.getString(9);
                                    String IDContrato = rsps.getString(8);
                                    String IDOrden = rsps.getString(17);
                        %>
                        <tr>
                            <td><%= rsps.getString(7)%></td>
                            <td><%= rsps.getString(2)%></td>
                            <td><%= rsps.getString(3)%></td>
                            <td><%= rsps.getString(4)%></td>
                            <td><%= rsps.getString(5)%></td>
                            <td><%= rsps.getString(6)%></td>
                            <td><%= rsps.getString(11)%></td>
                            <td><%= rsps.getString(10)%></td>
                            <td><%= rsps.getString(13)%></td>
                            <td>
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="estadotrabajo<%=cont%>" name="estadotrabajo" onchange="Actualizar(<%=IDOrden%>, this.id);" >
                                        <option id="<%=estadoorden%>" value="<%= rsps.getString(14)%>"><%= estadoorden%></option>
                                        <%
                                            PreparedStatement eot = conn.prepareStatement("SELECT ID, Nombre FROM estado_orden_trabajo WHERE Nombre!=? AND Estado = 0"
                                                    + " GROUP BY (Nombre)");
                                            eot.setString(1, estadoorden);
                                            eot.execute();
                                            ResultSet rseot = eot.getResultSet();
                                            while (rseot.next()) {
                                                estadoorden = rseot.getString(2);
                                        %>
                                        <option id="<%=estadoorden%>" value="<%= rseot.getString(1)%>"><%= estadoorden%></option>
                                        <%}
                                            eot.close();
                                        %>
                                    </select>
                                </div>
                            </td>
                            <td><%= rsps.getString(16)%></td>
                            <td><%= rsps.getString(12)%></td>
                            <td><a id="<%= IDContrato%>" href="Detalle del Trabajo.jsp?ID=<%= rsps.getString(1)%>&Cont=<%=IDContrato%>&tip=1&IDOrden=<%=IDOrden%>"></a></td>
                    <input type="hidden" name="pago" id="pago" value="<%=rsps.getString(15)%>" />
                    </tr>

                    <%     cont++;
                        }
                        ps.close();
                        ResultSet rspse = pse.getResultSet();
                        while (rspse.next()) {
                            String estadoorden = rspse.getString(9);
                            String IDContrato = rspse.getString(8);
                            String IDOrden = rspse.getString(17);
                    %>
                    <tr>
                        <td><%= rspse.getString(7)%></td>
                        <td><%= rspse.getString(2)%></td>
                        <td><%= rspse.getString(3)%></td>
                        <td><%= rspse.getString(4)%></td>
                        <td></td>
                        <td><%= rspse.getString(6)%></td>
                        <td><%= rspse.getString(11)%></td>
                        <td><%= rspse.getString(10)%></td>
                        <td><%= rspse.getString(13)%></td>
                        <td>
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-list"></i></span>
                                <select id="estadotrabajo<%=cont%>" name="estadotrabajo" onchange="Actualizar(<%=IDOrden%>, this.id);" >
                                    <option id="<%=estadoorden%>" value="<%= rspse.getString(14)%>"><%= estadoorden%></option>
                                    <%
                                        PreparedStatement eot = conn.prepareStatement("SELECT ID, Nombre FROM estado_orden_trabajo WHERE Nombre!=? AND Estado = 0"
                                                + " GROUP BY (Nombre)");
                                        eot.setString(1, estadoorden);
                                        eot.execute();

                                        ResultSet rseot = eot.getResultSet();
                                        while (rseot.next()) {
                                            estadoorden = rseot.getString(2);
                                    %>
                                    <option id="<%=estadoorden%>" value="<%= rseot.getString(1)%>"><%= estadoorden%></option>
                                    <%}
                                        eot.close();
                                    %>
                                </select>
                            </div>
                        </td>
                        <td><%= rspse.getString(16)%></td>
                        <td><%= rspse.getString(12)%></td>
                        <td><a href="Detalle del Trabajo.jsp?ID=<%= rspse.getString(1)%>&Cont=<%=IDContrato%>&tip=2&IDOrden=<%=IDOrden%>"></a></td>
                    <input type="hidden" name="pago" id="pago" value="<%=rspse.getString(15)%>" />
                    </tr>
                    <%  cont++;
                        }
                        pse.close();

                        PreparedStatement ins = conn.prepareStatement("SELECT * FROM instalacion"
                                + " WHERE Estado !='REALIZADO' ");
                        ins.execute();
                        ResultSet rsins = ins.getResultSet();
                        while (rsins.next()) {
                            int IDOrdenInstalacion = Integer.parseInt(rsins.getString(1));
                            int tipo = Integer.parseInt(rsins.getString(9));
                            String estadoorden = rsins.getString(11);
                            String pn = "";
                            String sn = "";
                            String pa = "";
                            String sa = "";
                            if (tipo == 1) {
                                pn = rsins.getString(2);
                                sn = rsins.getString(3);
                                pa = rsins.getString(4);
                                sa = rsins.getString(5);
                            } else {
                                pn = rsins.getString(6);
                                sn = rsins.getString(7);
                                pa = rsins.getString(8);
                                sa = "";
                            }
                    %>
                    <tr>
                        <td><%= IDOrdenInstalacion%></td>
                        <td><%= pn%></td>
                        <td><%= sn%></td>
                        <td><%= pa%></td>
                        <td><%= sa%></td>
                        <td><%= rsins.getString(12)%></td>
                        <td><%= rsins.getString(15)%></td>
                        <td><%= rsins.getString(13)%></td>
                        <td><%= rsins.getString(18)%></td>
                        <td>
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-list"></i></span>
                                <select id="estadotrabajo<%=cont%>" name="estadotrabajo" onchange="ActInst(<%=IDOrdenInstalacion%>, this.id);" >
                                    <option id="<%=estadoorden%>"><%= estadoorden%></option>
                                    <%
                                        PreparedStatement eot = conn.prepareStatement("SELECT Nombre FROM estado_orden_trabajo WHERE Nombre!=? AND Estado = 0"
                                                + " GROUP BY (Nombre)");
                                        eot.setString(1, estadoorden);
                                        eot.execute();
                                        ResultSet rseot = eot.getResultSet();
                                        while (rseot.next()) {
                                            estadoorden = rseot.getString(1);
                                    %>
                                    <option value="<%= rseot.getString(1)%>"><%= estadoorden%></option>
                                    <%}
                                        eot.close();
                                    %>
                                </select>
                            </div>
                        </td>
                        <td><%= rsins.getString(17)%></td>
                        <td><%= rsins.getString(10)%></td>
                        <td><a href="Detalle del Trabajo.jsp?tip=3&IDOrden=<%=IDOrdenInstalacion%>&ca=<%=rsins.getString(9)%>"></a></td>
                    </tr>

                    <%   cont++;
                            }
                        } catch (Exception ex) {
                            System.out.println("SQL LTP:" + ex.getMessage());
                        }



                    %>
                    </tbody>
                </table>
                <br/>
            </div>		
        </div>
    </body>
</html>
