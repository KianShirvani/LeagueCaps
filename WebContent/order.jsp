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
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css">
	</head>
	<body class="container mt-5">

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
	
	</body>
	</html>