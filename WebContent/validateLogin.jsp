<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		
        Connection connection = null;

        try {
            connection = DriverManager.getConnection(
                "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True",
                "sa",
                "304#sa#pw"
            );

            // Check if userId and password match some customer account. If so, set retStr to be the username.
            String sql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        retStr = username; // Set retStr to username if match found
                    }
                }
            }
        } catch (SQLException ex) {
            out.println(ex);
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    out.println(e);
                }
            }
        }

        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Could not connect to the system using that username/password.");
        }

        return retStr;
    }
%>