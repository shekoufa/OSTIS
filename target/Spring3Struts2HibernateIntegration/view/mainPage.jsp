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
    <style type="text/css">
        a{
            outline: none !important;
        }
        input{
            outline: none !important;
        }
        #logout-div{
            float: right;
            margin-top:7px;
            margin-right: 10px;
        }
        .left {
            width: 75%;
            height: 535px;
            float: left;
        }

        .right {
            width: 200px;
            height: 500px;
            float: left;
            padding: 10px;
        }

        .right div {
            margin-bottom: 4px;
        }

        .right textarea {
            height: 150px;
            width: 300px;
        }

        .top-margin {
            margin-top: 5px;
        }

        #map {
            height: 500px;
        }

        #infoBox {
            width: 300px;
            color: black;
        }
    </style>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../js/jquery-ui.js"></script>
    <script type="text/javascript" src="../js/GeoJSON.js"></script>
    <link rel="stylesheet" href="../css/jquery-ui.css" type="text/css">
    <link rel="stylesheet" href="../css/theme.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.blue.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.plastic.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.round.css" type="text/css">
    <link rel="stylesheet" href="../css/jslider.round.plastic.css" type="text/css">
    <link rel="stylesheet" href="../css/jquery.loadmask.css" type="text/css">
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
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

        }
        function clearMap() {
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

            document.getElementById("put_geojson_string_here").value = JSON.stringify(geojson);

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
                var content = "<div id='infoBox'><strong>Result for diabetes in this area:</strong><br />";
                for (var j in this.geojsonProperties) {
                    content += j + ": " + this.geojsonProperties[j] + "<br />";
                }
                content += "</div>";
                infowindow.setContent(content);
                infowindow.setPosition(event.latLng);
                infowindow.open(map);
            });
        }
        function prepareForShowFeature(ppcode, color, count) {
            for (var i in zipRegions.features) {
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
        function sendRequest() {
            $("#tabs").mask("<img height='20px' src='../images/loading.gif'/> Processing...");
            var minAge = document.getElementById('minAge').value;
            var maxAge = document.getElementById('maxAge').value;
            var minYear = document.getElementById('minYear').value;
            var maxYear = document.getElementById('maxYear').value;
            var sex = document.getElementById('sex').value;
            $.ajax({
                url: "/sendRequest?minYear=" + minYear + "&maxYear=" + maxYear + "&minAge=" + minAge + "&maxAge=" + maxAge + "&sex=" + sex,
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',
                success: function (data) {
                    clearMap();
                    var res = JSON.parse(data.facetfieldStr);
                    total = data.total;
                    var cnt = res.length;
                    var resultGradient = jsgradient.generateGradient('#FF0000', '#00FF15', cnt);
                    cnt = 0;
                    for (var i = 0; i < res.length; i++) {
                        prepareForShowFeature(res[i].value, resultGradient[i], res[i].count);
                    }
                    $("#tabs").unmask("<img height='20px' src='../images/loading.gif'/> Processing...");
                },
                error: function (data, status, er) {
                    $("#tabs").unmask("<img height='20px' src='../images/loading.gif'/> Processing...");
                    alert("error: " + data + " status: " + status + " er:" + er);

                }
            });
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
                            text: 'Share of diabetes between ' + minYear + ' and ' + maxYear
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
                    alert("error: " + data + " status: " + status + " er:" + er);
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
                            text: 'Result for diabetes between ' + minYear + ' and ' + maxYear + ' per sex',
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
                    alert("error: " + data + " status: " + status + " er:" + er);
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
                            text: 'Result for Diabetes based on specific age groups'
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
                    alert("error: " + data + " status: " + status + " er:" + er);
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
                    <a href="<c:url value="j_spring_security_logout" />" > Logout</a>
                </div>
                <ul>
                    <li><a href="#tabs-1">Map Search</a></li>
                    <sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-2">Line Chart</a></li></sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-3">Pie Chart</a></li></sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-4">Histogram Chart</a></li></sec:authorize>
                </ul>
                <div id="tabs-1">
                    <div class="col-xs-12" style="height: 555px;">
                        <div class="col-xs-12">
                            <div class="col-xs-12">
                                <div class="col-xs-2">
                                    <div class="col-xs-12">From Age:</div>
                                    <div class="col-xs-12">
                                        <sec:authorize access="hasRole('ROLE_USER')">
                                            <input type="text" placeholder="Minimum Age..." id="minAge"
                                                   class="form-control input-sm"/>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('ROLE_GUEST')">
                                            <input value="18" type="hidden" id="minAge"/>
                                            <label>18</label>
                                        </sec:authorize>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <div class="col-xs-12">To Age:</div>
                                    <div class="col-xs-12">
                                        <sec:authorize access="hasRole('ROLE_USER')">
                                            <input type="text" placeholder="Maximum Age..." id="maxAge"
                                                   class="form-control input-sm"/>
                                        </sec:authorize>
                                        <sec:authorize access="hasRole('ROLE_GUEST')">
                                            <input value="99" type="hidden" id="maxAge"/>
                                            <label>99</label>
                                        </sec:authorize>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <div class="col-xs-12">From Year:</div>
                                    <div class="col-xs-12">
                                        <input type="text" placeholder="Minimum Year..." id="minYear"
                                               class="form-control input-sm"/>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <div class="col-xs-12">To Year:</div>
                                    <div class="col-xs-12">
                                        <input type="text" placeholder="Maximum Year..." id="maxYear"
                                               class="form-control input-sm"/>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <div class="col-xs-12">Sex:</div>
                                    <div class="col-xs-12">
                                        <select id="sex" class="form-control input-sm">
                                            <option value="*">All</option>
                                            <option value="F">Female</option>
                                            <option value="M">Male</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <div class="btn-group">
                                        <input type="button" class="btn btn-primary btn-md" id="search-button" value="Search"
                                               onclick="sendRequest();"/>
                                        <input type="button" class="btn btn-warning btn-md" value="Clear"
                                               onclick="clearMap();"/>
                                    </div>
                                </div>
                            </div>
                            <textarea style="display:none;" id="put_geojson_string_here"></textarea>

                            <div style="display:none;"><input type="button" class="btn btn-primary"
                                                              value="Show GeoJSON above"
                                                              onclick="rawGeoJSON();"/></div>
                        </div>
                        <div class="col-xs-12 top-margin">
                            <div id="map"></div>
                        </div>
                    </div>
                    <div style="clear: both"></div>
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
<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery("#tabs").tabs();
    });
</script>
</body>
</html>
