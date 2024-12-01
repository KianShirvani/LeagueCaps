<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Caps Store - Product Information</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet" href="styles.css"> 
</head>
<body>

    
<!-- Navbar Section -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: midnightblue;">
    <!-- Logo and Brand Name -->
    <a class="navbar-brand ml-4" href="index.jsp" style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-size: 2em; color: whitesmoke; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);">
        <img src="img/logo.png" alt="SQL Cap Shop" height="100" class="mr-2"> <!-- Replace with your logo -->
        LeagueCaps
    </a>

    <!-- Shop Dropdown Button -->
    <div class="dropdown mx-3 ml-2">
        <button class="btn btn-warning btn-lg dropdown-toggle" type="button" id="shopDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
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

    <!-- Navbar Toggler for Mobile View -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Navbar Links -->
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto align-items-center w-100">
            <!-- Search Bar -->
            <li class="nav-item flex-grow-1">
                <form class="form-inline my-2 my-lg-1 w-100">
                    <input class="form-control mr-3 w-75" type="search" placeholder="Search for Your Favourite Team!" aria-label="Search" style="flex-grow: 1; height: 45px;">
                    <button class="btn btn-outline-light my-2 my-sm-0 mr-4" type="submit">Search</button>
                </form>
            </li>

            <!-- Dynamic User Greeting or Sign In -->
            <li class="nav-item">
                <%
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <a href="logout.jsp" class="btn btn-primary btn-lg mx-2">Welcome: <%= authenticatedUser %></a>
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

<%
    // Get product name to search for
    String productName = request.getParameter("productName");
    String productId = request.getParameter("id");

    // SQL query to retrieve and display all the info for the product
    String sql = "SELECT p.productId, p.productName, p.productDesc, p.productPrice, p.productImageURL, p.productImage " +
                 "FROM product p WHERE p.productId = ?";

    //make connection
    try (Connection con = DriverManager.getConnection("jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True", "sa", "304#sa#pw");
         PreparedStatement pstmt = con.prepareStatement(sql)) {

        pstmt.setString(1, productId);
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                String name = rs.getString("productName");
                String desc = rs.getString("productDesc");
                double price = rs.getDouble("productPrice");
                String imageUrl = rs.getString("productImageURL");

                out.println("<div class='container mt-5'>");
                out.println("<div class='card'>");

                // Card Header for product name
                out.println("<div class='card-header bg-primary text-white'>");
                out.println("<h2>" + name + "</h2>");
                out.println("</div>");

                
                // If there is a productImageURL, display using IMG tag
                out.println("<div class='card-body'>");
                if (imageUrl != null && !imageUrl.trim().isEmpty()) { //if Url exists in DB
                    out.println("<img src='" + imageUrl + "' alt='" + name + "' class='img-fluid mb-3'>");
                }

                // Product ID and Price
                out.println("<p><strong>ID:</strong> " + productId + "</p>");
                out.println("<p><strong>Price:</strong> $" + price + "</p>");

                // Links to Add to Cart and Continue Shopping
                out.println("<a href='addcart.jsp?id=" + productId + "&name=" + name + "&price=" + price + "' class='btn btn-success me-2'>Add to Cart</a>");
                out.println("<a href='listprod.jsp' class='btn btn-secondary'>Continue Shopping</a>");

                out.println("</div>"); // Close card body
                out.println("</div>"); // Close card
                out.println("</div>"); // Close container
            } else {//Invalid Product ID
                out.println("<div class='alert alert-warning'>Product not found. Please go back and try again.</div>");
            }
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>Error retrieving product details: " + e.getMessage() + "</div>");
    }
%>

</body>
</html>
