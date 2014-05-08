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
    if( (request.getSession(false)==null) || (session.getAttribute("login")==null) || (session.getAttribute("login").equals(false))){
        response.sendRedirect("index.jsp");
    }
%>
<%
    String msg_error = "<p>&nbsp;</p>";
    String lista_cliente = "<p>&nbsp;</p>";
    String resultado = "<p>&nbsp;</p>";
    String resultado2 = "<p>&nbsp;</p>";
    String resultado3 = "<p>&nbsp;</p>";
    
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
    Object id_usuario = session.getAttribute("identidad");
    
    if(request.getParameter("submit")!=null){
        Connection c = null;
        int id_ventatemp=1;
        int id_detalletemp=1;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
            ResultSet r = c.createStatement().executeQuery("SELECT * FROM \"venta\"");
            while( r.next() ){
                id_ventatemp++;  
            }
            ResultSet r2 = c.createStatement().executeQuery("SELECT * FROM \"detalle_venta\"");
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
        String id_venta = Integer.toString(id_ventatemp);
        String id_detalle = Integer.toString(id_detalletemp);
        
        int monto_total = 0;
        int i = 1;
        
        while(request.getParameter("prod"+i)!=null){
            String v1 = request.getParameter("prod"+i);
            String v2 = request.getParameter("cant"+i);
            String v3 = null;
            Connection cc = null;
            
            try{              
                Class.forName("oracle.jdbc.OracleDriver");
                cc = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
                ResultSet r2 = cc.createStatement().executeQuery("SELECT * FROM \"producto\" WHERE \"id_producto\"='"+v1+"'");       
                if(r2.next()){
                    v3 = r2.getString("precio");         
                }
            }catch(Exception e){
                msg_error = "<p>Exception: "+e.getMessage()+"</p>";
            }finally{
                if( cc != null ){
                    cc.close();
                }
            }
            int temp1 = Integer.parseInt(v3); // Precio
            int temp2 = Integer.parseInt(v2); // Cantidad
            monto_total = monto_total+(temp2*temp1);
            i++;
        }
        i = 1;
        String id_cliente=request.getParameter("cliente");
        Connection c3 = null;
        try{
            Class.forName("oracle.jdbc.OracleDriver");
            c3 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
            String insert = "INSERT INTO \"venta\" VALUES ('"+id_venta+"','"+id_cliente+"','"+id_usuario+"','"+monto_total+"',SYSDATE,CURRENT_TIMESTAMP)";
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
            i++;
            Connection c2 = null;
            try{
                Class.forName("oracle.jdbc.OracleDriver");
                c2 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
                String insert = "INSERT INTO \"detalle_venta\" VALUES ('"+id_detalle+"','"+id_venta+"','"+v1+"','"+v2+"')";
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
            resultado = resultado+"<table><tr><th>Rut Vendedor</th><th>Nombre Vendedor</th><th>Rut Cliente</th><th>Nombre Cliente</th></tr>";
            ResultSet r2 = c4.createStatement().executeQuery("SELECT * FROM \"usuario\" WHERE \"rut\"='"+id_usuario+"'");
            if(r2.next()){
                resultado = resultado+"<tr><td>"+id_usuario+"</td><td>"+r2.getString("nombre")+"</td>";                
            }
            ResultSet r3 = c4.createStatement().executeQuery("SELECT * FROM \"cliente\" WHERE \"rut\"='"+id_cliente+"'");
            if(r3.next()){
                resultado = resultado+"<td>"+id_cliente+"</td><td>"+r3.getString("nombre")+"</td></tr></table>";                
            }
            ResultSet r = c4.createStatement().executeQuery("SELECT * FROM \"venta\" WHERE \"id_venta\"='"+id_venta+"'");
            if( r.next() ){
                resultado2 = resultado2+"<table><tr><th>Monto Total</th><th>Fecha y Hora</th></tr>";
                resultado2 = resultado2+"<tr><td>"+r.getString("monto_total")+"</td><td>"+r.getString("hora")+"</td></tr></table>";           
            }
            ResultSet r4 = c4.createStatement().executeQuery("SELECT * FROM \"detalle_venta\" WHERE \"id_venta\"='"+id_venta+"'");    
            resultado3 = resultado3+"<table><tr><th>Producto</th><th>Precio</th></tr>";
            while(r4.next()){
                ResultSet r5 = c4.createStatement().executeQuery("SELECT * FROM \"producto\" WHERE \"id_producto\"='"+r4.getString("id_producto")+"'");
                if(r5.next()){
                    resultado3 = resultado3+"<tr><td>"+r5.getString("nombre")+"</td><td>"+r5.getString("precio")+"</td></tr>";
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
        <script id="js1" type="text/JavaScript">
            function agregar(){
                var tabla = document.getElementById('ventatable');
                var ultcol = tabla.rows.length;
                var iteracion = ultcol;
                var col = tabla.insertRow(ultcol);
                
                var celda1 = col.insertCell(0);
                var prod = document.createElement('input');
                prod.type = 'text';
                prod.name = 'prod' + iteracion;
                prod.id = 'prod' + iteracion;
                celda1.appendChild(prod);
                
                var celda2 = col.insertCell(1);
                var cant = document.createElement('input');
                cant.type = 'text';
                cant.name = 'cant' + iteracion;
                cant.id = 'cant' + iteracion;
                celda2.appendChild(cant);
            } 
            function remover(){
                var tabla = document.getElementById('ventatable');
                var ultcol = tabla.rows.length;
                if (ultcol > 2) tabla.deleteRow(ultcol - 1);
            }
        </script>
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works: Ingresar Venta</title>
    </head>
    <body>
        <h1>Ingresar Venta</h1>
        <form method="post">
            <input type="button" value="Agregar" onclick="agregar();" />
            <input type="button" value="Remover Fila" onclick="remover();"> 
            <input type="submit" name="submit" value="Ingresar"><br>
            Cliente:<select name="cliente">
                <%= lista_cliente%>
            </select>
            <table id="ventatable">   
                <tr>
                    <th>ID Producto</th>
                    <th>Cantidad</th>
                </tr>
                <tr>
                    <td><input type = "text" name = "prod1"></td>
                    <td><input type = "text" name = "cant1"></td>
                </tr>
            </table>
            <input type="reset" value="Reestablecer">
        </form>
        <%=resultado%>
        <%=resultado2%>
        <%=resultado3%>
        <%=volver%>    
    </body>
</html>