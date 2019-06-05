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
            ws = new WebSocket('ws://' + window.location.host + '/stu/StuEnter');

            ws.onmessage = function(e) {
                $('<li>').text(e.data).appendTo($ul);
                var josnData = JSON.parse(e.data);
                switch (josnData.Type){
                    case 0:  //StuJoin
                        $('<li>').text("-->  stu join!").appendTo($ul);
                        break;
                    case 1:  //StuLoadlessosn
                        $('<li>').text("-->  load lesson!").appendTo($ul);
                        stuLessons = "";
                        for(var i=0; i<josnData.LChoice.HaveL.length; i++){ //josnData.LChoice.HaveL.lenght
                            stuLessons += "<tr>";
                            stuLessons +=    "<td>"+ josnData.LChoice.HaveL[i].TID +"</td>";
                            stuLessons +=    "<td>"+ josnData.LChoice.HaveL[i].TNAME +"</td>";
                            stuLessons +=    "<td>"+ josnData.LChoice.HaveL[i].LID +"</td>";
                            stuLessons +=    "<td>"+ josnData.LChoice.HaveL[i].LNAME +"</td>";
                            stuLessons += "</tr>";
                        }
                        console.log(stuLessons);
                        $("#aj_data").html(stuLessons);
                        break;
                    case 2: //stu choose Lessons
                        $('<li>').text("-->  choose lesson!").appendTo($ul);
                        break;
                    case 3: //stu show choose L
                        $('<li>').text("-->  show choose lesson!").appendTo($ul);
                        stuChooseL = "";
                        for(var i=0; i<josnData.LTake.TakeL.length; i++){ //josnData.LChoice.HaveL.lenght
                            stuChooseL += "<tr>";
                            stuChooseL +=    "<td>"+ josnData.LTake.TakeL[i].SID +"</td>";
                            stuChooseL +=    "<td>"+ josnData.LTake.TakeL[i].TID +"</td>";
                            stuChooseL +=    "<td>"+ josnData.LTake.TakeL[i].TNAME +"</td>";
                            stuChooseL +=    "<td>"+ josnData.LTake.TakeL[i].LID +"</td>";
                            stuChooseL +=    "<td>"+ josnData.LTake.TakeL[i].LNAME +"</td>";
                            stuChooseL +=    "<td>"+ josnData.LTake.TakeL[i].SCORE +"</td>";
                            stuChooseL += "</tr>";
                        }
                        console.log(stuChooseL);
                        $("#haveChooseL").html(stuChooseL);
                        break;
                    case 4:  //stu log msg
                        break;
                }

                console.log("from client's message!"+ typeof(e.data) + typeof(josnData));
                //for(var i in)
                //ws.send("from client's message!"+ typeof(e.data));
                stuHtml += "<tr>";
                stuHtml +=    "<td>"+ josnData.Message +"</td>";
                stuHtml +=    "<td>"+ josnData.From +"</td>";
                stuHtml +=    "<td>"+ josnData.To +"</td>";
                stuHtml += "</tr>";
                //$("#aj_data").html(stuHtml);
            };

        });


        function chooseL() {
            // alert("btSend  triggered!");
            //alert("chooseL need to implement");
            // document.getElementById('content1').innerHTML =
            //     "hello world";
            // ws.send('chooseL operated!');
            // alert("chooseL need to implement");
            if(document.getElementById('LID').value.lenght == "" ||
                document.getElementById('SID').value == "" ||
                document.getElementById('SID').value == ""
            ){
                alert("input cannot be null!");
                return ;
            }
            if(confirm("sure to choose this lesson？")){
                var message = {};
                message.Type = "chooseL";
                // var lid = $("#LID").value;
                // var tid = $("#TID").value;
                // var sid = $("#SID").value;
                message.Data = {
                    "SID":document.getElementById('SID').value,
                    "TID":document.getElementById('TID').value,
                    "LID":document.getElementById('LID').value,
                };
                var json = JSON.stringify(message);
                ws.send(json);
                var $ul = $('#log-list');
                $('<li>').text("web send:"+json).appendTo($ul);
            }
            else{
                aler("submit abort!");
            }

        };

        function refresh() {
            var message = {};
            message.Type = "refresh";
            // var lid = $("#LID").value;
            // var tid = $("#TID").value;
            // var sid = $("#SID").value;
            message.Data = {

            };
            var json = JSON.stringify(message);
            ws.send(json);
            var $ul = $('#log-list');
            $('<li>').text("web send:"+json).appendTo($ul);
        };


    </script>
</head>
<body>
<div id="container">
    <div>
        <h1>welcome! Dear {{.UserName}}</h1>
    </div>
    <div style="height:600px;float:left;">
        <div id="menu" style="background: rgba(255, 255, 255, 0.3);height:300px;float:top;">
            <label style="font-size:25px;float:top; font-family:'Monospac821 BT';">menu</label><br><br>

            <button id="btResfresh" onclick="refresh()">resfresh</button><br>
        </div>
        <div id="menu" style="background: rgba(0, 0, 0, 0.3);height:300px;float:bottom;">

        </div>
    </div>
    <div style="float:left">
        <div id="content1" style="align:center;background: rgba(0, 0, 0, 0.05);height:300px;width:800px;float:top;overflow:scroll;">
            <label style="font-size:25px;float:top; font-family:'Monospac821 BT';">lesson can choosen</label><br><br>
            <table>
                <thead>
                <tr>
                    <th>TID</th>
                    <th>TNAME</th>
                    <th>LID</th>
                    <th>LNAME</th>
                </tr>
                </thead>
                <tbody id="aj_data">

                </tbody>
            </table>
        </div>
        <div id="content2" style="height:300px;width:800px;float:bottom;background: rgba(255, 255, 255, 0.05);overflow:scroll;">
            <label style="font-size:25px;float:top; font-family:'Monospac821 BT';">lessons have choosen</label><br><br>
            <table >
                <thead>
                <tr>
                    <th>SID</th>
                    <th>TID</th>
                    <th>TNAME</th>
                    <th>LID</th>
                    <th>LNAME</th>
                    <th>SCORE</th>
                </tr>
                </thead>
                <tbody id="haveChooseL">

                </tbody>
            </table>
        </div>
    </div>
    <div style="float: left">
        <div id="operateChooseL" style="background: rgba(255, 255, 255, 0.1);height:300px;width:395px;float:top;">
{{/*            <form id="formMessage" action="" method="post" target="nm_iframe">*/}}
                <p style="float: left; padding-left:40px;" >
                    <label style="font-size:25px;float:top">lesson choosen</label><br><br>
                    <label style="font-size:16px;float:top"> STUDENT ID</label>
                    <input id="SID" type="text" placeholder="student id" required="required"><br><br>
                    <label style="font-size:16px;float:top"> TEACHER ID</label>
                    <input id="TID" type="text" placeholder="teacher id" required="required"><br><br>
                    <label style="font-size:16px;float:top"> LESSON  ID</label>
                    <input id="LID" type="text" placeholder="lesson id" required="required"><br><br>
                    <button id="btChooseL" type="submit" onclick="chooseL()">submit</button>
                    <button id="btRestChooseL" type="reset" >reset</button>
                </p>
                {{/*这里的 onsubmit只是为了提醒用户来输入数据，不提交的form在chrome看来，是不会提示要输入的*/}}
{{/*            </form>*/}}
            {{/*这里的 iframe是用来保证不会在提交表但以后发生跳转*/}}
{{/*            <iframe id="id_iframe" name="nm_iframe" style="display:none;"></iframe>*/}}
        </div>
        <div id="log" style="background: rgba(0, 0, 0, 0.1);height:300px;width:395px;float:bottom;overflow:scroll;">
            log
            <ul id="log-list" ></ul>
        </div>
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
        background-color: white;
        text-align:center;
        background-image:url('../static/img/stuB3.png');
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

