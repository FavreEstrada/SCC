<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE>
<html>
    <body>
        <%
            try {
                Dba dba = new Dba();
                dba.conectar();

                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                
                PreparedStatement ps = conn.prepareStatement("SELECT MIN(Fecha) FROM contrato");
                ps.execute();
                ResultSet rs = ps.getResultSet();
               
                String fecha= "";
                while (rs.next()) {
                    fecha = rs.getString(1);    
                }
                String fec[] = null;
                for (int i = 0; i < fecha.length(); i++) {
                        fec = fecha.split("-");
                    }
               
                out.println( fec[0] + "$" + fec[0] + "#");
                ps.close();
                conn.close();
            } catch (Exception ex) {
                out.print("false");
            }

        %>
    </body>
</html>