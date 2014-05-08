<%-- 
    Document   : compra
    Created on : 19-04-2014, 05:12:51 PM
    Author     : Andres
--%>

<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*"%>
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
    volver = volver + tipo + ": " + nombre+"<br><a href";
    
    if(tipo.equals("Administrador")){
        volver = volver + "=\"admin.jsp\">Volver</a>";
    }else{
        volver = volver + "=\"vendedor.jsp\">Volver</a>";
    }
%>
<%
    String msg_error = "<p>&nbsp;</p>";
    String resultado = "<p>&nbsp;</p>";
    String resultado2 = "<p>&nbsp;</p>";
    if(request.getParameter("submit")!=null){
        Connection c = null;
        int id_compratemp=1;
        int id_detalletemp=1;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
            ResultSet r = c.createStatement().executeQuery("SELECT * FROM \"compra\"");
            while( r.next() ){
                id_compratemp++;  
            }
            ResultSet r2 = c.createStatement().executeQuery("SELECT * FROM \"detalle_compra\"");
            while( r2.next() ){
                id_detalletemp++;  
            }
	}catch(Exception e){
            msg_error = "<p>Exception: "+e.getMessage()+"</p>";
	}finally{
            if( c != null ){
                c.close();
            }
	}
        String id_compra = Integer.toString(id_compratemp);
        String id_detalle = Integer.toString(id_detalletemp);
        int monto_total = 0;
        int i = 1;
        
        while(request.getParameter("prod"+i)!=null){
            String v2 = request.getParameter("cant"+i);
            String v3 = request.getParameter("prec"+i);
            int temp1 = Integer.parseInt(v3);
            int temp2 = Integer.parseInt(v3);
            monto_total = monto_total+(temp1*temp2);
            i++;
        }
        i = 1;
        Connection c3 = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c3 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
            String insert = "INSERT INTO \"compra\" VALUES ('"+id_compra+"','"+monto_total+"',SYSDATE,CURRENT_TIMESTAMP)";
            c3.createStatement().execute(insert);
	}catch(Exception e){
            msg_error = "<p>Exception: "+e.getMessage()+"</p>";
	}finally{
            if( c3 != null ){
                c3.close();
            }
	}
        
        while(request.getParameter("prod"+i)!=null){
            String v1 = request.getParameter("prod"+i);
            String v2 = request.getParameter("cant"+i);
            String v3 = request.getParameter("prec"+i);
            i++;
            
            Connection c2 = null;
            try{
                Class.forName("oracle.jdbc.OracleDriver");
                c2 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
                String insert = "INSERT INTO \"detalle_compra\" VALUES ('"+id_detalle+"','"+id_compra+"','"+v1+"','"+v2+"','"+v3+"')";
                c2.createStatement().execute(insert);
                id_detalletemp++;
                id_detalle = Integer.toString(id_detalletemp);
            }catch(Exception e){
                msg_error = "<p>Exception: "+e.getMessage()+"</p>";
            }finally{
                if( c2 != null ){
                    c2.close();
                }
            }
        }
        Connection c4 = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c4 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
            ResultSet r = c4.createStatement().executeQuery("SELECT * FROM \"compra\" WHERE \"id_compra\"='"+id_compra+"'");
            if( r.next() ){
                resultado = resultado+"<table><tr><th>Monto Total</th><th>Fecha y Hora</th></tr>";
                resultado = resultado+"<tr><td>"+r.getString("monto_total")+"</td><td>"+r.getString("hora")+"</td></tr></table>";           
            }
            ResultSet r2 = c4.createStatement().executeQuery("SELECT * FROM \"detalle_compra\" WHERE \"id_compra\"='"+id_compra+"'");    
            resultado2 = resultado2+"<table><tr><th>Producto</th><th>Precio</th></tr>";
            while(r2.next()){
                ResultSet r3 = c4.createStatement().executeQuery("SELECT * FROM \"producto\" WHERE \"id_producto\"='"+r2.getString("id_producto")+"'");
                if(r3.next()){
                    resultado2 = resultado2+"<tr><td>"+r3.getString("nombre")+"</td><td>"+r2.getString("precio")+"</td></tr>";
                } 
            }
            resultado2 = resultado2+"</tr></table>";
	}catch(Exception e){
            msg_error = "<p>Exception: "+e.getMessage()+"</p>";
	}finally{
            if( c4 != null ){
                c4.close();
            }
	}
    }    
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <script id="js1" type="text/JavaScript">
            function agregar(){
                var tabla = document.getElementById('prodtable');
                var ultcol = tabla.rows.length;
                var iteracion = ultcol;
                var col = tabla.insertRow(ultcol);

                var celda0 = col.insertCell(0);
                var prod = document.createElement('input');
                prod.type = 'text';
                prod.name = 'prod' + iteracion;
                prod.id = 'prod' + iteracion;
                celda0.appendChild(prod);
                
                var celda1 = col.insertCell(1);
                var cant = document.createElement('input');
                cant.type = 'text';
                cant.name = 'cant' + iteracion;
                cant.id = 'cant' + iteracion;
                celda1.appendChild(cant);
                
                var celda2 = col.insertCell(2);
                var prec = document.createElement('input');
                prec.type = 'text';
                prec.name = 'prec' + iteracion;
                prec.id = 'prec' + iteracion;
                celda2.appendChild(prec);
            } 
            function remover(){
                var tabla = document.getElementById('prodtable');
                var ultcol = tabla.rows.length;
                if (ultcol > 2) tabla.deleteRow(ultcol - 1);
            }
        </script>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Ingresar Compra</title>
    </head>
    <body>
        <h1>Ingresar Compra</h1>
        <form method="post">
            <input type="button" value="Agregar" onclick="agregar();" />
            <input type="button" value="Remover Fila" onclick="remover();"> 
            <input type="submit" name="submit" value="Ingresar">
            <table id="prodtable">   
                <tr>
                    <th>Codigo Producto</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                </tr>
                <tr>
                    <td><input type = "text" name = "prod1"></td>
                    <td><input type = "text" name = "cant1"></td>
                    <td><input type = "text" name = "prec1"></td>
                </tr>
            </table>
            <input type="reset" value="Reestablecer">
        </form>
        <%= resultado%>
        <%= resultado2%>
        <%= volver %>
    </body>
</html>