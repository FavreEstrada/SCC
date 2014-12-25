
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE>

<%
    if (session.getAttribute("s_user") == null) {
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }%>

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
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script src="SpryAssets/js/jquery-maskedinput.js" type="text/javascript" charset="utf-8"></script>
        <link href="SpryAssets/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/bootstrap/css/bootstrap-responsive.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>

        <script>
            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }
                $('#check_dia').change(function() {
                    var chk = $(this).is(':checked');
                    if (chk === false) {
                        document.getElementById("hora_ini").disabled = false;
                        document.getElementById("hora_fin").disabled = false;
                        document.getElementById("repitencia").disabled = true;
                    } else {
                        document.getElementById("repitencia").disabled = false;
                        document.getElementById("hora_ini").disabled = true;
                        document.getElementById("hora_fin").disabled = true;
                    }
                });
                $('input[name=rad_rep]').change(function() {
                    var chk = $('input[name=rad_rep]:checked').val();
                    if (chk === "1") {
                        document.getElementById("fecha_until").disabled = true;
                    }
                    else {
                        document.getElementById("fecha_until").disabled = false;
                    }
                });

            });

            function insertar_evento() {
                var estado = $('#forma').validationEngine('validate');
                if (estado !== false) {
                    var evento = $('#nombre').attr("value");
                    var lugar = $('#lugar').attr("value");
                    var fecini = $('#fecini').attr("value");
                    var fecfin = $('#fecfin').attr("value");
                    var chk = $('#check_dia').is(':checked');
                    var rep = $('#repitencia option:selected').val();
                    var int = $('#frec_cada option:selected').val();
                    var fecha_unt = $('#fecha_until').attr("value");
                    var fec_unt_edit = fecha_unt.replace(/-/g, "");
                    var hasta = ";UNTIL=" + fec_unt_edit + "T170000Z";
                    var rad_op = $('#rad_nunca').is(':checked');
                    var resource;

                    if (rad_op === true) {
                        hasta = "";
                    }
                    if (chk === true) {
                        if (rep === "1") {
                            resource = {
                                "summary": evento,
                                "location": lugar,
                                "start": {
                                    "date": fecini
                                },
                                "end": {
                                    "date": fecfin
                                },
                                "reminder": {
                                    "useDefault": "true"
                                }
                            };
                        }
                        else if (rep === "2") {
                            resource = {
                                "summary": evento,
                                "location": lugar,
                                "start": {
                                    "dateTime": fecini + "T08:00:00.000",
                                    "timeZone": "America/Tegucigalpa"
                                }, "end": {
                                    "dateTime": fecfin + "T23:00:00.000",
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "recurrence": [
                                    "RRULE:FREQ=DAILY;INTERVAL=" + int + hasta
                                ],
                                "reminder": {
                                    "useDefault": "true"
                                }
                            };
                        }

                        else if (rep === "3") {
                            resource = {
                                "summary": evento,
                                "location": lugar,
                                "start": {
                                    "date": fecini,
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "end": {
                                    "date": fecfin,
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "recurrence": [
                                    "RRULE:FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR" + hasta
                                ],
                                "reminder": {
                                    "useDefault": "true"
                                }
                            };
                        }

                        else if (rep === "4") {
                            resource = {
                                "summary": evento,
                                "location": lugar,
                                "start": {
                                    "date": fecini,
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "end": {
                                    "date": fecfin,
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "recurrence": [
                                    "RRULE:FREQ=MONTHLY;INTERVAL=" + int + hasta
                                ],
                                "reminder": {
                                    "useDefault": "true"
                                }
                            };
                        }
                        else {
                            resource = {
                                "summary": evento,
                                "location": lugar,
                                "start": {
                                    "date": fecini,
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "end": {
                                    "date": fecfin,
                                    "timeZone": "America/Tegucigalpa"
                                },
                                "recurrence": [
                                    "RRULE:FREQ=YEARLY;INTERVAL=" + int + hasta
                                ],
                                "reminder": {
                                    "useDefault": "true"
                                }
                            };
                        }
                    }
                    else {
                        var horaI = $('#hora_ini option:selected').text();
                        var horaF = $('#hora_fin option:selected').text();
                        resource = {
                            "summary": evento,
                            "location": lugar,
                            "start": {
                                "dateTime": fecini + "T" + horaI + ":00",
                                "timeZone": "America/Tegucigalpa"
                            },
                            "end": {
                                "dateTime": fecfin + "T" + horaF + ":00",
                                "timeZone": "America/Tegucigalpa"
                            }
                        };
                    }
            <% String ID = "5lg18n5aihtacv192i51ulnu6k@group.calendar.google.com";%>
                    gapi.client.load('calendar', 'v3', function() {
                        var request = gapi.client.calendar.events.insert({
                            'calendarId': '<%= ID%>',
                            'resource': resource
                        });

                        request.execute(function(resp) {
                            console.log(resp);
                            if (resp.id) {
                                alert("Evento Creado Correctamente!");
                                Limpiar();
                                window.location.reload();
                            }
                            else {
                                alert("Ocurrió un error, Intente nuevamente");
                            }
                        });
                    });
                }
            }

            function Limpiar() {
                $('#nombre').prop("value", "");
                $('#lugar').prop("value", "");
                $('#fecini').prop("value", "");
                $('#fecfin').prop("value", "");
                $('#forma').validationEngine('hideAll');
            }

            function Cargar() {
                var rep = $('#repitencia option:selected').val();
                if (rep === "3" || rep === "1") {
                    document.getElementById("frec_cada").disabled = true;
                }
                else {
                    $("#frec_cada").empty();
                    for (var a = 1; a < 31; a++) {
                        $("#frec_cada").append('<option value=' + a + '>' + a + '</option>');
                    }
                    document.getElementById("frec_cada").disabled = false;
                }
                if (rep === "1") {
                    document.getElementById("fecha_until").disabled = true;
                }
            }

        </script>
        <style type="text/css">

            iframe#cal{
                frameborder: 0;
                scrolling: no;
                width: 400px;
                height: 300px;
            }

            div#formulario{
                text-align: center;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <jsp:include page="Menu.jsp" flush="false"></jsp:include>
                </br>
                </br>
                </br>
                <a href='#' id='authorize-button' onclick='handleAuthClick();'>Login</a>


                <div class="row-fluid">
                    <div class="span6">
                        <iframe id="cal" src="https://www.google.com/calendar/embed?showPrint=0&amp;showCalendars=0&amp;showTz=0&amp;height=600&amp;wkst=1&amp;bgcolor=%23FFFFFF&amp;src=5lg18n5aihtacv192i51ulnu6k%40group.calendar.google.com&amp;color=%23875509&amp;ctz=America%2FTegucigalpa"></iframe>
                        </br>
                        </br>
                        <a href="#myModal" data-toggle="modal"><button id="btn_agr" class="btn btn-info" disabled="disabled" >Agregar Evento</button></a>
                    </div>
                    <div class="span6">
                        <p id="titulo">Resumen de Actividades</p>
                        <p>Órdenes de Cobro realizadas en los últimos días: </p>
                        <table class="table table-striped table-condensed">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>P.Nombre</th>
                                    <th>S.Nombre</th>
                                    <th>P.Apellido</th>
                                    <th>S.Apellido</th>
                                    <th>Ba/Col.</th>
                                    <th>Fecha</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                    PreparedStatement ps = conn.prepareCall("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido, ba.Abreviacion,"
                                            + " Fecha_Pagada FROM cliente_natural cn, cliente cl,barriocolonia ba, contrato c, orden_cobro oc"
                                            + " WHERE cn.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                            + " AND c.IDContrato = oc.CONTRATO_IDContrato AND Fecha_Pagada BETWEEN DATE_SUB(CURDATE(),INTERVAL 1 MONTH) AND CURDATE()"
                                            + " AND ESTADO_COBRO_ID = (SELECT ID FROM estado_cobro WHERE Nombre = 'REALIZADO')"
                                            + " ORDER BY(Fecha_Pagada)  DESC LIMIT 3 ");
                                    ps.execute();

                                    PreparedStatement pse = conn.prepareCall("SELECT NoID,Nombre_Empresa, Representante, Cargo, Fax, ba.Abreviacion,"
                                            + " Fecha_Pagada FROM cliente_juridico cj, cliente cl,barriocolonia ba, contrato c, orden_cobro oc"
                                            + " WHERE cj.CLIENTE_idCLIENTE = cl.idCLIENTE AND cl.idCLIENTE = c.CLIENTE_idcliente AND c.IDBarriocolonia = ba.IDBarriocolonia"
                                            + " AND c.IDContrato = oc.CONTRATO_IDContrato AND Fecha_Pagada BETWEEN DATE_SUB(CURDATE(),INTERVAL 1 MONTH) AND CURDATE()"
                                            + " AND ESTADO_COBRO_ID = (SELECT ID FROM estado_cobro WHERE Nombre = 'REALIZADO')"
                                            + " ORDER BY(Fecha_Pagada) DESC LIMIT 2 ");
                                    pse.execute();
                                    ResultSet rs = ps.getResultSet();
                                    ResultSet rse = pse.getResultSet();
                                    while (rs.next()) {%>
                            <tr>
                                <td><%=rs.getString(1)%></td>
                                <td><%=rs.getString(2)%></td>
                                <td><%=rs.getString(3)%></td>
                                <td><%=rs.getString(4)%></td>
                                <td><%=rs.getString(5)%></td>
                                <td><%=rs.getString(6)%></td>
                                <td><%=rs.getString(7)%></td>
                            </tr>
                            <%}
                                while (rse.next()) {%>
                            <tr>
                                <td><%=rse.getString(1)%></td>
                                <td><%=rse.getString(2)%></td>
                                <td><%=rse.getString(3)%></td>
                                <td><%=rse.getString(4)%></td>
                                <td></td>
                                <td><%=rse.getString(6)%></td>
                                <td><%=rse.getString(7)%></td>
                            </tr>
                            <%}
                                    ps.close();
                                    pse.close();
                                    conn.close();
                                } catch (Exception Ex) {
                                    System.out.println("SQL OC_REC_ACT: " + Ex.getMessage());
                                }
                            %>
                        </tbody>
                    </table>

                    <p>Órdenes de Trabajo realizadas en los últimos días: </p>
                    <table class="table table-striped table-condensed">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>P.Nombre</th>
                                <th>S.Nombre</th>
                                <th>P.Apellido</th>
                                <th>S.Apellido</th>
                                <th>Ba/Col.</th>
                                <th>Fecha</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                    PreparedStatement ps = conn.prepareCall("SELECT NoID,Primer_Nombre, Segundo_Nombre, Primer_Apellido,"
                                            + "Segundo_Apellido, ba.Abreviacion, ot.Fecha"
                                            + " FROM cliente_natural cn,barriocolonia ba,cliente cl, contrato con, orden_trabajo ot, estado_orden_trabajo eoc"
                                            + " WHERE cn.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia = ba.IDBarriocolonia"
                                            + " AND ot.CONTRATO_IDContrato = IDContrato AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.Nombre ='REALIZADO'"
                                            + " AND ot.Fecha BETWEEN DATE_SUB(CURDATE(),INTERVAL 1 MONTH) AND CURDATE() ORDER BY (ot.Fecha) DESC LIMIT 3");
                                    ps.execute();

                                    PreparedStatement pse = conn.prepareCall("SELECT NoID,Nombre_Empresa, Representante, Cargo, Fax, ba.Abreviacion,"
                                            + " ot.Fecha FROM cliente_juridico cj, barriocolonia ba,cliente cl, contrato con, orden_trabajo ot, estado_orden_trabajo eoc"
                                            + " WHERE cj.CLIENTE_idCLIENTE=cl.idCLIENTE AND cl.idCLIENTE=con.CLIENTE_idCLIENTE AND con.IDBarriocolonia = ba.IDBarriocolonia"
                                            + " AND ot.CONTRATO_IDContrato = IDContrato AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.ID = ot.ESTADO_ORDEN_TRABAJO_ID AND eoc.Nombre ='REALIZADO'"
                                            + " AND ot.Fecha BETWEEN DATE_SUB(CURDATE(),INTERVAL 1 MONTH) AND CURDATE() ORDER BY (ot.Fecha) DESC LIMIT 2");
                                    pse.execute();
                                    ResultSet rs = ps.getResultSet();
                                    ResultSet rse = pse.getResultSet();
                                    while (rs.next()) {%>
                            <tr>
                                <td><%=rs.getString(1)%></td>
                                <td><%=rs.getString(2)%></td>
                                <td><%=rs.getString(3)%></td>
                                <td><%=rs.getString(4)%></td>
                                <td><%=rs.getString(5)%></td>
                                <td><%=rs.getString(6)%></td>
                                <td><%=rs.getString(7)%></td>
                            </tr>
                            <%}
                                while (rse.next()) {%>
                            <tr>
                                <td><%=rse.getString(1)%></td>
                                <td><%=rse.getString(2)%></td>
                                <td><%=rse.getString(3)%></td>
                                <td><%=rse.getString(4)%></td>
                                <td></td>
                                <td><%=rse.getString(6)%></td>
                                <td><%=rse.getString(7)%></td>
                            </tr>
                            <%}
                                } catch (Exception ex) {
                                    System.out.println("SQL OT_REC_ACT: " + ex.getMessage());
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h3 id="myModalLabel">Crear Evento</h3>
                </div>
                <div class="modal-body" id="formulario">
                    <form id="forma">
                        Evento:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-pencil"></i></span>
                            <input id="nombre" type="text" class="input-large validate[required] text-input" placeholder="Evento..." />
                        </div>
                        </br>
                        Lugar:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-pencil"></i></span>
                            <input id="lugar" type="text" class="input-large" placeholder="Lugar..." />
                        </div>
                        </br>
                        Empieza:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-calendar"></i></span>
                            <input id="fecini" name="empieza" type="date" class="validate[required] text-input"/>
                        </div>
                        </br>
                        Finaliza:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-calendar"></i></span>
                            <input id="fecfin" name="finaliza" type="date" class="validate[required] text-input" />
                        </div>
                        </br>
                        Todo el día: 
                        <input id="check_dia" type="checkbox" checked="checked" />
                        </br>
                        </br>
                        Se repite:
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-list"></i></span>
                            <select name="frecuencia" id="repitencia" onchange="Cargar();">
                                <option value="1">Nunca</option>
                                <option value="2">Todos los días</option>
                                <option value="3">Todos los días hábiles (de lunes a viernes)</option>
                                <option value="4">Todos los meses</option>
                                <option value="5">Todos los años</option>
                            </select>
                        </div>
                        </br>
                        Repetir cada:
                        <select name="cada" id="frec_cada" class="input-small" disabled="disabled">
                        </select>
                        </br>
                        Recurrencia finaliza:
                        </br>
                        <label class="inline radio">
                            <input type="radio" value="1" name="rad_rep" id="rad_nunca" checked="checked"  />
                            Nunca
                        </label>
                        </br>
                        <label class="inline radio">
                            <input type="radio" value="2" name="rad_rep"/>
                            El: <input type="date" id="fecha_until" disabled="disabled" />
                        </label>
                        </br>
                        </br>
                        Hora de Inicio:<select disabled="disabled"  id="hora_ini" class="input-small hora ">
                            <%

                                for (int i = 0; i < 24; i++) {
                                    if (i < 10) {%>
                            <option><%= "0" + i + ":00"%></option>
                            <option><%= "0" + i + ":30"%></option>
                            <%} else {%>
                            <option><%= i + ":00"%></option>
                            <option><%= i + ":30"%></option>
                            <%}
                                }
                            %>
                        </select>
                        </br>
                        Hora de Finalización: <select disabled="disabled" id="hora_fin" class="input-small hora">
                            <%

                                for (int i = 0; i < 24; i++) {
                                    if (i < 10) {%>
                            <option><%= "0" + i + ":00"%></option>
                            <option><%= "0" + i + ":30"%></option>
                            <%} else {%>
                            <option><%= i + ":00"%></option>
                            <option><%= i + ":30"%></option>
                            <%}
                                }
                            %>
                        </select>
                </div>
                </form>
                <div class="modal-footer">
                    <button class="btn" data-dismiss="modal" type="submit" onclick="Limpiar();" aria-hidden="true">Cancelar</button>
                    <button class="btn btn-primary" id="btn_evento" onclick="insertar_evento();">Guardad Evento</button>
                </div>
            </div>
        </div>


        <script>
            <%
                String clientID = "362950476286.apps.googleusercontent.com";
                String apiKey = "AIzaSyAnYTX6BSL4Pn_RLrsrGe-I3GMeD8OjfYE";
            %>
            var clientId = '<%= clientID%>';
            var apiKey = '<%= apiKey%>';
            var scopes = 'https://www.googleapis.com/auth/calendar';

            function handleClientLoad() {
                gapi.client.setApiKey(apiKey);
                window.setTimeout(checkAuth, 1);
                checkAuth();
            }

            function checkAuth() {
                gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true},
                handleAuthResult);
            }

            function handleAuthResult(authResult) {
                var authorizeButton = document.getElementById('authorize-button');
                if (authResult) {
                    authorizeButton.style.visibility = 'hidden';
                    document.getElementById("btn_agr").disabled = false;
                } else {
                    authorizeButton.style.visibility = '';
                    authorizeButton.onclick = handleAuthClick;
                }
            }

            function handleAuthClick(event) {
                gapi.auth.authorize(
                        {client_id: clientId, scope: scopes, immediate: false},
                handleAuthResult);
                return false;
            }

        </script>
        <script src="SpryAssets/bootstrap/js/bootstrap-modal.js" type="text/javascript"></script>
        <script src="https://apis.google.com/js/client.js?onload=handleClientLoad"></script>	
    </body>
</html>