<!DOCTYPE html>
<html lang="en">
<head>
    <title>GMS</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script src="http://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>

    <script>
        var ws
        var logHtml ="";
        var showHtml ="";
        var writeSHtml = "";
        var writeLHtml = "";
        var teaShowStu = "";  //when show stu, show this
        var teaShowL = "";    //when change to insert lessons, show this
        var teaShowT = "";   //show the teacher's tests created by self;
        var teaShowStuWs = "";  //show stus for writeS
        var teaShowTakeTWs = ""; //show take testsfor writeS
        var staHtml = "";
        var setLHtml = "";

        $(document).ready(function() {
            var $ul = $('#log-list');
            ws = new WebSocket('ws://' + window.location.host + '/teacher/TeaEnter');

            ws.onmessage = function(e) {
                $('<li>').text(e.data).appendTo($ul);
                var josnData = JSON.parse(e.data);
                switch (josnData.Type) {
                    case 0:  //TeaJoin
                        $('<li>').text("-->  Tea join!").appendTo($ul);
                        break;
                    case 1:  //TeaShow
                        showHtml="<div id=\"pane\" style=\"width:100%;height:100%;overflow: scroll; float: left;\">\n" +
                            "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">my students</label><br><br>\n" +
                            "                <table>\n" +
                            "                    <thead>\n" +
                            "                    <tr>\n" +
                            "                        <th>TID</th>\n" +
                            "                        <th>SID</th>\n" +
                            "                        <th>SNAME</th>\n" +
                            "                        <th>LID</th>\n" +
                            "                        <th>LNAME</th>\n" +
                            "                        <th>SCORE</th>\n" +
                            "                    </tr>\n" +
                            "                    </thead>\n" +
                            "                    <tbody id=\"aj_data\">\n" +
                            "\n" +
                            "                    </tbody>\n" +
                            "                </table>\n" +
                            "            </div>";
                        $("#content1").html(showHtml);
                        $('<li>').text("-->  TeaShow").appendTo($ul);
                        teaShowStu = "";
                        if(josnData.LTake.TakeL!=null){
                            for (var i = 0; i < josnData.LTake.TakeL.length; i++) { //josnData.LChoice.HaveL.lenght
                                teaShowStu += "<tr>";
                                teaShowStu += "<td>" + josnData.LTake.TakeL[i].TID + "</td>";
                                teaShowStu += "<td>" + josnData.LTake.TakeL[i].SID + "</td>";
                                teaShowStu += "<td>" + josnData.LTake.TakeL[i].SNAME + "</td>";
                                teaShowStu += "<td>" + josnData.LTake.TakeL[i].LID + "</td>";
                                teaShowStu += "<td>" + josnData.LTake.TakeL[i].LNAME + "</td>";
                                teaShowStu += "<td>" + josnData.LTake.TakeL[i].SCORE + "</td>";
                                teaShowStu += "</tr>";
                            }
                        }

                        console.log(teaShowStu);
                        $("#aj_data").html(teaShowStu);
                        break;
                    case 2: //TeaWriteS
                        $('<li>').text("-->  choose lesson!").appendTo($ul);


                        break;
                    case 3: //TeaWriteL
                        $('<li>').text("-->  show my inserted tests !").appendTo($ul);
                        teaShowT = "";
                        if(josnData.TeaT.HaveT!=null)
                        for(var i=0; i<josnData.TeaT.HaveT.length; i++){ //josnData.LChoice.HaveL.lenght
                            teaShowT += "<tr>";
                            teaShowT +=    "<td>"+ josnData.TeaT.HaveT[i].TEID +"</td>";
                            teaShowT +=    "<td>"+ josnData.TeaT.HaveT[i].LID +"</td>";
                            teaShowT +=    "<td>"+ josnData.TeaT.HaveT[i].TEW +"</td>";
                            teaShowT +=    "<td>"+ josnData.TeaT.HaveT[i].TENAME +"</td>";
                            teaShowT += "</tr>";
                        }
                        console.log(teaShowT);
                        $("#myTests").html(teaShowT);
                        break;
                    case 4:  //TeaLogMessage
                        //do nothing
                        break;
                    case 5:  //TeaLoadMyL for writeL
                        $('<li>').text("-->  show load myLessons !").appendTo($ul);
                        teaShowL = "";
                        for(var i=0; i<josnData.TeaL.HaveL.length; i++){ //josnData.LChoice.HaveL.lenght
                            teaShowL += "<tr>";
                            teaShowL +=    "<td>"+ josnData.TeaL.HaveL[i].TID +"</td>";
                            teaShowL +=    "<td>"+ josnData.TeaL.HaveL[i].TNAME +"</td>";
                            teaShowL +=    "<td>"+ josnData.TeaL.HaveL[i].LID +"</td>";
                            teaShowL +=    "<td>"+ josnData.TeaL.HaveL[i].LNAME +"</td>";
                            teaShowL += "</tr>";
                        }
                        console.log(teaShowL);
                        $("#myLessons").html(teaShowL);
                        break;
                    case 6:  //TeaLoadWriteS
                        $('<li>').text("-->  show load writeS !").appendTo($ul);
                        teaShowStusWs = "";
                        //加载学生部分
                        if(josnData.LTake.TakeL!=null){
                            for (var i = 0; i < josnData.LTake.TakeL.length; i++) { //josnData.LChoice.HaveL.lenght
                                teaShowStusWs += "<tr>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].TID + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].SID + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].SNAME + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].LID + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].LNAME + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].SCORE + "</td>";
                                teaShowStusWs += "</tr>";
                            }
                        }
                        console.log(teaShowStusWs);
                        $("#myStusWs").html(teaShowStusWs);

                        //加载考试部分
                        teaShowTakeTWs = "";
                        for(var i=0; i<josnData.TeaTakeT.HaveTakeTs.length; i++){ //josnData.LChoice.HaveL.lenght
                            teaShowTakeTWs += "<tr>";
                            teaShowTakeTWs +=    "<td>"+ josnData.TeaTakeT.HaveTakeTs[i].SID +"</td>";
                            teaShowTakeTWs +=    "<td>"+ josnData.TeaTakeT.HaveTakeTs[i].LID +"</td>";
                            teaShowTakeTWs +=    "<td>"+ josnData.TeaTakeT.HaveTakeTs[i].TEID +"</td>";
                            teaShowTakeTWs +=    "<td>"+ josnData.TeaTakeT.HaveTakeTs[i].PSCORE +"</td>";
                            teaShowTakeTWs += "</tr>";
                        }
                        console.log(teaShowTakeTWs);
                        $("#myStusTakeT").html(teaShowTakeTWs);
                        break;
                    case 7:  //TeaLoadShowLevels
                        $('<li>').text("-->  show load writeS !").appendTo($ul);
                        teaShowStusWs = "";
                        //加载学生部分
                        var teaShowStusWs;
                        if (josnData.LTake.TakeL != null) {
                            for (var i = 0; i < josnData.LTake.TakeL.length; i++) { //josnData.LChoice.HaveL.lenght
                                teaShowStusWs += "<tr>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].TID + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].SID + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].SNAME + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].LID + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].LNAME + "</td>";
                                teaShowStusWs += "<td>" + josnData.LTake.TakeL[i].SCORE + "</td>";
                                if (document.getElementById('AB').value < JSON.stringify(josnData.LTake.TakeL[i].SCORE)) {
                                    teaShowStusWs += "<td>" + "A" + "</td>";
                                    teaShowStusWs += "</tr>";
                                    continue;
                                } else if (document.getElementById('BC').value < JSON.stringify(josnData.LTake.TakeL[i].SCORE)) {
                                    teaShowStusWs += "<td>" + "B" + "</td>";
                                    teaShowStusWs += "</tr>";
                                    continue;
                                } else if (document.getElementById('CD').value < JSON.stringify(josnData.LTake.TakeL[i].SCORE)) {
                                    teaShowStusWs += "<td>" + "C" + "</td>";
                                    teaShowStusWs += "</tr>";
                                    continue;

                                } else if (document.getElementById('DE').value < JSON.stringify(josnData.LTake.TakeL[i].SCORE)) {
                                    teaShowStusWs += "<td>" + "D" + "</td>";
                                    teaShowStusWs += "</tr>";
                                    continue;

                                } else {
                                    teaShowStusWs += "<td>" + "E" + "</td>";
                                    teaShowStusWs += "</tr>";
                                }
                            }
                        }
                        console.log(teaShowStusWs);
                        $("#showLevelsStu").html(teaShowStusWs);
                        break;
                }
            }
        })
        function show() {

            var message = {};
            message.Type = "show";
            // var lid = $("#LID").value;
            // var tid = $("#TID").value;
            // var sid = $("#SID").value;
            message.Data = {

            };
            var json = JSON.stringify(message);
            ws.send(json);
            var $ul = $('#log-list');
            $('<li>').text("web send:"+json).appendTo($ul);
        }


        function writeS() {

            writeSHtml=" <div id=\"pane\" style=\"width:70%;float:left;height:100%;\">\n" +
                "            <div id=\"myL\" style=\"width:100%;height:50%; float: left;overflow: scroll\";>\n" +
                "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">my stus</label><br><br>\n" +
                "                <table>\n" +
                "                    <thead>\n" +
                "                    <tr>\n" +
                "                        <th>TID</th>\n" +
                "                        <th>SID</th>\n" +
                "                        <th>SNAME</th>\n" +
                "                        <th>LID</th>\n" +
                "                        <th>LNAME</th>\n" +
                "                        <th>SCORE</th>\n" +
                "                    </tr>\n" +
                "                    </thead>\n" +
                "                    <tbody id=\"myStusWs\">\n" +
                "\n" +
                "                    </tbody>\n" +
                "                </table>\n" +
                "            </div>\n" +
                "            <div id=\"myT\" style=\"width:100%;height:50%; float: left;overflow: scroll;\">\n" +
                "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">my stus grade</label><br><br>\n" +
                "                <table>\n" +
                "                    <thead>\n" +
                "                    <tr>\n" +
                "                        <th>SID</th>\n" +
                "                        <th>LID</th>\n" +
                "                        <th>TEID</th>\n" +
                "                        <th>PSCORE</th>\n" +
                "                    </tr>\n" +
                "                    </thead>\n" +
                "                    <tbody id=\"myStusTakeT\">\n" +
                "\n" +
                "                    </tbody>\n" +
                "                </table>\n" +
                "            </div>    \n" +
                "        </div>\n" +
                "            <div id=\"write\" style=\"height:80%;width:30%;background: rgba(0, 0, 0, 0.05);overflow: scroll; float: right;\">\n" +
                "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">write scores for stus</label><br>\n" +
                "                \n" +
                "                <p style=\"float: left; padding-left:40px;\" >\n" +
                "                    <label style=\"font-size:16px;float:left;\"> LESSON ID</label>\n" +
                "                    <input style=\"float:right\" id=\"LIDws\" type=\"text\" placeholder=\"lesson id\" required=\"required\"><br><br>\n" +
                "                    <label style=\"font-size:16px;float:left;\"> TEST ID</label>\n" +
                "                    <input style=\"float:right\" id=\"TEIDws\" type=\"text\" placeholder=\"test id\" required=\"required\"><br><br>\n" +
                "                    <label style=\"font-size:16px;float:left;\"> STU ID</label>\n" +
                "                    <input style=\"float:right\" id=\"SIDws\" type=\"text\" placeholder=\"stu id\" required=\"required\"><br><br>\n" +
                "                    <label style=\"font-size:16px;float:left;\"> PART SCORE</label>\n" +
                "                    <input style=\"float:right\" id=\"PSCOREws\" type=\"text\" placeholder=\"part score\" required=\"required\"><br><br>\n" +
                "                    <button id=\"btWriteLSubmit\" type=\"submit\" onclick=\"writeSSubmit()\">submit</button>\n" +
                "                    <button id=\"btRestWriteL\" onclick=\"screen()\" >screen </button><br>\n" +
                "                </p>\n"+
                "            </div>\n"+
                "                <div id=\"ATTENTION\" style=\"height:20%;width:30%;background: rgba(0, 0, 0, 0.05);overflow: scroll; float: bottom;\">\n" +
                "     <br>                " +
                "<label style=\"color:yellow; font-weight:bold; font-size:15px;font-family:\'Italic\';float:left;\"> SCREE WORKS BY FILL LESSON ID AND TEST ID</label>\n" +
                "            </div>";
            $("#content1").html(writeSHtml);
            $("#aj_data").html(teaShowStu);

            var message = {};
            message.Type = "loadWriteS";
            message.Data = {
            };
            var json = JSON.stringify(message);
            ws.send(json);

            var $ul = $('#log-list');
            $('<li>').text("web send:"+json).appendTo($ul);
        };


        function screen()
        {
            if(document.getElementById('LIDws').value.lenght === "" ||
                document.getElementById('TEIDws').value === ""
            ){
                alert("Lesson id and test id cannot be null!");
                return ;
            }
            alert("wating for creating ^_^! ");
        }

        //登入分数
        function writeSSubmit(){
            if(document.getElementById('LIDws').value.lenght === "" ||
                document.getElementById('TEIDws').value === "" ||
                document.getElementById('SIDws').value.lenght === "" ||
                document.getElementById('PSCOREws').value === ""
            ){
                alert("input cannot be null!");
                return ;
            }
            var message = {};
            message.Type = "writeS";
            message.Data = {
                "LIDws":document.getElementById('LIDws').value,
                "TEIDws":document.getElementById('TEIDws').value,
                "SIDws":document.getElementById('SIDws').value,
                "PSCOREws":document.getElementById('PSCOREws').value,
            };
            var json = JSON.stringify(message);
            ws.send(json);
        }

        function writeL() {   //这里的writeL 为 write Test for Lesson

            writeLHtml=" <div id=\"pane\" style=\"width:70%;float:left;height:100%;\">\n" +
                "            <div id=\"myL\" style=\"width:100%;height:50%; float: left;overflow: scroll\";>\n" +
                "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">my lessons</label><br><br>\n" +
                "                <table>\n" +
                "                    <thead>\n" +
                "                    <tr>\n" +
                "                        <th>TID</th>\n" +
                "                        <th>TNAME</th>\n" +
                "                        <th>LID</th>\n" +
                "                        <th>LNAME</th>\n" +
                "                    </tr>\n" +
                "                    </thead>\n" +
                "                    <tbody id=\"myLessons\">\n" +
                "\n" +
                "                    </tbody>\n" +
                "                </table>\n" +
                "            </div>\n" +
                "            <div id=\"myT\" style=\"width:100%;height:50%; float: left;overflow: scroll;\">\n" +
                "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">my tests</label><br><br>\n" +
                "                <table>\n" +
                "                    <thead>\n" +
                "                    <tr>\n" +
                "                        <th>TEID</th>\n" +
                "                        <th>LID</th>\n" +
                "                        <th>TEW</th>\n" +
                "                        <th>TNAME</th>\n" +
                "                    </tr>\n" +
                "                    </thead>\n" +
                "                    <tbody id=\"myTests\">\n" +
                "\n" +
                "                    </tbody>\n" +
                "                </table>\n" +
                "            </div>    \n" +
                "        </div>\n" +
                "            <div id=\"write\" style=\"height:80%;width:30%;background: rgba(0, 0, 0, 0.05);overflow: scroll; float: right;\">\n" +
                "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">write Lesson Tests</label><br>\n" +
                "                \n" +
                    "                <p style=\"float: left; padding-left:40px;\" >\n" +
                "                    <label style=\"font-size:16px;float:left;\"> LESSON ID</label>\n" +
                "                    <input style=\"float:right\" id=\"LID\" type=\"text\" placeholder=\"lesson id\" required=\"required\"><br><br>\n" +
                "                    <label style=\"font-size:16px;float:left;\"> TEST ID</label>\n" +
                "                    <input style=\"float:right\" id=\"TEID\" type=\"text\" placeholder=\"test id\" required=\"required\"><br><br>\n" +
                "                    <label style=\"font-size:16px;float:left;\"> TEST WEIGHT</label>\n" +
                "                    <input style=\"float:right\" id=\"TEW\" type=\"text\" placeholder=\"test weight\" required=\"required\"><br><br>\n" +
                "                    <label style=\"font-size:16px;float:left;\"> TEST NAME</label>\n" +
                "                    <input style=\"float:right\" id=\"TENAME\" type=\"text\" placeholder=\"test name\" required=\"required\"><br><br>\n" +
                "                    <button id=\"btWriteLSubmit\" type=\"submit\" onclick=\"writeLSubmit()\">submit</button>\n" +
                "                    <button id=\"btRestWriteL\" type=\"reset\" >reset</button><br>\n" +
                "                </p>\n"+

                "            </div>\n"+
            "                <div id=\"ATTENTION\" style=\"height:20%;width:30%;background: rgba(0, 0, 0, 0.05);overflow: scroll; float: bottom;\">\n" +
            "     <br>                " +
                "<label style=\"color:yellow; font-weight:bold; font-size:15px;font-family:\'Italic\';float:left;\"> FOR ONE LID, SUM OF WEIGHTS SHALL BE 1</label>\n" +
                "            </div>";
            $("#content1").html(writeLHtml);
            //$("#aj_data").html(teaShowStu);
            var $ul = $('#log-list');
            $('<li>').text("web send:"+json).appendTo($ul);
            var message = {};
            message.Type = "loadMyL";
            // var lid = $("#LID").value;showLevels()
            // var teid = $("#TEID").value;
            // var tew = $("#TEW").value;
            // var teName = $("#TENAME").value;
            message.Data = {
                };
            var json = JSON.stringify(message);
            ws.send(json);

        }
    function writeLSubmit() {
        var message = {};
        message.Type = "writeL";
        // var lid = $("#LID").value;
        // var teid = $("#TEID").value;
        // var tew = $("#TEW").value;
        // var teName = $("#TENAME").value;
        message.Data = {
            "LID":document.getElementById('LID').value,
            "TEID":document.getElementById('TEID').value,
            "TEW":document.getElementById('TEW').value,
            "TENAME":document.getElementById('TENAME').value,
        };
        var json = JSON.stringify(message);
        ws.send(json);
    }

    function stat() {
        var message = {};
        message.Type = "stat";
        message.Data = {
        };
        var json = JSON.stringify(message);
        ws.send(json);
    }

    function showLevels() {
        writeLHtml="<div id=\"pane\" style=\"width:70%;height:100%;overflow: scroll; float: left;\">\n" +
            "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">my students</label><br><br>\n" +
            "                <table>\n" +
            "                    <thead>\n" +
            "                    <tr>\n" +
            "                        <th>TID</th>\n" +
            "                        <th>SID</th>\n" +
            "                        <th>SNAME</th>\n" +
            "                        <th>LID</th>\n" +
            "                        <th>LNAME</th>\n" +
            "                        <th>SCORE</th>\n" +
            "                        <th>LEVEL</th>\n" +
            "                    </tr>\n" +
            "                    </thead>\n" +
            "                    <tbody id=\"showLevelsStu\">\n" +
            "\n" +
            "                    </tbody>\n" +
            "                </table>\n" +
            "            </div>\n"+
            "            <div id=\"write\" style=\"height:100%;width:30%;background: rgba(0, 0, 0, 0.05);overflow: scroll; float: right;\">\n" +
            "                <label style=\"font-size:25px;float:top; font-family:'Monospac821 BT';\">set levels</label><br><br><br>\n" +
            "                \n" +
            "                <p style=\"float: left; padding-left:40px;\" >\n" +
            "                    <label style=\"font-size:14px;float:left;\"> AB divider value</label>\n" +
            "                    <input style=\"float:right\" id=\"AB\" type=\"text\" placeholder=\"AB\" required=\"required\"><br><br>\n" +
            "                    <label style=\"font-size:14px;float:left;\">BC divider value</label>\n" +
            "                    <input style=\"float:right\" id=\"BC\" type=\"text\" placeholder=\"BC\" required=\"required\"><br><br>\n" +
            "                    <label style=\"font-size:14px;float:left;\"> CD divider value</label>\n" +
            "                    <input style=\"float:right\" id=\"CD\" type=\"text\" placeholder=\"CD\" required=\"required\"><br><br>\n" +
            "                    <label style=\"font-size:14px;float:left;\"> DE divider value</label>\n" +
            "                    <input style=\"float:right\" id=\"DE\" type=\"text\" placeholder=\"DE\" required=\"required\"><br><br>\n" +
            "                    <button id=\"btWriteLSubmit\" type=\"submit\" onclick=\"setLevels()\">submit</button>\n" +
            "                </p>\n"+

            "            </div>\n";
        $("#content1").html(writeLHtml);
    }
    function setLevels(){
        var message = {};
        message.Type = "loadShowLevels";
        // var lid = $("#LID").value;
        // var tid = $("#TID").value;
        // var sid = $("#SID").value;
        message.Data = {

        };
        var json = JSON.stringify(message);
        ws.send(json);
        var $ul = $('#log-list');
        $('<li>').text("web send:"+json).appendTo($ul);
    }


    </script>
</head>
<body>
<div id="container">
    <div>
        <h1>welcome! Dear {{.UserName}}</h1>
    </div>
    <div style="height:600px;float:left;">
        <div id="menu" style="background: rgba(255, 255, 255, -0.2);height:600px;float:top;">
            <label style="font-size:25px;float:top; font-family:'Monospac821 BT';">menu</label><br><br>
            <button id="btShow" onclick="show()">show students</button><br><br>
            <button id="btWriteS" onclick="writeS()">write scores</button><br><br>
            <button id="btWriteL" onclick="writeL()">write lessons</button><br><br>
            <button id="btWriteL" onclick="stat()">statistic</button><br><br>
            <button id="btWriteL" onclick="showLevels()">show levels</button><br><br>
        </div>
{{/*        <div id="menu2" style="background: rgba(0, 0, 0, 0.3);height:300px;float:bottom;">*/}}

{{/*        </div>*/}}
    </div>
    <div style="float:left">
        <div id="content1" style="align:center;background: rgba(0, 0, 0, 0.05);height:420px;width:1195px;float:top;">
            <div id="pane" style="width:70%;height:100%; float: left;overflow: scroll;">
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
            <div id="write" style="height:100%;width:30%;background: rgba(0, 0, 0, 0.05); overflow: scroll;float: right;">
                <label style="font-size:25px;float:top; font-family:'Monospac821 BT';">write Scores</label><br><br>

            </div>
        </div>
        <div id="content2" style="height:180px;width:1195px;float:bottom;background: rgba(255, 255, 255, 0.05);overflow:scroll;">
            <label style="font-size:15px;float:top; font-family:'Monospac821 BT';">operation & socket log</label><br><br>
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
        background-image:url('../static/img/teaB3.png');
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