<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	
    <title>The SQL Cap Shop</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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

<div class="container my-4">

<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white text-center">
            <h1>Your Shopping Cart</h1>
        </div>
        <div class="card-body">
            <%
            @SuppressWarnings({"unchecked"})
            HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

            if (productList == null || productList.isEmpty()) {
                out.println("<div class='alert alert-warning text-center'><h3>Your shopping cart is empty!</h3></div>");
            } else {
                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
            %>
                <table class="table table-bordered table-striped">
                    <thead class="table-light">
                        <tr>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                            <th>Remove</th>
                            <th>Update</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    double total = 0;
                    for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                        ArrayList<Object> product = entry.getValue();
                        if (product.size() < 4) continue;

                        String id = product.get(0).toString();
                        String name = product.get(1).toString();
                        double price = Double.parseDouble(product.get(2).toString());
                        int quantity = Integer.parseInt(product.get(3).toString());
                        double subtotal = price * quantity;

                        total += subtotal;
                    %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= name %></td>
                            <td><%= quantity %></td>
                            <td><%= currFormat.format(price) %></td>
                            <td><%= currFormat.format(subtotal) %></td>
                            <td><a href="addcart.jsp?removeId=<%= id %>" class="btn btn-danger btn-sm">Remove</a></td>
                            <td>
                                <form action="addcart.jsp" method="get" class="d-flex">
                                    <input type="hidden" name="updateId" value="<%= id %>">
                                    <input type="number" name="quantity" value="<%= quantity %>" class="form-control" style="width: 80px;" min="0">
                                    <button type="submit" class="btn btn-primary btn-sm ms-2">Update</button>
                                </form>
                            </td>
                        </tr>
                    <%
                    }
                    %>
                        <tr>
                            <td colspan="4" class="text-end"><b>Total</b></td>
                            <td colspan="3" class="text-end"><%= currFormat.format(total) %></td>
                        </tr>
                    </tbody>
                </table>
            <%
            }
            %>
        </div>
        <div class="card-footer text-center">
            <a href="checkout.jsp" class="btn btn-success btn-lg">Check Out</a>
            <a href="listprod.jsp?productName=" class="btn btn-secondary btn-lg">Continue Shopping</a>
        </div>
    </div>
</div>
</body>
</html>
