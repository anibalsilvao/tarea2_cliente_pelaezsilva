<%-- 
    Document   : admin
    Created on : 19-04-2014, 03:26:47 PM
    Author     : Andres
--%>
<%
    // Comprobar inicio de sesion
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false)) || !(session.getAttribute("login").equals("Administrador")) ){
        response.sendRedirect("index.jsp");
    }
%>
<%
    String dato = "<p>&nbsp;</p>";
    Object tipo = session.getAttribute("login");
    Object nombre = session.getAttribute("nombre");
    dato = dato + tipo + ": " + nombre;
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Administracion</title>
    </head>
    <body>
        <h1>Panel de Administración</h1>
        <ul id="menu">
            <li><a href="ing_ven.jsp">Ingresar Vendedor</a></li>
            <li><a href="ing_cli.jsp">Ingresar Cliente</a></li>
            <li><a href="ad_pro.jsp">Administrar Productos</a></li>
            <li><a href="compra.jsp">Ingresar Compra</a></li>
            <li><a href="venta.jsp">Ingresar Venta</a></li>
            <li><a href="ver_cli.jsp">Ver Ventas de Cliente</a></li>
            <li><a href="logout.jsp">Salir</a></li>
        </ul>
        <%= dato%>
    </body>
</html>
