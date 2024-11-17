<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>The SQL Cap Shop</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
    

<div class ="container my-4">
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp" class="mb-4">
    <input type="text" name="productName" size="50" class="form-control mb-2" placeholder="Enter product name">
    <select name="category" class="form-control mb-2">
        <option value="">All Categories</option>
        <option value="NFL Caps">NFL Caps</option>
        <option value="MLB Caps">MLB Caps</option>
        <option value="NBA Caps">NBA Caps</option>
    </select>
    <button type="submit" class="btn btn-primary">Submit</button>
    <button type="reset" class="btn btn-secondary">Reset</button> 
    <small class="form-text text-muted">(Leave blank for all products)</small>
</form>

<%
    // Get search parameters
    String name = request.getParameter("productName");
    String categoryFilter = request.getParameter("category");

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

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

            // Display products in a table
            out.println("<table class='table table-striped table-bordered'>");
            out.println("<thead class='thead-dark'><tr>");
            out.println("<th>Product ID</th><th>Product Name</th><th>Category</th><th>Description</th><th>Price</th><th>Action</th>");
            out.println("</tr></thead><tbody>");

            while (rst.next()) {
                int productId = rst.getInt("productId");
                String productName = rst.getString("productName");
                String productDesc = rst.getString("productDesc");
                String productPrice = currency.format(rst.getDouble("productPrice"));
                String categoryName = rst.getString("categoryName");

                String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") 
                                     + "&price=" + rst.getDouble("productPrice");
                // New row for each product info
                out.println("<tr>");
                out.println("<td>" + productId + "</td>");
                out.println("<td><a href='product.jsp?id=" + productId + "'>" + productName + "</a></td>"); 
                out.println("<td>" + categoryName + "</td>");
                out.println("<td>" + productDesc + "</td>");
                out.println("<td>" + productPrice + "</td>");
                out.println("<td><a href='" + addToCartLink + "' class='btn btn-success'>Add to Cart</a></td>");
                out.println("</tr>");
            }

            out.println("</tbody></table>");

            rst.close();
        }
    } catch (SQLException ex) {
        out.println("SQLException: " + ex);
    }
%>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body> 
</html>
