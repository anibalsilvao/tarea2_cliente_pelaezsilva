<%
	session.removeAttribute("login");
	session.removeAttribute("tipo");
	session.invalidate();
	response.sendRedirect("index.jsp");
%>
