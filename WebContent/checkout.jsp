<!DOCTYPE html>
<html>
<head>
    <title>SQL Cap Shop Checkout Line</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white text-center">   
            <h1>SQL Cap Shop Checkout Line</h1>
        </div>
        <div class="card-body">
            <p class="text-center">Enter your customer ID and password to complete the transaction:</p>
            <form method="get" action="order.jsp" class="d-flex flex-column align-items-center">
                <div class="mb-3" style="width: 300px;">
                    <label for="customerId" class="form-label"></label>
                    <input type="text" id="customerId" name="customerId" class="form-control" placeholder="Customer ID" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="customerPassword" class="form-label"></label>
                    <input type="password" id="customerPassword" name="customerPassword" class="form-control" placeholder="Password" required>
                </div>
                <div>
                    <input type="submit" value="Submit" class="btn btn-success me-2">
                    <a href="index.jsp" class="btn btn-secondary">Home</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>
