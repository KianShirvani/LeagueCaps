<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>The SQL Cap Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
    
    <%
        // Database credentials
        String dbUrl = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";

        // Get the current list of products
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
        boolean remove = false;

        // Initialize the product list if it doesn't exist
        if (productList == null) {
            productList = new HashMap<>();
            session.setAttribute("productList", productList);
        }

        // Remove a product if "removeId" is provided
        String removeId = request.getParameter("removeId");
        if (removeId != null) {
            productList.remove(removeId);
            remove = true; // Set to true if deleted an item
        }

        // Update product quantity if "updateId" and "quantity" are provided
        String updateId = request.getParameter("updateId");
        String quantityParam = request.getParameter("quantity");
        if (updateId != null && quantityParam != null) {
            try {
                int newQuantity = Integer.parseInt(quantityParam);

                if (productList.containsKey(updateId)) {
                    // Validate quantity against inventory
                    int availableInventory = 0;

                    try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                         PreparedStatement stmt = con.prepareStatement("SELECT quantity FROM productinventory WHERE productId = ?")) {
                        stmt.setInt(1, Integer.parseInt(updateId));
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) {
                            availableInventory = rs.getInt("quantity");
                        }
                    }

                    if (newQuantity > 0 && newQuantity <= availableInventory) {
                        ArrayList<Object> product = productList.get(updateId);
                        product.set(3, newQuantity); // Update the quantity in the product list
                    } else if (newQuantity > availableInventory) {
                        session.setAttribute("errorMessage", "Only " + availableInventory + " units available for this product. Please adjust your quantity.");
                        response.sendRedirect("addcart.jsp");
                        return;
                    } else {
                        // Remove the product if the new quantity is 0
                        productList.remove(updateId);
                    }
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid quantity provided. Please try again.");
                response.sendRedirect("addcart.jsp");
                return;
            }
            remove = true; // Avoid adding a product if updating quantity
        }

        // Add or update a product if "removeId" and "updateId" are not present
        if (!remove) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String price = request.getParameter("price");

            if (id != null && name != null && price != null) {
                ArrayList<Object> product = new ArrayList<>();
                int requestedQuantity = 1;
                int availableInventory = 0;

                // Check available inventory
                try (Connection con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                     PreparedStatement stmt = con.prepareStatement("SELECT quantity FROM productinventory WHERE productId = ?")) {
                    stmt.setInt(1, Integer.parseInt(id));
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        availableInventory = rs.getInt("quantity");
                    }
                }

                if (requestedQuantity <= availableInventory) {
                    // Check if the product already exists in the cart
                    if (productList.containsKey(id)) {
                        product = productList.get(id);
                        int curAmount = (Integer) product.get(3);
                        if (curAmount + requestedQuantity <= availableInventory) {
                            product.set(3, curAmount + requestedQuantity); // Increment quantity
                        } else {
                            session.setAttribute("errorMessage", "Only " + availableInventory + " units available for this product. Please adjust your quantity.");
                            response.sendRedirect("addcart.jsp");
                            return;
                        }
                    } else {
                        // Add new product to the list
                        product.add(id);     // Product ID
                        product.add(name);   // Product Name
                        product.add(price);  // Product Price
                        product.add(requestedQuantity); // Product Quantity
                        productList.put(id, product);
                    }
                } else {
                    session.setAttribute("errorMessage", "Only " + availableInventory + " units available for this product. Please adjust your quantity.");
                    response.sendRedirect("addcart.jsp");
                    return;
                }
            }
        }

        // Update the session attribute with the updated product list
        session.setAttribute("productList", productList);
    %>
    <jsp:forward page="showcart.jsp" />
</div>
</body>
</html>