
<%@page import="BD.OC"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
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
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css" />
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery-maskedinput.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="SpryAssets/js/jquery.stickytableheaders.js" type="text/javascript"></script>
        <link href="SpryAssets/css/custom.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/css/tablesorter.css" rel="stylesheet" type="text/css" />
        <script>
            function Retornar() {
                location.href = "Busqueda Clientes.jsp";
            }

            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }

                // initialize stickyTableHeaders _after_ tablesorter
                $(".tablesorter").tablesorter();
                $("table").stickyTableHeaders();

                $('[name="check"].checkbox').click(function() {
                    oc = $(this).attr("value");
                    var chk = $('[name="check"].checkbox').is(':checked');
                    if (chk == true) {
                        location.href = "Detalle Cobro.jsp?IDOC=" + oc+ "&Tip=2" + "&IDCon=<%= request.getParameter("ID")%>";
                    }
                });


                $('#tabla tr').dblclick(function() {
                    oc = $(this).find("[name='check'].checkbox").attr("value");
                    var id = $(this).find("input").attr("id");
                    id = "[id=" + id + "].checkbox";
                    check = $(id).is(':checked');
                    var idsel = $(this).find('select[name=estadocobro]').attr("id");
                    var estado = $('#' + idsel + " option:selected").text();                    
                    if (check == false && estado !== "REALIZADO") {
                        $(id).prop('checked', true);
                        location.href = "Detalle Cobro.jsp?IDOC=" + oc + "&Tip=2" + "&IDCon=<%= request.getParameter("ID")%>";
                    }
                    else
                        $(id).prop('checked', false);
                });

                $('#tabla tr').click(function() {
                    ec = $(this).find("select").attr("id");
                    oc = $(this).find("[name='check'].checkbox").attr("value");
                    var href = $(this).find("a").attr("href");
                    if (href) {
                        window.location = href;
                    }
                });

                var tipousuario = '<%= session.getAttribute("s_Rol").toString()%>';
                if (tipousuario != "ADMINISTRADOR") {
                    $('#id').prop("readonly", "readonly");
                    $('#estadocliente').prop("disabled", "disabled");
                    $('#servicio').prop("disabled", "disabled");
                    $('#ext').prop("disabled", "disabled");
                    $('#empresa').prop("readonly", "readonly");
                    $('#rep').prop("readonly", "readonly");
                    $('#cargo').prop("readonly", "readonly");
                    $('#barriocolonia').prop("disabled", "disabled");
                    $('#phone').prop("readonly", "readonly");
                    $('#fax').prop("readonly", "readonly");
                    $('#email').prop("readonly", "readonly");
                    $('#dir').prop("readonly", "readonly");
                    $('#obser').prop("readonly", "readonly");
                    $('#btn_mod').prop("disabled", "disabled");
                }
                
            });

            jQuery(function($) {
                $("#phone").mask("9999-9999");
            });

            jQuery(function($) {
                $("#fax").mask("9999-9999");
            });



            function Actualizar() {
                var id = "#" + ec + " option:selected";
                var ides = $(id).val();


                var estado = $(id).attr("id");
                if (estado == "REALIZADO") {
                    location.href = "Detalle Cobro.jsp?IDOC=" + oc + "&Tip=2" + "&IDCon=<%= request.getParameter("ID")%>";
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
        </script>
        <style type="text/css">
            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left: auto;
                margin-right:auto;
                padding: 30px;
                text-align:center;
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
                        <p id="titulo">Modificar Contrato Cliente Jurídico</p>
                        <div id="fondotabla">
                            <div id="contenedorforma">
                                <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                    </br>
                                <%
                                    String tipoid = "";
                                    int idCliente = 0;

                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();

                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM cliente_juridico WHERE IDCliente=?");
                                        ps.setInt(1, Integer.parseInt(request.getParameter("ID")));
                                        ps.execute();
                                        ResultSet set = ps.getResultSet();

                                        while (set.next()) {
                                            idCliente = Integer.parseInt(set.getString(11));
                                            PreparedStatement ti = conn.prepareStatement("SELECT Tipo FROM identificacion i,cliente_juridico cj"
                                                    + " WHERE cj.IDENTIFICACION_ID=i.ID AND cj.IDCliente = ?");
                                            ti.setInt(1, Integer.parseInt(request.getParameter("ID")));
                                            ti.execute();
                                            ResultSet rsti = ti.getResultSet();

                                            while (rsti.next()) {
                                                tipoid = rsti.getString(1);
                                            }
                                            ti.close();

                                %>
                                <%= tipoid%>: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="id" id="id" type="text" value="<%= set.getString(12)%>" class="validate[required] text-input input-medium" size="14"/>
                                </div>
                                Estado Gen. del Cliente:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="estadocliente" name="estado_cliente" class="input-medium">
                                        <%
                                            PreparedStatement ps3 = conn.prepareStatement("SELECT ID, Nombre FROM estado_general_cliente WHERE ID=?");
                                            int IDestado = 0;
                                            IDestado = Integer.parseInt(set.getString(10));
                                            ps3.setInt(1, IDestado);
                                            ps3.execute();
                                            ResultSet rs3 = ps3.getResultSet();
                                            while (rs3.next()) {
                                        %>
                                        <option value="<%=rs3.getString(1)%>"><%=rs3.getString(2)%></option>
                                        <%}
                                            ps3.close();

                                            PreparedStatement ps4 = conn.prepareStatement("SELECT ID, Nombre FROM estado_general_cliente WHERE Estado=0 AND ID!=?"
                                                    + " GROUP BY(Nombre)");
                                            ps4.setInt(1, IDestado);
                                            ps4.execute();
                                            ResultSet rs4 = ps4.getResultSet();
                                            while (rs4.next()) {
                                        %>
                                        <option value="<%=rs4.getString(1)%>"><%=rs4.getString(2)%></option>
                                        <%}
                                            ps4.close();

                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                Servicio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="servicio" name="servicio" class="input-medium">
                                        <%
                                            PreparedStatement ps5 = conn.prepareStatement("SELECT ID,Nombre FROM servicio s, contrato c, cliente cl,"
                                                    + "cliente_juridico cj WHERE cj.IDCliente=? AND cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=c.CLIENTE_idcliente"
                                                    + " AND c.SERVICIO_ID=s.ID");
                                            ps5.setInt(1, Integer.parseInt(request.getParameter("ID")));
                                            ps5.execute();
                                            ResultSet rs5 = ps5.getResultSet();
                                            int IDServicio = 0;
                                            while (rs5.next()) {
                                                IDServicio = Integer.parseInt(rs5.getString(1));
                                        %>

                                        <option value="<%=IDServicio%>"><%= rs5.getString(2)%></option>    
                                        <%}
                                            ps5.close();

                                            PreparedStatement ps2 = conn.prepareStatement("SELECT ID, Nombre FROM servicio WHERE Estado=0 AND ID!=? "
                                                    + " GROUP BY (Nombre)");
                                            ps2.setInt(1, IDServicio);
                                            ps2.execute();
                                            ResultSet rs2 = ps2.getResultSet();
                                            while (rs2.next()) {
                                        %>
                                        <option value="<%=rs2.getString(1)%>"><%=rs2.getString(2)%></option>
                                        <%}
                                            ps2.close();
                                        %>
                                    </select>
                                </div>
                                <%
                                    PreparedStatement psce = conn.prepareStatement("SELECT No_Conexiones FROM contrato c,cliente WHERE idCLIENTE=? AND c.CLIENTE_idcliente=idCLIENTE");
                                    psce.setInt(1, idCliente);
                                    psce.execute();
                                    ResultSet rsce = psce.getResultSet();
                                    int cantex = 1;
                                    while (rsce.next()) {
                                        cantex = Integer.parseInt(rsce.getString(1));
                                    }
                                    psce.close();
                                %>
                                Cant. Extensiones: <input type="number" style="height:30px;" min="0" id="ext" name="extensiones" value="<%=cantex%>" class="input-small" />
                                </br>
                                </br>
                                Nombre Empresa:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-briefcase"></i></span>
                                    <input name="nombre_empresa" id="empresa" type="text" value="<%=set.getString(2)%>" size="30" class="validate[required] text-input input-large" maxlength="30"/>
                                </div>
                                Representante:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="representante" class="input-medium" id="rep" type="text" value="<%=set.getString(3)%>" maxlength="20" size="20" placeholder="Representante"/>
                                </div>
                                </br>
                                </br>
                                Cargo:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="cargo" id="cargo" type="text" class="input-medium" value="<%=set.getString(4)%>" maxlength="20" size="20" placeholder="Cargo"/>
                                </div>
                                Barrio o Colonia: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="barriocolonia" name="barriocolonia" class="input-small">
                                        <%

                                            PreparedStatement psbc = conn.prepareStatement("SELECT b.IDBarriocolonia,Abreviacion FROM barriocolonia b, contrato c,cliente"
                                                    + " WHERE idCLIENTE = ? AND c.CLIENTE_idcliente = idCLIENTE AND c.IDBarriocolonia = b.IDBarriocolonia");
                                            psbc.setInt(1, idCliente);
                                            psbc.execute();
                                            ResultSet rsbc = psbc.getResultSet();
                                            int IDBarriocolonia = 0;
                                            while (rsbc.next()) {
                                                IDBarriocolonia = Integer.parseInt(rsbc.getString(1));
                                        %>
                                        <option value="<%=IDBarriocolonia%>"><%=rsbc.getString(2)%></option>
                                        <%}
                                            psbc.close();

                                            PreparedStatement ps1 = conn.prepareStatement("SELECT IDBarriocolonia, Abreviacion FROM barriocolonia WHERE Estado=0 "
                                                    + "AND Cobertura=0 AND IDBarriocolonia!=? GROUP BY (Abreviacion)");
                                            ps1.setInt(1, IDBarriocolonia);
                                            ps1.execute();
                                            ResultSet rs1 = ps1.getResultSet();
                                            while (rs1.next()) {
                                        %>
                                        <option value="<%=rs1.getString(1)%>"><%=rs1.getString(2)%></option>
                                        <%}
                                            ps1.close();
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                Télefono:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="phone" placeholder="Teléfono" name="telefono" class="input-small" type="tel" value="<%=set.getString(6)%>" size="8" maxlength="8" />
                                </div>
                                Fax:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="fax" name="fax" type="tel" placeholder="Fax" class="input-small" value="value="<%=set.getString(7)%>" size="8" maxlength="8" />
                                </div>
                                </br>
                                </br>
                                Email:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-envelope"></i></span>
                                    <input name="email" id="email" class="input-medium" placeholder="Email" type="email" value="<%=set.getString(8)%>" maxlength="30" size="30"/>
                                </div>
                                </br>
                                </br>
                                Dirección: <textarea name="direccion" placeholder="Dirección" id="dir" class="validate[required] text-input" maxlength="100"><%=set.getString(5)%></textarea>
                                Observaciones: <textarea name="observaciones" placeholder="Observaciones" id="obser" maxlength="45" size="45"><%=set.getString(9)%></textarea>
                                </br>
                                </br>
                                <%
                                        }
                                    } catch (Exception ex) {
                                        System.out.println("SQL: " + ex.getMessage());
                                    }
                                %>

                                <input name="btn_modificar" id="btn_mod" class="btn btn-primary" type="submit" value="Guardar Cambios" />
                                <input name="btn_cancelar" type="button" class="btn" value="Cancelar" onclick="Retornar();"/>

                            </form>
                        </div>
                        <%
                            if (request.getParameter("btn_modificar") != null) {
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                    PreparedStatement st3 = conn.prepareStatement("SELECT CURDATE()");
                                    st3.execute();
                                    ResultSet s = st3.getResultSet();
                                    String fecha = "";
                                    while (s.next()) {
                                        fecha = s.getString(1);
                                    }
                                    st3.close();

                                    PreparedStatement ps = conn.prepareStatement("UPDATE cliente_juridico "
                                            + " SET Nombre_Empresa=?, Representante =?, Cargo = ?, Direccion=?,"
                                            + " Telefono=?,Fax=?, Email=?, Observaciones=?, ESTADO_GENERAL_CLIENTE_ID=? WHERE IDCliente=?");
                                    String empresa = request.getParameter("nombre_empresa");
                                    String repre = request.getParameter("representante");
                                    String cargo = request.getParameter("cargo");
                                    String dir = request.getParameter("direccion");
                                    ps.setString(1, empresa.toUpperCase());
                                    ps.setString(2, repre.toUpperCase());
                                    ps.setString(3, cargo.toUpperCase());
                                    ps.setString(4, dir.toUpperCase());
                                    String tel = request.getParameter("telefono");
                                    String tel2 = "";
                                    int telint = 0;
                                    if (!tel.equals("")) {
                                        for (int i = 0; i < tel.length(); i++) {
                                            if (tel.charAt(i) != '-') {
                                                tel2 += tel.charAt(i);
                                            }
                                        }
                                        telint = Integer.parseInt(tel2);
                                    }
                                    ps.setInt(5, telint);

                                    String fax = request.getParameter("fax");
                                    String fax2 = "";
                                    int faxint = 0;
                                    if (!fax.equals("")) {
                                        for (int i = 0; i < fax.length(); i++) {
                                            if (fax.charAt(i) != '-') {
                                                fax2 += fax.charAt(i);
                                            }
                                        }
                                        faxint = Integer.parseInt(fax2);
                                    }
                                    ps.setInt(6, faxint);
                                    ps.setString(7, request.getParameter("email"));
                                    ps.setString(8, request.getParameter("observaciones"));
                                    ps.setInt(9, Integer.parseInt(request.getParameter("estado_cliente")));
                                    ps.setInt(10, Integer.parseInt(request.getParameter("ID")));
                                    ps.execute();
                                    ps.close();

                                    OC ordencobro = new OC();
                                    Boolean error = true;
                                    error = ordencobro.ActualizarOrdenes(idCliente, Integer.parseInt(request.getParameter("extensiones")));

                                    PreparedStatement st2 = conn.prepareStatement("UPDATE contrato c, cliente cl SET Fecha=?, IDBarriocolonia=?, USUARIO_IDUsuario=?,"
                                            + " SERVICIO_ID =?, No_Conexiones=? WHERE c.CLIENTE_idcliente=?");
                                    st2.setString(1, fecha);
                                    st2.setInt(2, Integer.parseInt(request.getParameter("barriocolonia")));
                                    st2.setInt(3, Integer.parseInt(session.getAttribute("s_ID").toString()));
                                    st2.setInt(4, Integer.parseInt(request.getParameter("servicio")));
                                    st2.setInt(5, Integer.parseInt(request.getParameter("extensiones")));
                                    st2.setInt(6, idCliente);

                                    if (st2.execute() == false && error == false) {
                                        out.print("<script>alert('El cliente se actualizó correctamente')</script>");
                                        out.print("<script>location.href = 'Principal.jsp'</script>");
                                    }
                                    st2.close();
                                    conn.close();

                                } catch (Exception ex) {
                                    System.out.println("SQL: " + ex.getMessage());
                                }
                            }
                        %>
                        </br>
                        <div class="accordion" id="accordion2">
                            <div class="accordion-group">
                                <div class="accordion-heading">
                                    <a class="accordion-toggle btn-info" data-toggle="collapse" data-parent="#accordion2" href="#collapseOne">
                                        <p id="titulo">Órdenes de Cobro</p>
                                    </a>
                                </div>
                                <div id="collapseOne" class="accordion-body collapse in">
                                    <div class="accordion-inner">
                                        <div id="contenedor_ordenes">
                                            <table id="tabla" class="tableWithFloatingHeader stock tablesorter table-condensed">
                                                <thead>
                                                    <tr>
                                                        <th>Fact.</th>
                                                        <th>Fecha</th>
                                                        <th>Mes en Mora</th>
                                                        <th>Servicio</th>
                                                        <th>Est. de Pago</th>
                                                        <th>Est. de Cobro</th>
                                                        <th>Descuento</th>
                                                        <th>Total</th>
                                                        <th>Fecha Pagada</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        OC cobro = new OC();
                                                        int IDContrato = 0;
                                                        try {
                                                            String fact = "";
                                                            Dba dba = new Dba();
                                                            dba.conectar();
                                                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                            PreparedStatement ps = conn.prepareStatement("SELECT IDOrdenCobro, CantidadPagar, oc.Fecha, ec.Nombre, ep.Nombre, s.Nombre, ec.ID, oc.Fecha_Pagada, oc.Descuento,c.IDContrato"
                                                                    + " FROM contrato c, orden_cobro oc, servicio s,"
                                                                    + "estado_cobro ec, estado_pago_cliente ep "
                                                                    + "WHERE c.CLIENTE_idcliente = ? AND c.SERVICIO_ID = s.ID AND oc.CONTRATO_IDContrato=c.IDContrato AND oc.ESTADO_COBRO_ID=ec.ID AND oc.ESTADO_PAGO_CLIENTE_ID=ep.ID"
                                                                    + " ORDER BY (oc.Fecha)");
                                                            ps.setInt(1, idCliente);
                                                            ps.execute();
                                                            ResultSet rsps = ps.getResultSet();
                                                            String fec = "";
                                                            int cont = 0;
                                                            Double desc = 0.00;
                                                            while (rsps.next()) {
                                                                IDContrato = Integer.parseInt(rsps.getString(10));
                                                                fec = rsps.getString(3);
                                                                fact = rsps.getString(1);
                                                    %>
                                                    <tr>
                                                        <td><%= fact%></td>
                                                        <td><%= fec%></td>
                                                        <td><%= cobro.MesActual(fec)%></td>
                                                        <td><%=rsps.getString(6)%></td>
                                                        <td><%= rsps.getString(5)%></td>
                                                        <td><select name="estadocobro" id="ec<%=cont%>" onchange="Actualizar()";>
                                                                <%
                                                                    String estadocobro = rsps.getString(4);
                                                                %>
                                                                <option id="<%=estadocobro%>" value="<%=rsps.getString(7)%>"><%=estadocobro%></option>
                                                                <%
                                                                    PreparedStatement psec = conn.prepareStatement("SELECT ID, Nombre FROM"
                                                                            + " estado_cobro WHERE Nombre!=?");
                                                                    psec.setString(1, estadocobro);
                                                                    psec.execute();
                                                                    ResultSet rspsec = psec.getResultSet();
                                                                    while (rspsec.next()) {
                                                                        estadocobro = rspsec.getString(2);
                                                                %>
                                                                <option id="<%=estadocobro%>" value="<%= rspsec.getString(1)%>" ><%= estadocobro%></option>
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
                                                        </td>
                                                        <td><%=  desc = Double.parseDouble(rsps.getString(9))%></td>
                                                        <td><%= Double.parseDouble(rsps.getString(2)) - desc%></td>
                                                        <%
                                                            String fechapag = rsps.getString(8);
                                                            if (fechapag == null) {
                                                                fechapag = "";
                                                            }
                                                        %>
                                                        <td><%=fechapag%></td>
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
                                        </div>
                                        </br>
                                        <input title="Crea la orden solamente si no hay pendientes" type="button" name="btn_generar" value="Generar Factura de Cobro" class="btn btn-warning" onclick="<% cobro.RevisarContratoTerminado(IDContrato);%>" id="btn_gen"/>
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-group">
                                <div class="accordion-heading">
                                    <a class="accordion-toggle btn-info" data-toggle="collapse" data-parent="#accordion2" href="#collapseTwo">
                                        <p id="titulo">Órdenes de Trabajo </p>
                                    </a>
                                </div>
                                <div id="collapseTwo" class="accordion-body collapse">
                                    <div class="accordion-inner">
                                        <div id="contenedor_ordenes">
                                            <table class="tableWithFloatingHeader stock tablesorter table-condensed">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Fecha</th>
                                                        <th>Trabajo Realizado</th>
                                                        <th>Servicio</th>
                                                        <th>IDContrato</th>
                                                        <th>Barrio</th>
                                                        <th>Técnico</th>
                                                        <th>IDFactura</th>
                                                        <th>Descripción</th>
                                                        <th>Cantidad Pagada</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        try {
                                                            Dba dba = new Dba();
                                                            dba.conectar();
                                                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                            PreparedStatement ps = conn.prepareStatement("SELECT ba.Abreviacion, c.IDContrato, s.Nombre, ot.Fecha, Tecnico_Asignado,tr.Nombre, ot.IDOrdenTrabajo"
                                                                    + " FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, servicio s, orden_trabajo ot, trabajo_realizar tr"
                                                                    + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                                                    + " AND c.SERVICIO_ID = s.ID AND c.IDContrato = ot.CONTRATO_IDContrato "
                                                                    + " AND ot.TRABAJO_REALIZAR_ID = tr.ID AND c.CLIENTE_idcliente = ?");
                                                            ps.setInt(1, idCliente);
                                                            ps.execute();
                                                            ResultSet rs = ps.getResultSet();
                                                            while (rs.next()) {
                                                                int Orden = Integer.parseInt(rs.getString(7));%>
                                                    <tr>
                                                        <td><%=Orden%></td>
                                                        <td><%=rs.getString(4)%></td>
                                                        <td><%=rs.getString(6)%></td>
                                                        <td><%=rs.getString(3)%></td>
                                                        <td><%=rs.getString(2)%></td>
                                                        <td><%=rs.getString(1)%></td>
                                                        <td><%=rs.getString(5)%></td>

                                                        <% PreparedStatement fac = conn.prepareStatement("SELECT IDFactura, Descripcion, Cantidad_Pagada"
                                                                    + " FROM factura where ORDEN_TRABAJO_IDOrdenTrabajo = ?");
                                                            fac.setInt(1, Orden);
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
                                                            fac.close();%>
                                                        <td><%=IDfac%></td>
                                                        <td><%=descf%></td>
                                                        <td><%=cantf%></td>
                                                    </tr>
                                                    <%}
                                                        } catch (Exception ex) {
                                                            System.out.println("SQL LISTA ORDENES DE TRABAJO CLIENTE " + ex.getMessage());
                                                        }
                                                    %>
                                                </tbody>
                                            </table></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
       <script>
            $(document).ready(function() {
                $('#tabla tr').each(function() {
                    var idsel = $(this).find('select[name=estadocobro]').attr("id");
                    var idchk = $(this).find('input[name=check]').attr("id");
                    var estado = $('#' + idsel + " option:selected").text();
                    if (estado === "REALIZADO"){
                        document.getElementById(idsel).disabled = true;
                        document.getElementById(idchk).disabled = true;
                    }
                });
            });
        </script>
    </body>
</html>
