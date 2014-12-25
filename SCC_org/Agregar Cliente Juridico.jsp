
<%@page import="BD.OC"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE>

<%        if (session.getAttribute("s_user") == null || !session.getAttribute("s_Rol").equals("ADMINISTRADOR")) {
         out.print("<script>location.href = 'index.jsp';</script>");
    }
%>
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
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css"/>
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

            jQuery(function($) {
                $("#fax").mask("9999-9999");
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
                        <p id="titulo">Crear Nuevo Contrato Cliente Juridico</p>
                        <div id="fondotabla">
                            <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" >
                                <div id="contenedorforma">
                                    </br>
                                    </br>
                                <%=session.getAttribute("ID")%>:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="id" type="text" placeholder="<%= session.getAttribute("ID")%>" value="" class="validate[required] text-input input-medium" size="14"/>
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
                                                PreparedStatement ps = conn.prepareStatement("SELECT ID, Nombre FROM estado_general_cliente WHERE Estado=0"
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
                                                PreparedStatement ps = conn.prepareStatement("SELECT ID, Nombre FROM servicio WHERE Estado=0"
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
                                Cant. Extensiones: <input style="height: auto;" class="input-small" type="number" name="extensiones" value="0" />
                                </br>
                                </br>
                                Nombre Empresa:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-briefcase"></i></span>
                                    <input name="nombre_empresa" placeholder="Nombre de la Empresa" type="text" value="" size="30" class="validate[required] text-input input-medium" maxlength="30"/>
                                </div>
                                Representante: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-user"></i></span>
                                    <input name="representante" placeholder="Representante" class="input-medium" type="text" maxlength="20" size="20"/>
                                </div>
                                </br>
                                </br>
                                Cargo:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="cargo" placeholder="Cargo" type="text" class="input-medium" maxlength="20" size="20"/>
                                </div>
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
                                </br>
                                </br>
                                Télefono:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="phone" placeholder="Teléfono" name="telefono" class="input-small" type="tel" size="8" maxlength="8">
                                </div>
                                Fax:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input id="fax" placeholder="Fax" name="fax" type="tel" class="input-small" size="8" maxlength="8">
                                </div>
                                Email: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-envelope"></i></span>
                                    <input name="email" placeholder="Email" type="email" class="input-medium" maxlength="30" size="30">
                                </div>

                                </br>
                                </br>
                                Dirección: <textarea name="direccion" placeholder="Dirección" class="validate[required] text-input" maxlength="100"></textarea>
                                Observaciones: <textarea name="observaciones" placeholder="Observaciones" maxlength="45" size="45"></textarea>
                                </br>
                                </br>
                                <input name="btn_crear" type="submit" class="btn btn-success" value="Crear" />
                                <input name="btn_cancelar" type="button" class="btn" value="Cancelar" onclick="Retornar();"/>
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
                                    String fecha = "";
                                    int indice = 0;

                                    PreparedStatement st1 = conn.prepareStatement("INSERT INTO cliente (idCLIENTE) VALUES (null)");
                                    st1.execute();
                                    st1.close();

                                    PreparedStatement st3 = conn.prepareStatement("SELECT CURDATE(), MAX(idCLIENTE) FROM cliente");
                                    st3.execute();
                                    ResultSet s = st3.getResultSet();
                                    while (s.next()) {
                                        fecha = s.getString(1);
                                        indice = Integer.parseInt(s.getString(2));
                                    }

                                    st3.close();

                                    PreparedStatement sta = conn.prepareStatement("SELECT ID FROM identificacion id"
                                            + " WHERE id.Tipo=?");
                                    sta.setString(1, session.getAttribute("ID").toString());
                                    sta.execute();
                                    ResultSet res = sta.getResultSet();
                                    int ididen = 0;
                                    while (res.next()) {
                                        ididen = Integer.parseInt(res.getString(1));
                                    }
                                    sta.close();

                                    PreparedStatement ps = conn.prepareStatement("INSERT INTO cliente_juridico "
                                            + "(Nombre_Empresa, Representante, Cargo, Direccion,"
                                            + " Telefono,Fax, Email, Observaciones, ESTADO_GENERAL_CLIENTE_ID,CLIENTE_idCLIENTE,NoID,IDENTIFICACION_ID) VALUES"
                                            + " (?,?,?,?,?,?,?,?,?,?,?,?) ");
                                    String empresa = request.getParameter("nombre_empresa");
                                    String repres = request.getParameter("representante");
                                    String cargo = request.getParameter("cargo");
                                    String direccion = request.getParameter("direccion");
                                    ps.setString(1, empresa.toUpperCase());
                                    ps.setString(2, repres.toUpperCase());
                                    ps.setString(3, cargo.toUpperCase());
                                    ps.setString(4, direccion.toUpperCase());
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
                                    String obser = request.getParameter("observaciones");
                                    ps.setString(8, obser.toUpperCase());
                                    ps.setInt(9, Integer.parseInt(request.getParameter("estado_cliente")));
                                    ps.setInt(10, indice);
                                    ps.setString(11, request.getParameter("id"));
                                    ps.setInt(12, ididen);
                                    ps.execute();
                                    ps.close();

                                    PreparedStatement st2 = conn.prepareStatement("INSERT INTO contrato (Fecha, IDBarriocolonia, USUARIO_IDUsuario, CLIENTE_idcliente,PERSONERIA_ID,SERVICIO_ID, No_Conexiones)"
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

                                    PreparedStatement estados = conn.prepareStatement("SELECT ep.ID, ec.ID, Precio FROM estado_pago_cliente ep, estado_cobro ec, servicio s"
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
                                    PreparedStatement con = conn.prepareStatement("SELECT IDContrato FROM contrato c, cliente cl, cliente_juridico cj"
                                            + " WHERE cj.NoID=? AND cj.CLIENTE_idCLIENTE=cl.idCLIENTE"
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
                                    System.out.println("SQL: CLIENTE JURIDICO" + ex.getMessage());
                                }
                            }
                        %>
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
