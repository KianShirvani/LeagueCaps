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

	<div class="container mt-5 mb-3">
		<div class="card mb-3">
			<div class="card-header bg-primary text-white text-center">
				<h1>Order Confirmation</h1>
			</div>
			<div class="card-body">
				<%
					String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
					String uid = "sa";
					String pw = "304#sa#pw";
					Connection conn = null;

					try {
						// Retrieve customer ID and password from session
						String customerId = (String) session.getAttribute("customerId");
						String customerPassword = (String) session.getAttribute("customerPassword");

						// Ensure customer ID and password are present in session
						if (customerId == null || customerPassword == null) {
							out.println("<div class='alert alert-danger'>Session expired. Please log in again.</div>");
							return;
						}

						// Attempt to connect to the database
						conn = DriverManager.getConnection(url, uid, pw);

						// Get the shopping cart from the session
						@SuppressWarnings("unchecked")
						HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
						if (productList == null || productList.isEmpty()) {
							out.println("<div class='alert alert-danger'>Shopping cart is empty.</div>");
							return;
						}

						// Process the order and display confirmation
						// (Add your order processing logic here)

						// Display order details
						out.println("<h2>Order Details</h2>");
						out.println("<table class='table table-bordered'>");
						out.println("<thead><tr><th>Product</th><th>Quantity</th><th>Price</th><th>Total</th></tr></thead>");
						out.println("<tbody>");

						double grandTotal = 0.0;
						for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
							String productId = entry.getKey();
							ArrayList<Object> productDetails = entry.getValue();
							String productName = (String) productDetails.get(1);
							int quantity = (int) productDetails.get(3);
							double price = Double.parseDouble((String) productDetails.get(2));
							double total = quantity * price;
							grandTotal += total;

							out.println("<tr>");
							out.println("<td>" + productName + "</td>");
							out.println("<td>" + quantity + "</td>");
							out.println("<td>" + NumberFormat.getCurrencyInstance().format(price) + "</td>");
							out.println("<td>" + NumberFormat.getCurrencyInstance().format(total) + "</td>");
							out.println("</tr>");
						}

						out.println("</tbody>");
						out.println("<tfoot><tr><th colspan='3'>Grand Total</th><th>" + NumberFormat.getCurrencyInstance().format(grandTotal) + "</th></tr></tfoot>");
						out.println("</table>");

						// Retrieve shipping information from session
						String shiptoAddress = (String) session.getAttribute("shiptoAddress");
						String shiptoCity = (String) session.getAttribute("shiptoCity");
						String shiptoState = (String) session.getAttribute("shiptoState");
						String shiptoPostalCode = (String) session.getAttribute("shiptoPostalCode");
						String shiptoCountry = (String) session.getAttribute("shiptoCountry");

						// Insert order summary into the database
						String insertOrderSQL = "INSERT INTO ordersummary (customerId, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, totalAmount) VALUES (?, ?, ?, ?, ?, ?, ?)";
						try (PreparedStatement pstmt = conn.prepareStatement(insertOrderSQL)) {
							pstmt.setString(1, customerId);
							pstmt.setString(2, shiptoAddress);
							pstmt.setString(3, shiptoCity);
							pstmt.setString(4, shiptoState);
							pstmt.setString(5, shiptoPostalCode);
							pstmt.setString(6, shiptoCountry);
							pstmt.setDouble(7, grandTotal);

							int rowsAffected = pstmt.executeUpdate();
							if (rowsAffected > 0) {
								out.println("<div class='alert alert-success'>Order placed successfully!</div>");
							} else {
								out.println("<div class='alert alert-danger'>Failed to save order summary.</div>");
							}
						} catch (SQLException e) {
							e.printStackTrace();
							out.println("<div class='alert alert-danger'>An error occurred while saving the order summary.</div>");
						}

						// Clear the shopping cart
						session.removeAttribute("productList");

						conn.close();
					} catch (Exception e) {
						e.printStackTrace();
						out.println("<div class='alert alert-danger'>An error occurred while processing your order. Please try again.</div>");
					} finally {
						if (conn != null) {
							try {
								conn.close();
							} catch (SQLException e) {
								e.printStackTrace();
							}
						}
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
	
	</body>
	</html>