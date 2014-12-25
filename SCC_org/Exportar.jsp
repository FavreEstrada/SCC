<%-- 
    Document   : Exportar
    Created on : Jul 14, 2013, 1:01:04 PM
    Author     : Favré Estrada
--%>
<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="com.itextpdf.text.html.simpleparser.HTMLWorker"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="BD.Dba"%>
<%@page trimDirectiveWhitespaces ="true"%>
<%@page contentType="application/pdf" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            response.setHeader("Content-Disposition", "attachment; filename=\"Lista Clientes.pdf\"");
            try {
                
                
                Document PDF = new Document();
                //PdfWriter.getInstance(PDF, new FileOutputStream("Lista Clientes.pdf"));
                PdfWriter.getInstance(PDF, response.getOutputStream());
                PDF.open();
                Dba dba = new Dba();
                dba.conectar();
                Connection conn = DriverManager.getConnection(dba.getUrl(), dba.getUser(), dba.getPass());
                PreparedStatement eslogo = conn.prepareStatement("SELECT Nombre_Empresa, Logo, Eslogan from Parametrizacion");
                eslogo.execute();
                ResultSet rs = eslogo.getResultSet();
                byte[] buffer = null;
                Paragraph par = new Paragraph();
                par.setAlignment(Element.ALIGN_CENTER);
                while (rs.next()) {
                    buffer = rs.getBytes(2);
                    Image imagen = Image.getInstance(buffer);
                    imagen.scalePercent(40);
                    imagen.setAlignment(Image.ALIGN_CENTER);
                    par.add(imagen);
                    par.add(Chunk.NEWLINE);
                    par.add(rs.getString(1));
                    par.add(Chunk.NEWLINE);
                    par.add(rs.getString(3));
                    par.add(Chunk.NEWLINE);
                }
                par.add(Chunk.NEWLINE);
                par.add(request.getParameter("tit"));
                par.add(Chunk.NEWLINE);
                par.add(Chunk.NEWLINE);
                par.add(Chunk.NEWLINE);

                PdfPTable table;
                table = (PdfPTable) session.getAttribute("ar");
                table.setWidthPercentage(100);
                par.add(table);
                par.add(Chunk.NEWLINE);
                par.add(Chunk.NEWLINE);

                if (request.getParameter("tot") != null) {
                    par.add("Total: " + request.getParameter("tot"));
                    par.add(Chunk.NEWLINE);
                }
                if (request.getParameter("cant") != null) {
                    par.add("Ingresos: " + request.getParameter("cant"));
                    par.add(Chunk.NEWLINE);
                    par.add(Chunk.NEWLINE);
                }
                PDF.add(par);
                PDF.close();
                response.getOutputStream().flush();
                response.getOutputStream().close();
                out.clear();
                out = pageContext.pushBody();
                session.removeAttribute("ar");
            } catch (Exception ex) {
                System.out.println("Error Exportar: " + ex.getMessage());
            }
        %>
    </body>
</html>
