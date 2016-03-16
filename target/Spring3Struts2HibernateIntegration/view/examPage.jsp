<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

  <meta name="author" content="Yasaman">

  <link href="../css/bootstrap.css" rel="stylesheet">
  <script src="../js/jquery.min.js"></script>
  <script src="../js/bootstrap.min.js"></script>

</head>
<body>
<div class="container-fluid">
  <div class="row">
    <div class="col-md-12">
      <div class="page-header">
        <h1>
          Lets start <small>Written test!</small>
        </h1>
      </div>
      <nav class="navbar navbar-inverse">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-2">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">Brand</a>
          </div>

          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-2">
            <ul class="nav navbar-nav">
              <li class="active"><a href="#">Link <span class="sr-only">(current)</span></a></li>
              <li><a href="questionAdminPanel">questionAdminPanel</a></li>
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Dropdown <span class="caret"></span></a>
                <ul class="dropdown-menu" role="menu">
                  <li><a href="#">Action</a></li>
                  <li><a href="#">Another action</a></li>
                  <li><a href="#">Something else here</a></li>
                  <li class="divider"></li>
                  <li><a href="#">Separated link</a></li>
                  <li class="divider"></li>
                  <li><a href="/j_spring_security_logout">Logout</a></li>
                </ul>
              </li>
            </ul>
            <form class="navbar-form navbar-left" role="search">
              <div class="form-group">
                <input type="text" class="form-control" placeholder="Search">
              </div>
              <button type="submit" class="btn btn-default">Submit</button>
            </form>
            <ul class="nav navbar-nav navbar-right">
              <li><a href="#">Link</a></li>
            </ul>
          </div>
        </div>
      </nav>
    </div>
  </div>
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
      <div class="panel panel-primary">
        <div class="panel-heading" >
          <p>QuestionNo: </p>
          <p id="questionNo"><c:out value="${questionEntity.questionNo}" /></p>
        </div>
        <div class="panel-body">
          <p>
            <c:out value="${questionEntity.question}" />
          </p>
          <ol>
            <li>
              <c:out value="${questionEntity.alternative1}" />
            </li>
            <li>
              <c:out value="${questionEntity.alternative2}" />
            </li>
            <li>
              <c:out value="${questionEntity.alternative3}" />
            </li>
            <li>
              <c:out value="${questionEntity.alternative4}" />
            </li>
          </ol>
          <div class="row">
            <div class="col-md-3">
              <div class="radio">
                <label>
                  <input type="radio" name="optionsRadios" id="optionsRadios1" value="1">
                  1
                </label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="radio">
                <label>
                  <input type="radio" name="optionsRadios" id="optionsRadios2" value="2">
                  2
                </label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="radio">
                <label>
                  <input type="radio" name="optionsRadios" id="optionsRadios3" value="3">
                  3
                </label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="radio">
                <label>
                  <input type="radio" name="optionsRadios" id="optionsRadios4" value="4">
                  4
                </label>
              </div>
            </div>
            <div class="col-md-3">
              <button class="btn btn-success" id="btnConfirmAnswer" onclick="getDescription()">Submit</button>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12">
          <ul class="pager">
            <li class="previous"><a href="#" id="btnPre" onclick="getPreQuestion()">← Older</a></li>
            <li class="next"><a href="#" id="btnNext" onclick="getNextQuestion()">Newer →</a></li>
          </ul>
        </div>
      </div>

    </div>
  </div>
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
      <div class="panel-group" id="panel-443981">
        <div class="panel panel-default">
          <div class="panel-heading">
            <a class="panel-title collapsed" data-toggle="collapse" data-parent="#panel-443981" href="#panel-element-973414" id="questionDescription"></a>
          </div>
          <div id="panel-element-973414" class="panel-collapse collapse">
            <div class="panel-body">
              <div id="description">${questionEntity.description} so that the right answer is: </div>
              <div id="rightAnswer">${questionEntity.rightAnswer}</div>
            </div>
          </div>
        </div>

      </div>

    </div>
  </div>
  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
  <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
        </div>
        <div class="modal-body">
          <p>Please select one of the alternatives.</p>
        </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
  $(document).ready(function(){
    $("#panel-443981").hide();
  });
  function getDescription() {
    var btnCheched = "";
    if (document.getElementById('optionsRadios1').checked) {
      btnCheched = document.getElementById('optionsRadios1').value;
    } else if (document.getElementById('optionsRadios2').checked) {
      btnCheched = document.getElementById('optionsRadios2').value;
    } else if (document.getElementById('optionsRadios3').checked) {
      btnCheched = document.getElementById('optionsRadios3').value;
    } else if (document.getElementById('optionsRadios4').checked) {
      btnCheched = document.getElementById('optionsRadios4').value;
    } else  $("#myModal").modal();

    var rightanswer = "";
    rightanswer = document.getElementById('rightAnswer').innerHTML;

    if (rightanswer == btnCheched)
      document.getElementById('questionDescription').innerHTML = "that's correct."
    else document.getElementById('questionDescription').innerHTML = "That's incorrect."

    if (btnCheched !== "")
      $("#panel-443981").show();
    var questionNo = parseInt(document.getElementById('questionNo').innerHTML);

    $.ajax({
      url: '/adjustCurrQuestion',
      data: {'questionNo' : questionNo },
      type: "post",
      cache: false
    });
  };
  function getNextQuestion(){
    $.ajax({
      url: '/list',
      type: "post",
      cache: false,
      success:function(data) {
        $("body").html(data);
      }
    });
  };

  function getPreQuestion(){
    $.ajax({
      url: '/findPreQuestion',
      type: "post",
      cache: false,
      success:function(data) {
      }
    });
  };
</script>
</body>
</html>
