<%-- 
    Document   : index
    Created on : 19-04-2014, 03:13:30 PM
    Author     : Andres
--%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>
<%
    String msg_error = "<p>&nbsp;</p>";
    if( request.getParameter("submit") != null ){
		String u = request.getParameter("user");
		String p = request.getParameter("pass");
		Connection c = null;
                
		try{
                   
			// Conectar a la BD
			Class.forName("oracle.jdbc.OracleDriver");
			c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE","SYSTEM","admin");
                        
			ResultSet r = c.createStatement().executeQuery("SELECT * FROM \"usuario\" WHERE \"rut\"='"+u+"' AND \"contrasena\"='"+p+"'");
                        if( r.next() ){
				session.setAttribute("login",true);
				session.setAttribute("login",r.getString("tipo"));
                                String tipo = r.getString("tipo");
                                session.setAttribute("identidad",true);
				session.setAttribute("identidad",r.getString("rut"));
                                session.setAttribute("nombre",true);
				session.setAttribute("nombre",r.getString("nombre"));
                                if(tipo.equals("Administrador")){
                                    response.sendRedirect("admin.jsp");
                                }else{
                                    response.sendRedirect("vendedor.jsp");
                                }
			}
			msg_error = "<p>ERROR!<br>Combinaci&oacute;n clave/usuario incorrecta!</p>";
		}catch(Exception e){
			msg_error = "<p>Exception: "+e.getMessage()+"</p>";
		}
		finally{
			if( c != null ){
				c.close();
			}
		}
    }    
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="shortcut icon" href="favicon.ico">
        <link rel="stylesheet" href="css/index.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pepe's Works</title>     
    </head>
    <body>
        <h1>Bienvenido a la PYME de Pepe</h1>
        <p>A continuación inicia sesión:</p>
        <form method="get">
            Usuario: <input type = "text" name = "user"><br>
            Contraseña: <input type = "password" name = "pass"><br>
            <input type="submit" name="submit" value="Log In">
            <%= msg_error %>
        </form>
    </body>
</html>
