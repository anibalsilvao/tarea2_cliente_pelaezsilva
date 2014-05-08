<%-- 
    Document   : ing_ven
    Created on : 19-04-2014, 03:34:08 PM
    Author     : Andres
--%>
<%
    // Comprobar inicio de sesion
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false)) || !(session.getAttribute("login").equals("Administrador")) ){
        response.sendRedirect("index.jsp");
    }
%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String msg_error = "<p>&nbsp;</p>";
    if( request.getParameter("submit") != null ){
    
        String r = request.getParameter("rut");
        String p = request.getParameter("pass");
        String p2 = request.getParameter("pass2");
        String n = request.getParameter("name");
    
    if(!p.equals(p2)){
        msg_error = "<p>ERROR!<br>Contraseñas incorrectas!</p>";
    }else{
        //REALIZAR INSERCIÓN
        Connection c = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","admin");
            String insert = "INSERT INTO \"usuario\" VALUES ('"+r+"','"+p+"','"+n+"','Vendedor',0)";
            c.createStatement().execute(insert);
            response.sendRedirect("response.jsp");
        }catch(SQLException ex){
            msg_error = "Exception: "+ex.getMessage();
        }finally{
            if( c != null ){
                c.close();
            }
        }
    }
    }
%>
<%
    String volver = "<p>&nbsp;</p>";
    Object tipo = session.getAttribute("login");
    Object nombre = session.getAttribute("nombre");
    volver = volver + tipo + ": " + nombre + "<br><a href";
    
    if(tipo.equals("Administrador")){
        volver = volver + "=\"admin.jsp\">Volver</a>";
    }else{
        volver = volver + "=\"vendedor.jsp\">Volver</a>";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Ingresar Vendedor</title>
    </head>
    <body>
        <h1>Ingresar Vendedor</h1>
        <form>
            Rut: <input type = "text" name = "rut"><br>
            Contraseña: <input type = "password" name = "pass"><br>
            Repetir Contraseña: <input type = "password" name = "pass2"><br>
            Nombre: <input type = "text" name = "name"><br>
            <input type="submit" name="submit" value="Finalizar">
            <input type="reset" value="Reestablecer">
            <%= msg_error %>
        </form>
        <%= volver %>
    </body>
</html>
