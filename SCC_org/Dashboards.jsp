<%@page import="BD.OC"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Array"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE>

<%if (session.getAttribute("s_user") == null) {
       out.print("<script>location.href = 'index.jsp';</script>");
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
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <script>
            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }


                $('#time').change(function() {
                    var tiempo = $('#time option:selected').val();
                    if (tiempo == "Anual") {
                        $('#month').prop("disabled", "disabled");
                    }
                });
            });
            function Cargar() {

                jQuery.ajax({
                    url: 'ControladoraTIEMPO.jsp',
                    type: 'GET',
                    async: true,
                    success: function(data)
                    {
                        if (data.trim() !== "none")
                        {
                            var datos = data.trim().split('#');
                            var valores = new Array();
                            for (i = 0; i < datos.length - 1; i++) {
                                valores = datos[i].split('$');
                            }
                            var año = parseInt(valores[1]);
                            var añoactual = parseInt(new Date().getFullYear());

                            for (i = año; i <= añoactual; i++) {
                                $('#year').append($('<option>', {
                                    value: i,
                                    text: i
                                }));
                            }
                        }
                        console.log(data);
                    }
                });
            }

            function Habilitar() {
                $('#time').prop("disabled", "");
            }

            function HabilitarResto() {
                $('#month').prop("disabled", "");
                $('#year').prop("disabled", "");
                $('#btn_gen').prop("disabled", "");
            }


        </script>
        <style type="text/css">

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left: auto;
                margin-right:auto;
                text-align:center;
                padding: 30px;
            }
            div#graf{
                text-align: center;
                height: 400px;
                width: 1350px;
                margin-left: auto;
                margin-right: auto;
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
                        <p id="titulo">Gráficas</p>
                        <div id="fondotabla" >
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <strong>Generar gráfica de:</strong>
                                </br>
                                <label class="inline radio">
                                    <input name="grafica" type="radio" onclick="Habilitar();" value="Orden Cobro" />
                                    Ingresos Órdenes de Cobro</label>
                                <label class="inline radio">    
                                    <input name="grafica" type="radio" onclick="Habilitar();" value="Orden Trabajo" />
                                    Ingresos Órdenes de Trabajo
                                </label>
                                </br>
                                </br>
                                Período de Tiempo:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="tiempo" class="input-medium" disabled="disabled" id="time" onchange="Cargar(); HabilitarResto();">
                                        <option value="Vacio">--------------</option>    
                                        <option value="Mensual">Mensual</option>    
                                        <option value="Trimestral">Trimestral</option>    
                                        <option value="Anual">Anual</option>    
                                    </select>
                                </div>
                                </br>
                                </br>
                                Mes:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="mes" id="month" disabled="disabled" class="input-small">
                                        <option value="01">Enero</option>
                                        <option value="02">Febrero</option>
                                        <option value="03">Marzo</option>
                                        <option value="04">Abril</option>
                                        <option value="05">Mayo</option>
                                        <option value="06">Junio</option>
                                        <option value="07">Julio</option>
                                        <option value="08">Agosto</option>
                                        <option value="09">Septiembre</option>
                                        <option value="10">Octubre</option>
                                        <option value="11">Noviembre</option>
                                        <option value="12">Diciembre</option>
                                    </select>
                                </div>
                                Año:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="Year" id="year" disabled="disabled" class="input-small">
                                    </select>
                                </div>
                                </br>
                                </br>
                                <input type="submit" id="btn_gen" value="Generar" class="btn btn-primary" disabled="disabled" name="btn_generar"/>
                            </form>
                        <%

                            if (request.getParameter("btn_generar") != null) {
                                try {
                                    Dba dba = new Dba();
                                    dba.conectar();
                                    String arreglomes[][] = null;
                                    Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                    PreparedStatement ps = null;
                                    PreparedStatement contar = null;
                                    int dias = 0;
                                    String desde = "";
                                    String hasta = "";
                                    int anio = 0;
                                    if (request.getParameter("tiempo").equals("Mensual")) {
                                        dias = new Date(Integer.parseInt(request.getParameter("Year")), Integer.parseInt(request.getParameter("mes")), 0).getDate();
                                        desde = request.getParameter("Year") + "-" + request.getParameter("mes") + "-01";
                                        hasta = request.getParameter("Year") + "-" + request.getParameter("mes") + "-" + String.valueOf(dias);
                                    } else if (request.getParameter("tiempo").equals("Trimestral")) {
                                        int mes = Integer.parseInt(request.getParameter("mes"));
                                        anio = Integer.parseInt(request.getParameter("Year"));
                                        for (int i = 0; i < 2; i++) {
                                            if ((mes + 1) > 12) {
                                                mes = 1;
                                                anio++;
                                            } else {
                                                mes++;
                                            }
                                        }
                                        dias = new Date(anio, mes, 0).getDate();
                                        String mesarreglado = String.valueOf(mes);
                                        if (mes < 10) {
                                            mesarreglado = "0" + mesarreglado;
                                        }
                                        desde = request.getParameter("Year") + "-" + request.getParameter("mes") + "-01";
                                        hasta = String.valueOf(anio) + "-" + mesarreglado + "-" + String.valueOf(dias);

                                    } else {
                                        anio = Integer.parseInt(request.getParameter("Year"));
                                        desde = request.getParameter("Year") + "-01" + "-01";
                                        hasta = request.getParameter("Year") + "-12" + "-31";
                                        
                                    }

                                    int tam = 0;

                                    if (request.getParameter("grafica").equals("Orden Cobro")) {

                                        contar = conn.prepareStatement("SELECT DISTINCT Fecha_Pagada FROM orden_cobro "
                                                + "WHERE Fecha_Pagada BETWEEN ? AND ? AND Fecha_Pagada != '0000-00-00'");
                                        contar.setString(1, desde);
                                        contar.setString(2, hasta);
                                        contar.execute();
                                        ResultSet contarrs = contar.getResultSet();
                                        while (contarrs.next()) {
                                            tam++;
                                        }
                                        contar.close();
                                        arreglomes = new String[tam][2];

                                        ps = conn.prepareStatement("SELECT Fecha_Pagada, CantidadPagar FROM orden_cobro "
                                                + "WHERE Fecha_Pagada BETWEEN ? AND ? AND Fecha_Pagada != '0000-00-00' ORDER BY (Fecha_Pagada)");
                                        ps.setString(1, desde);
                                        ps.setString(2, hasta);
                                        ps.execute();
                                        ResultSet rs = ps.getResultSet();

                                        String fec;
                                        String cant;
                                        String temp = "";
                                        int j = 0;
                                        Double cantidad = 0.0;
                                        while (rs.next()) {
                                            fec = rs.getString(1);
                                            cant = rs.getString(2);

                                            if (fec.equals(temp)) {
                                                cantidad = Double.parseDouble(cant) + cantidad;
                                                arreglomes[j - 1][1] = String.valueOf(cantidad);
                                            } else {
                                                arreglomes[j][0] = fec;
                                                arreglomes[j][1] = cant;
                                                cantidad = Double.parseDouble(cant);
                                                temp = fec;
                                                j++;
                                            }
                                        }

                                    } else {

                                        contar = conn.prepareStatement("SELECT DISTINCT Fecha FROM factura "
                                                + "WHERE Fecha BETWEEN ? AND ? ");
                                        contar.setString(1, desde);
                                        contar.setString(2, hasta);
                                        contar.execute();
                                        ResultSet contarrs = contar.getResultSet();
                                        while (contarrs.next()) {
                                            tam++;
                                        }
                                        contar.close();
                                        arreglomes = new String[tam][2];


                                        ps = conn.prepareStatement("SELECT Fecha, Cantidad_Pagada FROM factura "
                                                + "WHERE Fecha BETWEEN ? AND ? ORDER BY (Fecha)");
                                        ps.setString(1, desde);
                                        ps.setString(2, hasta);
                                        ps.execute();
                                        ResultSet rs = ps.getResultSet();

                                        String fec;
                                        String cant;
                                        String temp = "";
                                        int j = 0;
                                        Double cantidad = 0.0;
                                        while (rs.next()) {
                                            fec = rs.getString(1);
                                            cant = rs.getString(2);

                                            if (fec.equals(temp)) {
                                                cantidad = Double.parseDouble(cant) + cantidad;
                                                arreglomes[j - 1][1] = String.valueOf(cantidad);
                                            } else {
                                                arreglomes[j][0] = fec;
                                                arreglomes[j][1] = cant;
                                                cantidad = Double.parseDouble(cant);
                                                temp = fec;
                                                j++;
                                            }
                                        }
                                    }
                                    
                                    ps.close();
                                    conn.close();
                                    OC oc = new OC();

                        %>
                        <script>
            google.load("visualization", "1", {packages: ["corechart"]});
            google.setOnLoadCallback(drawChart);
            function drawChart() {
                var data = new google.visualization.DataTable();
                data.addColumn('string', 'Fecha');

                            <%
                                String fecha[] = null;
                                if (request.getParameter("tiempo").equals("Mensual")) {%>
                data.addColumn('number', 'Lempiras');
                data.addRows(<%=dias%>);
                            <% for (int j = 0; j < dias; j++) {%>
                data.setCell(<%=j%>, 0, '<%=j + 1%>');
                data.setCell(<%=j%>, 1, 0);
                            <%}


                                for (int i = 0; i < arreglomes.length; i++) {
                                    for (int j = 0; j < arreglomes[i][0].length(); j++) {
                                        fecha = arreglomes[i][0].split("-");
                                    }
                            %>
                data.setCell(<%=Integer.parseInt(fecha[2]) - 1%>, 1, <%=arreglomes[i][1]%>);
                            <% }
                            } else if (request.getParameter("tiempo").equals("Trimestral")) {
                                int messiguiente = Integer.parseInt(request.getParameter("mes")) + 1;
                                String date = request.getParameter("Year") + "-" + String.valueOf(messiguiente);
                            %>
                data.addColumn('number', '<%= oc.MesActual(desde)%>');
                data.addColumn('number', '<%= oc.MesActual(date)%>');
                data.addColumn('number', '<%= oc.MesActual(hasta)%>');

                data.addRows(31);
                            <% for (int j = 0; j < 31; j++) {%>
                data.setCell(<%=j%>, 0, '<%=j + 1%>');
                data.setCell(<%=j%>, 1, 0);
                data.setCell(<%=j%>, 2, 0);
                data.setCell(<%=j%>, 3, 0);
                            <%}
                                int columna = 0;
                                for (int i = 0; i < arreglomes.length; i++) {
                                    for (int j = 0; j < arreglomes[i][0].length(); j++) {
                                        fecha = arreglomes[i][0].split("-");
                                    }

                                    columna = (Integer.parseInt(fecha[1]) - (Integer.parseInt(request.getParameter("mes"))) + 1);

                            %>
                data.setCell(<%=Integer.parseInt(fecha[2]) - 1%>, <%=columna%>, <%=arreglomes[i][1]%>);
                            <%
                                }
                            } else {%>
                data.addColumn('number', 'Lempiras');
                data.addRows(12);
                            <% for (int i = 0; i < 12; i++) {%>
                data.setCell(<%=i%>, 0, '<%= oc.MesActual("2013-" + (i + 1))%>');
                            <%}
                                for (int j = 0; j < arreglomes.length; j++) {
                                    for (int k = 0; k < arreglomes[j][0].length(); k++) {
                                        fecha = arreglomes[j][0].split("-");
                                    }
                            %>
                data.setCell(<%=Integer.parseInt(fecha[1]) - 1%>, 1, <%=arreglomes[j][1]%>);
                            <% }
                                }

                                String tit = oc.MesActual(desde) + " " + request.getParameter("Year");
                                if (request.getParameter("tiempo").equals("Trimestral")) {
                                    tit = "Trimeste: " + oc.MesActual(desde) + " " + request.getParameter("Year") + " - " + oc.MesActual(hasta) + " " + String.valueOf(anio);
                                } else if (request.getParameter("tiempo").equals("Anual")) {
                                    tit = "ENERO - DICIEMBRE " + request.getParameter("Year");
                                }
                            %>
                var options = {
                    title: 'Ingresos por <%= request.getParameter("grafica")%>: <%= tit%>',
                    colors: ['#253071', 'red', 'green'],
                    vAxis: {title: 'Cantidad', titleTextStyle: {color: 'Black'}},
                    hAxis: {title: 'Fecha', titleTextStyle: {color: 'Black'}}
                };

                var chart = new google.visualization.ColumnChart(document.getElementById('graf'));
                chart.draw(data, options);
            }
                        </script>

                        <%
                                } catch (Exception ex) {
                                    System.out.println("SQL DASHBOARD: " + ex.getMessage());
                                }
                            }
                        %>
                    </div>

                    <div id="graf">
                        </br>
                        </br>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
