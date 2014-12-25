
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
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css"/>
        <script>
            function Retornar() {
                location.href = "Principal.jsp";
            }

            $(document).ready(function() {
                var rol = '<%= session.getAttribute("s_Rol")%>';
                if (rol != "ADMINISTRADOR") {
                    $('#menu').prop("class", "Menu");
                }
            });

            function cargar() {
                var tipoPersoneria = $('#personerias option:selected').val();

                jQuery.ajax({
                    url: 'ControladoraID.jsp',
                    type: 'GET',
                    async: true,
                    data: {
                        tipoPersoneria: tipoPersoneria
                    },
                    success: function(data)
                    {
                        if (data.trim() !== "none")
                        {

                            var datos = data.trim().split('#');
                            var valores = new Array();
                            jQuery('#tipoid').empty();
                            for (var i = 0; i < datos.length - 1; i++)
                            {
                                valores = datos[i].split('$');
                                jQuery('#tipoid').append('<option></option>');
                                jQuery('#tipoid option:last').attr('value', valores[1]);
                                jQuery('#tipoid option:last').append(valores[1]);
                            }

                        }
                        console.log(data);
                    }
                });
                document.getElementById('btn_siguiente').disabled = false;
            }

        </script>

        <style type="text/css">

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                width: 30%;
                margin-left: auto;
                margin-right:auto;
                text-align:center;
                padding: 30px;
            }

        </style>
    </head>

    <body>
        <div class="container">
            <jsp:include page="Menu.jsp" flush="false"></jsp:include>
                </br>
                </br>
                <div class="row-fluid">
                    <div class="span12">
                        <p id="titulo">Crear Nuevo Cliente</p>
                        <div id="fondotabla">
                            <form method="POST" id="forma">
                                Tipo de Personería:
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-list"></i></span>
                                    <select name="tipoper" id="personerias" onChange="cargar();">
                                        <option value="default">Elija tipo de Personería</option>
                                    <%
                                        int idper = 0;
                                        try {
                                            Dba dba = new Dba();
                                            dba.conectar();
                                            Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());

                                            PreparedStatement ps = conn.prepareStatement("SELECT ID,Tipo FROM personeria WHERE Estado=0"
                                                    + " ORDER BY (Tipo)");
                                            ps.execute();
                                            ResultSet rs = ps.getResultSet();

                                            while (rs.next()) {
                                                idper = Integer.parseInt(rs.getString(1));
                                    %>
                                    <option><%=rs.getString(2)%></option>
                                    <%}
                                            ps.close();
                                            conn.close();
                                        } catch (Exception ex) {
                                            System.out.println("SQLException: " + ex);
                                        }
                                    %>
                                </select>
                            </div>
                            </br>
                            </br>
                            Tipo de Identificación:
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-list"></i></span>
                                <select name="tipoId" id="tipoid">
                                    <option>Elija una Personería</option>
                                </select>
                            </div>   
                            </br>   
                            </br>
                            <input name="btn_crear" id="btn_siguiente" type="submit" class="btn btn-primary" disabled="disabled" value="Siguiente" />
                            <input name="btn_cancelar" type="button" value="Cancelar" class="btn" onclick="Retornar();" />
                        </form>
                        <%
                            if (request.getParameter("btn_crear") != null) {
                                session.setAttribute("ID", request.getParameter("tipoId"));
                                session.setAttribute("Nombreper", idper);
                                if (request.getParameter("tipoper").equals("NATURAL")) {
                                    out.print("<script>location.href = 'Agregar Cliente Natural.jsp'</script>");
                                } else {
                                    out.print("<script>location.href = 'Agregar Cliente Juridico.jsp'</script>");
                                }
                            }
                        %>
                    </div>	
                </div>	
            </div>	
        </div>	
    </body>
</html>
