<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
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
        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css" media="screen"/>
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script>
            function Retornar() {
                location.href = "Busqueda Clientes.jsp";
            }

            jQuery(document).ready(function() {

                var tipo = '<%= request.getParameter("tip")%>';
                if (tipo == "2") {
                    $('#emp').css("display", "inline");
                }
            });

            jQuery(function($) {
                $("#phone").mask("9999-9999");
            });

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
                            jQuery('#tr').empty();
                            for (var i = 0; i < datos.length - 1; i++)
                            {
                                valores = datos[i].split('$');
                                if (valores[1] !== "INSTALACION") {
                                    jQuery('#tr').append('<option></option>');
                                    jQuery('#tr option:last').attr('value', valores[0]);
                                    jQuery('#tr option:last').append(valores[1]);
                                }
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
                text-align:center;
                margin-left:auto;
                margin-right:auto;
                padding: 20px;
            }

            div#emp{
                display: none;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="row-fluid">
                <jsp:include page="Menu.jsp" flush="false"></jsp:include>
                    </br>
                    </br>
                    </br>
                    <div class="span12">
                        <p id="titulo">Crear Orden de Trabajo</p> 
                        <div id="fondotabla">
                            <form name="forma" id="forma" method="post">
                                <div id="contenedorforma">
                                    </br>
                                <%
                                    int IDCliente = Integer.parseInt(request.getParameter("ID"));
                                    int IDContrato = 0;
                                    String apellido = "Apellido";
                                    String temp = "";
                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                        PreparedStatement cl = null;
                                        if (request.getParameter("tip").equals("1")) {
                                            cl = conn.prepareStatement("SELECT Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido,"
                                                    + " Direccion, Telefono, NoID, id.Tipo, ba.Abreviacion, s.Nombre, con.IDContrato FROM cliente_natural cn, identificacion id, cliente cl, contrato con, barriocolonia ba,"
                                                    + "servicio s WHERE cn.IDCliente = ? AND cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND con.CLIENTE_idcliente = cl.idCLIENTE"
                                                    + " AND con.IDBarriocolonia = ba.IDBarriocolonia AND con.SERVICIO_ID = s.ID AND cn.IDENTIFICACION_ID = id.ID");
                                            cl.setInt(1, IDCliente);
                                            cl.execute();
                                        } else {
                                            cl = conn.prepareStatement("SELECT Nombre_Empresa, Representante, Cargo , Fax,"
                                                    + " Direccion, Telefono, NoID, id.Tipo, ba.Abreviacion, s.Nombre, con.IDContrato FROM cliente_juridico cj, identificacion id, cliente cl, contrato con, barriocolonia ba,"
                                                    + "servicio s WHERE cj.IDCliente = ? AND cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND con.CLIENTE_idcliente = cl.idCLIENTE"
                                                    + " AND con.IDBarriocolonia = ba.IDBarriocolonia AND con.SERVICIO_ID = s.ID AND cj.IDENTIFICACION_ID = id.ID");
                                            cl.setInt(1, IDCliente);
                                            cl.execute();
                                        }

                                        ResultSet clrs = cl.getResultSet();
                                        while (clrs.next()) {
                                            IDContrato = Integer.parseInt(clrs.getString(11));
                                %>
                                <%= clrs.getString(8)%>
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="identidad" readonly="readonly" class="input-medium" value="<%=clrs.getString(7)%>" type="text" size="14"/>
                                </div>
                                </br>
                                </br>
                                <%
                                    String pn = clrs.getString(1);
                                    String sn = clrs.getString(2);
                                    String pa = clrs.getString(3);
                                    String sa = clrs.getString(4);
                                    if (request.getParameter("tip").equals("2")) {
                                        sa = "";
                                        apellido = "Cargo: ";
                                        temp = sn;
                                        sn = "";
                                    }

                                %>
                                Nombre:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="nombre" class="input-large" type="text" value="<%= pn + " " + sn%>" size="35" readonly="readonly"/>
                                </div>
                                <div id="emp">
                                    </br>
                                    </br>
                                    Representante:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-user"></i></span>
                                        <input name="representante" class="input-large" type="text" value="<%= temp%>" size="35" readonly="readonly"/>
                                    </div>
                                    </br>
                                    </br>
                                </div>
                                <%= apellido%>
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="apellido" class="input-large" value="<%= pa + " " + sa%>" type="text" size="35" readonly="readonly"/>
                                </div>
                                </br>
                                </br>
                                Barrio o Colonia:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input type="text" class="input-small" value="<%= clrs.getString(9)%>" name="barriocolonia" size="4" readonly="readonly"/>
                                </div>
                                Servicio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="Servcio" id="serv" class="input-medium" onchange="getTrabajo_Realizar();">
                                        <option>Elija un Servicio</option>
                                        <%
                                            PreparedStatement psser = conn.prepareStatement(" SELECT ID, Nombre FROM servicio s, contrato con"
                                                    + " WHERE Estado = 0 AND con.SERVICIO_ID = s.ID AND IDContrato = ?");
                                            psser.setInt(1, IDContrato);
                                            psser.execute();
                                            ResultSet rsser = psser.getResultSet();
                                            while (rsser.next()) {
                                        %>
                                        <option value="<%= rsser.getString(1)%>"><%= rsser.getString(2)%></option>
                                        <%}
                                            psser.close();

                                        %>    
                                    </select>
                                </div>
                                </br>
                                </br>
                                <%
                                    String tel = clrs.getString(6);
                                    if (tel.equals("0")) {
                                        tel = "";
                                    }

                                %>
                                Télefono:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input input id="phone" name="telefono" class="input-small" value="<%= tel%>" readonly="readonly" type="tel" value="" size="8" maxlength="8" />
                                </div>
                                Trabajo A Realizar:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="trabajo" id="tr" class="input-large">
                                    </select>
                                </div>
                                </br>
                                </br>
                                Dirección:
                                <textarea readonly="readonly" style="height: 70px; vertical-align: middle;" name="direccion"><%= clrs.getString(5)%></textarea>
                                </br>
                                </br>
                                <%
                                        }
                                        cl.close();
                                        conn.close();
                                    } catch (Exception ex) {
                                        System.out.println("SQL COT: " + ex.getMessage());
                                    }
                                %>
                                Técnico Asignado:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <select name="Tecnico" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement pstec = conn.prepareStatement(" SELECT u.Nombre FROM usuario u, rol r"
                                                        + " WHERE u.ROL_IDRol = r.IDRol AND r.Nombre = 'TECNICO' AND r.Estado = 0");
                                                pstec.execute();
                                                ResultSet rstec = pstec.getResultSet();
                                                String tec = "";
                                                while (rstec.next()) {
                                                    tec = rstec.getString(1);

                                        %>
                                        <option value="<%= tec%>"><%= tec%></option>
                                        <%}
                                                pstec.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL COTTEC: " + ex.getMessage());
                                            }
                                        %>    

                                    </select>
                                </div>
                                Prioridad:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="prioridad" class="input-small">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement pspri = conn.prepareStatement(" SELECT ID,Nombre FROM prioridad"
                                                        + " WHERE Estado = 0 ORDER BY (Nombre)");
                                                pspri.execute();
                                                ResultSet rspri = pspri.getResultSet();
                                                while (rspri.next()) {
                                        %>
                                        <option value="<%= rspri.getString(1)%>"><%= rspri.getString(2)%></option>
                                        <%}
                                                pspri.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL COTPRI: " + ex.getMessage());
                                            }
                                        %>    
                                    </select>
                                </div>
                                </br>
                                </br>
                                Comentarios: 
                                <textarea style="height: 70px; vertical-align: middle;" name="comentarios" placeholder="Comentarios"></textarea>
                                </br>
                                </br>
                                <input name="btn_crear" class="btn btn-primary" type="submit" value="Crear Orden" />
                                <input name="btn_cancelar" class="btn" type="button" value="Cancelar" onclick="Retornar();" />
                                </br>
                                </br>
                            </div>
                        </form>
                        <%
                            if (request.getParameter("btn_crear") != null) {
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                    PreparedStatement fec = conn.prepareStatement("SELECT CURDATE(), "
                                            + "ID FROM estado_orden_trabajo,contrato WHERE Nombre = 'PENDIENTE - NO VISITADO' AND IDContrato=?");
                                    fec.setInt(1, IDContrato);
                                    fec.execute();
                                    ResultSet rsfec = fec.getResultSet();

                                    String fecha = "";
                                    int IDBarrio = 0;
                                    int IDPer = 0;
                                    int IDSer = 0;
                                    int EOT = 0;
                                    while (rsfec.next()) {
                                        fecha = rsfec.getString(1);
                                        EOT = Integer.parseInt(rsfec.getString(2));
                                    }
                                    PreparedStatement iot = conn.prepareStatement("INSERT INTO orden_trabajo (Fecha, Observaciones, Tecnico_Asignado,"
                                            + "CONTRATO_IDContrato, ESTADO_ORDEN_TRABAJO_ID, PRIORIDAD_ID, TRABAJO_REALIZAR_ID )"
                                            + " VALUES(?,?,?,?,?,?,?)");
                                    iot.setString(1, fecha);
                                    String obser = request.getParameter("comentarios");
                                    iot.setString(2, obser.toUpperCase());
                                    iot.setString(3, request.getParameter("Tecnico"));
                                    iot.setInt(4, IDContrato);
                                    iot.setInt(5, EOT);
                                    iot.setInt(6, Integer.parseInt(request.getParameter("prioridad")));
                                    iot.setInt(7, Integer.parseInt(request.getParameter("trabajo")));
                                    if (iot.execute() == false) {
                                        out.print("<script>alert('Se Generó Correctamente la Orden de Trabajo')</script>");
                                        out.print("<script>location.href = 'Busqueda Clientes.jsp'</script>");
                                    }
                                    conn.close();
                                } catch (Exception ex) {
                                    System.out.println("SQL ICOT: " + ex.getMessage());
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
