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
    <title>OSTIS - Main Dashboard</title>
    <link rel="stylesheet" href="../css/jquery-ui.min.css" type="text/css">
    <link href="../css/bootstrap.min.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="../js/jquery-2.1.4.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../js/jquery-ui.js"></script>
    <script type="text/javascript" src="../js/GeoJSON.js"></script>
    <%--<script type="text/javascript" src="../js/rainbowvis.js"></script>--%>
    <%--<link rel="stylesheet" href="../css/theme.css" type="text/css">--%>
    <link rel="stylesheet" href="../css/jslider.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.blue.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.plastic.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.round.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.round.plastic.css" type="text/css">
    <link rel="stylesheet" href="../css/jquery.loadmask.css" type="text/css">
    <link rel="stylesheet" href="../css/style.css" type="text/css">
    <link rel="stylesheet" href="../css/timeline-style.css" type="text/css">
    <link rel="stylesheet" href="../css/reset.css" type="text/css">
    <link rel="stylesheet" href="../css/menu-style.css" type="text/css">
    <link rel="stylesheet" href="../css/sweet-alert.css" type="text/css">
    <!-- end -->

    <!-- bin/jquery.slider.min.js -->
    <script type="text/javascript" src="../js/jshashtable-2.1_src.js"></script>
    <script type="text/javascript" src="../js/jquery.numberformatter-1.2.3.js"></script>
    <script type="text/javascript" src="../js/tmpl.js"></script>
    <script type="text/javascript" src="../js/jquery.dependClass-0.1.js"></script>
    <script type="text/javascript" src="../js/draggable-0.1.js"></script>
    <script type="text/javascript" src="../js/jquery.slider.js"></script>
    <script type="text/javascript" src="../js/highcharts.js"></script>
    <script type="text/javascript" src="../js/highcharts-3d.js"></script>
    <script type="text/javascript" src="../js/exporting.js"></script>

    <script type="text/javascript" src="../js/jsGradient.js"></script>
    <script type="text/javascript" src="../js/zipregions.js"></script>
    <script type="text/javascript" src="../js/jquery.loadmask.js"></script>
    <script type="text/javascript" src="../js/jquery.mobile.custom.min.js"></script>
    <script type="text/javascript" src="../js/main-timeline.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/modernizr.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/cron.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/jquery.timelinr-0.9.6.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/menu-main.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/sweet-alert.js"></script> <!-- Resource jQuery -->

    <%--<script type="text/javascript" src="../js/jquery.easing.1.3.js"></script> <!-- Resource jQuery -->--%>
    <%--<script type="text/javascript" src="../js/jquery.easing.compatibility.js"></script> <!-- Resource jQuery -->--%>
    <script type="text/javascript">
        var total = 0;
        var features = [];

        var map;
        currentFeature_or_Features = null;

        var geojson_Polygon = null;
        var geojson_MultiPolygon = null;

        var roadStyle = {
            strokeColor: "#FFFF00",
            strokeWeight: 7,
            strokeOpacity: 0.75
        };

        var addressStyle = {
            icon: "img/marker-house.png"
        };

        var parcelStyle = {
            strokeColor: "#FF7800",
            strokeOpacity: 1,
            strokeWeight: 2,
            fillColor: "#46461F",
            fillOpacity: 0.25
        };

        var infowindow = new google.maps.InfoWindow();

        function init() {
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 7,
                center: new google.maps.LatLng(48.4663, -55.8457),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                keyboardShortcuts: false,
//                disableDefaultUI: true,
                streetViewControl: false,
                mapTypeControl: false
            });
            var legend = document.getElementById('legend');
            map.controls[google.maps.ControlPosition.LEFT_BOTTOM].push(legend);
            $("#timeline").timelinr({
                autoPlay: 'true',
                autoPlayDirection: 'forward'
            });

        }
        function clearFilter(){
            $(".disease-selector").removeClass("active");
            $(".comorbidity-selector").removeClass("active");
            $("#minYear").val("");
            $("#maxYear").val("");
            $("#minAge").val("");
            $("#maxAge").val("");
            $("#sex").val("*");
            $("#healthcare").val("*");
            $("#mortality").val("*");
            $("#timeline").timelinr({
                autoPlay: 'true',
                autoPlayDirection: 'forward'
            });
        }
        function clearMap() {
            clearLegend();
            infowindow.close();
            $("#table-container").html("");
            for (var feature in features) {
                cf = features[feature];
                if (!cf)
                    return;
                if (cf.length) {
                    for (var i = 0; i < cf.length; i++) {
                        if (cf[i].length) {
                            for (var j = 0; j < cf[i].length; j++) {
                                cf[i][j].setMap(null);
                            }
                        }
                        else {
                            cf[i].setMap(null);
                        }
                    }
                } else {
                    cf.setMap(null);
                }
            }
            if (infowindow.getMap()) {
//infowindow.close();
            }
        }
        function showFeature(geojson, color, postCode, count, style) {
            ff = {"fillColor": color, "weight": 5, "fillOpacity": 0.8, "strokeColor": 'black', "strokeWidth": 1}
            currentFeature_or_Features = new GeoJSON(geojson, ff || null);
            features.push(currentFeature_or_Features);
            currentFeature_or_Features.strokeWidth = 10;
            if (currentFeature_or_Features.type && currentFeature_or_Features.type == "Error") {
                document.getElementById("put_geojson_string_here").value = currentFeature_or_Features.message;
                return;
            }
            if (currentFeature_or_Features.length) {
                for (var i = 0; i < currentFeature_or_Features.length; i++) {
                    if (currentFeature_or_Features[i].length) {
                        for (var j = 0; j < currentFeature_or_Features[i].length; j++) {
                            currentFeature_or_Features[i][j].setMap(map);
                            if (currentFeature_or_Features[i][j].geojsonProperties) {
                                setInfoWindow(currentFeature_or_Features[i][j]);
                            }
                        }
                    }
                    else {

                        currentFeature_or_Features[i].setMap(map);
                    }
                    if (currentFeature_or_Features[i].geojsonProperties) {
                        setInfoWindow(currentFeature_or_Features[i]);
                    }
                }
            } else {
                currentFeature_or_Features.setMap(map)
                if (currentFeature_or_Features.geojsonProperties) {
                    setInfoWindow(currentFeature_or_Features);
                }
            }
        }
        function rawGeoJSON() {
            currentFeature_or_Features = new GeoJSON(JSON.parse(document.getElementById("put_geojson_string_here").value));
            if (currentFeature_or_Features.length) {
                for (var i = 0; i < currentFeature_or_Features.length; i++) {
                    if (currentFeature_or_Features[i].length) {
                        for (var j = 0; j < currentFeature_or_Features[i].length; j++) {
                            currentFeature_or_Features[i][j].setMap(map);
                            if (currentFeature_or_Features[i][j].geojsonProperties) {
                                setInfoWindow(currentFeature_or_Features[i][j]);
                            }
                        }
                    }
                    else {
                        currentFeature_or_Features[i].setMap(map);
                    }
                    if (currentFeature_or_Features[i].geojsonProperties) {
                        setInfoWindow(currentFeature_or_Features[i]);
                    }
                }
            } else {
                currentFeature_or_Features.setMap(map);
                if (currentFeature_or_Features.geojsonProperties) {
                    setInfoWindow(currentFeature_or_Features);
                }
            }
        }
        function setInfoWindow(feature) {
            google.maps.event.addListener(feature, "click", function (event) {
                var content = "<div id='infoBox'><strong>Results in this area:</strong><br />";
                var postalcode = "";
                for (var j in this.geojsonProperties) {
                    if(j=="Postal Code"){
                        postalcode = this.geojsonProperties[j];
                    }
                    content += j + ": " + this.geojsonProperties[j] + "<br />";
                }
                content += "<button id='show-in-table-btn' style='margin-top:5px;' onclick='scrollToId(\"ROW-"+postalcode+"\");' class='btn-xs btn btn-info'>Show in table</button> </div>";
                infowindow.setContent(content);
                infowindow.setPosition(event.latLng);
                infowindow.open(map);
            });
        }
        function prepareForShowFeature(ppcode, color, count) {
            for (var i in zipRegions.features) {
//                var bounds = new google.maps.LatLngBounds();
//                console.log(zipRegions.features[i]);
//                for (var j = 0; j < zipRegions.features[i].geometry.coordinates[j][0][0].length; j++) {
//                    bounds.extend(zipRegions.features[i].geometry.coordinates[j][0][0]);
//                }
//                console.log("center: "+bounds.getCenter());
                var targetPpCode = zipRegions.features[i].properties["Postal Code"];
                if (targetPpCode == ppcode) {
                    var geometry = zipRegions.features[i].geometry;
                    var type = geometry.type;
                    type = "geojson_" + type;
                    var percentage = (count / total) * 100;
                    if (type = "Polygon") {
                        geojson_Polygon = geometry;
                        zipRegions.features[i].properties.Description = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                        showFeature(zipRegions.features[i], color, ppcode, count);
                    } else if (type = "MultiPolygon") {
                        geojson_MultiPolygon = geometry;
                        zipRegions.features[i].properties.Description = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                        showFeature(zipRegions.features[i], color, ppcode, count);
                    }
                }
            }
        }
        function sendPieRequest() {
            var minYear = document.getElementById('minPieYear').value;
            var maxYear = document.getElementById('maxPieYear').value;
            $.ajax({
                url: "http://localhost:8080/lineyearservlet?type=pie&minYear=" + minYear + "&maxYear=" + maxYear,
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',
                success: function (data) {
                    var maleData = data.male;
                    var femaleData = data.female;
                    var totalData = data.total;
                    $('#piecontainer').highcharts({
                        chart: {
                            type: 'pie',
                            options3d: {
                                enabled: true,
                                alpha: 45,
                                beta: 0
                            }
                        },
                        title: {
                            text: 'Share between ' + minYear + ' and ' + maxYear
                        },
                        tooltip: {
                            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                depth: 35,
                                dataLabels: {
                                    enabled: true,
                                    format: '{point.name}'
                                }
                            }
                        },
                        series: [
                            {
                                type: 'pie',
                                name: 'Share',
                                data: [
                                    ['Female', femaleData],
                                    ['Male', maleData]
                                ]
                            }
                        ]
                    });
                },
                error: function (data, status, er) {
                    alert("An error occurred. Please try again later.");
                }
            });
        }
        function sendLineRequest() {
            var minYear = document.getElementById('minLineYear').value;
            var maxYear = document.getElementById('maxLineYear').value;
            $.ajax({
                url: "http://localhost:8080/lineyearservlet?type=line&minYear=" + minYear + "&maxYear=" + maxYear,
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',
                success: function (data) {
                    var maleData = data.male;
                    var categories = [];
                    var malePlotData = [];
                    var femalePlotData = [];
                    for (var key in maleData) {
                        categories.push(key);
                        malePlotData.push(maleData[key]);
                    }
                    var femaleData = data.female;
                    for (var key in femaleData) {
                        femalePlotData.push(femaleData[key]);
                    }
                    $('#container').highcharts({
                        title: {
                            text: 'Results between ' + minYear + ' and ' + maxYear + ' per sex',
                            x: -20 //center
                        },
                        xAxis: {
                            categories: categories
                        },
                        yAxis: {
                            title: {
                                text: 'No. of occurrences'
                            },
                            plotLines: [
                                {
                                    value: 0,
                                    width: 1,
                                    color: '#808080'
                                }
                            ]
                        },
                        tooltip: {
                            valueSuffix: ' Individuals'
                        },
                        legend: {
                            layout: 'vertical',
                            align: 'right',
                            verticalAlign: 'middle',
                            borderWidth: 0
                        },
                        series: [
                            {
                                name: 'Male',
                                data: malePlotData
                            },
                            {
                                name: 'Female',
                                data: femalePlotData
                            }
                        ]
                    });
                },
                error: function (data, status, er) {
                    alert("An error occurred. Please try again later.");
                }
            });
        }
        function sendHistoRequest() {
            var minYear = document.getElementById('minHistYear').value;
            var maxYear = document.getElementById('maxHistYear').value;
            $.ajax({
                url: "http://localhost:8080/lineyearservlet?type=histogram&minYear=" + minYear + "&maxYear=" + maxYear,
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',

                success: function (data) {

                    var maleData = data.male;
                    var categories = [];
                    var malePlotData = [];
                    var femalePlotData = [];
                    for (var key in maleData) {
                        categories.push(key);
                        malePlotData.push(maleData[key]);
                    }
                    var femaleData = data.female;
                    for (var key in femaleData) {
                        femalePlotData.push(femaleData[key]);
                    }
                    for (var i in categories) {
                        var str = "<tr><th>" + categories[i] + "</th><td>" + maleData[categories[i]] + "</td><td>" + femaleData[categories[i]] + "</td></tr>";
                        $("#datatableboddy").append(str);
                    }
                    $('#histocontainer').highcharts({
                        chart: {
                            type: 'column'
                        },
                        title: {
                            text: 'Result based on specific age groups'
                        },
                        xAxis: {
                            categories: categories,
                            crosshair: true
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: 'No. of Persons'
                            }
                        },
                        tooltip: {
                            formatter: function () {
                                return '<b>' + this.series.name + '</b><br/>' +
                                        this.point.y + " individuals";
                            }
                        },
                        series: [
                            {
                                name: 'Male',
                                data: malePlotData

                            },
                            {
                                name: 'Female',
                                data: femalePlotData

                            }
                        ]
                    });
                },
                error: function (data, status, er) {
                    alert("An error occurred. Please try again later.");
                }
            });
        }
    </script>
</head>
<body onload="init();">
<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12">
            <div id="tabs">
                <div id="logout-div">

                    <%--<a href="<c:url value="j_spring_security_logout" />" ><i title="Logout" class="fa fa-sign-out fa-2x"></i></a>--%>
                    <a onclick="logout();" href="javascript:void(0);" ><i title="Logout" class="fa fa-sign-out fa-2x"></i></a>
                </div>
                <ul>
                    <li><a href="#tabs-1">Map Search</a></li>
                    <sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-2">Line Chart</a></li></sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-3">Pie Chart</a></li></sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-4">Histogram Chart</a></li></sec:authorize>
                </ul>
                <div id="tabs-1" style="height:100%">
                    <div class="col-xs-12">
                        <div class="col-xs-12">
                            <div class="col-xs-3">
                                <input style="margin-top:10px;" type="button" id="hide-filters-btn" class="btn btn-warning btn-xs" value="Hide Filters"
                                       onclick="toggleFilters();"/>
                            </div>
                            <div class="col-xs-9">
                                <%--<div class="col-xs-1 text-center">--%>
                                    <%--<input type="hidden" id="play_pause_hidden" value="pause"/>--%>
                                    <%--<a href="javascript:void(0);" id="play_pause_a" onclick="playOrPause();"><img id="play_pause_img" src="../images/play.png" width="48" height="48"/></a>--%>
                                <%--</div>--%>
                                <div class="col-xs-12" style="padding: 0; border: 1px solid #E1E1E1; border-radius: 5px; background: #E9E9E9;">
                                    <div class="col-xs-12" style="padding: 0;">
                                        <div id="timeline">
                                            <ul id="dates">
                                                <li><a onclick="prepareSendRequest(1998);" href="javascript:void(0);">1998</a></li>
                                                <li><a onclick="prepareSendRequest(1999);" href="javascript:void(0);">1999</a></li>
                                                <li><a onclick="prepareSendRequest(2000);" href="javascript:void(0);">2000</a></li>
                                                <li><a onclick="prepareSendRequest(2001);" href="javascript:void(0);">2001</a></li>
                                                <li><a onclick="prepareSendRequest(2002);" href="javascript:void(0);">2002</a></li>
                                                <li><a onclick="prepareSendRequest(2003);" href="javascript:void(0);">2003</a></li>
                                                <li><a onclick="prepareSendRequest(2004);" href="javascript:void(0);">2004</a></li>
                                                <li><a onclick="prepareSendRequest(2005);" href="javascript:void(0);">2005</a></li>
                                                <li><a onclick="prepareSendRequest(2006);" href="javascript:void(0);">2006</a></li>
                                                <li><a onclick="prepareSendRequest(2007);" href="javascript:void(0);">2007</a></li>
                                                <li><a onclick="prepareSendRequest(2008);" href="javascript:void(0);">2008</a></li>
                                            </ul>
                                            <ul id="issues">
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 top-margin">
                            <div class="col-xs-3" id="filters">
                                <div class="col-xs-12 text-center" style="margin-bottom: 10px;">
                                    <div class="btn-group">
                                        <input type="button" class="btn btn-primary btn-md" id="search-button" value="Search"
                                               onclick="handleTimeline();prepareSendRequest();"/>
                                        <input type="button" class="btn btn-warning btn-md" value="Clear"
                                               onclick="clearMap();clearFilter();"/>
                                    </div>
                                </div>
                                <div class="col-xs-12 text-center">
                                    <ul class="cd-accordion-menu animated">
                                        <li class="has-children">
                                            <input type="checkbox" name ="disease_type_chk" id="disease_type_chk" checked>
                                            <label for="disease_type_chk">Disease Type</label>
                                            <ul style="display: none;" class="inner-ul-menu">
                                                <li><a class="disease-selector" style="text-decoration: none;" href="javascript:void(0);" onclick="handleActivation(this);" disease="diabetes">Diabetes</a></li>
                                                <li><a class="disease-selector" style="text-decoration: none;" href="javascript:void(0);" onclick="handleActivation(this);" disease="cardiacarrest">Cardiac Arrest</a></li>
                                                <li><a class="disease-selector" style="text-decoration: none;" href="javascript:void(0);" onclick="handleActivation(this);" disease="cancer">Cancer</a></li>
                                                <li><a class="disease-selector" style="text-decoration: none;" href="javascript:void(0);" onclick="handleActivation(this);" disease="hypertension">Hypertension</a></li>
                                            </ul>
                                        </li>
                                        <li class="has-children">
                                            <input type="checkbox" name ="year_chk" id="year_chk" checked>
                                            <label for="year_chk">Year</label>

                                            <ul style="display: none;" class="inner-ul-menu">
                                                <br/>
                                                <li class="input-class"><input type="text" placeholder="From Year..." id="minYear"
                                                           class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To Year..." id="maxYear"
                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li class="has-children">
                                            <input type="checkbox" name ="age_chk" id="age_chk" checked>
                                            <label for="age_chk">Age</label>

                                            <ul style="display: none;" class="inner-ul-menu">
                                                <br/>
                                                <li class="input-class"><input type="text" placeholder="From Age..." id="minAge"
                                                                               class="form-control input-sm"/><br/></li>
                                                <li class="input-class"><input type="text" placeholder="To Age..." id="maxAge"
                                                                               class="form-control input-sm"/><br/></li>
                                            </ul>
                                        </li>
                                        <li class="has-children">
                                            <input type="checkbox" name ="sex_chk" id="sex_chk" checked>
                                            <label for="sex_chk">Sex</label>

                                            <ul style="display: none;" class="inner-ul-menu">
                                                <li class="input-class">
                                                    <br/>
                                                    <select id="sex" class="form-control input-sm">
                                                        <option value="*">All</option>
                                                        <option value="F">Female</option>
                                                        <option value="M">Male</option>
                                                    </select>
                                                    <br/>
                                                </li>
                                            </ul>
                                        </li>
                                        <li class="has-children">
                                            <input type="checkbox" name ="health_chk" id="health_chk" checked>
                                            <label for="health_chk">Healthcare Utilization</label>

                                            <ul style="display: none;" class="inner-ul-menu">
                                                <li class="input-class">
                                                    <br/>
                                                    <select id="healthcare" class="form-control input-sm">
                                                        <option value="*">Not important</option>
                                                        <option value="1">Yes</option>
                                                        <option value="0">No</option>
                                                    </select>
                                                    <br/>
                                                </li>
                                            </ul>
                                        </li>
                                        <li class="has-children">
                                            <input type="checkbox" name ="mortality_chk" id="mortality_chk" checked>
                                            <label for="mortality_chk">Mortality</label>

                                            <ul style="display: none;" class="inner-ul-menu">
                                                <li class="input-class">
                                                    <br/>
                                                    <select id="mortality" class="form-control input-sm">
                                                        <option value="*">Not important</option>
                                                        <option value="1">Yes</option>
                                                        <option value="0">No</option>
                                                    </select>
                                                    <br/>
                                                </li>
                                            </ul>
                                        </li>
                                        <li class="has-children">
                                            <input type="checkbox" name ="comorbidities_chk" id="comorbidities_chk" checked>
                                            <label for="comorbidities_chk">Comorbidities</label>
                                            <ul style="display: none;" class="inner-ul-menu">
                                                <li><a style="text-decoration: none;" class="comorbidity-selector" href="javascript:void(0);" comorbidity="bloodpressure" onclick="handleActivation(this);">Blood Pressure</a></li>
                                                <li><a style="text-decoration: none;" class="comorbidity-selector" href="javascript:void(0);" comorbidity="nausia" onclick="handleActivation(this);">Nausia</a></li>
                                                <li><a style="text-decoration: none;" class="comorbidity-selector" href="javascript:void(0);" comorbidity="dizziness" onclick="handleActivation(this);">Dizziness</a></li>
                                                <li><a style="text-decoration: none;" class="comorbidity-selector" href="javascript:void(0);" comorbidity="seizure" onclick="handleActivation(this);">Seizure</a></li>
                                            </ul>
                                        </li>
                                    </ul>
                                </div>
                                <div class="col-xs-12 text-center">
                                    <div class="btn-group">
                                        <input type="button" class="btn btn-primary btn-md" id="second-search-button" value="Search"
                                               onclick="handleTimeline();prepareSendRequest();"/>
                                        <input type="button" class="btn btn-warning btn-md" value="Clear"
                                               onclick="clearMap();clearFilter();"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-9" id="map-container">
                                <div id="legend" style="width:210px;display: none;"><div style="margin-top:10px;" id="legend-content"></div></div>
                                <div id="map"></div>
                                <div class="btn-group">
                                    <input style="margin-top:10px;" type="button" class="btn btn-primary btn-xs" id="show-legend-button" value="Show Legend"
                                           onclick="showLegend();"/>
                                    <input style="margin-top:10px;" type="button" class="btn btn-warning btn-xs" id="hide-legend-button" value="Hide Legend"
                                           onclick="hideLegend();"/>
                                </div>
                                <div id="table-container">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="clear:both;"></div>
                </div>

                <sec:authorize access="hasRole('ROLE_USER')">
                <div id="tabs-2" style="display: inline-block;margin-top: 10px;width: 100%;">
                    <div class="left">
                        <div id="container" style="height: 500px; margin: 0 auto"></div>
                    </div>
                    <div class="right">
                        <div><br/></div>
                        From Year:&nbsp;<input type="text" placeholder="Minimum Year..." id="minLineYear"
                                               style="width:250px;"/>

                        <div><br/></div>
                        To Year:&nbsp;<input type="text" placeholder="Maximum Year..." id="maxLineYear"
                                             style="width:250px;"/>

                        <div><br/></div>
                        <input type="button" class="btn btn-primary" value="Draw" onclick="sendLineRequest();"/>
                    </div>
                </div>
                <div id="tabs-3" style="display: inline-block;margin-top: 10px;width: 100%;">
                    <div class="left">
                        <div id="piecontainer" style="height: 500px; margin: 0 auto"></div>
                    </div>
                    <div class="right">
                        <div><br/></div>
                        From Year:&nbsp;<input type="text" placeholder="Minimum Year..." id="minPieYear"
                                               style="width:250px;"/>

                        <div><br/></div>
                        To Year:&nbsp;<input type="text" placeholder="Maximum Year..." id="maxPieYear"
                                             style="width:250px;"/>

                        <div><br/></div>
                        <input type="button" class="btn btn-primary" value="Draw" onclick="sendPieRequest();"/>
                    </div>
                </div>
                <div id="tabs-4" style="display: inline-block;margin-top: 10px;width: 100%;">
                    <div class="left">
                        <div id="histocontainer" style="height: 500px; margin: 0 auto"></div>
                    </div>
                    <div class="right">
                        <div><br/></div>
                        From Year:&nbsp;<input type="text" placeholder="Minimum Year..." id="minHistYear"
                                               style="width:250px;"/>

                        <div><br/></div>
                        To Year:&nbsp;<input type="text" placeholder="Maximum Year..." id="maxHistYear"
                                             style="width:250px;"/>

                        <div><br/></div>
                        <input type="button" class="btn btn-primary" value="Draw" onclick="sendHistoRequest();"/>
                    </div>
                </div>
                </sec:authorize>
            </div>
        </div>
    </div>
</div>
<span id="top-link-block" class="hidden">
    <a href="#top" style="background-color: #007FFF;text-decoration: none;" class="well well-sm"  onclick="$('html,body').animate({scrollTop:0},'slow');return false;">
        <i class="fa fa-chevron-up"></i> Back to Map
    </a>
</span>
<script type="text/javascript">
    $('body').click(function(event) {
        if(!$(event.target).parent().parent().parent().parent().is('#map-container')){
            infowindow.close();
        }
    });
    var inervalHolder;
    var isPaused = true;
    if ( ($(window).height() + 100) < $(document).height() ) {
        $('#top-link-block').removeClass('hidden').affix({
            // how far to scroll down before link "slides" into view
            offset: {top:100}
        });
    }
    jQuery(document).ready(function () {
        jQuery("#tabs").tabs();

    });
    function logout(){
        swal({
            title: "Are you sure?",
            text: "You will be logged out of the application. Continue?",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes!",
            closeOnConfirm: false
        },
        function(){
            window.location.href='<c:url value="j_spring_security_logout" />';
        });

    }
    function playOrPause(){
        if($("#play_pause_img").attr("src").indexOf("play")>=0){
            $("#play_pause_hidden").val("pause");
            $("#play_pause_img").attr("src","../images/pause.png");
            isPaused =false;
        }else{
            $("#play_pause_hidden").val("play");
            $("#play_pause_img").attr("src","../images/play.png");
            isPaused =true;
        }

    }
    function handleActivation(elem){
        if($(elem).hasClass("active")){
            $(elem).removeClass("active");
        }else{
            $(elem).addClass("active");
        }
    }
    function hideLegend(){
        $("#legend").hide();
    }
    function showLegend(){
        $("#legend").fadeIn("slow");
    }
    function clearLegend(){
        $("#legend").hide();
        $("#legend-content").html("");
    }
    function toggleFilters(){
        if($("#filters").is(":visible")){
            $("#map-container").css("visibility","hidden");
            $("#filters").hide("slide", { direction: "left" }, "slow",function(){
                $("#hide-filters-btn").removeClass("btn-warning");
                $("#hide-filters-btn").addClass("btn-primary");
                $("#hide-filters-btn").attr("value","Show Filters");
                $("#map-container").removeClass("col-xs-9");
                $("#map-container").addClass("col-xs-12");
                $("#map-container").css("visibility","visible");
                google.maps.event.trigger(map, "resize");
//                init();
            });
        }else{
            $("#map-container").css("visibility","hidden");
            $("#map-container").removeClass("col-xs-12");
            $("#map-container").addClass("col-xs-9");
            $("#filters").show("slide", { direction: "left" }, "slow",function(){
                $("#hide-filters-btn").addClass("btn-warning");
                $("#hide-filters-btn").removeClass("btn-primary");
                $("#hide-filters-btn").attr("value","Hide Filters");
                $("#map-container").css("visibility","visible");
            });
        }
    }
    function handleTimeline(){
        $("#timeline a").removeClass("selected");
    }
    function prepareSendRequest(timelineDate){
        var minAge = document.getElementById('minAge').value;
        var maxAge = document.getElementById('maxAge').value;
        var minYear = 0;
        var maxYear = 0;
        if(timelineDate===undefined){
            minYear = document.getElementById('minYear').value;
            maxYear = document.getElementById('maxYear').value;
        }else{
            minYear = timelineDate;
            maxYear = timelineDate;
        }
        if(parseInt(minYear)>parseInt(maxYear)){
            swal({
                title: "Error!",
                text: "From year can not be larger than To year!",
                type: "error",
                confirmButtonText: "Got it!"
            });
            return;
        }
        if(parseInt(minAge)>parseInt(maxAge)){
            swal({
                title: "Error!",
                text: "From age can not be larger than To age!",
                type: "error",
                confirmButtonText: "Got it!"
            });
            return;
        }
        clearLegend();
        var disease = "";
        $(".disease-selector.active").each(function(){
            disease +=$(this).attr("disease")+",";
        });
        disease = disease.substr(0,disease.length-1);
        var comorbidity = "";
        $(".comorbidity-selector.active").each(function(){
            comorbidity +=$(this).attr("comorbidity")+",";
        })
        comorbidity = comorbidity.substr(0,comorbidity.length-1);
        if(timelineDate===undefined){
//            $("#tabs").mask("<img height='20px' src='../images/loading.gif'/> Processing...");
        }else{
        }

        var sex = document.getElementById('sex').value;
        var healthcare = document.getElementById('healthcare').value;
        var mortality = document.getElementById('mortality').value;

        $.ajax({
            url: "/sendRequest?comorbidity="+comorbidity+"&disease="+disease+"&minYear=" + minYear + "&maxYear=" + maxYear +
            "&healthcare=" + healthcare + "&mortality=" + mortality+ "&minAge=" + minAge + "&maxAge=" + maxAge + "&sex=" + sex,
            type: 'GET',
            dataType: 'json',
            contentType: 'application/json',
            mimeType: 'application/json',
            success: function (data) {
                clearMap();
                var res = JSON.parse(data.facetfieldStr);
                total = data.total;
                var cnt = res.length;
//                var resultGradient = jsgradient.generateGradient('#FFFFFF', '#FF0400', cnt);
//                var rainbow = new Rainbow();
//                rainbow.setSpectrum('red', 'FFFFFF', '#00ff00');
                var resultGradient = jsgradient.generateGradient('#FFFFFF', '#FF0400', cnt);
                cnt = 0;
                for (var i = 0; i < res.length; i++) {
                    if($("#"+res[i].color).length<=0) {
                        $("#legend-content").append("<div id='" + res[i].color + "'><div class='col-xs-1' style='margin-bottom:5px; height:25px;background-color: "+res[i].color+"'></div><div  style='margin-top:8px;margin-bottom:5px; height:25px;' class='col-xs-10'>"+res[i].description+"</div></div>");
                    }
                    prepareForShowFeature(res[i].value, "#"+res[i].color, res[i].count);
                }
                $("#legend-content").append("<div class='col-xs-1' style='margin-bottom:5px; height:25px;background: url(../images/all-legend.png) no-repeat;'></div><div  style='margin-top:8px;margin-bottom:5px; height:25px;' class='col-xs-10'><b style='font-weight: bold;'>Total:</b> "+total+"</div>");
                    createTable(res);
                if(timelineDate===undefined) {
//                    $("#tabs").unmask("<img height='20px' src='../images/loading.gif'/> Processing...");
                }
                showLegend();
            },
            error: function (data, status, er) {
                if(timelineDate===undefined) {
//                    $("#tabs").unmask("<img height='20px' src='../images/loading.gif'/> Processing...");
                }
                alert("An error occurred. Please try again later.");

            }
        });
    }
    function createTable(rows){
        var tableStr = "";
        tableStr="<table class='table'><thead><tr class='reporttable-row'><th>Rank</th><th>Postal Code</th><th>Provice</th><th>Occurance</th></tr></thead><tbody>";
        for(var i=0; i < rows.length; i++){
            tableStr+="<tr class='reporttable-row' id='ROW-"+rows[i].value+"' style='background-color:"+rows[i].color+"'><td>"+(i+1)+"</td><td>"+rows[i].value+"</td><td>Newfoundland & Labrador</td><td>"+rows[i].count+" individuals</td></tr>";
        }
        tableStr+="</tbody></table>";
        $("#table-container").html(tableStr);
    }
    function scrollToId(theId){
        var container = $("body");
        var scrollTo = $("#"+theId);
        $("#table-container tr").removeClass("scrolled");
        scrollTo.addClass("scrolled");
        blinker(scrollTo);
        container.animate({scrollTop:scrollTo.offset().top - (container.offset().top + container.scrollTop()+25)},'slow');
    }
    function blinker(elem){
        elem.fadeOut("slow",function(){
            elem.fadeIn("slow");
        });
    }

</script>
</body>
</html>
