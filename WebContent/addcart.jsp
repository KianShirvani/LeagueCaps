<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>The SQL Cap Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<!-- Page Header with Navigation Links -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <a class="navbar-brand" href="#">The SQL Cap Shop</a>
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
                <a class="nav-link" href="showcart.jsp.jsp">Shopping Cart</a>
            </li>
        </ul>
    </div>
</nav>

<%
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
    boolean remove = false;

    // Initialize the product list if it doesn't exist
    if (productList == null) {
        productList = new HashMap<String, ArrayList<Object>>();
        session.setAttribute("productList", productList);
    }

    // Remove a product if "removeId" is provided from "Remove" button on showcart.jsp
    String removeId = request.getParameter("removeId");
    if (removeId != null) {
        productList.remove(removeId);
        remove = true; //set to true if deleted an item
    }

    // Update product quantity if "updateId" and "quantity" are provided
    String updateId = request.getParameter("updateId");
    String quantityParam = request.getParameter("quantity");
    if (updateId != null && quantityParam != null) {
        try {
            int newQuantity = Integer.parseInt(quantityParam);
            if (newQuantity > 0 && productList.containsKey(updateId)) {
                ArrayList<Object> product = productList.get(updateId);
                product.set(3, newQuantity); // Update the quantity in the product list
            } else if (newQuantity == 0) {
                // Remove the product if the new quantity is 0
                productList.remove(updateId);
            }
        } catch (NumberFormatException e) {
            // Handle invalid quantity input
            out.println("<p>Invalid quantity provided. Please try again.</p>");
        }
        remove = true; // Avoid adding a product if updating quantity
    }

    // Add or update a product if "removeId" and "updateId" are not present
    if (!remove) {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String price = request.getParameter("price");

        if (id != null && name != null && price != null) {
            ArrayList<Object> product = new ArrayList<Object>();
            Integer quantity = 1;

            // Check if the product already exists in the cart
            if (productList.containsKey(id)) {
                product = (ArrayList<Object>) productList.get(id);
                int curAmount = ((Integer) product.get(3)).intValue();
                product.set(3, curAmount + 1); // Increment quantity
            } else {
                // Add new product to the list
                product.add(id);     // Product ID
                product.add(name);   // Product Name
                product.add(price);  // Product Price
                product.add(quantity); // Product Quantity
                productList.put(id, product);
            }
        }
    }

    // Update the session attribute with the updated product list
    session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />
</body>
</html>
