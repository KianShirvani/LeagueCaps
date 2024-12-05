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

			out.println("<div class='alert alert-success'>Order placed successfully!</div>");

						conn.close();
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