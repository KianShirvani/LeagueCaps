<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Order Confirmation</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		<link rel="stylesheet" href="styles.css">
		<link rel="shortcut icon" type="image/x-icon" href="img/logo.png" />
	</head>
	<body>

		
	<!-- Navbar Section -->
	<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: midnightblue;">
		<!-- Logo and Brand Name -->
		<a class="navbar-brand ml-4" href="index.jsp"
			style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-size: 2em; color: whitesmoke; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);">
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
					<% String authenticatedUser=(String) session.getAttribute("authenticatedUser"); if
						(authenticatedUser !=null) { %>
						<a href="logout.jsp" class="btn btn-primary btn-lg mx-2">Welcome: <%= authenticatedUser %></a>
						<% } else { %>
							<a href="login.jsp" class="btn btn-primary btn-lg mx-2">Sign In</a>
							<% } %>
				</li>

				<!-- Create Account Button -->
				<% if (authenticatedUser==null) { // Only display if user is not logged in %>
					<li class="nav-item">
						<a href="createAccount.jsp" class="btn btn-success btn-lg mx-2">Create Account</a>
					</li>
					<% } %>

						<!-- Cart Button -->
						<li class="nav-item">
							<a href="showcart.jsp">
								<img src="img/cart-icon.jpg" alt="Cart" style="height: 40px; width: 40px;" class="mx-2">
								<!-- Replace with your cart image -->
							</a>
						</li>
			</ul>
		</div>
	</nav>

	<div class="container mt-5">

		<%
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";
		Connection conn = null;
	
		try {
			// Retrieve customer ID and password
			String customerId = request.getParameter("customerId");
			String password = request.getParameter("customerPassword");
	
			// Validate input
			if (customerId == null || !customerId.matches("\\d+")) {
				out.println("<div class='alert alert-danger'>Invalid customer ID.</div>");
				return;
			}
			if (password == null || password.isEmpty()) {
				out.println("<div class='alert alert-danger'>Password cannot be empty.</div>");
				return;
			}
	
			conn = DriverManager.getConnection(url, uid, pw);
	
			// Validate customer ID and password in the database
			PreparedStatement checkCustomerStmt = conn.prepareStatement(
				"SELECT firstName, lastName FROM Customer WHERE customerId = ? AND password = ?");
			checkCustomerStmt.setInt(1, Integer.parseInt(customerId));
			checkCustomerStmt.setString(2, password);
			ResultSet customerRs = checkCustomerStmt.executeQuery();
	
			String customerName = "";
			if (customerRs.next()) {
				customerName = customerRs.getString("firstName") + " " + customerRs.getString("lastName");
			} else {
				out.println("<div class='alert alert-danger'>Invalid customer ID or password.</div>");
				return;
			}
	
			// Get the shopping cart from the session
			@SuppressWarnings("unchecked")
			HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
			if (productList == null || productList.isEmpty()) {
				out.println("<div class='alert alert-danger'>Shopping cart is empty.</div>");
				return;
			}
	
			// Insert Order Summary
			PreparedStatement orderStmt = conn.prepareStatement(
				"INSERT INTO OrderSummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)",
				Statement.RETURN_GENERATED_KEYS);
			orderStmt.setInt(1, Integer.parseInt(customerId));
			orderStmt.executeUpdate();
	
			ResultSet orderKeys = orderStmt.getGeneratedKeys();
			int orderId = 0;
			if (orderKeys.next()) {
				orderId = orderKeys.getInt(1);
			}
	
			// Insert Products into OrderProduct
			double totalAmount = 0;
			PreparedStatement productStmt = conn.prepareStatement(
				"INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");
	
			for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
				ArrayList<Object> product = entry.getValue();
	
				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				double price = Double.parseDouble(product.get(2).toString());
				int quantity = Integer.parseInt(product.get(3).toString());
				double subtotal = quantity * price;
	
				productStmt.setInt(1, orderId);
				productStmt.setInt(2, Integer.parseInt(productId));
				productStmt.setInt(3, quantity);
				productStmt.setDouble(4, price);
				productStmt.executeUpdate();
	
				totalAmount += subtotal;
			}
	
			// Update Order Total
			PreparedStatement updateTotalStmt = conn.prepareStatement(
				"UPDATE OrderSummary SET totalAmount = ? WHERE orderId = ?");
			updateTotalStmt.setDouble(1, totalAmount);
			updateTotalStmt.setInt(2, orderId);
			updateTotalStmt.executeUpdate();
	
			conn.commit();
	
			// Display Order Details and Confirmation
			NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
			out.println("<div class='alert alert-success'>Order placed successfully!</div>");
			out.println("<h3>Order Details</h3>");
			out.println("<table class='table table-striped'>");
			out.println("<thead><tr><th>Order ID</th><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr></thead>");
			out.println("<tbody>");
			for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
				ArrayList<Object> product = entry.getValue();
				String productId = (String) product.get(0);
				String productName = (String) product.get(1);
				double price = Double.parseDouble(product.get(2).toString());
				int quantity = Integer.parseInt(product.get(3).toString());
				double subtotal = quantity * price;
	
				out.println("<tr><td>" + orderId + "</td><td>" + productId + "</td><td>" + productName + "</td><td>" + quantity + "</td><td>" + currencyFormat.format(price) + "</td><td>" + currencyFormat.format(subtotal) + "</td></tr>");
			}
			out.println("</tbody>");
			out.println("<tfoot>");
			out.println("<tr><td colspan='5' class='text-end'><b>Total:</b></td><td>" + currencyFormat.format(totalAmount) + "</td></tr>");
			out.println("</tfoot>");
			out.println("</table>");
			out.println("<h4>Order completed. Will be shipped soon...</h4>");
			out.println("<p>Your order reference number is: " + orderId + "</p>");
			out.println("<p>Shipping to customer: " + customerId + "</p>");
			out.println("<p>Name: " + customerName + "</p>");
			session.setAttribute("productList", null);
		} catch (Exception e) {
			if (conn != null) conn.rollback();
			out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
		} finally {
			if (conn != null) conn.close();
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
	
	</body>
	</html>