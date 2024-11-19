<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Caps Store - Product Information</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

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

                out.println("<div class='container mt-5'>");
                out.println("<div class='card'>");

                // Card Header for product name
                out.println("<div class='card-header bg-primary text-white'>");
                out.println("<h2>" + name + "</h2>");
                out.println("</div>");

                
                // If there is a productImageURL, display using IMG tag
                out.println("<div class='card-body'>");
                if (imageUrl != null && !imageUrl.trim().isEmpty()) { //if Url exists in DB
                    out.println("<img src='" + imageUrl + "' alt='" + name + "' class='img-fluid mb-3'>");
                }

                // Product ID and Price
                out.println("<p><strong>ID:</strong> " + productId + "</p>");
                out.println("<p><strong>Price:</strong> $" + price + "</p>");

                // Links to Add to Cart and Continue Shopping
                out.println("<a href='addcart.jsp?id=" + productId + "&name=" + name + "&price=" + price + "' class='btn btn-success me-2'>Add to Cart</a>");
                out.println("<a href='listprod.jsp' class='btn btn-secondary'>Continue Shopping</a>");

                out.println("</div>"); // Close card body
                out.println("</div>"); // Close card
                out.println("</div>"); // Close container
            } else {//Invalid Product ID
                out.println("<div class='alert alert-warning'>Product not found. Please go back and try again.</div>");
            }
        }
    } catch (SQLException e) {
        out.println("<div class='alert alert-danger'>Error retrieving product details: " + e.getMessage() + "</div>");
    }
%>

</body>
</html>
