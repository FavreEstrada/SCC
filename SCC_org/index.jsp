<%-- 
    Document   : index
    Created on : Jan 22, 2013, 11:37:18 PM
    Author     : Favré Estrada
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sistema de Control de Clientes</title>
        <link rel="stylesheet" href="SpryAssets/css/validationEngine.jquery.css" type="text/css"/>
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap.min.css" type="text/css" media="screen"/>
        <link rel="stylesheet" href="SpryAssets/bootstrap/css/bootstrap-responsive.css" />
        <link rel="stylesheet" href="SpryAssets/General.css" type="text/css" media="screen"/>
        <script src="SpryAssets/js/jquery-1.8.2.min.js" type="text/javascript"></script>
        <script src="SpryAssets/js/languages/jquery.validationEngine-es.js" type="text/javascript" charset="utf-8"></script>
        <script src="SpryAssets/js/jquery.validationEngine.js" type="text/javascript" charset="utf-8"></script>
        <style type="text/css">
            h1 , p {
                text-align: center;            
            }
            body{
                background-color: #fff;
            }
            p#Login {
                font-weight: bold;
                font-size: 110%;
                color: #00536c;
            }
            div#Contenedor {
                text-align: center;
                background-color: #f5f5f5;
                width: 40%;
                margin-left:auto; 
                margin-right:auto; 
            }
            input[type="text"],input[type="password"]{
                height: 20px;
            }
        </style>
    </head>

    <body>
        <div class="container">
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
                } catch (Exception ex) {
                    System.out.println("SQL ESLOGAN: " + ex.getMessage());
                }
            %>

            <div align="center">
                </br>
                <img src="Logo.jsp" width="217" height="89" alt="Logo"/>
                </br>
                <p id="Eslogan"><%=eslogan%></p> 
            </div>

            <h1 id="Titulo">Sistema de Control de Clientes</h1>
            </br>
            <div class='row-fluid'>
                <div class="span12">
                    <div id="Contenedor">
                        </br>
                        <p id="Login">Login</p>
                        <form name="forma" class="form-horizontal" method="post" onsubmit="return jQuery(this).validationEngine('validate');" action="Autenticacion.jsp" >
                            Usuario:
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-user"></i></span>
                                <input class="validate[required] text-input input-medium"  type="text" name="usuario_id" placeholder="Nombre del Usuario "/>
                            </div>
                            </br>
                            </br>
                            Contraseña:
                            <div class="input-prepend">
                                <span class="add-on"><i class="icon-lock"></i></span>
                                <input class="validate[required] text-input input-medium" type="password" name="usuario_pass" placeholder="Contraseña"/>
                            </div>
                            </br>
                            </br>
                            <button type="submit" name="btn_login" class="btn btn-large btn-primary">Log In</button>
                        </form>
                        </br>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
