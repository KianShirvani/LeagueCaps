<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SQL Cap Shop</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="styles.css"> 

    <style>
        .category-buttons a {
            text-decoration: none;
        }
    </style>
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
        <div class="dropdown-menu " aria-labelledby="shopDropdown">
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


            <!-- Sign In Button -->
            <li class="nav-item">
                <a href="login.jsp" class="btn btn-primary btn-lg mx-2">Sign In</a>
            </li>

            <!-- Create Account Button -->
            <li class="nav-item">
                <a href="createAccount.jsp" class="btn btn-success btn-lg mx-2">Create Account</a>
            </li>

            <!-- Cart Button -->
            <li class="nav-item">
                <a href="cart.jsp">
                    <img src="img/cart-icon.jpg" alt="Cart" style="height: 40px; width: 40px;" class="mx-2"> <!-- Replace with your cart image -->
                </a>
            </li>
        </ul>
    </div>
</nav>

	

<!-- Hero Section -->
<div class="text-center bg-light mt-4 mb-4 animated-hero">
	<h1 class="display-2 mb-2" style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-weight: 700;">Welcome to LeagueCaps</h1>
    <p class="lead mt-4" style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-weight: 400;">Find your favorite caps for NBA, NFL, and MLB teams!</p>
</div>


<div class="slideshow">
	<!-- Middle Section with Carousel -->
<div class="container my-5">
    <div id="offersCarousel" class="carousel slide rounded shadow" data-ride="carousel" data-interval="10000">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#offersCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#offersCarousel" data-slide-to="1"></li>
            <li data-target="#offersCarousel" data-slide-to="2"></li>
        </ol>

        <!-- Carousel Items -->
        <div class="carousel-inner">
            <!-- Slide 1 -->
            <div class="carousel-item active">
                <img src="img/city-edition-offer.jpg" class="d-block w-100" alt="NBA Offer" style="height: 600px; object-fit:scale-down;"> <!-- Replace with your image -->
                <div class="carousel-caption d-none d-md-block">
                    <h5>NBA League Caps</h5>
                    <p class="card-text">NBA team caps inspired by the latest City Edition.</p>
                    <a href="listprod.jsp?category=NBA Caps" class="btn btn-primary btn-lg">Shop NBA</a>
                </div>
            </div>
            <!-- Slide 2 -->
            <div class="carousel-item">
                <img src="img/football-promo.jpg" class="d-block w-100 bg-secondary.bg-gradient" alt="NFL Offer" style="height: 600px; object-fit: scale-down;"> <!-- Replace with your image -->
                <div class="carousel-caption d-none d-md-block">
                    <h5>NFL Fan Favorites</h5>
                    <p class="">Show your team spirit with NFL caps featuring iconic designs.</p>
                    <a href="listprod.jsp?category=NFL Caps" class="btn btn-danger btn-lg">Shop NFL</a>
                </div>
            </div>
            <!-- Slide 3 -->
            <div class="carousel-item">
                <img src="img/mlb-offer.png" class="d-block w-100" alt="MLB Offer" style="height: 600px; object-fit: scale-down;"> <!-- Replace with your image -->
                <div class="carousel-caption d-none d-md-block">
                    <h5>MLB Throwback Collection</h5>
                    <p>Check out our exclusive MLB caps featuring throwback designs.</p>
                    <a href="listprod.jsp?category=MLB Caps" class="btn btn-success btn-lg">Shop MLB</a>
                </div>
            </div>
        </div>
    </div>
</div>
>

    <!-- Controls -->
    <a class="carousel-control-prev" href="#offersCarousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#offersCarousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>  <!-- End Div of Slideshow -->


<!-- Categories Section -->
<div class="container my-5">
    <h2 class="text-center mb-4">Shop Your Favorite Sport</h2>
    <div class="row text-center category-buttons">
        <!-- NBA Category -->
        <div class="col-md-4 mb-3">
            <div class="card shadow p-3 border"> <!-- Added white box using card class -->
                <a href="listprod.jsp?category=NBA Caps">
                    <img src="img/nba-logo.png" alt="NBA" class="img-fluid rounded" style="max-height: 150px;"> <!-- Replace with your NBA logo image -->
                </a>
                <p class="mt-2">NBA</p> <!-- Optional caption -->
            </div>
        </div>
        <!-- NFL Category -->
        <div class="col-md-4 mb-3">
            <div class="card shadow p-3 border"> <!-- Added white box using card class -->
                <a href="listprod.jsp?category=NFL Caps">
                    <img src="img/nfl-logo.png" alt="NFL" class="img-fluid rounded" style="max-height: 150px;"> <!-- Replace with your NFL logo image -->
                </a>
                <p class="mt-2">NFL</p> <!-- Optional caption -->
            </div>
        </div>
        <!-- MLB Category -->
        <div class="col-md-4 mb-3">
            <div class="card shadow p-3 border"> <!-- Added white box using card class -->
                <a href="listprod.jsp?category=MLB Caps">
                    <img src="img/mlb-logo.png" alt="MLB" class="img-fluid rounded" style="max-height: 150px;"> <!-- Replace with your MLB logo image -->
                </a>
                <p class="mt-2">MLB</p> <!-- Optional caption -->
            </div>
        </div>
    </div>
</div>


</div>


<!-- Footer Section -->
<footer class="footer text-light text-center py-3" style="background-color: midnightblue;">
    <p>&copy; 2024 SQL Cap Shop. All Rights Reserved.</p>
</footer>

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
