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
    Object id_usuario = session.getAttribute("identidad");
    String tablar = "<p>&nbsp;</p>"; 
    Connection lc = null;
    String id_venta = null;
    String fecha = null;
    String id_producto = null;
    int i = 0;
    try{
        Class.forName("oracle.jdbc.OracleDriver");
        lc = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
        ResultSet r = lc.createStatement().executeQuery("SELECT * FROM \"venta\" WHERE \"id_usuario\"='"+id_usuario+"'");
        while(r.next()){
            id_venta = r.getString("id_venta");
            fecha = r.getString("fecha");
            ResultSet r2 = lc.createStatement().executeQuery("SELECT * FROM \"detalle_venta\" WHERE \"id_venta\"='"+id_venta+"'");            
            while(r2.next()){
                id_producto = r2.getString("id_producto");
                i = r2.getInt("cantidad");
                ResultSet r3 = lc.createStatement().executeQuery("SELECT * FROM \"producto\" WHERE \"id_producto\"='"+id_producto+"'");
                if(r3.next()){
                    tablar = tablar + "<tr><td>"+r3.getString("nombre")+"</td><td>"+Integer.toString(i)+"<td>"+fecha+"</td></tr>";
                }
            }
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
        <title>Pepe's Works: Mis Ventas</title>
    </head>
    <body>
        <h1>Mis Ventas</h1>
        <table>
            <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Fecha</th>                
            </tr>
            <%=tablar%>
        </table>
        <%=volver%>
    </body>
</html>
