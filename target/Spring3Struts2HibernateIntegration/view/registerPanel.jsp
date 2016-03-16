 <%--
  Created by IntelliJ IDEA.
  User: Yasaman
  Date: 2015-11-07
  Time: 11:53 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <link href="../css/bootstrap.css" rel="stylesheet">
    <script src="../js/jquery.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
</head>
<body>
  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-6 col-lg-offset-3">
        <div class="well">
          <form class="form-horizontal" action="registerUser" method='POST'>
            <fieldset>
              <legend>Legend</legend>
              <div class="form-group">
                <label for="firstname" class="col-lg-2 control-label">Name</label>
                <div class="col-lg-10">
                  <input type="text" class="form-control" id="firstname" placeholder="firstname" name="firstname">
                </div>
              </div>
              <div class="form-group">
                <label for="lastname" class="col-lg-2 control-label">Lastname</label>
                <div class="col-lg-10">
                  <input type="text" class="form-control" id="lastname" placeholder="Lastname" name="lastname">
                </div>
              </div>
              <div class="form-group">
                <label for="username" class="col-lg-2 control-label">Username</label>
                <div class="col-lg-10">
                  <input type="text" class="form-control" id="username" placeholder="Username" name="username">
                </div>
              </div>
              <div class="form-group">
                <label for="inputPassword" class="col-lg-2 control-label">Password</label>
                <div class="col-lg-10">
                  <input type="password" class="form-control" id="inputPassword" placeholder="Password" name="password">
                </div>
              </div>
              <div class="form-group">
                <div class="col-lg-10 col-lg-offset-2">
                  <button type="reset" class="btn btn-default">Cancel</button>
                  <button type="submit" class="btn btn-primary">Submit</button>
                </div>
              </div>
            </fieldset>
          </form>
        </div>
      </div>
    </div>
  </div>

</body>
</html>
