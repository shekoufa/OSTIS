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

    <title>Monitor Word</title>
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
    <c:if test="${!empty pendingTranslations}">
        <table width="80%" align="center">
            <thead>
                <th>Requested Word</th>
                <th>Reject</th>
                <th>Translate</th>
            </thead>
            <tbody>
            <c:forEach items="${pendingTranslations}" var="pt">
                <tr>
                    <td>&nbsp;&nbsp;${pt.faWord}&nbsp;&nbsp;</td>
                    <td><a href="/admin/rejectWord?wordId=${pt.id}">Reject</a></td>
                    <td><a href="javascript:void(0);" onclick="prepareForm('${pt.id}','${pt.faWord}')">Translate</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty pendingTranslations}">
        <table width="80%" align="center">
            <tr>
                <td>There is currently no pending translation requests!</td>
            </tr>
        </table>
    </c:if>
    <form id="translate-form" action="/admin/translateWord" style="display: none; margin-top: 20px;">
        <input type="hidden" id="trans-id" name="wordId"/>
        <div>
            Selected word is: &nbsp;<span id="selected-word"/>
        </div>
        <br/>
        <div>
            The meaning: &nbsp;<input type="text" name="translation.enWord"/>
        </div>
        <br/>
        <div>
            <input type="submit" class="btn btn-info" value="Submit"/>
        </div>
    </form>

</div>
<script type="text/javascript">
    function prepareForm(theId,theWord){
        jQuery("#translate-form").show();
        jQuery("#trans-id").val(theId);
        jQuery("#selected-word").html(theWord);
    }

</script>
</body>
</html>