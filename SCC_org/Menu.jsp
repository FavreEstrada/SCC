<%-- 
    Document   : Menu
    Created on : May 21, 2013, 1:22:05 AM
    Author     : Favré Estrada
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page session="true"%>
<!DOCTYPE html>

<%
    if (session.getAttribute("s_user") == null) {
        out.print("<script>location.href = 'index.jsp';</script>");
    }%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sistema de Control de Clientes</title>
        <script type='text/javascript'>
            $(window).load(function() {
                jQuery('.submenu').hover(function() {
                    jQuery(this).children('ul').removeClass('submenu-hide').addClass('submenu-show');
                }, function() {
                    jQuery(this).children('ul').removeClass('.submenu-show').addClass('submenu-hide');
                }).find("a:first").append(" &raquo; ");
            });//]]>
        </script>
        <style>
            .submenu-show
            {
                border-radius: 3px;
                display: block;
                left: 100%;
                margin-top: -25px !important;
                moz-border-radius: 3px;
                position: absolute;
                webkit-border-radius: 3px;
            }
            .submenu-hide
            {
                display: none !important;
                float: right;
                position: relative;
                top: auto;
            }
            .navbar .submenu-show:before
            {
                border-bottom: 7px solid transparent;
                border-left: none;
                border-right: 7px solid rgba(0, 0, 0, 0.2);
                border-top: 7px solid transparent;
                left: -7px;
                top: 10px;
            }

            .navbar .submenu-show:after
            {
                border-bottom: 6px solid transparent;
                border-left: none;
                border-right: 6px solid #fff;
                border-top: 6px solid transparent;
                left: 10px;
                left: -6px;
                top: 11px;
            }
            ul.nav li.dropdown:hover ul.dropdown-menu{
                display: block;
            }

            .center.navbar .nav,
            .center.navbar .nav > li {
                float:none;
                display:inline-block;
                *display:inline; /* ie7 fix */
                *zoom:1; /* hasLayout ie7 trigger */
                vertical-align: top;
            }
            .center .navbar-inner {
                text-align:center;
            }
            .center .dropdown-menu {
                text-align: left;
            }
            .prueba{
             margin-left: auto;
             margin-right:auto;
             text-align: center;
            }

        </style>
    </head>
    <body>
        <div id="Sesion">
            <p><%=session.getAttribute("s_user")%> | <a href="CerrarSesion.jsp">Salir</a></p>
        </div>
        <%
            String eslogan = "";
            try {
                Dba dba = new Dba();
                dba.conectar();
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                PreparedStatement ps = conn.prepareStatement("SELECT Eslogan FROM parametrizacion");
                ps.execute();
                ResultSet rs = ps.getResultSet();
                while (rs.next()) {
                    eslogan = rs.getString(1);
                }
                ps.close();
                conn.close();
            } catch (Exception ex) {
                System.out.println("SQL ESLOGAN: " + ex.getMessage());
            }
        %>
        <div class="container">
            <div align="center">
                <a href="Principal.jsp"><img src="Logo.jsp" width="217" height="89" alt="Logo"/></a>
                </br>
                <p id="Eslogan"><%=eslogan%></p> 
            </div>
            </br>

            <div class="navbar center">
                <div class="navbar-inner">
                    <div class="container-fluid">
                            <a data-target=".nav-collapse" data-toggle="collapse" class="btn btn-navbar">
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </a>
                            <div class="nav-collapse">
                                <ul class="nav">
                                    <li  class="dropdown"><a data-toggle="dropdown" class="dropdown-toggle" href="#">Clientes<b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li><a href="Agregar Cliente.jsp">Crear Cliente</a></li>
                                            <li><a href="Busqueda Clientes.jsp">B&uacute;squeda de Clientes</a></li>
                                            <li><a href="Solicitud Rechazada.jsp">Crear Solicitud Rechazada</a></li>
                                        </ul>
                                    </li>
                                    <li class="dropdown"><a data-toggle="dropdown" class="dropdown-toggle" href="#">Órdenes de Trabajo<b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li><a href="Instalaciones.jsp">Crear Orden de Trabajo</a></li>
                                            <li><a href="Lista Trabajos Pendientes.jsp">Lista de &Oacute;rdenes</a></li>
                                        </ul>
                                    </li>
                                    <li class="dropdown"><a data-toggle="dropdown" class="dropdown-toggle" href="#">Cobros<b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li><a href="Lista Cobros.jsp">Lista de Cobro</a></li>
                                        </ul>
                                    </li>
                                    <% if (session.getAttribute("s_Rol") != null) {
                                            if (session.getAttribute("s_Rol").equals("ADMINISTRADOR")) {
                                    %>
                                    <li class="dropdown"><a data-toggle="dropdown" class="dropdown-toggle" href="#">Reportes<b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li><a href="Dashboards.jsp">DashBoards</a></li>
                                            <li><a href="Lista Clientes.jsp">Lista de Clientes</a></li>
                                            <li><a href="Lista Solicitudes Rechazadas.jsp">Solicitudes Rechazadas</a></li>
                                            <li class="dropdown submenu">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Órdenes</a>
                                                <ul class="dropdown-menu submenu-show submenu-hide">
                                                    <li><a href="Lista Ordenes Cobro.jsp">Órdenes de Cobro</a></li>
                                                    <li><a href="Lista Ordenes Trabajo.jsp">Órdenes de Trabajo</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="dropdown">
                                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">Parametrización<b class="caret"></b></a>
                                        <ul class="dropdown-menu">
                                            <li class="dropdown submenu">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Estados</a>
                                                <ul class="dropdown-menu submenu-show submenu-hide">
                                                    <li><a href="Agregar Estado General Cliente.jsp">Estado General del Cliente</a></li>
                                                    <li><a href="Agregar Estado Pago Cliente.jsp">Estado de Pago del Cliente</a></li>
                                                    <li><a href="Agregar Estado Cobro Cliente.jsp">Estado de Cobro del Cliente</a></li>
                                                    <li><a href="Agregar Estado Orden Trabajo.jsp">Estado de Orden de Trabajo</a></li>
                                                </ul>
                                            <li class="dropdown submenu">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Usuarios</a>
                                                <ul class="dropdown-menu submenu-show submenu-hide">
                                                    <li><a href="Agregar Tipo Usuario.jsp">Crear Tipo de Usuario</a></li>
                                                    <li><a href="Crear Usuario.jsp">Crear Usuarios</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="Agregar Trabajo a Realizar.jsp">Trabajos a Realizar</a></li>
                                            <li><a href="Agregar BarrioColonia.jsp">Barrios/Colonias</a></li>
                                            <li class="dropdown submenu">
                                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">Otros</a>
                                                <ul class="dropdown-menu submenu-show submenu-hide">
                                                    <li><a href="Agregar Servicios.jsp">Servicios</a></li>
                                                    <li><a href="Agregar Prioridad.jsp">Prioridad</a></li>
                                                    <li><a href="Agregar Personeria.jsp">Personería</a></li>
                                                    <li><a href="Agregar Identificacion.jsp">Identificación</a></li>
                                                    <li><a href="Agregar EsloganLogo.jsp">Logo/Eslogan</a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <% }
                                        }%>
                                </ul>
                            </div><!-- /.nav-collapse -->
                    </div>
                </div>
            </div>
        </div>
        <script src="SpryAssets/bootstrap/js/bootstrap-dropdown.js" type="text/javascript"></script>
        <script src="SpryAssets/bootstrap/js/bootstrap-collapse.js" type="text/javascript"></script>
    </body>
</html>
