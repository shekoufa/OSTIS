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

    <title>Search Word</title>
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
        <s:form method="POST" action="/user/search">
            <tr>
                <td><input type="text" id="searchedWord" class="form-control" placeholder="Search word..." name="translation.faWord" value="${translation.faWord}"/></td>
            </tr>
            <tr>
                <td>
                    <br/>
                    <input type="submit" class="btn btn-info"/>
                </td>
            </tr>
        </s:form>
        <c:if test="${!empty translations}">
            <c:forEach items="${translations}" var="trans">
                <div>
                    The meaning is: &nbsp; ${trans.enWord}
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty translations}">
            <div id="search-res" style="display: none;">
                No meaning was found for this word! Request a meaning from the admins by clicking <a onclick="addRequest();">here</a>
            </div>
        </c:if>
    <form id="submitRequest" action="/user/addRequest">
        <input id="reqWord" name="reqWord" type="hidden"/>
    </form>
</div>
<script type="text/javascript">
    jQuery(document).ready(function(){
        if(jQuery("#searchedWord").val().length>0){
            jQuery("#search-res").show();
        }else{
            jQuery("#search-res").hide();
        }
    });
    function addRequest(){
        jQuery("#reqWord").val(jQuery("#searchedWord").val());
        jQuery("#submitRequest").submit();
    }
</script>
</body>
</html>