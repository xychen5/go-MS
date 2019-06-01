<!DOCTYPE html>
<html lang="en">
<head>
    <title>teacher</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<header>
    <h1 class="logo">Welcome to the GMS</h1>
    <div class="description">
        welcom teacher!
    </div>
</header>
    <form id="query" action="/teacher" method="post" onsubmit="return queryHandler">
        <button type="submit">查询所有bypost</button> <button type="reset">重置</button>
    </form>
    <script>
        var queryHandler = function () {
            return true;
        }
    </script>







</body>
</html>