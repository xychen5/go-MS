<!DOCTYPE html>
<html>
<head>
    <title>GMS</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>

    <script>
        var ws;
        var logHtml ="";
        var stuHtml ="";
        var stuLessons = "";
        var stuChooseL = "";
        $(document).ready(function() {
            var $ul = $('#log-list');
            ws = new WebSocket('ws://' + window.location.host + '/dba/DbaEnter');

            ws.onmessage = function(e) {
                $('<li>').text(e.data).appendTo($ul);
                var josnData = JSON.parse(e.data);
                switch (josnData.Type){
                    case 0:
                        $('<li>').text("-->  stu join!").appendTo($ul);
                        break;
                }
            };
        });

        function opStu() {
            var $ul = $('#log-list');
            if(document.getElementById('stuOp').value === "create"){
                if(confirm("sure to create this stu？")){
                    var message = {};
                    message.Type = "createStu";
                    message.Data = {
                        "SID":document.getElementById('SID').value,
                        "SNAME":document.getElementById('SNAME').value,
                        "SPASS":document.getElementById('SPASS').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);
                    var $ul = $('#log-list');
                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            } else if(document.getElementById('stuOp').value === "delete") {
                if(confirm("sure to delete this stu？")){
                    var message = {};
                    message.Type = "deleteStu";
                    message.Data = {
                        "SID":document.getElementById('SID').value,
                        "SNAME":document.getElementById('SNAME').value,
                        "SPASS":document.getElementById('SPASS').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);

                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            } else {
                if(confirm("sure to modify this stu？")){
                    var message = {};
                    message.Type = "modifyStu";
                    message.Data = {
                        "SID":document.getElementById('SID').value,
                        "SNAME":document.getElementById('SNAME').value,
                        "SPASS":document.getElementById('SPASS').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);
                    var $ul = $('#log-list');
                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            }
        }

        function opTea() {
            var $ul = $('#log-list');
            if(document.getElementById('teaOp').value === "create"){
                if(confirm("sure to create this tea？")){
                    var message = {};
                    message.Type = "createTea";
                    message.Data = {
                        "TID":document.getElementById('TID').value,
                        "TNAME":document.getElementById('TNAME').value,
                        "TPASS":document.getElementById('TPASS').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);
                    var $ul = $('#log-list');
                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            } else if(document.getElementById('teaOp').value === "delete") {
                if(confirm("sure to delete this tea？")){
                    var message = {};
                    message.Type = "deleteTea";
                    message.Data = {
                        "TID":document.getElementById('TID').value,
                        "TNAME":document.getElementById('TNAME').value,
                        "TPASS":document.getElementById('TPASS').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);

                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            } else {
                if(confirm("sure to modify this tea？")){
                    var message = {};
                    message.Type = "modifyTea";
                    message.Data = {
                        "TID":document.getElementById('TID').value,
                        "TNAME":document.getElementById('TNAME').value,
                        "TPASS":document.getElementById('TPASS').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);
                    var $ul = $('#log-list');
                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            }
        }

        function opLes() {
            var $ul = $('#log-list');
            if(document.getElementById('lesOp').value === "create"){
                if(confirm("sure to create this les？")){
                    var message = {};
                    message.Type = "createLes";
                    message.Data = {
                        "LID":document.getElementById('LID').value,
                        "LNAME":document.getElementById('LNAME').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);
                    var $ul = $('#log-list');
                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            } else  {
                if(confirm("sure to delete this les？")){
                    var message = {};
                    message.Type = "deleteLes";
                    message.Data = {
                        "LID":document.getElementById('LID').value,
                        "LNAME":document.getElementById('LNAME').value,
                    };
                    var json = JSON.stringify(message);
                    ws.send(json);

                    $('<li>').text("web send:"+json).appendTo($ul);
                }
                else{
                    alert("submit abort!");
                }
            }
        }

        function opSql() {
            var $ul = $('#log-list');

            if(confirm("sure to excute this sql？")){
                var message = {};
                message.Type = "anyDo";
                message.Data = {
                    "Sql":document.getElementById('sql').value,
                };
                var json = JSON.stringify(message);
                ws.send(json);
                var $ul = $('#log-list');
                $('<li>').text("web send:"+json).appendTo($ul);
            } else{
                alert("submit abort!");
            }

        }


    </script>

</head>
<body>
<div id="container" style="width:100%; height: 100%;">
    <div>
        <h1>welcome! Dear {{.UserName}}</h1>
    </div>
    <div style="height:350px;width:100%;float:left;background: rgba(255, 255, 255, 0.1);">
        <div id="operateChooseL" style="height:350px;background: rgba(255, 255, 255, 0.1);width:25%;float:left;">
            <p style="text-align:center;float: left; padding-left:40px;" >
                <label style="font-size:25px;float:left">stu operate</label><br><br>
                <label style="font-size:16px;float:left">op type</label>
                <select style="float:right;" id="stuOp">
                    <option value="create">create</option>
                    <option value="delete">delete</option>
                    <option value="modify">modify</option>
                </select><br><br>
                <label style="font-size:16px;float:left"> STUID</label>
                <input style="float:right;" id="SID" type="text" placeholder="sut id" required="required"><br><br>
                <label style="font-size:16px;float:left"> STUNAME</label>
                <input style="float:right;"id="SNAME" type="text" placeholder="sut name" required="required"><br><br>
                <label style="font-size:16px;float:left"> STUPASS</label>
                <input style="float:right;"id="SPASS" type="text" placeholder="sut pass" required="required"><br><br>
                <button id="btChooseL" type="submit" onclick="opStu()">submit</button>
            </p>
        </div>
        <div id="operateChooseL" style="height:350px;background: rgba(255, 255, 255, 0.1);width:25%;float:left;">
            <p style="text-align:center;float: left; padding-left:40px;" >
                <label style="font-size:25px;float:left">tea operate</label><br><br>
                <label style="font-size:16px;float:left">op type</label>
                <select style="float:right;" id="teaOp">
                    <option value="create">create</option>
                    <option value="delete">delete</option>
                    <option value="modify">modify</option>
                </select><br><br>
                <label style="font-size:16px;float:left"> TEAID</label>
                <input style="float:right;" id="TID" type="text" placeholder="tea id" required="required"><br><br>
                <label style="font-size:16px;float:left">TEANAME</label>
                <input style="float:right;"id="TNAME" type="text" placeholder="tea name" required="required"><br><br>
                <label style="font-size:16px;float:left"> TEAPASS</label>
                <input style="float:right;"id="TPASS" type="text" placeholder="tea pass" required="required"><br><br>
                <button id="btChooseL" type="submit" onclick="opTea()">submit</button>
            </p>
        </div>
        <div id="operateChooseL" style="height:350px;background: rgba(255, 255, 255, 0.1);width:25%;float:left;">
            <p style="text-align:center;float: left; padding-left:40px;" >
                <label style="font-size:25px;float:left">les operate</label><br><br>
                <label style="font-size:16px;float:left">op type</label>
                <select style="float:right;" id="lesOp">
                    <option value="create">create</option>
                    <option value="delete">delete</option>
                </select><br><br><br>
                <label style="font-size:16px;float:left"> LESID</label>
                <input style="float:right;" id="LID" type="text" placeholder="lesson id" required="required"><br><br><br>
                <label style="font-size:16px;float:left">LESNAME</label>
                <input style="float:right;"id="LNAME" type="text" placeholder="lesson name" required="required"><br><br>
                <button id="btChooseL" type="submit" onclick="opLes()">submit</button>
            </p>
        </div>
        <div id="operateChooseL" style="height:350px;background: rgba(255, 255, 255, 0.1);width:25%;float:left;">
            <p style="float: left; padding-left:40px;" >
                <label style="font-size:20px;float:top">do any with leagal mysql</label><br><br>
                <input style="border-radius:10px;width:265px;height:165px;" id="sql" type="text" placeholder="legal sql" required="required"><br><br>
                <button id="btChooseL" type="submit" onclick="opSql()">submit</button>

            </p>
        </div>
    </div>
    <div style="height:250px;width:100%;float:left;background: rgba(255, 255, 255, 0.1);">
        <label style="font-size:20px;float:top; font-family:'Monospac821 BT';">log</label><br><br>

        <ul id="log-list" ></ul>
    </div>

</div>
</body>

<style>
    table{
        border-collapse: collapse;
        border-spacing: 0;
        border: 0px solid #c0c0c0;
        width: 100%; height:100%;
        text-align:center;
    }
    th,td{
        border: none;
        padding: 10px;
    }
    th{
        font: bold 16px "微软雅黑";
        color: white;
    }
    body{
        color:white;
        background-color: black;
        text-align:center;
        background-size:100%;
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
        height: 37px;
        width: 138px;
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
    div{
        background: rgba(0, 0, 0, 0.2);
    }

    ::-webkit-scrollbar {
        width: 14px;
        height: 14px;
    }

    ::-webkit-scrollbar-track,
    ::-webkit-scrollbar-thumb {
        border-radius: 999px;
        border: 5px solid transparent;
    }

    ::-webkit-scrollbar-track {
        box-shadow: 1px 1px 5px rgba(0,0,0,.2) inset;
    }

    ::-webkit-scrollbar-thumb {
        min-height: 20px;
        background-clip: content-box;
        box-shadow: 0 0 0 5px rgba(0,0,0,.2) inset;
    }

    ::-webkit-scrollbar-corner {
        background: transparent;
    }
</style>
</html>

