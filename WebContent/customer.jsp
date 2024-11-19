<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
%>
    <div class="alert alert-danger" role="alert">
        You must be logged in to access this page. <a href="login.jsp" class="alert-link">Login here</a>.
    </div>
<%
        return;
    }
%>
    <h1 class="text-center mb-4">Customer Profile</h1>
<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    Connection conn = null;
    PreparedStatement fetchCustomerStmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(url, uid, pw);
        conn.setAutoCommit(false);

        String fetchCustomerSQL = "SELECT * FROM Customer WHERE userid = ?";
        fetchCustomerStmt = conn.prepareStatement(fetchCustomerSQL);
        fetchCustomerStmt.setString(1, userName);
        rs = fetchCustomerStmt.executeQuery();

        if (rs.next()) {
%>
    <table class="table table-striped table-bordered">
        <tbody>
            <tr><th scope="row">ID</th><td><%= rs.getInt("customerId") %></td></tr>
            <tr><th scope="row">First Name</th><td><%= rs.getString("firstName") %></td></tr>
            <tr><th scope="row">Last Name</th><td><%= rs.getString("lastName") %></td></tr>
            <tr><th scope="row">Email</th><td><%= rs.getString("email") %></td></tr>
            <tr><th scope="row">Phone</th><td><%= rs.getString("phonenum") %></td></tr>
            <tr><th scope="row">Address</th><td><%= rs.getString("address") %></td></tr>
            <tr><th scope="row">City</th><td><%= rs.getString("city") %></td></tr>
            <tr><th scope="row">State</th><td><%= rs.getString("state") %></td></tr>
            <tr><th scope="row">Postal Code</th><td><%= rs.getString("postalCode") %></td></tr>
            <tr><th scope="row">Country</th><td><%= rs.getString("country") %></td></tr>
            <tr><th scope="row">User ID</th><td><%= rs.getString("userid") %></td></tr>
        </tbody>
    </table>
<%
        } else {
%>
    <div class="alert alert-warning" role="alert">
        No customer data found for user: <%= userName %>.
    </div>
<%
        }

        conn.commit();
    } catch (Exception e) {
        if (conn != null) {
            conn.rollback();
        }
%>
    <div class="alert alert-danger" role="alert">
        Error: <%= e.getMessage() %>
    </div>
<%
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (fetchCustomerStmt != null) fetchCustomerStmt.close();
        if (conn != null) conn.close();
    }
%>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
