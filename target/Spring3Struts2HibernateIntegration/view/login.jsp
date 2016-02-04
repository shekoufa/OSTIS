<%@page import="com.howtodoinjava.controller.social.facebook.FBConnection" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page session="true" %>
<%
    FBConnection fbConnection = new FBConnection();
%>
<html>
<head>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <link href="../css/bootstrap-social.css" rel="stylesheet">

</head>
<body onload='document.loginForm.username.focus();'>
<div class="container">
    <div class="row">
        <div class="col-lg-4 col-md-offset-4">
            <div class=" login-panelpanel panel-default">
                <c:if test="${not empty error}">
                    <div class="error">${error}</div>
                </c:if>
                <c:if test="${not empty msg}">
                    <div class="msg">${msg}</div>
                </c:if>
                <div class="panel-body">
                    <form name='loginForm'
                          action="<c:url value='j_spring_security_check' />" method='POST'>
                        <h2 class="form-signin-heading">Please sign in</h2>
                        <div class="form-group">
                            <label class="control-label" for="focusedInput">Username</label>
                            <input class="form-control" id="focusedInput" type="text" name='username'>
                        </div>
                        <div class="form-group">
                            <label class="control-label" for="focusedInput">Password</label>
                            <input class="form-control" type="password" name='password'>
                        </div>
                        <input class="btn btn-lg btn-primary btn-block" name="submit" type="submit" value="Submit"/>
                    </form>
                    <%--<a href="/registerPanel">Sign Up!</a>--%>
                </div>
            </div>
        </div>
    </div>
</div>


</body>
</html>