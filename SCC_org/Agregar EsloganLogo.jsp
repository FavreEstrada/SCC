<%@page import="BD.Dba"%>
<%@page import="java.sql.*"%>
<%@page import="java.io.*"%>

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
        <link href="SpryAssets/General.css" rel="stylesheet" type="text/css" />
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8">
        </script>
        <script src="SpryAssets/js/jquery.tablesorter.js" type="text/javascript"></script>
        <script src="SpryAssets/js/jquery.stickytableheaders.js" type="text/javascript"></script>
        <link href="SpryAssets/css/custom.css" rel="stylesheet" type="text/css" />
        <link href="SpryAssets/css/tablesorter.css" rel="stylesheet" type="text/css" />
        <script>
            jQuery(document).ready(function() {

                // initialize stickyTableHeaders _after_ tablesorter
                $(".tablesorter").tablesorter();
                $("table").stickyTableHeaders();

                $('#tabla tr').click(function() {
                    var href = $(this).find("a").attr("href");
                    if (href) {
                        window.location = href;
                    }
                });
            });

        </script>

        <style type="text/css">

            div#fondotabla{
                background-color: rgba(100, 196, 248, 0.3);
                background: rgba(100, 196, 248, 0.3);
                margin-left: auto;
                margin-right:auto;
                width: 60%;
                text-align:center;
                padding: 30px;
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
                    <p id="titulo">Eslogan/Logo</p>
                    <div id="fondotabla">
                        <form id="forma" method="POST" onsubmit="return jQuery(this).validationEngine('validate');" action="Upload" enctype="multipart/form-data" method="post">
                            <div id="contenedorforma">
                                </br>
                                Nombre de la Empresa: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="nombre" type="text" maxlength="50" class="validate[required] text-input input-large" placeholder="Nombre de la Empresa">
                                </div>
                                </br>
                                </br>
                                Eslogan: 
                                <div class="input-prepend">
                                    <span class="add-on"><i class="icon-pencil"></i></span>
                                    <input name="eslogan" type="text" maxlength="50" class="input-large" placeholder="Eslogan">
                                </div>
                                </br>
                                </br>
                                Logo:
                                <input name="logo" type="file" maxlength="5" placeholder="Buscar Imagen">
                                </br>
                                <input name="btn_crear" class="btn btn-primary" type="submit" value="Crear"/>
                                <button type="reset" class="btn">Cancelar</button>
                                </br>
                                </br>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="SpryAssets/bootstrap/js/bootstrap-modal.js" type="text/javascript"></script>
    </body>
</html>
