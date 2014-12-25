<%@page import="BD.OC"%>
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
        <script src="SpryAssets/js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="SpryAssets/js/jquery.stickytableheaders.js" type="text/javascript"></script>
        <link href="SpryAssets/css/custom.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/css/tablesorter.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            var oc = "";
            var ec = "";
            var check;

            function Retornar() {
                location.href = "Lista Cobros.jsp";
            }

            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }

                // initialize stickyTableHeaders _after_ tablesorter
                $(".tablesorter").tablesorter();
                $("table").stickyTableHeaders();

                $('#tabla tr').click(function() {
                    oc = $(this).find("[name='check'].checkbox").attr("value");
                    ec = $(this).find("select").attr("id");

                });

                $('[name="check"].checkbox').click(function() {
                    oc = $(this).attr("value");
                    var chk = $('[name="check"].checkbox').is(':checked');
                    if (chk == true) {
                        var contrato = $('#contrato').val();
                        location.href = "Detalle Cobro.jsp?IDOC=" + oc + "&Tip=<%=request.getParameter("Tip")%>" + "&IDCon=" + contrato;
                    }
                });


                $('#tabla tr').dblclick(function() {
                    oc = $(this).find("[name='check'].checkbox").attr("value");
                    var id = $(this).find("input").attr("id");
                    id = "[id=" + id + "].checkbox";
                    check = $(id).is(':checked');
                    if (check == false) {
                        $(id).prop('checked', true);
                        var contrato = $('#contrato').val();
                        location.href = "Detalle Cobro.jsp?IDOC=" + oc + "&Tip=<%=request.getParameter("Tip")%>" + "&IDCon=" + contrato;
                    }
                    else
                        $(id).prop('checked', false);
                });
            });

            function Actualizar() {
                var id = "#" + ec + " option:selected";
                var ides = $(id).val();


                var estado = $(id).text();
                if (estado == "REALIZADO") {
                    var contrato = $('#contrato').val();
                    location.href = "Detalle Cobro.jsp?IDOC=" + oc + "&Tip=<%=request.getParameter("Tip")%>" + "&IDCon=" + contrato;
                }
                else {
                    jQuery.ajax({
                        url: "ControladoraOC.jsp",
                        async: true,
                        data: {
                            ides: ides,
                            idoc: oc
                        },
                        success: function(data) {
                            console.log(data);
                        }
                    });
                }
            }

            function CambiarFecha(fecha) {
                jQuery.ajax({
                    url: "ControladoraOCFECHA.jsp",
                    async: true,
                    data: {
                        idoc: oc,
                        fecha: fecha
                    },
                    success: function(data) {
                        console.log(data);
                    }
                });
            }

        </script>

        <style type="text/css">

            div#facturas
            {
                width:100px;
                height:100px;
                overflow:scroll;
            }

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left: auto;
                margin-right:auto;
                padding: 30px;
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
                        <p id="titulo">Cobros: Pago del Cliente por Mensualidad</p>

                        <div id="fondotabla">
                        <%
                            String fecha = "";
                            int IDContrato = 0;
                            double cant = 0.0;
                            try {
                                Dba dba = new Dba();
                                dba.conectar();
                                PreparedStatement pscn = null;
                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                PreparedStatement ps = conn.prepareStatement("SELECT CURDATE()");
                                ps.execute();

                                ResultSet rs = ps.getResultSet();
                                while (rs.next()) {
                                    fecha = rs.getString(1);
                                }
                                ps.close();
                                String tipo = request.getParameter("Tip");
                                String pn = "";
                                String pa = "";
                                String sn = "";
                                String sa = "";
                                String sav = "";
                                boolean emp = false;
                                if (tipo.equals("1")) {
                                    pscn = conn.prepareStatement("SELECT cn.IDCliente, Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                            + "Segundo_Apellido, ba.Nombre, Telefono, Direccion, con.IDContrato, con.No_Conexiones, cn.Observaciones"
                                            + " FROM cliente_natural cn,barriocolonia ba,cliente cl ,contrato con"
                                            + " WHERE cn.IDCliente = ? AND  cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia");
                                    pscn.setInt(1, Integer.parseInt(request.getParameter("ID")));
                                    pscn.execute();
                                    pn = "Primer Nombre:";
                                    sn = "Segundo Nombre:";
                                    pa = "Primer Apellido:";
                                    sa = "Segundo Apellido:";

                                } else {
                                    pscn = conn.prepareStatement("SELECT cj.IDCliente, Nombre_Empresa, Representante, Cargo,"
                                            + "Fax, ba.Nombre, Telefono, Direccion, con.IDContrato, con.No_Conexiones,cj.Observaciones"
                                            + " FROM cliente_juridico cj,barriocolonia ba,cliente cl ,contrato con"
                                            + " WHERE cj.IDCliente = ? AND cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia");
                                    pscn.setInt(1, Integer.parseInt(request.getParameter("ID")));
                                    pscn.execute();
                                    pn = "Nombre de la Empresa:";
                                    sn = "Representante:";
                                    pa = "Cargo:";
                                    sa = "::";
                                    emp = true;
                                }
                                ResultSet rspscn = pscn.getResultSet();
                                while (rspscn.next()) {
                                    IDContrato = Integer.parseInt(rspscn.getString(9));
                                    sav = rspscn.getString(5);
                                    if (emp == true) {
                                        sav = "";
                                    }
                        %>
                        <div id="contenedorforma">
                            </br>
                            <%= pn%>
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-user"></i></span>
                                <input name="primer_nombre" type="text" value="<%= rspscn.getString(2)%>" size="22" readonly="readonly" class="input-medium"/>
                            </div>
                            <%= sn%> 
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-user"></i></span>
                                <input name="segundo_nombre" type="text" value="<%= rspscn.getString(3)%>" size="22" readonly="readonly" class="input-medium"/>
                            </div>
                            </br>
                            </br>
                            <%= pa%>
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-user"></i></span>
                                <input name="primer_apellido" type="text" value="<%= rspscn.getString(4)%>" size="22" readonly="readonly" class="input-medium"/>
                            </div>
                            <%= sa%> 
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-user"></i></span>
                                <input name="segundo_apellido" type="text" value="<%= sav%>" size="22" readonly="readonly" class="medium"/>
                            </div>
                            </br>
                            </br>
                            Barrio o Colonia: <input name="barrioocolonia" size="15" type="text" value="<%= rspscn.getString(6)%>" readonly="readonly" class="input-medium"/>
                            <%
                                String tel = rspscn.getString(7);
                                if (tel.equals("0")) {
                                    tel = "";
                                }
                            %>
                            Télefono: <input name="telefono" type="text" value="<%= tel%>" class="input-small" size="7" readonly="readonly"/>
                            </br>
                            </br>
                            No. Contrato: <input type="text" id="contrato" name="Contrato" class="input-small" size="8" readonly="readonly" value="<%=IDContrato%>" />
                            No. Conexiones: <input type="text" id="conexiones" name="Conexiones" size="3" class="input-small" readonly="readonly" value="<%=rspscn.getString(10)%>" />
                            </br>
                            </br>
                            Dirección: <textarea name="direccion" readonly="readonly" ><%= rspscn.getString(8)%></textarea>
                            Observaciones: <textarea name="observaciones" readonly="readonly" ><%= rspscn.getString(11)%></textarea>
                            </br>
                            </br>
                        </div>
                        <%}
                                rspscn.close();
                                conn.close();
                            } catch (Exception ex) {
                                System.out.println("SQL:" + ex.getMessage());
                            }
                        %>
                        </br>
                        <p id="titulo">Cuotas Mensuales</p>
                        <table id="tabla" class="tableWithFloatingHeader stock tablesorter">
                            <thead>
                                <tr>
                                    <th>Fact.</th>
                                    <th>Fecha</th>
                                    <th>Mes en Mora</th>
                                    <th>Servicio</th>
                                    <th>Est. de Pago</th>
                                    <th>Est. de Cobro</th>
                                    <th>Fecha Visita</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try {
                                        String fact = "";
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                        PreparedStatement ps = conn.prepareStatement("SELECT IDOrdenCobro, CantidadPagar, oc.Fecha, ec.Nombre, ep.Nombre, s.Nombre, ec.ID, oc.Fecha_Visita"
                                                + " FROM contrato c, orden_cobro oc, servicio s,"
                                                + "estado_cobro ec, estado_pago_cliente ep "
                                                + "WHERE c.IDContrato = ? AND c.SERVICIO_ID = s.ID AND oc.CONTRATO_IDContrato=c.IDContrato AND oc.ESTADO_COBRO_ID=ec.ID AND oc.ESTADO_PAGO_CLIENTE_ID=ep.ID"
                                                + " AND ec.Nombre!='REALIZADO' ORDER BY (oc.Fecha)");
                                        ps.setInt(1, IDContrato);
                                        ps.execute();
                                        ResultSet rsps = ps.getResultSet();
                                        OC cobro = new OC();
                                        String fec = "";
                                        int cont = 0;
                                        while (rsps.next()) {
                                            fec = rsps.getString(3);
                                            fact = rsps.getString(1);
                                %>
                                <tr>
                                    <td><%= fact%></td>
                                    <td><%= fec%></td>
                                    <td><%= cobro.MesActual(fec)%></td>
                                    <td><%=rsps.getString(6)%></td>
                                    <td><%=rsps.getString(5)%></td>
                                    <td>
                                        <div class="input-prepend">
                                            <span class="add-on"><i class="icon-list"></i></span>
                                            <select name="estadocobro" id="ec<%=cont%>" onchange="Actualizar();">
                                                <%
                                                    String estadocobro = rsps.getString(4);
                                                %>
                                                <option value="<%=rsps.getString(7)%>"><%=estadocobro%></option>
                                                <%
                                                    PreparedStatement psec = conn.prepareStatement("SELECT ID, Nombre FROM"
                                                            + " estado_cobro WHERE Nombre!=?");
                                                    psec.setString(1, estadocobro);
                                                    psec.execute();
                                                    ResultSet rspsec = psec.getResultSet();
                                                    while (rspsec.next()) {
                                                        estadocobro = rspsec.getString(2);
                                                %>
                                                <option  value="<%= rspsec.getString(1)%>" ><%= estadocobro%></option>
                                                <%}
                                                    psec.close();

                                                    PreparedStatement rec = conn.prepareStatement("SELECT MAX(IDOrdenCobro) FROM orden_cobro");
                                                    rec.execute();
                                                    ResultSet rsrec = rec.getResultSet();
                                                    String recibo = "";
                                                    while (rsrec.next()) {
                                                        recibo = rsrec.getString(1);
                                                    }
                                                    rec.close();
                                                %>
                                            </select>
                                        </div>
                                    </td>
                                    <%
                                        String fecvis = rsps.getString(8);
                                        if (fecvis == null) {
                                            fecvis = "";
                                        }
                                    %>
                                    <td>
                                        <div class="input-prepend">
                                            <span class="add-on"><i class="icon-calendar"></i></span>
                                        <input name="fecha_visita" id="fec_vis" class="input-medium" type="date" value="<%=fecvis%>" onchange="CambiarFecha(this.value)" /></td>
                                    </div>
                                    <td><%=rsps.getString(2)%></td>
                                    <td><input type="checkbox" name="check" class="checkbox" id="<%=cont%>" value="<%=fact%>"></td>
                                </tr>
                                <%  cont++;
                                        }
                                        ps.close();
                                    } catch (Exception ex) {
                                        System.out.println("SQL: " + ex.getMessage());
                                    }
                                %>
                            </tbody>
                        </table>
                        </br>
                        <input name="btn_cancelar" type="button" class="btn" onclick="Retornar();" value="Regresar" />
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
