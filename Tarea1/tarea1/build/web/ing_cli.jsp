<%-- 
    Document   : ing_cli
    Created on : 19-04-2014, 03:48:07 PM
    Author     : Andres
--%>
<%
    // comprobar inicio de sesion!.
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false)) ){
        response.sendRedirect("index.jsp");
    }
%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String msg_error = "<p>&nbsp;</p>";
    if( request.getParameter("submit") != null ){
    
        String r = request.getParameter("rut");
        String n = request.getParameter("name");
        //REALIZAR INSERCIÓN
        Connection c = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","admin");
            String insert = "INSERT INTO \"cliente\" VALUES ('"+r+"','"+n+"')";
            c.createStatement().execute(insert);
            //Determinar si el que ingresa es vendedor o administrador.
            if(session.getAttribute("login").equals("Administrador")){
                response.sendRedirect("response.jsp");                           
            }else{
                response.sendRedirect("response_1.jsp");  
            }
        }catch(SQLException ex){
            msg_error = "Exception: "+ex.getMessage();
        }finally{
            if( c != null ){
                c.close();
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
<html>
    <head>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Ingresar Cliente</title>
    </head>
    <body>
        <h1>Ingresar Cliente</h1>
        <form>
            Rut: <input type = "text" name = "rut"><br>
            Nombre: <input type = "text" name = "name"><br>
            <input type="submit" name ="submit" value="Finalizar">
            <input type="reset" value="Reestablecer">
            <%= msg_error %>
        </form>
        <%= volver %>
    </body>
</html>
