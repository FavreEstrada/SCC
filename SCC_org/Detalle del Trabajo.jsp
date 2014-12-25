<%@page import="BD.OT"%>
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
        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>

        <script>

            jQuery(document).ready(function() {
                Activar('<%= request.getParameter("tip")%>');
                $('#estadotrabajo').change(function() {
                    var estado = $('#estadotrabajo option:selected').attr("id");
                    var pago = $('#pago').val();
                    if (estado === "REALIZADO" && pago == "SI") {
                        $('#fact').css("display", "inline");
                    }
                    else {
                        $('#fact').css("display", "none");
                    }
                });

                var pago = $("#pago").val();
                var real = '<%=request.getParameter("est")%>';
                if (pago === "SI" && real === "REALIZADO") {
                    $('#fact').css("display", "inline");
                }
                else {
                    $('#fact').css("display", "none");
                }

                jQuery("#forma").validationEngine();

                $('#cantpagada').change(function() {
                    var cantidad = $(this).val();
                    if (cantidad < 0) {
                        alert("Error al Ingresar Cantidad Pagada");
                    }
                });
            });
            function Retornar() {
                location.href = "Lista Trabajos Pendientes.jsp";
            }

            function Activar(tipo) {
                if (tipo === "2") {
                    $('#emp').css("display", "inline");
                }

                if (tipo === "3") {
                    var caso = '<%= request.getParameter("ca")%>';
                    if (caso === "2") {
                        $('#emp').css("display", "inline");
                    }
                    document.getElementById("comentarios").disabled = true;
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
                width: 50%;
                text-align:center;
            }
            div#fact{
                display:none;
            }

            div#emp{
                display: none;
            }

        </style>
    </head>

    <body>
        <jsp:include page="Menu.jsp" flush="false"></jsp:include>
            </br>
            </br>
            </br>
            <p id="titulo">Detalle de Trabajo</p>
            <div id="fondotabla">
                <form id="forma" method="post" onsubmit="return jQuery(this).validationEngine('validate');">  
                    <div id="contenedorforma">
                        </br>
                    <%
                        int IDCliente = 0;
                        int IDContrato = 0;
                        int IDOrden = 0;
                        int rec = 0;
                        Double precio = 0.00;
                        try {
                            Dba dba = new Dba();
                            dba.conectar();
                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                            PreparedStatement ps = null;
                            String apellido = "Apellido";
                            String temp = "";
                            if (request.getParameter("tip").equals("1")) {
                                IDCliente = Integer.parseInt(request.getParameter("ID"));
                                IDContrato = Integer.parseInt(request.getParameter("Cont"));

                                ps = conn.prepareStatement("SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                        + "Segundo_Apellido, ba.Abreviacion, telefono, Direccion,ot.Observaciones, eoc.Nombre, tr.Nombre, s.Nombre, ot.Fecha,"
                                        + "p.Nombre,eoc.ID,ot.Comentarios, tr.Pago, ot.IDOrdenTrabajo, tr.Precio"
                                        + " FROM cliente_natural cn,barriocolonia ba,cliente cl, contrato con, orden_trabajo ot, estado_orden_trabajo eoc, servicio s, trabajo_realizar tr, prioridad p"
                                        + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                        + " AND ot.CONTRATO_IDContrato = IDContrato AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.ID=ot.ESTADO_ORDEN_TRABAJO_ID "
                                        + "AND con.SERVICIO_ID=s.ID AND ot.PRIORIDAD_ID = p.ID AND cn.IDCliente = ? AND ot.TRABAJO_REALIZAR_ID = tr.ID AND IDOrdenTrabajo = ?");
                                ps.setInt(1, IDCliente);
                                ps.setInt(2, Integer.parseInt(request.getParameter("IDOrden")));
                                ps.execute();

                            } else if (request.getParameter("tip").equals("2")) {
                                IDCliente = Integer.parseInt(request.getParameter("ID"));
                                IDContrato = Integer.parseInt(request.getParameter("Cont"));
                                ps = conn.prepareStatement("SELECT Nombre_Empresa, Representante, Cargo,"
                                        + "Fax, ba.Abreviacion, telefono, Direccion,ot.Observaciones, eoc.Nombre, tr.Nombre, s.Nombre, ot.Fecha,"
                                        + "p.Nombre,eoc.ID,ot.Comentarios, tr.Pago, ot.IDOrdenTrabajo, tr.Precio"
                                        + " FROM cliente_juridico cj,barriocolonia ba,cliente cl, contrato con, orden_trabajo ot, estado_orden_trabajo eoc, servicio s, trabajo_realizar tr, prioridad p"
                                        + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia=ba.IDBarriocolonia"
                                        + " AND ot.CONTRATO_IDContrato = IDContrato AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.ID=ot.ESTADO_ORDEN_TRABAJO_ID "
                                        + "AND con.SERVICIO_ID=s.ID AND ot.PRIORIDAD_ID = p.ID AND cj.IDCliente = ? AND ot.TRABAJO_REALIZAR_ID = tr.ID AND IDOrdenTrabajo = ?");
                                ps.setInt(1, IDCliente);
                                ps.setInt(2, Integer.parseInt(request.getParameter("IDOrden")));
                                ps.execute();
                            } else {
                                int IDIns = Integer.parseInt(request.getParameter("IDOrden"));
                                ps = conn.prepareStatement("SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                        + "Segundo_Apellido,Nombre_Empresa, Representante, Cargo, Barrio, Telefono, Direccion,"
                                        + " i.Estado, TrabajoRealizar, Servicio, Fecha, Prioridad, tr.Precio "
                                        + "FROM instalacion i, trabajo_realizar tr WHERE i.ID = ? AND tr.Nombre = 'INSTALACION' ");
                                ps.setInt(1, IDIns);
                                ps.execute();
                            }

                            ResultSet rs = ps.getResultSet();
                            String pn = "";
                            String sn = "";
                            String pa = "";
                            String sa = "";
                            String barrio = "";
                            String tel = "";
                            String direccion = "";
                            String observaciones = "";
                            String tr = "";
                            String pago = "";
                            String com = "";
                            String icon = "icon-user";

                            while (rs.next()) {
                                if (!request.getParameter("tip").equals("3")) {
                                    IDOrden = Integer.parseInt(rs.getString(17));
                                    precio = Double.parseDouble(rs.getString(18));
                                }
                                pn = rs.getString(1);
                                sn = rs.getString(2);
                                pa = rs.getString(3);
                                sa = rs.getString(4);
                                barrio = rs.getString(5);
                                tel = rs.getString(6);
                                direccion = rs.getString(7);
                                observaciones = rs.getString(8);
                                tr = rs.getString(10);
                                pago = rs.getString(16);
                                com = rs.getString(15);

                                if (request.getParameter("tip").equals("2")) {
                                    sa = "";
                                    apellido = "Cargo: ";
                                    temp = sn;
                                    sn = "";
                                    icon = "icon-briefcase";
                                }

                                if (request.getParameter("tip").equals("3")) {
                                    int tipo = Integer.parseInt(request.getParameter("ca"));
                                    barrio = rs.getString(8);
                                    tel = rs.getString(9);
                                    direccion = rs.getString(10);
                                    observaciones = "";
                                    tr = "INSTALACION";
                                    pago = "0";
                                    com = "";
                                    precio = Double.parseDouble(rs.getString(16));
                                    if (tipo == 2) {
                                        pn = rs.getString(5);
                                        sn = rs.getString(6);
                                        pa = rs.getString(7);
                                        sa = "";
                                        apellido = "Cargo: ";
                                        temp = sn;
                                        sn = "";
                                        icon = "icon-briefcase";
                                    }
                                }

                    %>
                    Nombre:
                    <div class="input-prepend">
                        <span class="add-on"><i class="<%=icon%>"></i></span>
                        <input type="text" value="<%= pn + " " + sn%>" readonly="readonly" size="30" name="nombre" class="input-large" /> 
                    </div>
                    <div id="emp">
                        </br>
                        </br>
                        Representante:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="representante" type="text" value="<%= temp%>" size="35" disabled="disabled" readonly="readonly" class="input-medium"/>
                        </div>
                        </br>
                        </br>
                    </div>
                    <%=apellido%>
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-user"></i></span>
                        <input type="text" value="<%= pa + " " + sa%>" readonly="readonly" size="30" name="apellido" class="input-large"/> 
                    </div>
                    </br>
                    </br>
                    Barrio o Colonia:
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-pencil"></i></span>
                        <input name="barriocolonia" value="<%= barrio%>" type="text" size="4" readonly="readonly" class="input-small" />
                    </div>
                    <%

                        if (tel.equals("0")) {
                            tel = "";
                        }
                    %>
                    Teléfono:
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-pencil"></i></span>
                        <input name="tel" type="text" class="input-small" value="<%= tel%>" size="7" readonly="readonly" />
                    </div>
                    </br>
                    </br>
                    Dirección: 
                    <textarea name="direccion" readonly="readonly" ><%= direccion%></textarea>
                    </br>
                    </br>
                    Observaciones: <textarea name="observaciones" placeholder="Observaciones" readonly="readonly"><%= observaciones%></textarea>
                    </br>
                    </br>
                    Trabajo a Realizar:
                    <div class="input-prepend">
                        <span class="add-on"><i class="icon-pencil"></i></span>
                        <input name="trabajorealizar" class="input-medium" type="text" readonly="readonly" value="<%= tr%>" size="15"/>
                    </div>
                    <%

                        if (pago.equals("0")) {
                            pago = "SI";
                        } else {
                            pago = "NO";
                        }
                    %>
                    Requiere Pago: <input id="pago" name="Pago" class="input-small" type="text" size="2" value="<%=pago%>" readonly="readonly" />
                    </br>
                    </br>
                    <%

                        if (com == null) {
                            com = "";
                        }
                    %>
                    Comentarios: <textarea  id="comentarios" placeholder="Comentarios" name="Comentarios"><%=com%></textarea>
                    </br>
                    </br>
                    <% }
                            ps.close();
                        } catch (Exception ex) {
                            System.out.println("SQL DT: " + ex.getMessage());
                        }
                    %>
                    <div id="fact">
                        <div id="contenedorforma">
                            </br>
                            <p id="titulo">Detalle de Factura</p>
                            <%
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                    PreparedStatement fec = conn.prepareStatement("SELECT CURDATE(), Max(Numero_recibo) FROM factura");
                                    fec.execute();
                                    ResultSet fecrs = fec.getResultSet();
                                    String fecha = "";
                                    String recibo = "";
                                    while (fecrs.next()) {
                                        fecha = fecrs.getString(1);
                                        recibo = fecrs.getString(2);
                                        if (recibo == null) {
                                            recibo = "0";
                                        }
                                        rec = Integer.parseInt(recibo);
                                    }%>

                            Fecha: <input name="fecha" value="<%=fecha%>" class="input-small" readonly="readonly" size="10" />
                            <%} catch (Exception ex) {
                                    System.out.println("SQL Fecha: " + ex.getMessage());
                                }
                            %>
                            Cantidad Pagada: 
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-pencil"></i></span>
                                <input id="cantpagada" placeholder="<%=precio%>..." class="validate[required] text-input input-small" name="cantidadpagada" type="text" pattern="^\d*(\.\d{2}$)?" size="7" />
                            </div>
                            </br>
                            </br>
                            Descripción: <textarea id="desc" placeholder="Descripción de Factura" name="descripcion" class="validate[required] text-input"></textarea>
                            </br>
                            </br>
                        </div>
                        </br>
                        </br>
                    </div>    
                    <input name="btn_guardar" type="submit" class="btn btn-primary" value="Guardar" />
                    <input name="btn_cancelar" type="button" onclick="Retornar();" class="btn" value="Cancelar" />
            </form>
            </br>
            </br>
        </div>
    </div>
    <%
        if (request.getParameter("btn_guardar") != null) {
            OT ot = new OT();
            try {
                Dba dba = new Dba();
                dba.conectar();
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                String estado = "";
                Boolean error = false;
                PreparedStatement up = null;
                if (!request.getParameter("tip").equals("3")) {
                    if (request.getParameter("est").equals("REALIZADO")) {
                        PreparedStatement est = conn.prepareStatement("SELECT ID FROM estado_orden_trabajo "
                                + "WHERE Nombre=?");
                        est.setString(1, request.getParameter("est"));
                        est.execute();
                        ResultSet estrs = est.getResultSet();
                        while (estrs.next()) {
                            estado = estrs.getString(1);
                        }
                        est.close();

                        up = conn.prepareStatement(" INSERT INTO factura (Fecha, Descripcion, Cantidad_Pagada,"
                                + "Numero_Recibo,Tecnico,ORDEN_TRABAJO_IDOrdenTrabajo)"
                                + " VALUES (?,?,?,?,?,?)");
                        String descr = request.getParameter("descripcion");

                        up.setString(1, request.getParameter("fecha"));
                        up.setString(2, descr.toUpperCase());
                        up.setDouble(3, Double.parseDouble(request.getParameter("cantidadpagada")));
                        up.setInt(4, rec++);
                        up.setString(5, session.getAttribute("s_user").toString());
                        up.setInt(6, IDOrden);
                        error = up.execute();
                    }

                    up = conn.prepareStatement("UPDATE orden_trabajo SET Comentarios=?, ESTADO_ORDEN_TRABAJO_ID = ?"
                            + " WHERE IDOrdenTrabajo=?");
                    String comen = request.getParameter("Comentarios");
                    up.setString(1, comen.toUpperCase());
                    up.setInt(2, Integer.parseInt(estado));
                    up.setInt(3, IDOrden);

                    if (up.execute() == false && error == false) {
                        out.print("<script>alert('Se Actualizó Correctamente')</script>");
                        if (request.getParameter("trabajorealizar").equals("CORTE")) {
                            ot.CambiarEstado(IDCliente, Integer.parseInt(request.getParameter("tip")));
                        }
                    }
                } else {
                    up = conn.prepareStatement("UPDATE instalacion SET Estado = ?, CantidadPagada = ?, Descripcion = ?"
                            + " WHERE ID = ?");
                    up.setString(1, "REALIZADO");
                    up.setDouble(2, Double.parseDouble(request.getParameter("cantidadpagada")));
                    String des = request.getParameter("descripcion");
                    up.setString(3, des.toUpperCase());
                    up.setInt(4, Integer.parseInt(request.getParameter("IDOrden")));
                    if (up.execute() == false) {
                        out.print("<script>alert('Se Actualizó Correctamente')</script>");
                    }
                }
                out.print("<script>location.href = 'Lista Trabajos Pendientes.jsp'</script>");
                up.close();
                conn.close();
            } catch (Exception ex) {
                System.out.println("SQL UDT: " + ex.getMessage());
            }
        }
    %>	
</body>
</html>
