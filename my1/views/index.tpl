<!DOCTYPE html>

<html>
<head>
  <title>GMS</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style type="text/css">
        body{
            color:white;
            background-color: white;
            text-align:center;
            background-image:url('../static/img/indexBackground.png');
            background-size:1376px 868px;
        }
        h1{
            font-family:"Monospac821 BT";
            color:white;
            text-align:center;
        }
        p{
            color:white;
            font-family:"Monospac821 BT";
            font-size:20px;
            text-align:center;
        }
        input{
            border: 1px solid #ccc;
            padding: 7px 0px;
            border-radius: 3px;
            padding-left:5px;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        }
        input:focus{
            border-color: #66afe9;
            outline: 0;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6)
        }
        button {
            background-color: whitesmoke; /* Green */
            border: none;
            color: blue;
            padding: 10px 21px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 15px;
            border-radius: 8px;
        }
        button:hover {
            background-color: lightseagreen; /* Green */
            color: darkblue;
        }

        select {
            -webkit-appearance: none;   /* Safari 和 Chrome */
            -moz-appearance: none;   /* Firefox */
            background-color: white;
            width: 156px;
            height: 90%;
            border: 1px solid #ccc;
            padding: 7px 0px;
            border-radius: 3px;
            padding-left:5px;
            font-size:16px;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
            transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
        }
        select:focus{
            border-color: #66afe9;
            outline: 0;
            box-shadow: inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6)
        }
    </style>
</head>

<body>
  <header>
    <h1 class="logo">Welcome to Grade Manage System</h1>
  </header>

  <footer>

  <form id="test-register" action="/MyPost" target="_self" method="post" onsubmit="return checkRegisterForm()">
      <p id="test-error" style="color:red"></p>
      <p>
          User Type:
          <select name="idChooser">
              <option value="i am teacher">i am teacher</option>
              <option value="i am student">i am student</option>
          </select>
      </p>
      <p>
          User Name: <input type="text" id="username" name="username">
      </p>
      <p>
          User Pass: <input type="password" id="password" name="password">
      </p>
   <!--
      <p>
          重复口令: <input type="password" id="password2">
      </p>
   -->
      <p>
          <button type="submit">enter</button> <button type="reset">reset</button>
      </p>
  </form>
    <div class="author">
      Contact me: 1234567@qq.com
    </div>
  </footer>
  <div class="backdrop"></div>


  <script>
     var checkRegisterForm = function () {
         var userCh = /[0-9a-zA-Z]{3,10}/;
         var passCh = /[0-9a-zA-Z\_\$]{1,20}/;
         var inputU = document.getElementById("username");
         var inputP = document.getElementById("password");
         //var inputP2 = document.getElementById("password2");

         if(!userCh.test(inputU.value))
         {
             alert("illeagal username!");
             return false;
         }
         if(!passCh.test(inputP.value))
         {
             alert("illeagal password!");
             return false;
         }
         //if(inputP.value !== inputP2.value) retunr false;

         // TODO: var userCh = /[0-9a-zA-Z]{3,10}/;
         return true;
     }

  </script>

  <!--
    <script src="/static/js/reload.min.js"></script>
    -->
</body>
</html>
