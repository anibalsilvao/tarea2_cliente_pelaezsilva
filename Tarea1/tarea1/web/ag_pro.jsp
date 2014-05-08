<%-- 
    Document   : ag_pro
    Created on : 21-04-2014, 08:15:54 PM
    Author     : Andres
--%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String msg_error = "<p>&nbsp;</p>";
    if( request.getParameter("submit") != null ){
    
        String cod = request.getParameter("codigo");
        String n = request.getParameter("name");
        String d = request.getParameter("desc");
        String cat = request.getParameter("cat");
        String can = request.getParameter("cant");
        String p = request.getParameter("price");
        //REALIZAR INSERCIÓN
        Connection c = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","admin");
            String insert = "INSERT INTO \"producto\" VALUES ("+cod+",'"+n+"',"+can+",'"+d+"','"+cat+"',"+p+")";
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

%>
<%
    // Comprobar inicio de sesion
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false)) || !(session.getAttribute("login").equals("Administrador")) ){
        response.sendRedirect("index.jsp");
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
        <title>Pepe's Works: Agregar Producto</title>
    </head>
    <body>
        <h3>Agregar Producto</h3>
        <form>
            Codigo Producto: <input type = "text" name = "codigo"><br>
            Nombre: <input type = "text" name = "name"><br>
            Descripcion: <input type = "text" name = "desc"><br>
            Categoria: <input type = "text" name = "cat"><br>
            Cantidad: <input type = "text" name = "cant"><br>
            Precio: <input type = "text" name = "price"><br>
            <input type="submit" name ="submit" value="Finalizar">
            <input type="reset" value="Reestablecer">
            <%= msg_error %>
        </form>
        <%= volver%>
    </body>
</html>
