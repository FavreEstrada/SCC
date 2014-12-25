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
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script>
            var descpasado;
            jQuery(document).ready(function() {

                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }

                $('#desc').change(function() {
                    var total = parseFloat($('#total').attr("value"));
                    var des = parseFloat($('#desc').attr("value"));
                    if (des >= 0) {
                        if (des > total) {
                            alert("La cantidad ingresada es mayor al total");
                            $('#desc').prop("value", "");
                        }
                        else if (des == 0) {
                            $('#total').prop("value", total + pasado);
                            $('#saldo').prop("value", total + pasado);
                        }
                        else {
                            $('#total').prop("value", total - des);
                            $('#saldo').prop("value", total - des);
                            pasado = des;
                        }
                    }

                    else {
                        alert("La cantidad ingresada es incorrecta");
                        $('#desc').prop("value", "");
                    }
                });
            });

            function Retornar() {
                history.go(-1);
            }
            function Saldo(cant) {
                var total = parseFloat($('#total').attr("value"));

                if (parseFloat(cant) > 0) {
                    if (cant > total) {
                        alert("La cantidad ingresada es mayor a la especificada");
                        $('#cantpag').prop("value", "");
                    }
                    else {
                        $('#saldo').prop("value", total - parseFloat(cant));
                        $('#estadopago').prop("value", "Pago Realizado");
                    }
                }
                else if (parseFloat(cant) == 0) {
                    var saldo = $('#saldo').val();
                    if (saldo != 0) {
                        alert("Existe un Saldo Pendiente");
                    }
                }
                else {
                    alert("La cantidad ingresada es incorrecta");
                    $('#cantpag').prop("value", "");
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
                        <p id="titulo">Detalle de Cobro</p>
                        <div id="fondotabla">
                            <div id="contenedorforma">
                                <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');">
                                    </br>
                                <%
                                    int ID = Integer.parseInt(request.getParameter("IDOC"));
                                    int Contrato = 0;
                                    OC cobro = new OC();
                                    try {
                                        Dba dba = new Dba();
                                        dba.conectar();
                                        Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                        PreparedStatement ps = conn.prepareStatement("SELECT CantidadPagar, Fecha, MAX(NumeroRecibo), ep.Nombre, CONTRATO_IDContrato"
                                                + " FROM orden_cobro oc, estado_pago_cliente ep WHERE oc.ESTADO_PAGO_CLIENTE_ID = ep.ID AND oc.IDOrdenCobro = ?");
                                        ps.setInt(1, ID);
                                        ps.execute();
                                        ResultSet rs = ps.getResultSet();
                                        while (rs.next()) {
                                            String total = rs.getString(1);
                                            Contrato = Integer.parseInt(rs.getString(5));
                                %>
                                Total:<input name="Total" class="input-small" id="total" type="text" size="4" value="<%= total%>" readonly="readonly" />
                                </br>
                                </br>
                                Fecha de Factura: <input name="fecha" class="input-small" type="text" size="9" value="<%= rs.getString(2)%>" readonly="readonly" />
                                Mes a Cancelar: <input name="mes" class="input-small" type="text" size="9" value="<%= cobro.MesActual(rs.getString(2))%>" readonly="readonly" />
                                </br>
                                </br>
                                Descuento: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="descuento" value="0.00" id="desc" type="text" class="validate[required] text-input input-small" pattern="^\d*(\.\d{2}$)?" size="7"/>
                                </div>
                                Cantidad Pagada:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="cantpag" placeholder="Cantidad" onblur="Saldo(this.value);" id="cantpag" type="text" class="validate[required] text-input input-small" pattern="^\d*(\.\d{2}$)?" size="7"/>
                                </div>
                                Saldo:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-exclamation-sign"></i></span>
                                    <input name="saldo" id="saldo" value="<%= total%>" type="text" class="validate[required] text-input input-small" pattern="^\d*(\.\d{2}$)?" size="7" readonly="readonly" />
                                </div>
                                </br>
                                </br>
                                Estado de Pago: <input name="estadopago" class="input-medium" id="estadopago" size="12" type="text" value="<%= rs.getString(4)%>" readonly="readonly" disabled="disabled"/>
                                Estado de Cobro: <input name="estadocobro" size="8" type="text" class="input-medium" value="Realizado" readonly="readonly" disabled="disabled"/>
                                </br>
                                </br>
                                Número de Recibo: <input name="numerorecibo" type="text" class="input-small" value="<%= rs.getString(3)%>" readonly="readonly" disabled="disabled" size="6"/>
                                Nombre del Cobrador: <input name="nombrecobrador" class="input-medium" type="text" size="10" value="<%=session.getAttribute("s_user")%>" readonly="readonly" disabled="disabled"/>
                                </br>
                                </br>
                                <input name="btn_guardar" type="submit" class="btn btn-primary" value="Guardar" />
                                <input name="btn_cancelar" type="button" onclick="Retornar();" class="btn" value="Cancelar" />
                                </br>
                                <%      }
                                        conn.close();
                                    } catch (Exception ex) {
                                        System.out.println("SQL: DETCOBROCAR" + ex.getMessage());
                                    }
                                %>
                            </form>
                        </div>

                        <%
                            if (request.getParameter("btn_guardar") != null) {
                                Boolean error = false;

                                try {
                                    Double saldo = Double.parseDouble(request.getParameter("saldo"));
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                    PreparedStatement ps1 = conn.prepareStatement("SELECT ec.ID, ep.ID, CURDATE() FROM estado_cobro ec, estado_pago_cliente ep"
                                            + " WHERE ec.Nombre = 'REALIZADO' AND ep.Nombre = 'PAGO REALIZADO'");
                                    ps1.execute();
                                    ResultSet rs = ps1.getResultSet();
                                    int idec = 0;
                                    int idep = 0;
                                    String fecha = "";
                                    while (rs.next()) {
                                        idec = Integer.parseInt(rs.getString(1));
                                        idep = Integer.parseInt(rs.getString(2));
                                        fecha = rs.getString(3);
                                    }
                                    ps1.close();
                                    if (saldo != 0) {
                                        error = cobro.GenerarOrdenSaldo(saldo, request.getParameter("fecha"), session.getAttribute("s_user").toString(), Contrato);
                                    }

                                    PreparedStatement oc = conn.prepareStatement("UPDATE orden_cobro SET NombreCobrador=?, ESTADO_COBRO_ID=?, ESTADO_PAGO_CLIENTE_ID=?,Fecha_Pagada=?, Descuento = ?"
                                            + " WHERE IDOrdenCobro = ?");

                                    oc.setString(1, session.getAttribute("s_user").toString());
                                    oc.setInt(2, idec);
                                    oc.setInt(3, idep);
                                    oc.setString(4, fecha);
                                    oc.setString(5, request.getParameter("descuento"));
                                    oc.setInt(6, ID);
                                    if (oc.execute() == false && error == false) {
                                        out.print("<script>alert('El Pago se efectuó exitosamente')</script>");
                                        out.print("<script>location.href = 'Lista Cobros.jsp'</script>");
                                        cobro.RevisarEstado(ID, Integer.parseInt(request.getParameter("Tip")));
                                        cobro.RevisarContratoTerminado(Integer.parseInt(request.getParameter("IDCon")));
                                    }
                                    oc.close();
                                    conn.close();
                                } catch (Exception ex) {
                                    System.out.println("SQL DETCOBRO: " + ex.getMessage());
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
