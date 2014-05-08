<%-- 
    Document   : editar
    Created on : 29-04-2014, 03:07:09 PM
    Author     : Andres
--%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String msg_error = "<p>&nbsp;</p>";
    if( request.getParameter("submit") != null ){
        String d = request.getParameter("desc");
        String cat = request.getParameter("cat");
        String p = request.getParameter("price");
        //REALIZAR INSERCIÓN
        Connection c = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","admin");
            String sentence = "UPDATE \"producto\" SET \"descripcion\"='"+d+"',\"categoria\"='"+cat+"',\"precio\"='"+p+"' WHERE \"id_producto\"='"+session.getAttribute("idpro")+"'";
            c.createStatement().execute(sentence);
            session.removeAttribute("nompro");
            session.removeAttribute("idpro");
            response.sendRedirect("response.jsp");
        }catch(SQLException ex){
            msg_error = "Exception: "+ex.getMessage();
        }finally{
            if( c != null ){
                c.close();
            }
        }
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Editar Producto</title>
    </head>
    <body>
        <h3>Agregar Producto</h3>
        <form>
            Descripcion: <input type = "text" name = "desc"><br>
            Categoria: <input type = "text" name = "cat"><br>
            Precio: <input type = "text" name = "price"><br>
            <input type="submit" name ="submit" value="Finalizar">
            <input type="reset" value="Reestablecer">
            <%= msg_error %>
        </form>
    </body>
</html>
