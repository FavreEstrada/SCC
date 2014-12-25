
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
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css" media="screen"/>
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery-maskedinput.js" type="text/javascript" charset="utf-8"></script>
        <script>

            function Retornar() {
                location.href = "Agregar Cliente.jsp";
            }

            jQuery(function($) {
                $("#phone").mask("9999-9999");
            });

            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }

            });

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
                        <p id="titulo">Crear Nuevo Contrato Cliente Natural</p>
                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <div id="contenedorforma">
                                    </br>
                                <%=session.getAttribute("ID")%>: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="id" type="text" value="" class="validate[required] text-input input-medium" size="14" placeholder="<%= session.getAttribute("ID")%>"/>
                                </div>
                                Estado Gen. del Cliente:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="estado_cliente" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();

                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement ps = conn.prepareStatement("SELECT ID,Nombre from estado_general_cliente WHERE Estado=0"
                                                        + " ORDER BY(Nombre)");
                                                ps.execute();
                                                ResultSet rs = ps.getResultSet();
                                                while (rs.next()) {
                                        %>
                                        <option value="<%=rs.getString(1)%>"><%=rs.getString(2)%></option>
                                        <%}
                                                ps.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                </br>
                                </br>
                                Servicio:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="servicio" class="input-medium">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement ps = conn.prepareStatement(" SELECT ID, Nombre FROM servicio WHERE Estado=0"
                                                        + " ORDER BY (Nombre)");
                                                ps.execute();
                                                ResultSet rs = ps.getResultSet();
                                                while (rs.next()) {
                                        %>
                                        <option value="<%=rs.getString(1)%>"><%=rs.getString(2)%></option>
                                        <%}
                                                ps.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Cant. Extensiones: <input style="height: auto;" type="number" name="extensiones" value="0" class="input-small" min="0" />
                                </br>
                                </br>
                                Primer Nombre:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="primer_nombre" placeholder="Primer Nombre" type="text" value="" class="validate[required] text-input input-medium" maxlength="20" size="20"/>
                                </div>
                                Segundo Nombre:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="segundo_nombre" placeholder="Segundo Nombre" type="text" class="input-medium" value="" maxlength="20" size="20"/>
                                </div>
                                </br>
                                </br>
                                Primer Apellido:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="primer_apellido" placeholder="Primer Apellido" type="text" value="" class="validate[required] text-input input-medium" maxlength="20" size="20"/>
                                </div>
                                Segundo Apellido:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="segundo_apellido" placeholder="Segundo Apellido" class="input-medium" type="text" value="" maxlength="20" size="20"/>
                                </div>
                                </br>
                                </br>
                                Barrio o Colonia:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="barriocolonia" class="input-small">
                                        <%
                                            try {
                                                Dba dba = new Dba();
                                                dba.conectar();
                                                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                                                PreparedStatement ps = conn.prepareStatement("SELECT IDBarriocolonia, Abreviacion FROM barriocolonia WHERE Estado=0 AND Cobertura=0"
                                                        + " ORDER BY (Abreviacion)");
                                                ps.execute();
                                                ResultSet rs = ps.getResultSet();
                                                while (rs.next()) {
                                        %>
                                        <option value="<%=rs.getString(1)%>"><%=rs.getString(2)%></option>
                                        <%}

                                                ps.close();
                                                conn.close();
                                            } catch (Exception ex) {
                                                System.out.println("SQL: " + ex.getMessage());
                                            }
                                        %>
                                    </select>
                                </div>
                                Télefono:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="phone" placeholder="Teléfono" name="telefono" type="tel" class="input-small" value="" size="8" maxlength="8" />
                                </div>
                                Email:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-envelope"></i></span>
                                    <input name="email" placeholder="Email" type="email" class="input-medium" maxlength="30"/>
                                </div>
                                </br>
                                </br>
                                Dirección: <textarea placeholder="Dirección"  name="direccion" class="validate[required] text-input" maxlength="100"></textarea>
                                Observaciones: <textarea  name="observaciones" placeholder="Observaciones" maxlength="45"></textarea>
                                </br>
                                </br>
                                <input name="btn_crear" type="submit" class="btn btn-success" value="Crear" />
                                <input name="btn_cancelar" type="button" value="Cancelar" class="btn" onclick="Retornar();"/>
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

                                    //Recuperar ID del tipo del Identificacion 
                                    PreparedStatement sta = conn.prepareStatement("SELECT ID,CURDATE() FROM identificacion as id"
                                            + " WHERE id.Tipo=?");
                                    sta.setString(1, session.getAttribute("ID").toString());
                                    sta.execute();
                                    ResultSet res = sta.getResultSet();
                                    int ididen = 0;
                                    String fecha = "";
                                    while (res.next()) {
                                        ididen = Integer.parseInt(res.getString(1));
                                        fecha = res.getString(2);
                                    }
                                    sta.close();

                                    //Insertar en Tabla CLIENTES
                                    PreparedStatement st1 = conn.prepareStatement("INSERT INTO cliente (idCLIENTE) VALUES (null) ");
                                    st1.execute();
                                    st1.close();

                                    //Recuperar el número máximo de clientes
                                    PreparedStatement st = conn.prepareStatement("SELECT MAX(idCLIENTE) from cliente");
                                    st.execute();
                                    ResultSet set = st.getResultSet();
                                    int indice = 0;
                                    while (set.next()) {
                                        indice = Integer.parseInt(set.getString(1));
                                    }
                                    st.close();

                                    //Insertar el nuevo cliente
                                    PreparedStatement ps = conn.prepareStatement("INSERT INTO cliente_natural "
                                            + "(Primer_Nombre, Segundo_Nombre, Primer_Apellido, Segundo_Apellido,"
                                            + " Direccion, Telefono, Email, Observaciones, ESTADO_GENERAL_CLIENTE_ID,CLIENTE_idCLIENTE,NoID,IDENTIFICACION_ID) VALUES"
                                            + " (?,?,?,?,?,?,?,?,?,?,?,?) ");
                                    String pnombre = request.getParameter("primer_nombre");
                                    String papellido = request.getParameter("primer_apellido");
                                    String snombre = request.getParameter("segundo_nombre");
                                    String sapellido = request.getParameter("segundo_apellido");
                                    String dir = request.getParameter("direccion");
                                    ps.setString(1, pnombre.toUpperCase());
                                    ps.setString(2, snombre.toUpperCase());
                                    ps.setString(3, papellido.toUpperCase());
                                    ps.setString(4, sapellido.toUpperCase());
                                    ps.setString(5, dir.toUpperCase());
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
                                    ps.setInt(6, telint);
                                    ps.setString(7, request.getParameter("email"));
                                    String obser = request.getParameter("observaciones");
                                    ps.setString(8, obser.toUpperCase());
                                    ps.setInt(9, Integer.parseInt(request.getParameter("estado_cliente")));
                                    ps.setInt(10, indice);
                                    ps.setString(11, request.getParameter("id"));
                                    ps.setInt(12, ididen);
                                    ps.execute();
                                    ps.close();

                                    //Crear contrato para el nuevo cliente
                                    PreparedStatement st2 = conn.prepareStatement("INSERT INTO contrato (Fecha, IDBarriocolonia, USUARIO_IDUsuario, CLIENTE_idcliente,PERSONERIA_ID,SERVICIO_ID,No_Conexiones)"
                                            + " VALUES (?,?,?,?,?,?,?)");
                                    st2.setString(1, fecha);
                                    st2.setInt(2, Integer.parseInt(request.getParameter("barriocolonia")));
                                    st2.setInt(3, Integer.parseInt(session.getAttribute("s_ID").toString()));
                                    st2.setInt(4, indice);
                                    st2.setInt(5, Integer.parseInt(session.getAttribute("Nombreper").toString()));
                                    st2.setInt(6, Integer.parseInt(request.getParameter("servicio")));
                                    st2.setInt(7, Integer.parseInt(request.getParameter("extensiones")));

                                    if (st2.execute() == false) {
                                        out.print("<script>alert('El nuevo cliente fue creado correctamente')</script>");
                                    }
                                    st2.close();

                                    PreparedStatement estados = conn.prepareStatement("SELECT ep.ID, ec.ID,Precio FROM estado_pago_cliente ep, estado_cobro ec, servicio s"
                                            + " WHERE ep.Nombre='NO VENCIDO' AND ec.Nombre='PENDIENTE - NO VISITADO' AND s.ID=?");
                                    estados.setInt(1, Integer.parseInt(request.getParameter("servicio")));
                                    estados.execute();
                                    int IDep = 0;
                                    int IDec = 0;
                                    String servicio = "";
                                    ResultSet rsestados = estados.getResultSet();
                                    while (rsestados.next()) {
                                        IDep = Integer.parseInt(rsestados.getString(1));
                                        IDec = Integer.parseInt(rsestados.getString(2));
                                        servicio = rsestados.getString(3);
                                    }
                                    estados.close();

                                    int IDContrato = 0;
                                    PreparedStatement con = conn.prepareStatement("SELECT IDContrato FROM contrato c, cliente cl, cliente_natural cn"
                                            + " WHERE cn.NoID=? AND cn.CLIENTE_idCLIENTE=cl.idCLIENTE"
                                            + " AND c.CLIENTE_idcliente=cl.idCLIENTE");
                                    con.setString(1, request.getParameter("id"));
                                    con.execute();
                                    ResultSet rscon = con.getResultSet();
                                    while (rscon.next()) {
                                        IDContrato = Integer.parseInt(rscon.getString(1));
                                    }
                                    con.close();

                                    OC ordencobro = new OC();
                                    Boolean exito = ordencobro.GenerarOrdenCobro(Double.parseDouble(servicio), fecha, session.getAttribute("s_user").toString(), IDec, IDep, IDContrato,
                                            Integer.parseInt(request.getParameter("extensiones")));
                                    if (exito == false) {
                                        out.print("<script>location.href='Agregar Cliente.jsp'</script>");
                                    }
                                } catch (Exception ex) {
                                    System.out.println("SQL: CLIENTE NATURAL" + ex.getMessage());
                                }
                            }
                        %>
                    </div>
                </div>	
            </div>	
        </div>	
    </body>
</html>
