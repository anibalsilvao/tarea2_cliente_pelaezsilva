<%-- 
    Document   : ad_pro
    Created on : 19-04-2014, 04:13:42 PM
    Author     : Andres
--%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Comprobar inicio de sesion
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false)) || !(session.getAttribute("login").equals("Administrador")) ){
        response.sendRedirect("index.jsp");
    }
%>
<%
    String msg_error = "<p>&nbsp;</p>";
    String tabla = "<p>&nbsp;</p>";
    String nombre = null;
    Connection c = null;
    try{
        Class.forName("oracle.jdbc.OracleDriver");
        c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","admin");
        ResultSet r = c.createStatement().executeQuery("SELECT * FROM \"producto\"");
        while(r.next()){
            tabla = tabla+"<tr><td>"+r.getString(1)+"</td><td>"+r.getString(2)+"</td><td>"+r.getString(3)+"</td><td>"+r.getString(4)+"</td><td>"+r.getString(5)+"</td><td>"+r.getString(6)+"</td></tr>";
        }
    }catch(SQLException ex){
        msg_error = "Exception: "+ex.getMessage();
    }finally{
        if( c != null ){
            c.close();
        }
    }
%>
<%
    String seleccion = "<input type=\"text\" id=\"seleccionado\" disabled=\"disabled\">";
    if(request.getParameter("submit") != null){
        String se = request.getParameter("buscar");
        Connection c2 = null;
    try{
        Class.forName("oracle.jdbc.OracleDriver");
        c2 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","system","admin");
        ResultSet s = c2.createStatement().executeQuery("SELECT * FROM \"producto\" WHERE \"id_producto\"='"+se+"'");
            if( s.next() ){
                session.setAttribute("nompro",true);
		session.setAttribute("nompro",s.getString("nombre"));
                nombre = s.getString("nombre");
                session.setAttribute("idpro",true);
		session.setAttribute("idpro",s.getString("id_producto"));
                seleccion = "<input type=\"text\" id=\"seleccionado\" disabled=\"disabled\" value='"+nombre+"'>";
            }
    }catch(SQLException ex){
        msg_error = "Exception: "+ex.getMessage();
    }finally{
        if( c2 != null ){
            c2.close();
        }
    }
    }
%>
<%
    if(request.getParameter("editar") != null && (session.getAttribute("nompro")!=null)){
        response.sendRedirect("editar.jsp");
    }
%>
<%
    String volver = "<p>&nbsp;</p>";
    Object tipo = session.getAttribute("login");
    Object nombre2 = session.getAttribute("nombre");
    volver = volver + tipo + ": " + nombre2 + "<br><a href";
    
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
        <title>Pepe's Works: Administrar Productos</title>
    </head>
    <body>
        <h1>Opciones</h1>
        <ul id="menu">
            <li><a href="ag_pro.jsp">Agregar Producto</a></li>
        </ul>
        <h2>Editar Producto</h2>
                    <form id="buscador" method="get">
                        <input type="search" name="buscar" placeholder="Buscar Producto">
                        <input type="submit" name="submit" value="Buscar">
                    </form>
                    <form>Seleccionado:<%= seleccion%>
                    <input type="submit" name="editar" value="Editar"></form>
                    <table style= "text-align:center">
                        <tr>
                            <th>Codigo</th>
                            <th>Nombre</th>
                            <th>Cantidad</th>
                            <th>Descripcion</th>
                            <th>Categoria</th>
                            <th>Precio</th>
                        </tr>
                        <%= tabla %>
                    </table>
                    <div id="lista_productos"></div>
                    <script src="js/jquery-1.9.1.js"></script>
                    <%= volver %>
    </body>
</html>
