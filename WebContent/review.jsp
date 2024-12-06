<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Write a Review</title>
    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

<% 
    // Check if the user is logged in
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    if (authenticatedUser == null) {
%>
    <div class="container mt-5">
        <div class="alert alert-danger text-center">
            You must be logged in to write a review. <a href="login.jsp">Login here</a>.
        </div>
    </div>
<%
        return;
    }
%>

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
                    if (authenticatedUser != null) {
                %>
                    <a href="logout.jsp" class="btn btn-primary btn-lg mx-2">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-primary btn-lg mx-2">Sign In</a>
                <% } %>
            </li>

            <!-- Create Account Button -->
            <% if (authenticatedUser == null) { // Only display if user is not logged in %>
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
        // Get productId from the request parameter
        String productId = request.getParameter("id");
        if (productId == null || productId.isEmpty()) {
    %>
        <div class="alert alert-danger text-center">
            No product specified. Please go back and select a product to review.
        </div>
    <%
            return;
        }

        // Database connection parameters
        String dbUrl = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
        NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.US);

        try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            // Check if the user has purchased the product
            String customerId = (String) session.getAttribute("customerId");
            String purchaseCheckSQL = "SELECT COUNT(*) FROM ordersummary o " +
                                      "JOIN orderproduct op ON o.orderId = op.orderId " +
                                      "WHERE o.customerId = ? AND op.productId = ?";
            try (PreparedStatement ps = con.prepareStatement(purchaseCheckSQL)) {
                ps.setString(1, customerId);
                ps.setString(2, productId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                int purchaseCount = rs.getInt(1);
                if (purchaseCount == 0) {
    %>
        <div class="alert alert-danger text-center">
            Only customers who have purchased this product may leave reviews on it.
        </div>
    <%
                    return;
                }
            }

            // Check if the user has already reviewed this product
            String reviewCheckSQL = "SELECT COUNT(*) FROM review " +
                                    "WHERE customerId = ? AND productId = ?";
            try (PreparedStatement ps = con.prepareStatement(reviewCheckSQL)) {
                ps.setString(1, customerId);
                ps.setString(2, productId);
                ResultSet rs = ps.executeQuery();
                rs.next();
                int reviewCount = rs.getInt(1);
                if (reviewCount > 0) {
    %>
        <div class="alert alert-danger text-center">
            You can only review a specific item once.
        </div>
    <%
                    return;
                }
            }

            // Retrieve product details
            String productSQL = "SELECT productName, productPrice, productDesc " +
                                "FROM product WHERE productId = ?";
            String productName = "";
            double productPrice = 0.0;
            String productDescription = "";
            try (PreparedStatement ps = con.prepareStatement(productSQL)) {
                ps.setString(1, productId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    productName = rs.getString("productName");
                    productPrice = rs.getDouble("productPrice");
                    productDescription = rs.getString("productDesc");
                } else {
    %>
        <div class="alert alert-danger text-center">
            Product not found.
        </div>
    <%
                    return;
                }
            }

            // Handle review submission
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                int reviewRating = Integer.parseInt(request.getParameter("reviewRating"));
                String reviewComment = request.getParameter("reviewComment");
                String reviewDate = new java.sql.Timestamp(System.currentTimeMillis()).toString();

                String insertReviewSQL = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) " +
                                         "VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(insertReviewSQL)) {
                    ps.setInt(1, reviewRating);
                    ps.setString(2, reviewDate);
                    ps.setString(3, customerId);
                    ps.setString(4, productId);
                    ps.setString(5, reviewComment);

                    int rowsAffected = ps.executeUpdate();
                    if (rowsAffected > 0) {
    %>
        <div class="alert alert-success text-center">
            Your review has been submitted successfully!
        </div>
    <%
                    } else {
    %>
        <div class="alert alert-danger text-center">
            Failed to submit your review. Please try again.
        </div>
    <%
                    }
                } catch (SQLException e) {
    %>
        <div class="alert alert-danger text-center">
            An error occurred while submitting your review: <%= e.getMessage() %>
        </div>
    <%
                }
            }
    %>

    <h2 class="text-center">Write a review about '<%= productName %>'</h2>

    <!-- Display product details without buttons -->
    <div class="card mb-4">
        <div class="row no-gutters">
            <div class="col-md-4">
                <img src="img/<%= productId %>.jpg" class="card-img" alt="<%= productName %>">
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h5 class="card-title"><%= productName %></h5>
                    <p class="card-text"><strong>Price:</strong> <%= currency.format(productPrice) %></p>
                    <p class="card-text"><strong>Description:</strong> <%= productDescription %></p>
                    <!-- Add any other details as needed -->
                </div>
            </div>
        </div>
    </div>

    <!-- Review Form -->
    <form method="post" action="review.jsp?id=<%= productId %>">
        <div class="form-group">
            <label for="reviewRating">Rating (out of 5):</label>
            <input type="number" class="form-control" id="reviewRating" name="reviewRating"
                   min="1" max="5" required>
        </div>
        <div class="form-group">
            <label for="reviewComment">Comment (up to 1000 characters):</label>
            <textarea class="form-control" id="reviewComment" name="reviewComment"
                      maxlength="1000" rows="5" required></textarea>
        </div>
        <!-- Hidden fields to pass productId -->
        <input type="hidden" name="productId" value="<%= productId %>">
        <button type="submit" class="btn btn-primary">Submit Review</button>
    </form>

    <% 
        } catch (SQLException e) {
    %>
        <div class="alert alert-danger text-center">
            An error occurred: <%= e.getMessage() %>
        </div>
    <%
        }
    %>
</div>

<!-- Footer Section -->
<footer class="footer text-light mt-5 py-4" style="background-color: midnightblue;">
    <!-- Include your footer content from addcart.jsp -->
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

<!-- Include Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>