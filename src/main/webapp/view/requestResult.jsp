<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script src="/js/jquery.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>
    <script src="/js/annotator-full.min.js"></script>
    <link rel="stylesheet" href="/css/bootstrap.css">
    <link rel="stylesheet" href="/css/annotator.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="/css/bootstrap-theme.css">

    <title>Request Result</title>
    <style type="text/css">
        table.list
        {
            border-collapse:collapse;
            width: 40%;
        }
        table.list, table.list td, table.list th
        {
            border:1px solid gray;
            padding: 5px;
        }
    </style>
</head>
<body>
 
<p><a href="/j_spring_security_logout">Logout</a></p>
<div id="pdf-view" style="padding: 30px;">
    <%--<%@include file="../html/farsi.jsp"%>--%>
        <div>
            ${requestMessage}
        </div>
        <br/>
        <input type="button" value="Back" onclick="window.location.href='/user/welcome'"/>
</div>
<script type="text/javascript">
</script>
</body>
</html>