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
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery-maskedinput.js" type="text/javascript" charset="utf-8"></script>
        <script>
            var tipo = "natural";
            jQuery(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }

                $('#CN').click(function() {
                    var divdestino = document.getElementById("cliente");
                    var origen = document.getElementById("contenedor_cn");
                    divdestino.appendChild(origen);
                    $('#contenedor_cn').css("display", "inline");
                    $('#contenedor_cj').css("display", "none");
                    tipo = "natural";
                });

                $('#CJ').click(function() {
                    var divdestino = document.getElementById("cliente");
                    var origen = document.getElementById("contenedor_cj");
                    divdestino.appendChild(origen);
                    $('#contenedor_cj').css("display", "inline");
                    $('#contenedor_cn').css("display", "none");
                    tipo = "juridico";
                });

                var divdestino = document.getElementById("cliente");
                var origen = document.getElementById("contenedor_cn");
                divdestino.appendChild(origen);
                $('#contenedor_cn').css("display", "inline");
                $('#CN').button('toggle');


                $('#btn_cr').click(function() {
                    var validado = $('#forma').validationEngine('validate');
                    if (validado === true) {
                        var PN = $('#pn').val();
                        var SN = $('#sn').val();
                        var PA = $('#pa').val();
                        var SA = $('#sa').val();
                        var empresa = $('#empresa').val();
                        var cargo = $('#car').val();
                        var representante = $('#rep').val();
                        var barrio = $('#barrio option:selected').text();
                        var telefono = $('#phone').val();
                        var servicio = $('#serv option:selected').text();
                        var direccion = $('#dir').val();
                        var tecnico = $('#tec option:selected').text();
                        var prioridad = $('#prio option:selected').text();

                        jQuery.ajax({
                            url: 'ControladoraINS.jsp',
                            type: 'GET',
                            async: true,
                            data: {
                                PN: PN,
                                SN: SN,
                                PA: PA,
                                SA: SA,
                                empresa: empresa,
                                cargo: cargo,
                                representante: representante,
                                tipo: tipo,
                                barrio: barrio,
                                telefono: telefono,
                                servicio: servicio,
                                direccion: direccion,
                                tecnico: tecnico,
                                prioridad: prioridad

                            },
                            success: function(data)
                            {
                                alert("Se Creó Correctamente");
                                console.log(data);
                                window.location.reload();
                            }
                        });
                    }
                });
            });

            jQuery(function($) {
                $("#phone").mask("9999-9999");
            });

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

            .hidedivs{
                display: none;
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
                        <p id="titulo">Crear Orden de Trabajo: Instalación</p> 
                        <div id="fondotabla">
                            <form name="forma" id="forma" method="post" onsubmit="return jQuery(this).validationEngine('validate');">
                                <div id="contenedorforma">
                                    </br>
                                    <div class="btn-group" data-toggle="buttons-radio">
                                        <button name="btn_cn" type="button" id="CN" class="btn btn-info"/>Cliente Natural</button>
                                        <button name="btn_cj" type="button" id="CJ" class="btn btn-info">Cliente Jurídico</button>
                                    </div>
                                    </br>
                                    </br>
                                    <div id="cliente">
                                    </div>
                                    </br>
                                    Barrio o Colonia:
                                    <div class="input-prepend">
                                        <span class="add-on"><i class="icon-list"></i></span>
                                        <select name="barriocolonia" id="barrio" class="input-small">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement pstec = conn.prepareStatement(" SELECT IDBarriocolonia, Abreviacion FROM Barriocolonia"
                                                        + " WHERE Estado = 0 AND Cobertura=0 ORDER BY (Abreviacion)");
                                                pstec.execute();
                                                ResultSet rstec = pstec.getResultSet();
                                                while (rstec.next()) {
                                        %>
                                        <option value="<%= rstec.getString(1)%>"><%= rstec.getString(2)%></option>
                                        <%}
                                                pstec.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL CIBarrio: " + ex.getMessage());
                                            }
                                        %>    
                                    </select>
                                </div>
                                Trabajo a Realizar: 
                                <input name="trabajorealizar" id="tr" readonly="readonly" class="input-medium" value="INSTALACION" size="15" type="text"/>
                                </br>
                                </br>
                                Télefono:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="phone" placeholder="Teléfono" name="telefono" type="tel" class="input-small" value="" size="8" maxlength="8" />
                                </div>
                                Servicio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="serv" class="input-medium" name="servicio">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                                PreparedStatement serv = conn.prepareStatement("SELECT ID, Nombre FROM servicio"
                                                        + " WHERE Estado = 0");
                                                serv.execute();
                                                ResultSet servrs = serv.getResultSet();
                                                while (servrs.next()) {%>
                                        <option value="<%= servrs.getString(1)%>"><%= servrs.getString(2)%></option>
                                        <%}
                                                serv.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL Servicio: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                Dirección:
                                <textarea placeholder="Dirección" id="dir" class="validate[required] text-input " name="direccion"></textarea>
                                </br>
                                </br>
                                Técnico Asignado:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <select name="tecnico" id="tec" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement pstec = conn.prepareStatement(" SELECT IDUsuario,u.Nombre FROM usuario u, rol r"
                                                        + " WHERE u.ROL_IDRol = r.IDRol AND r.Nombre = 'TECNICO' AND r.Estado = 0");
                                                pstec.execute();
                                                ResultSet rstec = pstec.getResultSet();
                                                while (rstec.next()) {
                                        %>
                                        <option value="<%= rstec.getString(1)%>"><%= rstec.getString(2)%></option>
                                        <%}
                                                pstec.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL CITEC: " + ex.getMessage());
                                            }
                                        %>    
                                    </select>
                                </div>
                                Prioridad:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select id="prio" name="prioridad" class="input-small">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement pspri = conn.prepareStatement(" SELECT ID,Nombre FROM prioridad"
                                                        + " WHERE Estado = 0");
                                                pspri.execute();
                                                ResultSet rspri = pspri.getResultSet();
                                                while (rspri.next()) {
                                        %>
                                        <option value="<%= rspri.getString(1)%>"><%= rspri.getString(2)%></option>
                                        <%}
                                                pspri.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL CIPRI: " + ex.getMessage());
                                            }
                                        %>    
                                    </select>
                                </div>
                                </br>
                                </br>
                                <input name="btn_crear" id="btn_cr" type="submit" class="btn btn-primary" value="Crear" />
                                </br>
                                </br>
                            </div>
                        </form>

                        <%
                            if (request.getParameter("btn_crear") != null) {
                            }
                        %>
                    </div>

                    <div id="contenedor_cj" class="hidedivs">
                        Nombre de la Empresa: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="=nombre_empresa" id="empresa" type="text" class="validate[required] text-input  input-large" placeholder="Nombre de la Empresa"/>
                        </div>
                        Representante: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="representante" id="rep" class="input-medium" type="text" placeholder="Representante"/>
                        </div>
                        </br>
                        Cargo: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="cargo" id="car" type="text" class="input-medium" placeholder="Cargo"/>
                        </div>
                    </div>

                    <div id="contenedor_cn" class="hidedivs">
                        Primer Nombre: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="=p_nombre" id="pn" type="text" class="validate[required] text-input  input-medium" placeholder="Primer Nombre"/>
                        </div>
                        Segudo Nombre: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="s_nombre" id="sn" class="input-medium" type="text" placeholder="Segundo Nombre"/>
                        </div>
                        </br>
                        Primer Apellido: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="p_apellido" id="pa" type="text" class="validate[required] text-input  input-medium" placeholder="Primer Apellido"/>
                        </div>
                        Segundo Apellido: 
                        <div class="input-prepend">
                            <span class="add-on"><i class="icon-user"></i></span>
                            <input name="s_apellido" id="sa" class="input-medium" type="text" placeholder="Segundo Apellido"/>
                        </div>
                        </br>
                    </div>
                    <script src="SpryAssets/bootstrap/js/bootstrap-button.js" type="text/javascript"></script>
                </div>
            </div>
        </div>
    </body>
</html> 
