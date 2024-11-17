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
</head>
<body>
<!-- Page Header Start-->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <a class="navbar-brand" href="shop.html">The SQL Cap Shop</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="listprod.jsp">Product Page</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="listorder.jsp">List Order</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="showcart.jsp">Shopping Cart</a>
            </li>
        </ul>
    </div>
</nav>
<!-- Page Header End-->

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
