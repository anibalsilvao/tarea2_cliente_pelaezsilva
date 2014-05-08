<%-- 
    Document   : ver_cli
    Created on : 19-04-2014, 05:13:13 PM
    Author     : Andres
--%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*"%>
<%
    String msg_error = "<p>&nbsp;</p>";
    String lista_cliente = "<p>&nbsp;</p>";
    
    Connection lc = null;
    int it = 1;
    try{
        Class.forName("oracle.jdbc.OracleDriver");
        lc = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
        ResultSet r = lc.createStatement().executeQuery("SELECT * FROM \"cliente\"");
        while(r.next()){
            lista_cliente = lista_cliente+"<option name=\"clie"+it+"\">"+r.getString("rut")+"</option>";
            it++;
        }
    }catch(Exception e){
        msg_error = "<p>Exception: "+e.getMessage()+"</p>";
    }finally{
        if(lc != null){
            lc.close();
        }
    }
%>

<%
    String tablar = "<p>&nbsp;</p>";
    if(request.getParameter("submit")!=null){
        Connection c = null;
        String rut = request.getParameter("cliente");
        tablar = "<table><tr><th>Producto</th><th>Cantidad</th><th>Fecha y Hora</th></tr>";
        String id_venta = null;
        String id_producto = null;
        String fecha = null;
        int i = 0;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
            ResultSet r = c.createStatement().executeQuery("SELECT * FROM \"venta\" WHERE \"id_cliente\"='"+rut+"'");
            while(r.next()){
                id_venta=r.getString("id_venta");
                fecha=r.getString("fecha");
                ResultSet r2 = c.createStatement().executeQuery("SELECT * FROM \"detalle_venta\" WHERE \"id_venta\"='"+id_venta+"'");
                while(r2.next()){
                    id_producto = r2.getString("id_producto");
                    i = r2.getInt("cantidad");
                    ResultSet r3 = c.createStatement().executeQuery("SELECT * FROM \"producto\" WHERE \"id_producto\"='"+id_producto+"'");
                    if(r3.next()){
                        tablar = tablar + "<tr><td>"+r3.getString("nombre")+"</td><td>"+Integer.toString(i)+"<td>"+fecha+"</td></tr>";
                    }
                }
            }
            tablar = tablar+"</table>";
        }catch(Exception e){
            msg_error = "<p>Exception: "+e.getMessage()+"</p>";
        }finally{
            if(c != null){
                c.close();
            }
        }
    }   
%>
<%
    // Comprobar inicio de sesion
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false))){
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Ver Ventas a Cliente</title>
    </head>
    <body>
        <h1>Seleccionar Cliente</h1>
        <form method="post">
            Cliente:<select name="cliente">
                <%= lista_cliente%>
            </select>
            <input type="submit" name="submit" value="Ver Ventas"><br>
        </form>
        <%=tablar%>
        <%=volver%>
    </body>
</html>
