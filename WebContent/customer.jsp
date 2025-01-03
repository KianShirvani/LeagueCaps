<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Account Page</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="styles.css">
    <link rel="shortcut icon" type="image/x-icon" href="img/logo.png" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .navbar {
            background-color: midnightblue;
        }
        .navbar-brand {
            font-family: 'Playfair Display', serif;
            text-transform: uppercase;
            font-size: 2em;
            color: whitesmoke;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }
        .card-header {
            background-color: midnightblue;
        }
        .card-header h1 {
            color: whitesmoke;
        }
        .table th {
            background-color: midnightblue;
            color: whitesmoke;
        }
        .table td {
            font-family: 'Arial', sans-serif;
        }
        .table td:nth-child(2) {
            background-color: gold;
        }
    </style>
</head>
<body>

<!-- Navbar Section -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <!-- Logo and Brand Name -->
    <a class="navbar-brand ml-4" href="index.jsp">
        <img src="img/logo.png" alt="SQL Cap Shop" height="100" class="mr-2"> <!-- Replace with your logo -->
        LeagueCaps
    </a>

    <!-- Shop Dropdown Button -->
    <div class="dropdown mx-3 ml-2">
        <button class="btn btn-warning btn-lg dropdown-toggle" type="button" id="shopDropdown"
            data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Shop
        </button>
        <div class="dropdown-menu" aria-labelledby="shopDropdown">
            <a class="dropdown-item" href="listprod.jsp?category=MLB Caps">MLB</a>
            <a class="dropdown-item" href="listprod.jsp?category=NFL Caps">NFL</a>
            <a class="dropdown-item" href="listprod.jsp?category=NBA Caps">NBA</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="listprod.jsp">Shop All</a>
        </div>
    </div>

    <!-- Navbar Links -->
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto align-items-center w-100">
            <!-- Search Bar -->
            <li class="nav-item flex-grow-1">
                <form class="form-inline my-2 my-lg-1 w-100">
                    <input class="form-control mr-3 w-75" type="search"
                        placeholder="Search for Your Favourite Team!" aria-label="Search"
                        style="flex-grow: 1; height: 45px;">
                    <button class="btn btn-outline-light my-2 my-sm-0 mr-4" type="submit">Search</button>
                </form>
            </li>

            <!-- Dynamic User Greeting or Sign In -->
            <li class="nav-item">
                <%
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <a href="logout.jsp" class="btn btn-primary btn-lg mx-2">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-primary btn-lg mx-2">Sign In</a>
                <% } %>
            </li>

            <!-- Create Account Button -->
            <%
                if (authenticatedUser == null) { // Only display if user is not logged in
            %>
                <li class="nav-item">
                    <a href="createAccount.jsp" class="btn btn-success btn-lg mx-2">Create Account</a>
                </li>
            <% } %>

            <!-- Cart Button -->
            <li class="nav-item">
                <a href="showcart.jsp">
                    <img src="img/cart-icon.jpg" alt="Cart" style="height: 40px; width: 40px;" class="mx-2"> <!-- Replace with your cart image -->
                </a>
            </li>
        </ul>
    </div>
</nav>

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

        String errorMessage = "";
    %>
    <div class="card">
        <div class="card-header text-center">
            <h1>User Account Page</h1>         
        </div>
        <div class="card-body">
        <!-- Add the button to view orders -->
            <div class="text-center my-4">
                <div class="mb-3">
                    <a href="admin.jsp" class="btn btn-primary btn-lg w-100">Administrator Portal </a>
                </div>
                <div>
                    <a href="listorder.jsp" class="btn btn-primary btn-lg w-100">View Your Orders</a>
                </div>
            </div>
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
            <form method="post" action="customer.jsp">
                <table class="table table-striped table-bordered">
                    <tbody>
                        <tr><th scope="row">ID</th><td><%= rs.getInt("customerId") %></td></tr>
                        <tr><th scope="row">First Name</th><td><input type="text" name="firstName" class="form-control" value="<%= rs.getString("firstName") %>"></td></tr>
                        <tr><th scope="row">Last Name</th><td><input type="text" name="lastName" class="form-control" value="<%= rs.getString("lastName") %>"></td></tr>
                        <tr><th scope="row">Email</th><td><input type="email" name="email" class="form-control" value="<%= rs.getString("email") %>"></td></tr>
                        <tr><th scope="row">Phone Number</th><td><input type="text" name="phone" class="form-control" value="<%= rs.getString("phonenum") %>"></td></tr>
                        <tr><th scope="row">Address</th><td><input type="text" name="address" class="form-control" value="<%= rs.getString("address") %>"></td></tr>
                        <tr><th scope="row">City</th><td><input type="text" name="city" class="form-control" value="<%= rs.getString("city") %>"></td></tr>
                        <tr><th scope="row">State</th><td><input type="text" name="state" class="form-control" value="<%= rs.getString("state") %>"></td></tr>
                        <tr><th scope="row">Postal Code</th><td><input type="text" name="postalCode" class="form-control" value="<%= rs.getString("postalCode") %>"></td></tr>
                        <tr><th scope="row">Country</th><td><input type="text" name="country" class="form-control" value="<%= rs.getString("country") %>"></td></tr>
                        <tr><th scope="row">Password</th><td><input type="password" name="newPassword" class="form-control" placeholder="New Password"></td></tr>
                        <tr><th scope="row">User ID</th><td><%= rs.getString("userid") %></td></tr>
                    </tbody>
                </table>
                <div class="form-group text-center">
                    <button type="submit" class="btn btn-primary btn-lg w-100">Update Information</button>
                </div>
            </form>
            <div class="text-center text-success"><%= errorMessage %></div>
            <%
                    }

                    // Update customer details
                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String firstName = request.getParameter("firstName");
                        String lastName = request.getParameter("lastName");
                        String email = request.getParameter("email");
                        String phone = request.getParameter("phone");
                        String address = request.getParameter("address");
                        String city = request.getParameter("city");
                        String state = request.getParameter("state");
                        String postalCode = request.getParameter("postalCode");
                        String country = request.getParameter("country");
                        String newPassword = request.getParameter("newPassword");

                        String updateCustomerSQL = "UPDATE Customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userid = ?";
                        PreparedStatement updateCustomerStmt = conn.prepareStatement(updateCustomerSQL);
                        updateCustomerStmt.setString(1, firstName);
                        updateCustomerStmt.setString(2, lastName);
                        updateCustomerStmt.setString(3, email);
                        updateCustomerStmt.setString(4, phone);
                        updateCustomerStmt.setString(5, address);
                        updateCustomerStmt.setString(6, city);
                        updateCustomerStmt.setString(7, state);
                        updateCustomerStmt.setString(8, postalCode);
                        updateCustomerStmt.setString(9, country);
                        updateCustomerStmt.setString(10, authenticatedUser);
                        updateCustomerStmt.executeUpdate();

                        if (newPassword != null && !newPassword.isEmpty()) {
                            String updatePasswordSQL = "UPDATE customer SET password = ? WHERE userid = ?";
                            PreparedStatement updatePasswordStmt = conn.prepareStatement(updatePasswordSQL);
                            updatePasswordStmt.setString(1, newPassword);
                            updatePasswordStmt.setString(2, authenticatedUser);
                            updatePasswordStmt.executeUpdate();
                            out.println("<div class='alert alert-success'>Password changed successfully</div>");
                        }
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='alert alert-danger'>Error processing request</div>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (fetchCustomerStmt != null) try { fetchCustomerStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </div>
    </div>
</div>

<!-- Footer Section -->
<footer class="footer text-light mt-5 py-4" style="background-color: midnightblue;">
    <div class="container">
        <div class="row">
            <!-- About Section -->
            <div class="col-md-3">
                <h5>About</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-light">About Us</a></li>
                    <li><a href="#" class="text-light">Career Opportunities</a></li>
                    <li><a href="#" class="text-light">Affiliates</a></li>
                </ul>
            </div>

            <!-- Shop Section -->
            <div class="col-md-3">
                <h5>Shop</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-light">Email Gift Cards</a></li>
                    <li><a href="#" class="text-light">Gift Card Balance</a></li>
                    <li><a href="#" class="text-light">Coupons</a></li>
                    <li><a href="#" class="text-light">Mobile App</a></li>
                    <li><a href="#" class="text-light">Student Discount</a></li>
                </ul>
            </div>

            <!-- Support Section -->
            <div class="col-md-3">
                <h5>Support</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-light">Contact Us</a></li>
                    <li><a href="#" class="text-light">Return Policy</a></li>
                    <li><a href="#" class="text-light">Sizing Help</a></li>
                    <li><a href="#" class="text-light">Store Locator</a></li>
                </ul>
            </div>

            <!-- Legal Section -->
            <div class="col-md-3">
                <h5>Legal</h5>
                <ul class="list-unstyled">
                    <li><a href="#" class="text-light">Terms of Use</a></li>
                    <li><a href="#" class="text-light">Privacy Statement</a></li>
                    <li><a href="#" class="text-light">Accessibility</a></li>
                    <li><a href="#" class="text-light">Ad Choices</a></li>
                    <li><a href="#" class="text-light">Your Privacy Choices</a></li>
                    <li><a href="#" class="text-light">Modern Slavery Act Policy</a></li>
                </ul>
            </div>
        </div>

        <hr class="bg-light">
        <div class="text-center">
            <p>&copy; 2024 LeagueCaps. All Rights Reserved.</p>
        </div>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
