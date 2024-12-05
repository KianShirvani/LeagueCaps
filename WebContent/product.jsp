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
<style>
    .product-details-box {
        padding: 20px;
        margin-left: 100px;
        background-color: #f8f9fa; /* Light gray background */
        border-radius: 5px; /* Rounded corners */
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
    }

    .navbar {
    opacity: 0.8;
    position: relative;
}

.footer {
    opacity: 0.8;
}

    .product-details-box h2 {
        font-size: 2rem;
        margin-bottom: 15px;
        color: #343a40; /* Dark gray text */
    }

    .product-details-box p {
        font-size: 1.1rem;
        margin-bottom: 10px;
    }

    .product-details-box .btn {
        margin-top: 10px;
    }

    /* Larger image styling */
    .product-image {
        max-height: 600px;
        width: 100%;
        margin-right: 300px ;
        object-fit: cover;
        border-radius: 5px;
    }
</style>
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
<!-- Search Bar -->
<li class="nav-item flex-grow-1">
    <form class="form-inline my-2 my-lg-1 w-100" action="listprod.jsp" method="get">
        <!-- Update name to 'productName' to match listprod.jsp -->
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
                %>
                <div class="container mt-5">
                    <div class="row">
                        <!-- Left Column: Product Image -->
                        <div class="col-md-6 d-flex justify-content-center align-items-center">
                            <div class="image-container">
                                <img src="<%= imageUrl %>" alt="<%= name %>" class="product-image">
                            </div>
                        </div>
                
                        <!-- Right Column: Product Details -->
                        <div class="col-md-6">
                            <div class="product-details-box">
                                <h2><%= name %></h2>
                                <p><strong>Price:</strong> $<%= price %></p>
                
                                <!-- Dropdown Sections -->
                                <div id="accordion">
                
                                    <!-- Shipping Information -->
                                    <div class="card">
                                        <div class="card-header" id="shippingHeader">
                                            <button class="btn btn-link" data-toggle="collapse" data-target="#shippingInfo" aria-expanded="false" aria-controls="shippingInfo">
                                                Shipping
                                            </button>
                                        </div>
                                        <div id="shippingInfo" class="collapse show" aria-labelledby="shippingHeader" data-parent="#accordion">
                                            <div class="card-body">
                                                This item will ship within 2 business days.
                                            </div>
                                        </div>
                                    </div>
                
                                    <!-- Product Details -->
                                    <div class="card">
                                        <div class="card-header" id="detailsHeader">
                                            <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#productDetails" aria-expanded="false" aria-controls="productDetails">
                                                Details
                                            </button>
                                        </div>
                                        <div id="productDetails" class="collapse" aria-labelledby="detailsHeader" data-parent="#accordion">
                                            <div class="card-body">
                                                <ul>
                                                    <li>Product ID: <%= productId %></li>
                                                    <li>Brand: '47</li>
                                                    <li>Imported</li>
                                                    <li>Six panels with eyelets</li>
                                                    <li>Embroidered graphics with raised details</li>
                                                    <li>One size fits most</li>
                                                    <li>Woven clip tag</li>
                                                    <li>Material: 100% Cotton</li>
                                                    <li>Wipe clean with a damp cloth</li>
                                                    <li>Curved bill</li>
                                                    <li>Adjustable fabric strap with snap button</li>
                                                    <li>Low Crown</li>
                                                    <li>Unstructured relaxed fit</li>
                                                    <li>Officially licensed</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    
                
                                    <!-- Description -->
                                    <div class="card">
                                        <div class="card-header" id="descriptionHeader">
                                            <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#descriptionInfo" aria-expanded="false" aria-controls="descriptionInfo">
                                                Description
                                            </button>
                                        </div>
                                        <div id="descriptionInfo" class="collapse" aria-labelledby="descriptionHeader" data-parent="#accordion">
                                            <div class="card-body">
                                                Wearing LeagueCaps ensures you're sporting officially licensed gear that lets you represent your favorite team with loyalty and pride. Show the world your true fandom!
                                            </div>
                                        </div>
                                    </div>
                                </div>
                
                                <!-- Add to Cart and Continue Shopping Buttons -->
                                <a href="addcart.jsp?id=<%= productId %>&name=<%= name %>&price=<%= price %>" class="btn btn-success mt-3">Add to Cart</a>
                                <a href="listprod.jsp" class="btn btn-secondary mt-3">Continue Shopping</a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="mt-5">
                    <div style="background-color: midnightblue; height: 100px; width: 100%; opacity: 80%; position: relative; display: flex; justify-content: center; align-items: center;">
                        <h2 style="color: white; font-size: 2.5rem; text-transform: uppercase; margin: 0; text-align: center;">
                            Rep Your Team with Pride
                        </h2>
                    </div>
                </div>
                

                <div class="container mt-5">
                    <div class="row">
                        <!-- Existing Product Image and Details Columns -->
                        <!-- (Omitted for brevity, refer to your code above) -->
                    </div>
                
                    <!-- Recommendations Section -->
                    <div class="mt-5">
                        <h3 class="mb-4">Recommended for You</h3>
                        <div class="row">
                            <%
                                // Query to fetch 5 random hats from the database
                                String recommendationSql = "SELECT TOP 4 productId, productName, productPrice, productImageURL FROM product ORDER BY NEWID()";
                
                                try (PreparedStatement recommendationStmt = con.prepareStatement(recommendationSql);
                                     ResultSet recResultSet = recommendationStmt.executeQuery()) {
                                    while (recResultSet.next()) {
                                        String recProductId = recResultSet.getString("productId");
                                        String recProductName = recResultSet.getString("productName");
                                        double recProductPrice = recResultSet.getDouble("productPrice");
                                        String recProductImageURL = recResultSet.getString("productImageURL");
                            %>
                            <!-- Recommended Product Card -->
                            <div class="col-md-3 mb-4">
                                <div class="card">
                                    <img src="<%= recProductImageURL %>" class="card-img-top" alt="<%= recProductName %>" style="height: 150px; object-fit: cover;">
                                    <div class="card-body">
                                        <h5 class="card-title" style="font-size: 1rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                            <%= recProductName %>
                                        </h5>
                                        <p class="card-text">$<%= recProductPrice %></p>
                                        <a href="product.jsp?id=<%= recProductId %>" class="btn btn-primary btn-sm">View Product</a>
                                    </div>
                                </div>
                            </div>
                            <% 
                                    }
                                } catch (SQLException recEx) {
                                    out.println("<div class='alert alert-danger'>Error fetching recommendations: " + recEx.getMessage() + "</div>");
                                }
                            %>
                        </div>
                    </div>
                </div>
                


                
                
                <%
                            } else {
                %>
                <div class="alert alert-warning text-center mt-5">Product not found. Please go back and try again.</div>
                <%
                            }
                        }
                    } catch (SQLException e) {
                %>
                <div class="alert alert-danger text-center mt-5">Error retrieving product details: <%= e.getMessage() %></div>
                <%
                    }
                %>


                

                
<!-- Footer Section -->
<footer class="footer text-light py-4" style="background-color: midnightblue;">
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
                
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
                </body>
                </html>