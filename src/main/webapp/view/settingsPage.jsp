<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: Yasaman
  Date: 2015-10-21
  Time: 12:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="OSTIS">
    <title>OSTIS - Settings Dashboard</title>
    <link rel="stylesheet" href="../css/jquery-ui.min.css" type="text/css">
    <link href="../css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="../js/jquery-2.1.4.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/jquery-ui.js"></script>
    <link rel="stylesheet" href="../css/style.css" type="text/css">
    <link rel="stylesheet" href="../css/timeline-style.css" type="text/css">
    <link rel="stylesheet" href="../css/reset.css" type="text/css">
    <link rel="stylesheet" href="../css/sweetalert.css" type="text/css">
    <!-- end -->

    <!-- bin/jquery.slider.min.js -->
    <script type="text/javascript" src="../js/jquery.numberformatter-1.2.3.js"></script>
    <script type="text/javascript" src="../js/jquery.dependClass-0.1.js"></script>
    <script type="text/javascript" src="../js/jsGradient.js"></script>
    <script type="text/javascript" src="../js/jquery.mobile.custom.min.js"></script>
    <script type="text/javascript" src="../js/modernizr.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/jquery.timelinr-0.9.6.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/menu-main.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/sweetalert.min.js"></script> <!-- Resource jQuery -->
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12">
            <div id="tabs">
                <div id="logout-div">

                    <%--<a href="<c:url value="j_spring_security_logout" />" ><i title="Logout" class="fa fa-sign-out fa-2x"></i></a>--%>
                    <a id="loading-spinner" style="display:none;position: absolute;left: 360px;" onclick="void(0);"
                       href="javascript:void(0);"><i class="fa fa-spinner fa-spin fa-2x" aria-hidden="true"></i> loading
                        results...</a>
                    <a href="/list" style="margin-right: 20px;"><i title="Home"
                                                                                                                                      class="fa fa-home fa-2x"></i></a>
                    <a onclick="logout();" href="javascript:void(0);"><i title="Logout"
                                                                         class="fa fa-sign-out fa-2x"></i></a>

                </div>
                <ul>
                    <li><a onclick="initCompareCounter();" href="#tabs-1">Your Preferences</a></li>
                </ul>
                <div id="tabs-1" style="height:100%">
                    In this section you will be able to set your preferences for using the application.
                    <br/>
                    <br/>
                    What would be your favorite coloring scheme to show prevalence on the map?
                    <br/>
                    <br/>
                    <select id="color-preference" onchange="handleColorChange(this);">
                        <option <c:if test="${settings.prevalenceColor == 'default'}">selected</c:if> value="default">Green to Red spectrum (Default)</option>
                        <option <c:if test="${settings.prevalenceColor == 'reverse'}">selected</c:if> value="reverse">Red to Green spectrum</option>
                        <option <c:if test="${settings.prevalenceColor != 'default' && settings.prevalenceColor != 'reverse'}">selected</c:if> value="custom">Choose a custom spectrum</option>
                    </select>
                    <input type="color" id="custom-color" style="display: none;" value="${settings.prevalenceColor}"/>
                    <label id="color-description"></label>
                    <br/>
                    <br/>
                    <input type="button" class="btn btn-sm btn-info" value="Save" onclick="handleSettingsSave();"/>

                </div>

            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    jQuery(document).ready(function () {
        $("#tabs").tabs();
        if($("#color-preference").val()=="default"){
            $("#custom-color").hide("slow",function(){
                $("#color-description").text("This will create a gradient from green to red.")
            });
        }else if($("#color-preference").val()=="reverse"){
            $("#custom-color").hide("slow",function(){
                $("#color-description").text("This will create a gradient from red to green.")
            });
        }else{
            $("#custom-color").show("slow",function(){
                $("#color-description").text("This will create a gradient from white to the specified color. Try to choose darker colors.")
            });

        }
    });
    function logout() {
        swal({
                    title: "Are you sure?",
                    text: "You will be logged out of the application. Continue?",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Yes!",
                    closeOnConfirm: false
                },
                function () {
                    window.location.href = '<c:url value="j_spring_security_logout" />';
                });

    }
    function handleColorChange(obj){
        if($(obj).val()=="default"){
            $("#custom-color").hide("slow",function(){
                $("#color-description").text("This will create a gradient from green to red.")
            });
        }else if($(obj).val()=="reverse"){
            $("#custom-color").hide("slow",function(){
                $("#color-description").text("This will create a gradient from red to green.")
            });
        }else{
            $("#custom-color").show("slow",function(){
                $("#color-description").text("This will create a gradient from white to the specified color. Try to choose darker colors.")
            });
        }
    }
    function handleSettingsSave(){
        var colorChoice = $("#color-preference").val();
        var colorSelected = $("#custom-color").val();
        if(colorChoice == 'default'){
            colorSelected = 'default';
        }else if(colorChoice == 'reverse'){
            colorSelected = 'reverse';
        }
        $.ajax({
            url: '/saveSettings',
            data: {'settings.prevalenceColor': colorSelected},
            type: "post",
            cache: false,
            success:function(data) {
                swal({
                    title: "Done",
                    text: "Your preferences were saved successfully!",
                    type: "info",
                    confirmButtonText: "Ok",
                    closeOnConfirm: true
                    });
            }
        });
    }

</script>
</body>
</html>
