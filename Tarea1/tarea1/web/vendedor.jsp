<%-- 
    Document   : admin
    Created on : 19-04-2014, 03:26:47 PM
    Author     : Andres
--%>
<%
    // comprobar inicio de sesion!.
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false)) || !(session.getAttribute("login").equals("Vendedor")) ){
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
        <h1>Panel de Vendedor</h1>
        <ul id="menu">
            <li><a href="ing_cli.jsp">Ingresar Cliente</a></li>
            <li><a href="venta.jsp">Ingresar Venta</a></li>
            <li><a href="ver_cli.jsp">Ver Ventas de Cliente</a></li>
            <li><a href="mis_ven.jsp">Mis Ventas</a></li>
            <li><a href="logout.jsp">Salir</a></li>
        </ul>
        <%=dato%>
    </body>
</html>
