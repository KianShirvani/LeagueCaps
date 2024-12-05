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
    <title>Create Account</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
                    <form class="form-inline my-2 my-lg-1 w-100" action="listprod.jsp" method="get">
                        <input class="form-control mr-3 w-75" type="search" name="productName" placeholder="Search for Your Favourite Team!" aria-label="Search" style="flex-grow: 1; height: 45px;">
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

    <div class="container my-4">
        <h1 class="text-center">Create Account</h1>
        <%
            String errorMessage = "";
            boolean hasError = false;

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String userId = request.getParameter("userId");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");

                // Validate input
                if (userId == null || userId.isEmpty()) {
                    errorMessage += "User ID is required.<br/>";
                    hasError = true;
                }
                if (password == null || password.isEmpty()) {
                    errorMessage += "Password is required.<br/>";
                    hasError = true;
                }
                if (confirmPassword == null || confirmPassword.isEmpty() || !confirmPassword.equals(password)) {
                    errorMessage += "Passwords do not match.<br/>";
                    hasError = true;
                }
                if (firstName == null || firstName.isEmpty()) {
                    errorMessage += "First Name is required.<br/>";
                    hasError = true;
                }
                if (lastName == null || lastName.isEmpty()) {
                    errorMessage += "Last Name is required.<br/>";
                    hasError = true;
                }
                if (email == null || email.isEmpty()) {
                    errorMessage += "Email is required.<br/>";
                    hasError = true;
                }

                if (!hasError) {
                    Connection conn = null;
                    PreparedStatement checkStmt = null;
                    PreparedStatement insertStmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        conn = DriverManager.getConnection("jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True", "sa", "304#sa#pw");

                        // Check if the user ID already exists
                        String checkSql = "SELECT COUNT(*) FROM Customer WHERE userid = ?";
                        checkStmt = conn.prepareStatement(checkSql);
                        checkStmt.setString(1, userId);
                        rs = checkStmt.executeQuery();

                        if (rs.next() && rs.getInt(1) > 0) {
                            errorMessage = "User ID: "+ userId +" already exists. Please try a different User ID.";
                            hasError = true;
                        } else {
                            // Insert new user
                            String insertSql = "INSERT INTO Customer (userid, password, firstName, lastName, email) VALUES (?, ?, ?, ?, ?)";
                            insertStmt = conn.prepareStatement(insertSql);
                            insertStmt.setString(1, userId);
                            insertStmt.setString(2, password);
                            insertStmt.setString(3, firstName);
                            insertStmt.setString(4, lastName);
                            insertStmt.setString(5, email);
                            insertStmt.executeUpdate();

                            response.sendRedirect("login.jsp");
                            return;
                        }
                    } catch (SQLException | ClassNotFoundException e) {
                        errorMessage = "Error creating account: " + e.getMessage();
                        hasError = true;
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (checkStmt != null) try { checkStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (insertStmt != null) try { insertStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            }
        %>
        <% if (hasError) { %>
            <div class="alert alert-danger text-center"><%= errorMessage %></div>
        <% } %>
        <form method="post" action="createAccount.jsp" class="needs-validation" novalidate>
            <div class="form-group">
                <label for="userId">User ID</label>
                <input type="text" class="form-control" id="userId" name="userId" required>
                <div class="invalid-feedback">Please enter a User ID.</div>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <div class="invalid-feedback">Please enter a password.</div>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                <div class="invalid-feedback">Please confirm your password.</div>
            </div>
            <div class="form-group">
                <label for="firstName">First Name</label>
                <input type="text" class="form-control" id="firstName" name="firstName" required>
                <div class="invalid-feedback">Please enter your first name.</div>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name</label>
                <input type="text" class="form-control" id="lastName" name="lastName" required>
                <div class="invalid-feedback">Please enter your last name.</div>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
                <div class="invalid-feedback">Please enter a valid email address.</div>
            </div>
            <button type="submit" class="btn btn-primary btn-lg btn-block">Create Account</button>
        </form>
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
    <script>
        // Example starter JavaScript for disabling form submissions if there are invalid fields
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                // Fetch all the forms we want to apply custom Bootstrap validation styles to
                var forms = document.getElementsByClassName('needs-validation');
                // Loop over them and prevent submission
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
    </script>
</body>

</html>