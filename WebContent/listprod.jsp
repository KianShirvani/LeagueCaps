<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>LeagueCaps</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="styles.css"> 
    <link rel="shortcut icon" type="image/x-icon" href="img/logo.png" />

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
    <h1 class="text-center">Search Results</h1>
    <%
        // Get search parameters
        String name = request.getParameter("productName");
        String categoryFilter = request.getParameter("category");

        // Database connection details
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";
        NumberFormat currency = NumberFormat.getCurrencyInstance();

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String sql = "SELECT product.productId, product.productName, product.productDesc, product.productPrice, category.categoryName " +
                         "FROM product " +
                         "JOIN category ON product.categoryId = category.categoryId";
            
            if ((name != null && !name.trim().isEmpty()) || (categoryFilter != null && !categoryFilter.isEmpty())) {
                sql += " WHERE";
                if (name != null && !name.trim().isEmpty()) {
                    sql += " product.productName LIKE ?";
                    if (categoryFilter != null && !categoryFilter.isEmpty()) {
                        sql += " AND";
                    }
                }
                if (categoryFilter != null && !categoryFilter.isEmpty()) {
                    sql += " category.categoryName = ?";
                }
            }

            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                int paramIndex = 1;
                if (name != null && !name.trim().isEmpty()) {
                    pstmt.setString(paramIndex++, "%" + name + "%");
                }
                if (categoryFilter != null && !categoryFilter.isEmpty()) {
                    pstmt.setString(paramIndex, categoryFilter);
                }

                ResultSet rst = pstmt.executeQuery();

                out.println("<div class='row'>");
                while (rst.next()) {
                    int productId = rst.getInt("productId");
                    String productName = rst.getString("productName");
                    String productDesc = rst.getString("productDesc");
                    String productPrice = currency.format(rst.getDouble("productPrice"));
                    String categoryName = rst.getString("categoryName");
                    String imagePath = "img/" + productId + ".jpg"; // Path to product image
                    String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") 
                                         + "&price=" + rst.getDouble("productPrice");
                
                    // Generate a card for each product
                    out.println("<div class='col-md-3 mb-4'>");
                    out.println("    <div class='card shadow h-100'>");
                    out.println("        <img src='" + imagePath + "' class='card-img-top' alt='" + productName + "' style='height: 200px; object-fit: cover;'>");
                    out.println("        <div class='card-body'>");
                    out.println("            <h5 class='card-title'>" + productName + "</h5>");
                    out.println("            <p class='card-text'><strong>Category:</strong> " + categoryName + "</p>");
                    out.println("            <p class='card-text'>" + productDesc + "</p>");
                    out.println("            <p class='card-text'><strong>Price:</strong> " + productPrice + "</p>");
                    out.println("        </div>");
                    out.println("        <div class='card-footer text-center'>");
                    out.println("            <a href='product.jsp?id=" + productId + "' class='btn btn-info btn-sm'>View Details</a>");
                    out.println("            <a href='" + addToCartLink + "' class='btn btn-success btn-sm'>Add to Cart</a>");
                    out.println("        </div>");
                    out.println("    </div>");
                    out.println("</div>");
                }
                out.println("</div>");
                rst.close();
            }
        } catch (SQLException ex) {
            out.println("<p class='text-danger'>Error: " + ex.getMessage() + "</p>");
        }
    %>
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
