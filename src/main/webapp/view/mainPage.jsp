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
    <link href="../css/accordion.css" rel="stylesheet">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
    <script src="../js/jquery-2.1.4.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script language="javascript" src="https://maps.googleapis.com/maps/api/js?sensor=true&v=3"></script>
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
    <link rel="stylesheet" href="../css/sweetalert.css" type="text/css">
    <!-- end -->

    <!-- bin/jquery.slider.min.js -->
    <script type="text/javascript" src="../js/jshashtable-2.1_src.js"></script>
    <script type="text/javascript" src="../js/jquery.numberformatter-1.2.3.js"></script>
    <script type="text/javascript" src="../js/tmpl.js"></script>
    <script type="text/javascript" src="../js/jquery.dependClass-0.1.js"></script>
    <script type="text/javascript" src="../js/draggable-0.1.js"></script>
    <script type="text/javascript" src="../js/jquery.slider.js"></script>
    <script type="text/javascript" src="../js/highcharts.js"></script>
    <script type="text/javascript" src="../js/highcharts-more.js"></script>
    <script type="text/javascript" src="../js/highcharts-3d.js"></script>
    <script type="text/javascript" src="../js/exporting.js"></script>

    <script type="text/javascript" src="../js/jsGradient.js"></script>
    <script type="text/javascript" src="../js/regions/NL_Forward_Sortation_Area.js"></script>
    <script type="text/javascript" src="../js/regions/NL_Dissemination_Areas.js"></script>
    <script type="text/javascript" src="../js/regions/NL_Local_Areas.js"></script>
    <script type="text/javascript" src="../js/regions/NL_Census_Subdivision.js"></script>
    <script type="text/javascript" src="../js/jquery.loadmask.js"></script>
    <script type="text/javascript" src="../js/jquery.mobile.custom.min.js"></script>
    <script type="text/javascript" src="../js/modernizr.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/cron.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/jquery.timelinr-0.9.6.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/menu-main.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/sweetalert.min.js"></script> <!-- Resource jQuery -->
    <script type="text/javascript" src="../js/timeline-play.js"></script> <!-- Resource jQuery -->

    <%--<script type="text/javascript" src="../js/jquery.easing.1.3.js"></script> <!-- Resource jQuery -->--%>
    <%--<script type="text/javascript" src="../js/jquery.easing.compatibility.js"></script> <!-- Resource jQuery -->--%>
    <script type="text/javascript">
        var total = 0;
        var total1 = 0;
        var total2 = 0;
        var timelineStartYear = 1995;
        var features = [];
        var neededFeatures = [];
        var features1 = [];
        var features2 = [];

        var map;
        var map1;
        var map2;
        currentFeature_or_Features = null;
        currentFeature_or_Features1 = null;
        currentFeature_or_Features2 = null;

        var geojson_Polygon = null;
        var geojson_MultiPolygon = null;

        var roadStyle = {
            strokeColor: "#FFFF00",
            strokeWeight: 2,
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
        var infowindow1 = new google.maps.InfoWindow();
        var infowindow2 = new google.maps.InfoWindow();

        function init() {
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 6,
                scrollwheel: false,
                center: new google.maps.LatLng(51.8567976, -59.5151579),
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
            // add the double-click event listener
            google.maps.event.addListener(marker, 'dblclick', function(event){
                smoothZoom(map, 12, map.getZoom()); // call smoothZoom, parameters map, final zoomLevel, and starting zoom level
            });
        }
        // the smooth zoom function
        function smoothZoom (map, max, cnt) {
            if (cnt >= max) {
                return;
            }
            else {
                z = google.maps.event.addListener(map, 'zoom_changed', function(event){
                    google.maps.event.removeListener(z);
                    smoothZoom(map, max, cnt + 1);
                });
                setTimeout(function(){map.setZoom(cnt)}, 80); // 80ms is what I found to work well on my system -- it might not work well on all systems
            }
        }
        function initCompareCounter() {
            compareRun = 0;
        }
        function initCompare() {
            var latLang = [];
            var correct = [48.5663, -55.8457];
            var adjusted = [50.0663, -59.9457];
            if (compareRun <= 1) {
                latLang = adjusted;
            } else {
                latLang = correct;
            }

            map1 = new google.maps.Map(document.getElementById('map1'), {
                zoom: 7,
                center: new google.maps.LatLng(latLang[0], latLang[1]),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                keyboardShortcuts: false,
//                disableDefaultUI: true,
                streetViewControl: false,
                mapTypeControl: false
            });

            map2 = new google.maps.Map(document.getElementById('map2'), {
                zoom: 7,
                center: new google.maps.LatLng(latLang[0], latLang[1]),
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                keyboardShortcuts: false,
//                disableDefaultUI: true,
                streetViewControl: false,
                mapTypeControl: false
            });
            $("#compare-clear").click();
            $("#comparemaps-container").hide();
            compareRun++;
        }
        function hiddenInit() {
            google.maps.event.trigger(map1, "resize");
            google.maps.event.trigger(map2, "resize");
            google.maps.event.trigger(map1, "resize");
            google.maps.event.trigger(map2, "resize");
        }
        function clearFilter() {
            $(".disease-selector").removeClass("active-filter");
            $(".comorbidity-selector").removeClass("active-filter");
            $("#minYear").val("");
            $("#maxYear").val("");
            $("#minAge").val("");
            $("#maxAge").val("");
            $("#sex").val("*");
            $("#healthcare").val("*");
            $("#mortality").val("*");
            handleTimeline();
//            $("#timeline").timelinr({
//                autoPlay: 'true',
//                autoPlayDirection: 'forward'
//            });
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
        function clearMap1() {
            google.maps.event.trigger(map1, "resize");
            google.maps.event.trigger(map2, "resize");
            for (var feature in features1) {
                cf = features1[feature];
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
        }
        function clearMap2() {
            for (var feature in features2) {
                cf = features2[feature];
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
        }
        function showFeature(geojson, color, postCode, count, style) {
            ff = {"fillColor": color, "weight": 5, "fillOpacity": 0.8, "strokeColor": 'black', "strokeWeight": 2}
            currentFeature_or_Features = new GeoJSON(geojson, ff || null);
            features.push(currentFeature_or_Features);
            currentFeature_or_Features.strokeWeight= 2;
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
                                neededFeatures.push(currentFeature_or_Features[i][j]);
                            }
                        }
                    }
                    else {

                        currentFeature_or_Features[i].setMap(map);
                    }
                    if (currentFeature_or_Features[i].geojsonProperties) {
                        setInfoWindow(currentFeature_or_Features[i]);
                        neededFeatures.push(currentFeature_or_Features[i]);
                    }
                }
            } else {
                currentFeature_or_Features.setMap(map)
                if (currentFeature_or_Features.geojsonProperties) {
                    setInfoWindow(currentFeature_or_Features);
                    neededFeatures.push(currentFeature_or_Features);
                }
            }
        }
        function showFeature1(geojson, color, postCode, count, style) {
            ff = {"fillColor": color, "weight": 1, "fillOpacity": 0.8, "strokeColor": 'black', "strokeWeight": 2}
            currentFeature_or_Features1 = new GeoJSON(geojson, ff || null);
            features1.push(currentFeature_or_Features1);
            currentFeature_or_Features1.strokeWeight= 2;
            if (currentFeature_or_Features1.type && currentFeature_or_Features1.type == "Error") {
                document.getElementById("put_geojson_string_here").value = currentFeature_or_Features1.message;
                return;
            }
            if (currentFeature_or_Features1.length) {
                for (var i = 0; i < currentFeature_or_Features1.length; i++) {
                    if (currentFeature_or_Features1[i].length) {
                        for (var j = 0; j < currentFeature_or_Features1[i].length; j++) {
                            currentFeature_or_Features1[i][j].setMap(map1);
                            if (currentFeature_or_Features1[i][j].geojsonProperties) {
                                setInfoWindow1(currentFeature_or_Features1[i][j]);
                            }
                        }
                    }
                    else {

                        currentFeature_or_Features1[i].setMap(map1);
                    }
                    if (currentFeature_or_Features1[i].geojsonProperties) {
                        setInfoWindow1(currentFeature_or_Features1[i]);
                    }
                }
            } else {
                currentFeature_or_Features1.setMap(map1)
                if (currentFeature_or_Features1.geojsonProperties) {
                    setInfoWindow1(currentFeature_or_Features1);
                }
            }
        }
        function showFeature2(geojson, color, postCode, count, style) {
            ff = {"fillColor": color, "weight": 1, "fillOpacity": 0.8, "strokeColor": 'black', "strokeWeight": 2}
            currentFeature_or_Features2 = new GeoJSON(geojson, ff || null);
            features2.push(currentFeature_or_Features2);
            currentFeature_or_Features2.strokeWeight = 2;
            if (currentFeature_or_Features2.type && currentFeature_or_Features2.type == "Error") {
                document.getElementById("put_geojson_string_here").value = currentFeature_or_Features2.message;
                return;
            }
            if (currentFeature_or_Features2.length) {
                for (var i = 0; i < currentFeature_or_Features2.length; i++) {
                    if (currentFeature_or_Features2[i].length) {
                        for (var j = 0; j < currentFeature_or_Features2[i].length; j++) {
                            currentFeature_or_Features2[i][j].setMap(map2);
                            if (currentFeature_or_Features2[i][j].geojsonProperties) {
                                setInfoWindow2(currentFeature_or_Features2[i][j]);
                            }
                        }
                    }
                    else {

                        currentFeature_or_Features2[i].setMap(map2);
                    }
                    if (currentFeature_or_Features2[i].geojsonProperties) {
                        setInfoWindow2(currentFeature_or_Features2[i]);
                    }
                }
            } else {
                currentFeature_or_Features2.setMap(map2);
                if (currentFeature_or_Features2.geojsonProperties) {
                    setInfoWindow2(currentFeature_or_Features2);

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
            google.maps.event.addListener(feature, "mouseover", function (event) {
                var content = "<div id=''><strong>Results in this area:</strong><br />";
                var postalcode = "";
                for (var j in this.geojsonProperties) {
                    if (j == "Postal Code") {
                        postalcode = this.geojsonProperties[j];
                    }
                    if (j != "Description2" && j != "Description1") {
                        if (j == "Percentage") {
                            content += "Description" + ": " + this.geojsonProperties[j] + "<br />";
                        } else {
                            if (j != "description") {
                                content += j + ": " + this.geojsonProperties[j] + "<br />";
                            }
                        }
                    }
                }
                infowindow.setContent(content);
                infowindow.setPosition(event.latLng);
//                swal({
//                            title: "",
//                            text: content,
//                            html: true,
//                            showCancelButton: true,
//                            confirmButtonColor: "#286090",
//                            confirmButtonText: "Show in table",
//                            closeOnConfirm: true
//                        },
//                        function () {
//                            scrollToId("ROW-" + postalcode);
//                        });
                neededFeatures.forEach(function(element) {
                    element.setOptions({strokeColor: "black"});
                    element.setOptions({strokeWeight: 2});
                    element.setOptions({zIndex: 1});
                });
                feature.setOptions({strokeColor: "#F7D652"});
                feature.setOptions({strokeWeight: 4});
                feature.setOptions({zIndex: 1000});
                infowindow.open(map);
         });
        }
        function setInfoWindow1(feature) {
            google.maps.event.addListener(feature, "click", function (event) {
                var content = "<div id='infoBox1'><strong>Results for 1st comparison:</strong><br />";
                var postalcode = "";
                for (var j in this.geojsonProperties) {
                    if (j == "Postal Code") {
                        postalcode = this.geojsonProperties[j];
                    }
                    if (j != "Description" && j != "Description2") {
                        if (j == "Description1") {
                            content += "Description" + ": " + this.geojsonProperties[j] + "<br />";
                        } else {
                            content += j + ": " + this.geojsonProperties[j] + "<br />";
                        }
                    }
                }
                infowindow1.setContent(content);
                infowindow1.setPosition(event.latLng);
                infowindow1.open(map1);
            });
        }
        function setInfoWindow2(feature) {
            google.maps.event.addListener(feature, "click", function (event) {
                var content = "<div id='infoBox2'><strong>Results for 2nd comparison:</strong><br />";
                var postalcode = "";
                for (var j in this.geojsonProperties) {
                    if (j == "Postal Code") {
                        postalcode = this.geojsonProperties[j];
                    }
                    if (j != "Description" && j != "Description1") {
                        if (j == "Description2") {
                            content += "Description" + ": " + this.geojsonProperties[j] + "<br />";
                        } else {
                            content += j + ": " + this.geojsonProperties[j] + "<br />";
                        }
                    }
                }
                infowindow2.setContent(content);
                infowindow2.setPosition(event.latLng);
                infowindow2.open(map2);
            });
        }
        var showFeatureCount = 0;
        function prepareForShowFeature(ppcode, color, count) {
            var log = document.getElementById("geography-level").value;
            if (log == "fsa") {
                for (var i in zipRegions.features) {
                    var targetPpCode = zipRegions.features[i].properties["Name"];
                    var description = zipRegions.features[i].properties["description"];
                    delete zipRegions.features[i].properties.timestamp;
                    delete zipRegions.features[i].properties.begin;
                    delete zipRegions.features[i].properties.end;
                    delete zipRegions.features[i].properties.tessellate;
                    delete zipRegions.features[i].properties.extrude;
                    delete zipRegions.features[i].properties.visibility;
                    delete zipRegions.features[i].properties.drawOrder;
                    delete zipRegions.features[i].properties.icon;
                    delete zipRegions.features[i].properties.snippet;
                    if (targetPpCode == ppcode) {
                        var geometry = zipRegions.features[i].geometry;
                        var type = geometry.type;
                        type = "geojson_" + type;
                        var percentage = (count / total) * 100;
                        if (type = "Polygon") {
                            geojson_Polygon = geometry;
                            zipRegions.features[i].properties.description = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(zipRegions.features[i], color, ppcode, count);
                        } else if (type = "MultiPolygon") {
                            geojson_MultiPolygon = geometry;
                            zipRegions.features[i].properties.description = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(zipRegions.features[i], color, ppcode, count);
                        }
                    } else {
                    }
                }
            }
            if (log == "DA_UID_11") {
                for (var i in daRegions.features) {
                    var targetPpCode = daRegions.features[i].properties["Name"];
                    var description = daRegions.features[i].properties["description"];
                    delete daRegions.features[i].properties.timestamp;
                    delete daRegions.features[i].properties.begin;
                    delete daRegions.features[i].properties.end;
                    delete daRegions.features[i].properties.tessellate;
                    delete daRegions.features[i].properties.extrude;
                    delete daRegions.features[i].properties.visibility;
                    delete daRegions.features[i].properties.drawOrder;
                    delete daRegions.features[i].properties.icon;
                    delete daRegions.features[i].properties.snippet;
                    if (description.regexIndexOf("^(?=(.|[\n\r])*DAUID)(?=(.|[\n\r])*"+ppcode+")(.|[\n\r])*") > -1) {
                        var geometry = daRegions.features[i].geometry;
                        var type = geometry.type;
                        type = "geojson_" + type;
                        var percentage = (count / total) * 100;
                        if (type = "Polygon") {
                            geojson_Polygon = geometry;
                            daRegions.features[i].properties["myKription"] = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(daRegions.features[i], color, ppcode, count);
                        } else if (type = "MultiPolygon") {
                            geojson_MultiPolygon = geometry;
                            daRegions.features[i].properties["myKription"] = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(daRegions.features[i], color, ppcode, count);
                        }
                    }
                }
            }
            if (log == "LA_ID") {
                for (var i in laRegions.features) {
                    var targetPpCode = laRegions.features[i].properties["Name"];
                    var description = laRegions.features[i].properties["description"];
                    delete laRegions.features[i].properties.timestamp;
                    delete laRegions.features[i].properties.begin;
                    delete laRegions.features[i].properties.end;
                    delete laRegions.features[i].properties.tessellate;
                    delete laRegions.features[i].properties.extrude;
                    delete laRegions.features[i].properties.visibility;
                    delete laRegions.features[i].properties.drawOrder;
                    delete laRegions.features[i].properties.icon;
                    delete laRegions.features[i].properties.snippet;
                    if (description.regexIndexOf("^(?=(.|[\n\r])*AREA_ID)(?=(.|[\n\r])*"+ppcode+")(.|[\n\r])*") > -1) {
                        var geometry = laRegions.features[i].geometry;
                        var type = geometry.type;
                        type = "geojson_" + type;
                        var percentage = (count / total) * 100;
                        if (type = "Polygon") {
                            geojson_Polygon = geometry;
                            laRegions.features[i].properties["Percentage"] = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(laRegions.features[i], color, ppcode, count);
                        } else if (type = "MultiPolygon") {
                            geojson_MultiPolygon = geometry;
                            laRegions.features[i].properties["Percentage"] = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(laRegions.features[i], color, ppcode, count);
                        }
                    }
                }
            }
            if (log == "CSD_UID"){
                for (var i in csRegions.features) {
                    var targetPpCode = csRegions.features[i].properties["Name"];
                    var description = csRegions.features[i].properties["description"];
                    delete csRegions.features[i].properties.timestamp;
                    delete csRegions.features[i].properties.begin;
                    delete csRegions.features[i].properties.end;
                    delete csRegions.features[i].properties.tessellate;
                    delete csRegions.features[i].properties.extrude;
                    delete csRegions.features[i].properties.visibility;
                    delete csRegions.features[i].properties.drawOrder;
                    delete csRegions.features[i].properties.icon;
                    delete csRegions.features[i].properties.snippet;
                    if (description.regexIndexOf("^(?=(.|[\n\r])*CSDUID)(?=(.|[\n\r])*"+ppcode+")(.|[\n\r])*") > -1) {
                        var geometry = csRegions.features[i].geometry;
                        var type = geometry.type;
                        type = "geojson_" + type;
                        var percentage = (count / total) * 100;
                        if (type = "Polygon") {
                            geojson_Polygon = geometry;
                            csRegions.features[i].properties["Percentage"] = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(csRegions.features[i], color, ppcode, count);
                        } else if (type = "MultiPolygon") {
                            geojson_MultiPolygon = geometry;
                            csRegions.features[i].properties["Percentage"] = count + " persons out of " + total + " (" + percentage.toFixed(2) + "%)";
                            showFeature(csRegions.features[i], color, ppcode, count);
                        }
                    }
                }
            }
        }
        function prepareForShowFeature1(ppcode, color, count) {
            for (var i in zipRegions.features) {
                var targetPpCode = zipRegions.features[i].properties["Name"];
                if (targetPpCode == ppcode) {
                    var geometry = zipRegions.features[i].geometry;
                    var type = geometry.type;
                    type = "geojson_" + type;
                    var percentage = (count / total1) * 100;
                    if (type = "Polygon") {
                        geojson_Polygon = geometry;
                        zipRegions.features[i].properties.Description1 = count + " persons out of " + total1 + " (" + percentage.toFixed(2) + "%)";
                        showFeature1(zipRegions.features[i], color, ppcode, count);
                    } else if (type = "MultiPolygon") {
                        geojson_MultiPolygon = geometry;
                        zipRegions.features[i].properties.Description1 = count + " persons out of " + total1 + " (" + percentage.toFixed(2) + "%)";
                        showFeature1(zipRegions.features[i], color, ppcode, count);
                    }
                }
            }
        }
        function prepareForShowFeature2(ppcode, color, count) {
            for (var i in zipRegions.features) {
                var targetPpCode = zipRegions.features[i].properties["Postal Code"];
                if (targetPpCode == ppcode) {
                    var geometry = zipRegions.features[i].geometry;
                    var type = geometry.type;
                    type = "geojson_" + type;
                    var percentage = (count / total2) * 100;
                    if (type = "Polygon") {
                        geojson_Polygon = geometry;
                        zipRegions.features[i].properties.Description2 = count + " persons out of " + total2 + " (" + percentage.toFixed(2) + "%)";
                        showFeature2(zipRegions.features[i], color, ppcode, count);
                    } else if (type = "MultiPolygon") {
                        geojson_MultiPolygon = geometry;
                        zipRegions.features[i].properties.Description2 = count + " persons out of " + total2 + " (" + percentage.toFixed(2) + "%)";
                        showFeature2(zipRegions.features[i], color, ppcode, count);
                    }
                }
            }
        }
        String.prototype.regexIndexOf = function(regex) {
            var match = this.match(regex);
            return match ? this.indexOf(match[0]) : -1;
        };
        function sendChartRequest() {
            $.ajax({
                url: "/sendAgeGroupRequest?disease=" + $("#disease-chart").val(),
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',
                success: function (data) {
                    var info = data.finalChartResult;
                    var categoriesArray = new Array();
                    var maleArray = new Array();
                    var femaleArray = new Array();
                    var averageArray = new Array();
                    var totalMale = 0;
                    var totalFemale = 0;
                    categoriesArray.push("");
                    maleArray.push(null);
                    femaleArray.push(null);
                    averageArray.push(null);

                    categoriesArray.push("");
                    maleArray.push(null);
                    femaleArray.push(null);
                    averageArray.push(null);

                    for (var key in info) {
                        categoriesArray.push(key);
                        totalMale += info[key].m;
                        totalFemale += info[key].f;
                        maleArray.push(info[key].m);
                        femaleArray.push(info[key].f);
                        var average = ((parseInt(info[key].m) + parseInt(info[key].f)) / 2);
                        averageArray.push(average);
                    }
                    var diseaseText = $("#disease-chart").find("option:selected").text();
                    if (diseaseText == "All") diseaseText = "All diseases";
                    $('#chartcontainer').highcharts({
//                        chart: {
//                            type: 'bar'
//                        },
                        title: {
                            text: 'Prevalence of \'' + diseaseText + '\' per sex for different age groups'
                        },
                        xAxis: {
                            categories: categoriesArray,
                            title: {
                                text: null
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: 'Prevalence',
                                align: 'high'
                            },
                            labels: {
                                overflow: 'justify'
                            }
                        },
                        tooltip: {
                            valueSuffix: ' occurrences'
                        },
                        plotOptions: {
                            bar: {
                                dataLabels: {
                                    enabled: true
                                }
                            }
                        },
                        legend: {
                            layout: 'vertical',
                            align: 'left',
                            verticalAlign: 'bottom',
                            x: 75,
                            y: -40,
                            floating: true,
                            borderWidth: 1,
                            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
                            shadow: true
                        },
                        credits: {
                            enabled: false
                        },
                        series: [{
                            type: 'column',
                            name: 'Male',
                            data: maleArray
                        }, {
                            type: 'column',
                            name: 'Female',
                            data: femaleArray
                        }, {
                            type: 'spline',
                            name: 'Average',
                            data: averageArray
                        }, {
                            type: 'pie',
                            name: 'Total occurrences for ' + diseaseText + ' for each sex',
                            data: [{
                                name: 'Male',
                                y: totalMale,
                                color: Highcharts.getOptions().colors[0] // Jane's color
                            }, {
                                name: 'Female',
                                y: totalFemale,
                                color: Highcharts.getOptions().colors[1] // John's color
                            }],
                            center: [160, 95],
                            size: 185,
                            showInLegend: false,
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                            }
                        }]
                    });
                },
                error: function (data, status, er) {
                    alert("An error occurred. Please try again later.");
                }
            });

        }
        function sendDifferentDiseasesRequest() {
            $.ajax({
                url: "/sendDifferentDiseasesRequest?minYear=" + $("#diff_dis_min_year").val() + "&maxYear=" + $("#diff_dis_max_year").val(),
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',
                success: function (data) {
                    var info = data.finalChartResult;
                    var yearsArray = new Array();
                    var cardiacArray = new Array();
                    var cancerArray = new Array();
                    var diabetesArray = new Array();
                    var hypertensionArray = new Array();
                    var totalCancer = 0;
                    var totalCardiac = 0;
                    var totalDiabetes = 0;
                    var totalHypertension = 0;
                    var averageArray = new Array();


                    yearsArray.push("");
                    cardiacArray.push(null);
                    cancerArray.push(null);
                    diabetesArray.push(null);
                    hypertensionArray.push(null);
                    averageArray.push(null);

                    yearsArray.push("");
                    cardiacArray.push(null);
                    cancerArray.push(null);
                    diabetesArray.push(null);
                    hypertensionArray.push(null);
                    averageArray.push(null);

                    for (var key in info) {
                        yearsArray.push(key);
                        cardiacArray.push(info[key].cardiacarrest);
                        totalCardiac += parseInt(info[key].cardiacarrest);
                        cancerArray.push(info[key].cancer);
                        totalCancer += parseInt(info[key].cancer);
                        diabetesArray.push(info[key].diabetes);
                        totalDiabetes += parseInt(info[key].diabetes);
                        hypertensionArray.push(info[key].hypertension);
                        totalHypertension += parseInt(info[key].hypertension);
                        var average = ((parseInt(info[key].cancer) + parseInt(info[key].cardiacarrest) + parseInt(info[key].diabetes) + parseInt(info[key].hypertension)) / 4);
                        averageArray.push(average);
                    }
                    $('#chartcontainer').highcharts({
//                        chart: {
//                            type: 'bar'
//                        },
                        title: {
                            text: 'Prevalence of different diseases from ' + $("#diff_dis_min_year").val() + " to " + $("#diff_dis_max_year").val()
                        },
                        xAxis: {
                            categories: yearsArray,
                            title: {
                                text: null
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: 'Prevalence',
                                align: 'high'
                            },
                            labels: {
                                overflow: 'justify'
                            }
                        },
                        tooltip: {
                            valueSuffix: ' occurrences'
                        },
                        plotOptions: {
                            bar: {
                                dataLabels: {
                                    enabled: true
                                }
                            }
                        },
                        legend: {
                            layout: 'vertical',
                            align: 'left',
                            verticalAlign: 'bottom',
                            x: 75,
                            y: -40,
                            floating: true,
                            borderWidth: 1,
                            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
                            shadow: true
                        },
                        credits: {
                            enabled: false
                        },
                        series: [{
                            type: 'column',
                            name: 'Cardiovascular Disease',
                            data: cardiacArray
                        }, {
                            type: 'column',
                            name: 'Chronic obstructive pulmonary disease',
                            data: cancerArray
                        }, {
                            type: 'column',
                            name: 'Diabetes',
                            data: diabetesArray
                        }, {
                            type: 'column',
                            name: 'Hypertension',
                            data: hypertensionArray
                        }, {
                            type: 'spline',
                            name: 'Average',
                            data: averageArray
                        }
                            , {
                                type: 'pie',
                                name: 'Total occurrences from ' + $("#diff_dis_min_year").val() + " to " + $("#diff_dis_max_year").val(),
                                data: [{
                                    name: 'Cardiovascular Disease',
                                    y: totalCardiac,
                                    color: Highcharts.getOptions().colors[0] // Jane's color
                                }, {
                                    name: 'Hypertension',
                                    y: totalHypertension,
                                    color: Highcharts.getOptions().colors[3] // John's color
                                }, {
                                    name: 'Diabetes',
                                    y: totalDiabetes,
                                    color: Highcharts.getOptions().colors[2] // Jane's color
                                }, {
                                    name: 'Chronic obstructive pulmonary disease',
                                    y: totalCancer,
                                    color: Highcharts.getOptions().colors[1] // Jane's color
                                }],
                                center: [125, 115],
                                size: 150,
                                showInLegend: false,
                                allowPointSelect: true,
                                cursor: 'pointer',
                                dataLabels: {
                                    enabled: true,
                                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                                }
                            }
                        ]
                    });
                },
                error: function (data, status, er) {
                    alert("An error occurred. Please try again later.");
                }
            });

        }
        function sendBubbleChartRequest() {
            $.ajax({
                url: "/sendBubbleChartRequest",
                type: 'GET',
                dataType: 'json',
                contentType: 'application/json',
                mimeType: 'application/json',
                success: function (data) {
//                    var info = data.finalChartResult;
//                    var yearsArray = new Array();
//                    var cardiacArray = new Array();
//                    var cancerArray = new Array();
//                    var diabetesArray = new Array();
//                    var hypertensionArray = new Array();
//                    var totalCancer = 0;
//                    var totalCardiac = 0;
//                    var totalDiabetes = 0;
//                    var totalHypertension = 0;
//                    var averageArray = new Array();
//
//
//                    yearsArray.push("");
//                    cardiacArray.push(null);
//                    cancerArray.push(null);
//                    diabetesArray.push(null);
//                    hypertensionArray.push(null);
//                    averageArray.push(null);
//
//                    yearsArray.push("");
//                    cardiacArray.push(null);
//                    cancerArray.push(null);
//                    diabetesArray.push(null);
//                    hypertensionArray.push(null);
//                    averageArray.push(null);
//
//                    for (var key in info){
//                        yearsArray.push(key);
//                        cardiacArray.push(info[key].cardiacarrest);
//                        totalCardiac+=parseInt(info[key].cardiacarrest);
//                        cancerArray.push(info[key].cancer);
//                        totalCancer+=parseInt(info[key].cancer);
//                        diabetesArray.push(info[key].diabetes);
//                        totalDiabetes+=parseInt(info[key].diabetes);
//                        hypertensionArray.push(info[key].hypertension);
//                        totalHypertension+=parseInt(info[key].hypertension);
//                        var average = ((parseInt(info[key].cancer)+parseInt(info[key].cardiacarrest)+parseInt(info[key].diabetes)+parseInt(info[key].hypertension))/4);
//                        averageArray.push(average);
//                    }
                    $('#chartcontainer').highcharts({
                        chart: {
                            type: 'bubble',
                            plotBorderWidth: 1,
                            zoomType: 'xy'
                        },

                        legend: {
                            enabled: false
                        },

                        title: {
                            text: 'Prevalence of different diseases in different areas'
                        },

                        xAxis: {
                            gridLineWidth: 1,
                            title: {
                                text: 'Different Diseases'
                            }
                        },
                        yAxis: {
                            startOnTick: false,
                            endOnTick: false,
                            title: {
                                text: 'No. of occurrences'
                            },
                            maxPadding: 0.2,
                        },

                        tooltip: {
                            useHTML: true,
                            headerFormat: '<table>',
                            pointFormat: '<tr><th colspan="2"><h3>{point.country}</h3></th></tr>' +
                            '<tr><th>Fat intake:</th><td>{point.x}g</td></tr>' +
                            '<tr><th>Sugar intake:</th><td>{point.y}g</td></tr>' +
                            '<tr><th>Obesity (adults):</th><td>{point.z}%</td></tr>',
                            footerFormat: '</table>',
                            followPointer: true
                        },

                        plotOptions: {
                            series: {
                                dataLabels: {
                                    enabled: true,
                                    format: '{point.name}'
                                }
                            }
                        },

                        series: [{
                            data: [
                                {x: 95, y: 95, z: 13.8, name: 'BE', country: 'Belgium'},
                                {x: 86.5, y: 102.9, z: 14.7, name: 'DE', country: 'Germany'},
                                {x: 80.8, y: 91.5, z: 15.8, name: 'FI', country: 'Finland'},
                                {x: 80.4, y: 102.5, z: 12, name: 'NL', country: 'Netherlands'},
                                {x: 80.3, y: 86.1, z: 11.8, name: 'SE', country: 'Sweden'},
                                {x: 78.4, y: 70.1, z: 16.6, name: 'ES', country: 'Spain'},
                                {x: 74.2, y: 68.5, z: 14.5, name: 'FR', country: 'France'},
                                {x: 73.5, y: 83.1, z: 10, name: 'NO', country: 'Norway'},
                                {x: 71, y: 93.2, z: 24.7, name: 'UK', country: 'United Kingdom'},
                                {x: 69.2, y: 57.6, z: 10.4, name: 'IT', country: 'Italy'},
                                {x: 68.6, y: 20, z: 16, name: 'RU', country: 'Russia'},
                                {x: 65.5, y: 126.4, z: 35.3, name: 'US', country: 'United States'},
                                {x: 65.4, y: 50.8, z: 28.5, name: 'HU', country: 'Hungary'},
                                {x: 63.4, y: 51.8, z: 15.4, name: 'PT', country: 'Portugal'},
                                {x: 64, y: 82.9, z: 31.3, name: 'NZ', country: 'New Zealand'}
                            ]
                        }]

                    });
                },
                error: function (data, status, er) {
                    alert("An error occurred. Please try again later.");
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
<body onload="init();initCompare();">
<div class="container-fluid">
    <div class="row">
        <div class="col-xs-12">
            <div id="tabs">
                <div id="logout-div">

                    <%--<a href="<c:url value="j_spring_security_logout" />" ><i title="Logout" class="fa fa-sign-out fa-2x"></i></a>--%>
                    <a id="loading-spinner" style="display:none;position: absolute;left: 360px;" onclick="void(0);"
                       href="javascript:void(0);"><i class="fa fa-spinner fa-spin fa-2x" aria-hidden="true"></i> loading
                        results...</a>
                    <a href="/settings" onmouseover="handleSpin(this);" onmouseout="handleSpin(this);" style="margin-right: 20px;"><i title="Settings"
                                           class="fa fa-cog fa-2x"></i></a>
                    <a onclick="logout();" href="javascript:void(0);"><i title="Logout"
                                                                         class="fa fa-sign-out fa-2x"></i></a>

                </div>
                <ul>
                    <li><a onclick="initCompareCounter();" href="#tabs-1">Map Search</a></li>
                    <li><a onclick="initCompare();" href="#tabs-2">Comparison</a></li>
                    <li><a onclick="initCompareCounter();" href="#tabs-3">Charts</a></li>
                    <%--<sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-2">Line Chart</a></li></sec:authorize>--%>
                    <%--<sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-3">Pie Chart</a></li></sec:authorize>--%>
                    <%--<sec:authorize access="hasRole('ROLE_USER')"><li><a href="#tabs-4">Histogram Chart</a></li></sec:authorize>--%>
                </ul>
                <div id="tabs-1" style="height:100%">
                    <div class="col-xs-12">
                        <div class="col-xs-12" style="z-index:3;" id="top-functions">
                            <div class="col-xs-1" style="margin-left: -10px; margin-right: 25px;">
                                <input style="margin-top:10px;" type="button" id="hide-filters-btn"
                                       class="btn btn-warning btn-xs" value="Hide Filters"
                                       onclick="toggleFilters();"/>
                            </div>
                            <div class="text-center search-top-history">
                                <div class="btn-group" style="z-index:4;">
                                    <input type="button" class="btn btn-primary btn-md" id="search-button"
                                           value="Search"
                                           onclick="hideFilters();prepareSendRequest();"/>
                                    <input type="button" class="btn btn-warning btn-md" value="Clear"
                                           onclick="clearMap();clearFilter();"/>
                                </div>
                                <div class="">
                                        <input type="checkbox" id="save-queries"/>&nbsp;<label style="margin-top:6px;">Save
                                        Queries</label>
                                </div>
                            </div>

                            <div class="" id="timeline-wrapper">
                                <div class="col-xs-12"
                                     style="padding: 0; border: 1px solid #E1E1E1; border-radius: 5px; background: #E9E9E9;">
                                    <div class="col-xs-12" style="padding: 0;">
                                        <div id="timeline-play-wrapper">
                                            <a href="javascript:void(0);" onclick="togglePlay();"><i id="play-status" title="Time play" class="fa fa-play-circle fa-2x"></i></a>
                                            <label style="margin-left: 5px;margin-top: 15px;">Timeline:</label>
                                        </div>
                                        <div id="timeline">
                                            <ul id="dates">

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
                                <div class="col-xs-12 text-center">
                                    <jsp:include page="accordion-menu.jsp"/>
                                </div>
                                <div class="col-xs-12 text-center" style="margin-top:5px;">
                                    <div class="btn-group">
                                        <input type="button" class="btn btn-primary btn-md" id="second-search-button"
                                               value="Search"
                                               onclick="hideFilters();prepareSendRequest();"/>
                                        <input type="button" class="btn btn-warning btn-md" value="Clear"
                                               onclick="clearMap();clearFilter();"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-12" id="map-container">
                                <div id="legend" style="width:210px;display: none;">
                                    <div style="margin-top:10px;" id="legend-content"></div>
                                </div>
                                <div id="map"></div>
                                <div class="btn-group">
                                    <input style="margin-top:10px;" type="button" class="btn btn-primary btn-xs"
                                           id="show-legend-button" value="Show Legend"
                                           onclick="showLegend();"/>
                                    <input style="margin-top:10px;" type="button" class="btn btn-warning btn-xs"
                                           id="hide-legend-button" value="Hide Legend"
                                           onclick="hideLegend();"/>
                                </div>
                                <div id="statistics-container" style="margin-top: 20px; display:none;">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div style="display: inline-block;"><img src="../images/statistics.png"
                                                                                     width="48px"/></div>
                                            <div style="display: inline-block; vertical-align: top;margin-top: 15px;">
                                                Result's statistics
                                            </div>
                                        </div>
                                        <div id="age-statistics-container" class="panel-body"></div>
                                    </div>
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
                        <div class="col-xs-12">
                            <div class="col-xs-offset-2 col-xs-4">
                                <select id="first_map_select" onchange="getCompare1Details();">
                                    <option value="-1">Please select a query</option>
                                    <c:forEach var="history" items="${historyList}">
                                        <option value="${history.id}">Query#${history.id}</option>
                                    </c:forEach>
                                </select>

                                <div class="history-details" id="history1_details">
                                </div>
                            </div>
                            <div class="col-xs-offset-2 col-xs-4">
                                <select id="second_map_select" onchange="getCompare2Details();">
                                    <option value="-1">Please select a query</option>
                                    <c:forEach var="history" items="${historyList}">
                                        <option value="${history.id}">Query#${history.id}</option>
                                    </c:forEach>
                                </select>

                                <div class="history-details" id="history2_details">
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 text-center" style="margin-top:10px;">
                            <input type="button" class="btn btn-lg btn-primary" onclick="sendCompareRequest();"
                                   value="Compare"/>
                            <input type="button" class="btn btn-lg btn-warning" onclick="initCompare();"
                                   value="Clear Map"/>
                            <input id="compare-clear" type="button" class="btn btn-lg btn-warning"
                                   style="display: none;" onclick="hiddenInit();" value="Clear Map"/>
                        </div>
                        <div id="comparemaps-container" style="display: none;" class="col-xs-12"
                             style="margin-top:20px;">
                            <div class="col-xs-6">
                                <div id="map1" style="height: 500px;">
                                </div>

                            </div>
                            <div class="col-xs-6">
                                <div id="map2" style="height: 500px;">
                                </div>
                            </div>
                        </div>

                    </div>
                    <div id="tabs-3" style="display: inline-block;margin-top: 10px;width: 100%;">
                        <div class="left">
                            <div id="chartcontainer" style="height: 600px; margin: 0 auto"></div>
                        </div>
                        <div class="right" style="border-left: 1px solid #EFEFEF;">
                            <div id="accordion">
                                <h3>Prevalence of disease per sex for different age groups</h3>

                                <div>
                                    <label style="margin-top: 10px;"> Disease Type:</label>
                                    <select id="disease-chart" style="margin-top:5px;" class="form-control input-sm">
                                        <option value="diabetes">Diabetes</option>
                                        <option value="cancer">Obstructive Pulmonary Disease</option>
                                        <option value="hypertension">Hypertension</option>
                                        <option value="mentalillness">Mental Illness</option>
                                        <option value="anxiety">Mood and Anxieety Disorders</option>
                                        <option value="asthma">Asthma</option>
                                        <option value="ischemic-heartdisease">Ischemic Heart Disease</option>
                                        <option value="myocardial">Acute Myocardial Infarction</option>
                                        <option value="heart-failure">Heart Failure</option>
                                    </select>
                                    <input type="button" style="margin-top: 10px;" class="btn btn-primary" value="Draw"
                                           onclick="sendChartRequest();"/>
                                </div>
                                <!--<h3>Prevalence of diseases in different years</h3>

                                <div>
                                    <input style="margin-top:10px;" type="text" class="form-control"
                                           id="diff_dis_min_year" placeholder="Starting year..."/>
                                    <input style="margin-top:5px;" type="text" class="form-control"
                                           id="diff_dis_max_year" placeholder="Finishing year..."/>
                                    <input type="button" style="margin-top: 10px;" class="btn btn-primary" value="Draw"
                                           onclick="sendDifferentDiseasesRequest();"/>
                                </div>-->
                            </div>
                                <%--<div>--%>
                                <%--<label style="width: 100%; text-align: center;">Prevalence of diseases in different areas</label>--%>
                                <%--<input type="button" style="margin-top: 10px;" class="btn btn-primary" value="Draw" onclick="sendBubbleChartRequest();"/>--%>
                                <%--</div>--%>
                        </div>
                    </div>
                    <%--<div id="tabs-4" style="display: inline-block;margin-top: 10px;width: 100%;">--%>
                    <%--<div class="left">--%>
                    <%--<div id="histocontainer" style="height: 500px; margin: 0 auto"></div>--%>
                    <%--</div>--%>
                    <%--<div class="right">--%>
                    <%--<div><br/></div>--%>
                    <%--From Year:&nbsp;<input type="text" placeholder="Minimum Year..." id="minHistYear"--%>
                    <%--style="width:250px;"/>--%>

                    <%--<div><br/></div>--%>
                    <%--To Year:&nbsp;<input type="text" placeholder="Maximum Year..." id="maxHistYear"--%>
                    <%--style="width:250px;"/>--%>

                    <%--<div><br/></div>--%>
                    <%--<input type="button" class="btn btn-primary" value="Draw" onclick="sendHistoRequest();"/>--%>
                    <%--</div>--%>
                    <%--</div>--%>
                </sec:authorize>
            </div>
        </div>
    </div>
</div>
<span id="top-link-block" class="hidden">
    <a href="#top" style="background-color: #007FFF;text-decoration: none;" class="well well-sm"
       onclick="$('html,body').animate({scrollTop:0},'slow');return false;">
        <i class="fa fa-chevron-up"></i> Back to Map
    </a>
</span>
<script type="text/javascript">
    $('body').click(function (event) {
        if (!$(event.target).parent().parent().parent().parent().is('#map-container')) {
            infowindow.close();
        }
    });
    var inervalHolder;
    var compareRun = 0;
    var isPaused = true;
    if (($(window).height() + 100) < $(document).height()) {
        $('#top-link-block').removeClass('hidden').affix({
            // how far to scroll down before link "slides" into view
            offset: {top: 100}
        });
    }
    jQuery(document).ready(function () {
        $("#accordian a").click(function () {
            var link = $(this);
            var closest_ul = link.closest("ul");
            var parallel_active_links = closest_ul.find(".active")
            var closest_li = link.closest("li");
            var link_status = closest_li.hasClass("active");
            var count = 0;

            closest_ul.find("ul").slideUp(function () {
                if (++count == closest_ul.find("ul").length)
                    parallel_active_links.removeClass("active");
            });

            if (!link_status) {
                closest_li.children("ul").slideDown();
                closest_li.addClass("active");
            }
        });

        var lis = "";
        for (var i = 1995; i <= 2015; i++) {
            lis += '<li><a id="a-' + i + '" onclick="handleRange(this);"'
                    + 'href="javascript:void(0);">' + i + '</a>'
                    + '</li>';
        }
        $("#timeline #dates").html(lis);
        jQuery("#tabs").tabs();
        jQuery("#accordion").accordion({heightStyle: 'content'});
        jQuery("#main-accordion").accordion({
            heightStyle: 'content',
            collapsible: true
        });
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
    function playOrPause() {
        if ($("#play_pause_img").attr("src").indexOf("play") >= 0) {
            $("#play_pause_hidden").val("pause");
            $("#play_pause_img").attr("src", "../images/pause.png");
            isPaused = false;
        } else {
            $("#play_pause_hidden").val("play");
            $("#play_pause_img").attr("src", "../images/play.png");
            isPaused = true;
        }

    }
    function handleActivation(elem) {
        if ($(elem).hasClass("active-filter")) {
            $(elem).removeClass("active-filter");
            $(elem).find("img").attr("src", "../images/unchecked.png");
        } else {
            $(elem).find("img").attr("src", "../images/checked.png");
            $(elem).addClass("active-filter");

        }
    }
    function hideLegend() {
        $("#legend").hide();
    }
    function showLegend() {
        $("#legend").fadeIn("slow");
    }
    function clearLegend() {
        $("#legend").hide();
        $("#legend-content").html("");
    }
    function toggleFilters() {
        if ($("#filters").is(":visible")) {
            $("#filters").hide("slide", {direction: "left"}, "fast", function () {
                $("#hide-filters-btn").removeClass("btn-warning");
                $("#hide-filters-btn").addClass("btn-primary");
                $("#hide-filters-btn").attr("value", "Show Filters");
//                init();
            });
        } else {
            $("#filters").show("slide", {direction: "left"}, "fast", function () {
                $("#hide-filters-btn").addClass("btn-warning");
                $("#hide-filters-btn").removeClass("btn-primary");
                $("#hide-filters-btn").attr("value", "Hide Filters");
            });
        }
    }
    function hideFilters() {
        if ($("#filters").is(":visible")) {
            $("#filters").hide("slide", {direction: "left"}, "fast", function () {
                $("#hide-filters-btn").removeClass("btn-warning");
                $("#hide-filters-btn").addClass("btn-primary");
                $("#hide-filters-btn").attr("value", "Show Filters");
            });
        }
    }
    function handleTimeline() {
        $("#timeline a").removeClass("selected");
    }
    function getCompare1Details() {
        if ($("#first_map_select").val() == -1) {
            $("#history1_details").html("");
            return;
        }
        $.ajax({
            url: "/history1Details?historyId1=" + $("#first_map_select").val(),
            type: 'GET',
            dataType: 'json',
            contentType: 'application/json',
            mimeType: 'application/json',
            success: function (data) {

                var comorbidity = data.comorbidity;
                if (comorbidity.length == 0)comorbidity = "All";
                var diseaseType = data.diseaseType;
                if (diseaseType.length == 0)diseaseType = "All";
                var healthCareUtilization = data.healthCareUtilization;
                if (healthCareUtilization == "*")healthCareUtilization = "Not important";
                else if (healthCareUtilization == "1")healthCareUtilization = "Yes";
                else healthCareUtilization = "No";
                var maxAge = data.maxAge;
                var minAge = data.minAge;
                var ageRange = "All ages";
                if (maxAge === undefined && minAge !== undefined) {
                    ageRange = "Ages above " + minAge;
                }
                if (maxAge !== undefined && minAge === undefined) {
                    ageRange = "Ages below " + maxAge;
                }
                if (maxAge !== undefined && minAge !== undefined) {
                    ageRange = "Ages between " + minAge + " and " + maxAge;
                }
                var maxYear = data.maxYear;
                var minYear = data.minYear;
                var yearRange = "All years";
                if (maxYear === undefined && minYear !== undefined) {
                    yearRange = "Years above " + minYear;
                }
                if (maxYear !== undefined && minYear === undefined) {
                    yearRange = "Years below " + maxYear;
                }
                if (maxYear !== undefined && minYear !== undefined) {
                    yearRange = "Years between " + minYear + " and " + maxYear;
                }
                var mortality = data.mortality;
                if (mortality == "*")mortality = "Not important";
                else if (mortality == "1")mortality = "Yes";
                else mortality = "No";
                var sex = data.sex;
                if (sex == "*")sex = "Not important";
                else if (sex == "F")sex = "Female";
                else sex = "Male";
                $("#history1_details").html("<p>Disease Type: <b>" + diseaseType + "</b></p>"
                        + "<p>Year: <b>" + yearRange + "</b></p>"
                        + "<p>Age: <b>" + ageRange + "</b></p>"
                        + "<p>Sex: <b>" + sex + "</b></p>"
                        + "<p>Healthcare Utilization: <b>" + healthCareUtilization + "</b></p>"
                        + "<p>Mortality: <b>" + mortality + "</b></p>"
                        + "<p>Comorbidities: <b>" + comorbidity + "</b></p>"
                );
            },
            error: function (data, status, er) {
            }
        });
    }
    function getCompare2Details() {
        if ($("#second_map_select").val() == -1) {
            $("#history2_details").html("");
            return;
        }
        $.ajax({
            url: "/history2Details?historyId2=" + $("#second_map_select").val(),
            type: 'GET',
            dataType: 'json',
            contentType: 'application/json',
            mimeType: 'application/json',
            success: function (data) {
                var comorbidity = data.comorbidity;
                if (comorbidity.length == 0)comorbidity = "All";
                var diseaseType = data.diseaseType;
                if (diseaseType.length == 0)diseaseType = "All";
                var healthCareUtilization = data.healthCareUtilization;
                if (healthCareUtilization == "*")healthCareUtilization = "Not important";
                else if (healthCareUtilization == "1")healthCareUtilization = "Yes";
                else healthCareUtilization = "No";
                var maxAge = data.maxAge;
                var minAge = data.minAge;
                var ageRange = "All ages";
                if (maxAge === undefined && minAge !== undefined) {
                    ageRange = "Ages above " + minAge;
                }
                if (maxAge !== undefined && minAge === undefined) {
                    ageRange = "Ages below " + maxAge;
                }
                if (maxAge !== undefined && minAge !== undefined) {
                    ageRange = "Ages between " + minAge + " and " + maxAge;
                }
                var maxYear = data.maxYear;
                var minYear = data.minYear;
                var yearRange = "All years";
                if (maxYear === undefined && minYear !== undefined) {
                    yearRange = "Years above " + minYear;
                }
                if (maxYear !== undefined && minYear === undefined) {
                    yearRange = "Years below " + maxYear;
                }
                if (maxYear !== undefined && minYear !== undefined) {
                    yearRange = "Years between " + minYear + " and " + maxYear;
                }
                var mortality = data.mortality;
                if (mortality == "*")mortality = "Not important";
                else if (mortality == "1")mortality = "Yes";
                else mortality = "No";
                var sex = data.sex;
                if (sex == "*")sex = "Not important";
                else if (sex == "F")sex = "Female";
                else sex = "Male";
                $("#history2_details").html("<p>Disease Type: <b>" + diseaseType + "</b></p>"
                        + "<p>Year: <b>" + yearRange + "</b></p>"
                        + "<p>Age: <b>" + ageRange + "</b></p>"
                        + "<p>Sex: <b>" + sex + "</b></p>"
                        + "<p>Healthcare Utilization: <b>" + healthCareUtilization + "</b></p>"
                        + "<p>Mortality: <b>" + mortality + "</b></p>"
                        + "<p>Comorbidities: <b>" + comorbidity + "</b></p>"
                );
            },
            error: function (data, status, er) {
            }
        });
    }
    function sendCompareRequest() {
        initCompare();
        google.maps.event.trigger(map1, "resize");
        google.maps.event.trigger(map2, "resize");
        $.ajax({
            url: "/compare?historyId1=" + $("#first_map_select").val() + "&historyId2=" + $("#second_map_select").val(),
            type: 'GET',
            dataType: 'json',
            contentType: 'application/json',
            mimeType: 'application/json',
            success: function (data) {
                total1 = data.total1;
                total2 = data.total2;
                var res1 = JSON.parse(data.facetfieldStr1);
                for (var i = 0; i < res1.length; i++) {
                    prepareForShowFeature1(res1[i].value, "#" + res1[i].color, res1[i].count);
                }
                var res2 = JSON.parse(data.facetfieldStr2);
                for (var i = 0; i < res2.length; i++) {
                    prepareForShowFeature2(res2[i].value, "#" + res2[i].color, res2[i].count);
                }
                $("#comparemaps-container").show();
                hiddenInit();
            },
            error: function (data, status, er) {
            }
        });
    }
    function handleRange(elem) {
        hideFilters();
        var selectedCount = $("#timeline a.selected").size();
        var thisClass = $(elem).attr("class");
//        prepareSendRequest(1998);
        if (selectedCount == 0) {
            $(elem).addClass("selected");
        } else if (selectedCount == 1) {
            if (thisClass === undefined || thisClass != "selected") {
                $(elem).addClass("selected");
            } else {
                $(elem).removeClass("selected");
            }
        } else if (selectedCount == 2) {
            if (thisClass === undefined || thisClass != "selected") {
                $("#timeline a.selected").removeClass("selected");
                $(elem).addClass("selected");
            } else {
                $(elem).removeClass("selected");
            }
        }
        selectedCount = $("#timeline a.selected").size();
        if (selectedCount == 0) {
            clearMap();
            clearFilter();
        } else if (selectedCount == 1) {
            $("#minYear").val(parseInt($("#timeline a.selected").text()));
            $("#maxYear").val(parseInt($("#timeline a.selected").text()));
            prepareSendRequest();
        } else if (selectedCount == 2) {
            var firstYear = parseInt($("#timeline a.selected").first().text());
            var secondYear = parseInt($("#timeline a.selected").last().text());
            if (firstYear < secondYear) {
                $("#minYear").val(firstYear);
                $("#maxYear").val(secondYear);
                prepareSendRequest();
            } else {
                $("#minYear").val(secondYear);
                $("#maxYear").val(firstYear);
                prepareSendRequest();
            }
        }
    }
    function prepareSendRequest(timelineDate) {
        $("#loading-spinner").show();
        var minAge = document.getElementById('minAge').value;
        var maxAge = document.getElementById('maxAge').value;
        var minYear = 0;
        var maxYear = 0;
        if (timelineDate === undefined) {
            minYear = document.getElementById('minYear').value;
            maxYear = document.getElementById('maxYear').value;
        } else {
            minYear = timelineDate;
            maxYear = timelineDate;
        }
        if (parseInt(minYear) > parseInt(maxYear)) {
            swal({
                title: "Error!",
                text: "From year can not be larger than To year!",
                type: "error",
                confirmButtonText: "Got it!"
            });
            return;
        }
        if (parseInt(minAge) > parseInt(maxAge)) {
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
        $(".disease-selector.active-filter").each(function () {
            disease += $(this).attr("disease") + ",";
        });
        disease = disease.substr(0, disease.length - 1);
        var comorbidity = "";
        $(".comorbidity-selector.active-filter").each(function () {
            comorbidity += $(this).attr("comorbidity") + ",";
        });
        comorbidity = comorbidity.substr(0, comorbidity.length - 1);
        if (timelineDate === undefined) {
//            $("#tabs").mask("<img height='20px' src='../images/loading.gif'/> Processing...");
        } else {
        }

        var sex = document.getElementById('sex').value;
        var healthcare = document.getElementById('healthcare').value;
        var mortality = document.getElementById('mortality').value;
        var log = document.getElementById('geography-level').value;
        var hospitalizationStatus = document.getElementById('hospitalizationStatus').value;
        var noOfHospFrom = document.getElementById('noOfHospFrom').value;
        if(noOfHospFrom == '') noOfHospFrom = "*";
        var noOfHospTo = document.getElementById('noOfHospTo').value;
        if(noOfHospTo == '')noOfHospTo = "*";
        var lengthOfStayFrom = document.getElementById('lengthOfStayFrom').value;
        if(lengthOfStayFrom == '') lengthOfStayFrom = "*";
        var lengthOfStayTo = document.getElementById('lengthOfStayTo').value;
        if(lengthOfStayTo == '') lengthOfStayTo = "*";
        $.ajax({
            url: "/sendMyRequest?comorbidity=" + comorbidity + "&disease=" + disease + "&minYear=" + minYear + "&maxYear=" + maxYear +
            "&healthcare=" + healthcare + "&mortality=" + mortality + "&minAge=" + minAge + "&maxAge=" + maxAge + "&sex=" + sex +
            '&log=' + log+ '&hospitalizationStatus=' + hospitalizationStatus+ '&noOfHospFrom=' + noOfHospFrom+ '&noOfHospTo=' + noOfHospTo
            + '&lengthOfStayFrom=' + lengthOfStayFrom+ '&lengthOfStayTo=' + lengthOfStayTo,
            type: 'POST',
            dataType: 'json',
            contentType: 'application/json',
            mimeType: 'application/json',
            success: function (data) {
                clearMap();
                var res = JSON.parse(data.facetfieldStr);
                var stats = JSON.parse(data.statsObjectStr);
                var ageStats = stats.ageStatistics;
                var ageAverage = ageStats.average;
                var ageMin = ageStats.min;
                var ageMax = ageStats.max;
                var ageCount = ageStats.count;
                var ageStddev = ageStats.stddev;
                total = data.total;
                var cnt = res.length;
//                var resultGradient = jsgradient.generateGradient('#FFFFFF', '#FF0400', cnt);
//                var rainbow = new Rainbow();
//                rainbow.setSpectrum('red', 'FFFFFF', '#00ff00');
                var resultGradient = jsgradient.generateGradient('#FFFFFF', '#FF0400', cnt);
                cnt = 0;
                var borderColor = "black";
                for (var i = 0; i < res.length; i++) {
                    if(i == 0) {
                        borderColor = res[i].color;
                    }
                    if ($("#" + res[i].color).length <= 0) {
                        if (res[i].color != undefined) {
                            $("#legend-content").append("<div id='" + res[i].color + "'><div class='col-xs-1' style='margin-bottom:5px; height:25px;border:1px solid #"+borderColor+"; background-color: " + res[i].color + "'></div><div  style='margin-top:8px;margin-bottom:5px; height:25px;' class='col-xs-9'>" + res[i].description + "</div></div>");
                        }
                    }
                    prepareForShowFeature(res[i].value, "#" + res[i].color, res[i].count);
                }
                $("#legend-content").append("<div class='col-xs-1' style='margin-bottom:5px; height:25px;background: url(../images/all-legend.png) no-repeat;'></div><div  style='margin-top:8px;margin-bottom:5px; height:25px;' class='col-xs-10'><b style='font-weight: bold;'>Total:</b> " + total + "</div>");
                createTable(res);
                if (timelineDate === undefined) {
//                    $("#tabs").unmask("<img height='20px' src='../images/loading.gif'/> Processing...");
                }
                showLegend();
                $("#timeline a").removeClass("selected");
                if (minYear == "" || parseInt(minYear) < 1995)minYear = 1995;
                if (maxYear == "" || parseInt(maxYear) > 2015)maxYear = 2015;
                $("#a-" + minYear).addClass("selected");
                $("#a-" + maxYear).addClass("selected");
                var statsHtml = "<div class='stats-category'>Statistics related to <b style='font-weight: bolder;'>age</b>:</div>"
                        + "<div class='stats-wrapper'><div class='stats-title'>Total count:</div><div class='stats-value'>" + ageCount + "</div></div>"
                        + "<div class='stats-wrapper'><div class='stats-title'>Minimum value:</div><div class='stats-value'>" + ageMin + "</div></div>"
                        + "<div class='stats-wrapper'><div class='stats-title'>Maximum value:</div><div class='stats-value'>" + ageMax + "</div></div>"
                        + "<div class='stats-wrapper'><div class='stats-title'>Average:</div><div class='stats-value'>" + parseFloat(ageAverage).toFixed(4) + "</div></div>"
                        + "<div class='stats-wrapper'><div class='stats-title'>Standard Deviation:</div><div class='stats-value'>" + parseFloat(ageStddev).toFixed(4) + "</div></div>"
                $("#age-statistics-container").html(statsHtml);
                $("#statistics-container").show();
                $("#loading-spinner").hide();
            },
            error: function (data, status, er) {
                if (timelineDate === undefined) {
//                    $("#tabs").unmask("<img height='20px' src='../images/loading.gif'/> Processing...");
                }
                $("#loading-spinner").hide();
                alert("An error occurred. Please try again later.");

            }
        });
        var is_checked = ($("#save-queries").prop("checked"));
        if (is_checked) {
            swal({
                        title: "",
                        text: "Would you like to save this query to your history?",
                        type: "info",
                        showCancelButton: true,
                        confirmButtonColor: "#DD6B55",
                        confirmButtonText: "Yes!",
                        closeOnConfirm: true
                    },
                    function () {
                        $.ajax({
                            url: "/addToHistory?comorbidity=" + comorbidity + "&disease=" + disease + "&minYear=" + minYear + "&maxYear=" + maxYear +
                            "&healthcare=" + healthcare + "&mortality=" + mortality + "&minAge=" + minAge + "&maxAge=" + maxAge + "&sex=" + sex,
                            type: 'GET',
                            dataType: 'json',
                            contentType: 'application/json',
                            mimeType: 'application/json',
                            success: function (data) {
                                var select = document.getElementById("first_map_select");
                                var option = document.createElement('option');
                                option.text = "Query#" + data.historyId1;
                                option.value = data.historyId1;
                                select.add(option);
                                select = document.getElementById("second_map_select");
                                option = document.createElement('option');
                                option.text = "Query#" + data.historyId1;
                                option.value = data.historyId1;
                                select.add(option);
                            },
                            error: function (data, status, er) {
                            }
                        });
                    });
        }
    }
    function createTable(rows) {
        var tableStr = "";
        tableStr = "<table class='table'><thead><tr class='reporttable-row'><th>Rank</th><th>Postal Code</th><th>Province</th><th>Occurance</th></tr></thead><tbody>";
        for (var i = 0; i < rows.length; i++) {
            var noOfIndividuals = rows[i].count;
            var individualsString = noOfIndividuals +" individuals";
            if (noOfIndividuals <= 5){
                individualsString = "Below 5 individuals";
            }
            tableStr += "<tr class='reporttable-row' id='ROW-" + rows[i].value + "' style='background-color:" + rows[i].color + "'><td>" + (i + 1) + "</td><td>" + rows[i].value + "</td><td>Newfoundland & Labrador</td><td>" + individualsString + "</td></tr>";
        }
        tableStr += "</tbody></table>";
        $("#table-container").html(tableStr);
    }
    function scrollToId(theId) {
        var container = $("body");
        var scrollTo = $("#" + theId);
        $("#table-container tr").removeClass("scrolled");
        scrollTo.addClass("scrolled");
        blinker(scrollTo);
        container.animate({scrollTop: scrollTo.offset().top - (container.offset().top + container.scrollTop() + 25)}, 'slow');
    }
    function blinker(elem) {
        elem.fadeOut("slow", function () {
            elem.fadeIn("slow");
        });
    }
    function handleSpin(obj){
        if($(obj).find("i").hasClass("fa-spin")){
            $(obj).find("i").removeClass("fa-spin")
        }else{
            $(obj).find("i").addClass("fa-spin")
        }
    }

</script>
</body>
</html>
